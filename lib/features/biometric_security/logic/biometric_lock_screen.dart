import 'dart:ui';
import 'package:flutter/material.dart';
import '../pin_fallback_screen/pin_lock_screen.dart';
import 'biometric_service.dart';

class BiometricLockScreen extends StatefulWidget {
  final Widget child;

  const BiometricLockScreen({super.key, required this.child,});

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen> with SingleTickerProviderStateMixin,WidgetsBindingObserver {

  bool authenticated = false;
  late AnimationController _controller;
  late Animation<double> _fade;
  DateTime? _lastAuthTime;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900),)..forward();
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut,);
    // >>> App LifeCycle Observer ==============================================
    WidgetsBinding.instance.addObserver(this);
    // <<< App LifeCycle Observer ==============================================
    _authenticate();
  }

  @override
  void dispose() {
    _controller.dispose();
    // >>> App LifeCycle Observer ==============================================
    WidgetsBinding.instance.removeObserver(this);
    // <<< App LifeCycle Observer ==============================================
    super.dispose();
  }

  // >>> If authentication is successful then unlock the app ===================
  Future<void> _authenticate() async {
    // >>> For Auto Lock Purpose ===============================================
    if (_lastAuthTime != null && DateTime.now().difference(_lastAuthTime!).inSeconds < 3) {return;}
    if (_isAuthenticating) return;
    _isAuthenticating = true;
    _lastAuthTime = DateTime.now();
    // <<< For Auto Lock Purpose ===============================================

    final result = await BiometricService.authenticate();
    if (!mounted) return;
    if (result) {
      setState(() {authenticated = true;});
    }else {
      // >>>> fallback to PIN screen
      if(!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PinLockScreen(child: widget.child),),);
    }
    _isAuthenticating = false;
  }
  // <<< If authentication is successful then unlock the app ===================


  // >>> Auto Lock Logic Implements By WidgetsBindingObserver ==================
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      setState(() {
        authenticated = false; // >>> lock app
      });
    }
    if (state == AppLifecycleState.resumed) {
      _authenticate(); // >>> re-check biometric
    }
  }
  // <<< Auto Lock Logic Implements By WidgetsBindingObserver ==================

  @override
  Widget build(BuildContext context) {

    if (authenticated) {return widget.child;}

    return Scaffold(
      body: Stack(
        children: [

          // >>> Background blur gradient ======================================
          Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364),],),),),
          // <<< Background blur gradient ======================================

          // >>> Blur overlay ==================================================
          BackdropFilter(filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), child: Container(color: Colors.black.withValues(alpha: 0.3),),),
          // <<< Blur overlay ==================================================

          // >>> Center Card Design ============================================
          Center(
            child: FadeTransition(
              opacity: _fade,
              child: Container(
                width: 340,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(28), color: Colors.white.withValues(alpha: 0.10), border: Border.all(color: Colors.white.withValues(alpha: 0.20),), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.4), blurRadius: 30, spreadRadius: 2,),],),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // >>> Icon container ======================================
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Color(0xFF00C6FF), Color(0xFF0072FF),],), boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.4), blurRadius: 20,),],),
                      child: const Icon(Icons.fingerprint, size: 50, color: Colors.white,),
                    ),
                    // <<< Icon container ======================================

                    const SizedBox(height: 18),

                    // >>>> Title ==============================================
                    const Text("Secure Access", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5,),),
                    // <<<< Title ==============================================

                    const SizedBox(height: 8),

                    // >>>> Subtitle ===========================================
                    Text("Use Face ID / Fingerprint to continue", textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.75),),),
                    // <<<< Subtitle ===========================================

                    const SizedBox(height: 25),

                    // >>>> Unlock Button ======================================
                    GestureDetector(
                      onTap: _authenticate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14,),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), gradient: const LinearGradient(colors: [Color(0xFF00C6FF), Color(0xFF0072FF),],), boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: 0.3), blurRadius: 15,),],),
                        child: const Center(child: Text("Unlock Now", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600,),),),
                      ),
                    ),
                    // <<<< Unlock Button ======================================

                  ],
                ),
              ),
            ),
          ),
          // <<< Center Card Design ============================================

        ],
      ),
    );
  }
}