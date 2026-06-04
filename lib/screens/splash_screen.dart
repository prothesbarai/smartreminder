import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../features/ads/ads_manager.dart';
import '../features/biometric_security/biometric_guard.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  // >>> When Ads Ready Then Navigate Home =====================================
  @override
  void initState() {
    super.initState();
    AdsManager.stateNotifier.addListener(_onAdsStateChanged);

    // >>> Even if the ads are not ready, they will go to Home after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (!_navigated && mounted) {_goToHome();}
    });
    // >>> If it is already ready
    if (AdsManager.state.initialized) {_goToHome();}
  }

  bool _navigated = false;
  void _onAdsStateChanged() {if (AdsManager.state.initialized) {_goToHome();}}

  Future<void> _goToHome() async {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const BiometricGuard(child: HomeScreen(),),),);
  }

  @override
  void dispose() {
    AdsManager.stateNotifier.removeListener(_onAdsStateChanged);
    super.dispose();
  }
  // <<< When Ads Ready Then Navigate Home =====================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xff081420), Color(0xff0F2236), Color(0xff122B43),],),),
        child: Stack(
          children: [

            // >>> Background Glow =============================================
            Positioned(
              top: -100,
              right: -100,
              child: Container(height: 250, width: 250, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue.withValues(alpha: .15),),),
            ),

            Positioned(
              bottom: -100,
              left: -100,
              child: Container(height: 250, width: 250, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.cyan.withValues(alpha: .12),),),
            ),

            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // >>> App Logo
                  Container(
                    height: 140,
                    width: 140,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), boxShadow: [BoxShadow(color: Colors.cyan.withValues(alpha: .4), blurRadius: 40, spreadRadius: 5,),],),
                    child: ClipRRect(borderRadius: BorderRadius.circular(35), child: Image.asset("assets/images/icon.png", fit: BoxFit.cover,),),
                  ).animate(onPlay: (controller) => controller.repeat(reverse: true),).scale(duration: 2.seconds, begin: const Offset(.95, .95), end: const Offset(1.05, 1.05),),

                  const SizedBox(height: 30),
                  const Text("Smart Reminder", style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: 1.5,),).animate().fadeIn(duration: 800.ms).slideY(begin: .5),
                  const SizedBox(height: 12),
                  Text("Never Miss What Matters", style: TextStyle(color: Colors.white.withValues(alpha: .75), fontSize: 15, letterSpacing: 1.2,),).animate().fadeIn(delay: 300.ms, duration: 1000.ms,),
                  const SizedBox(height: 70),
                  SizedBox(width: 180, child: LinearProgressIndicator(minHeight: 5, borderRadius: BorderRadius.circular(100), backgroundColor: Colors.white12,),).animate().fadeIn(delay: 500.ms),
                ],
              ),
            ),

            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: SafeArea(child: Text("Powered by Smart Reminder", textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: .5), fontSize: 12, letterSpacing: 1,),)),
            ),
          ],
        ),
      ),
    );
  }
}