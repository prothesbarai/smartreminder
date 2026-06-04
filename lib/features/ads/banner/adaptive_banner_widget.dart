import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'banner_ad_helper.dart';

class AdaptiveBannerWidget extends StatefulWidget {
  const AdaptiveBannerWidget({super.key,});

  @override
  State<AdaptiveBannerWidget> createState() => _AdaptiveBannerWidgetState();
}

class _AdaptiveBannerWidgetState extends State<AdaptiveBannerWidget> {
  BannerAd? _bannerAd;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {_loadBanner();},);
  }

  Future<void> _loadBanner() async {
    final ad = await BannerAdHelper.createAdaptiveBanner(context,);
    if (!mounted) return;
    setState(() {_bannerAd = ad;_loaded = ad != null;});
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context,) {
    if (!_loaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!,),
    );
  }
}