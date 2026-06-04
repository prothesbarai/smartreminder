import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../config/ads_ids.dart';

class CollapsibleBannerWidget extends StatefulWidget {
  const CollapsibleBannerWidget({super.key,});

  @override
  State<CollapsibleBannerWidget> createState() => _CollapsibleBannerWidgetState();
}

class _CollapsibleBannerWidgetState extends State<CollapsibleBannerWidget> {

  BannerAd? _bannerAd;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final ad = BannerAd(
      adUnitId: AdsIds.banner,
      size: AdSize.banner,
      request: const AdRequest(extras: {"collapsible": "bottom",},),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          if (!mounted) return;
          setState(() {_loaded = true;});
        },
        onAdFailedToLoad: (ad, error,) {ad.dispose();},
      ),
    );
    await ad.load();
    _bannerAd = ad;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context,) {
    if (!_loaded || _bannerAd == null) {return const SizedBox();}

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!,),
    );
  }
}