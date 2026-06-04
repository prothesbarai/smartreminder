import 'package:flutter/material.dart';

import '../features/ads/ads_manager.dart';
class AdsTestScreen extends StatelessWidget {
  const AdsTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (AdsManager.isInitialized)...[
            Text("Ads Ready")
          ]
        ],
      ),
    );
  }
}
