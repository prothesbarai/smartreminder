import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pinput/pinput.dart';
import 'package:smartreminder/core/service/hive_service.dart';
import '../../../screens/home_screen.dart';

class SetupPinScreen extends StatefulWidget {
  const SetupPinScreen({super.key});

  @override
  State<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends State<SetupPinScreen> {

  final TextEditingController pinController = TextEditingController();
  bool isLoading = false;

  // >>>> Set / Save Pin Logic =================================================
  Future<void> savePin() async {
    if (pinController.text.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter 4 digit PIN"),),);
      return;
    }
    setState(() {isLoading = true;});
    await Future.delayed(const Duration(milliseconds: 700));
    await HiveService.pinBox.put('pin', pinController.text);
    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen(),),);
  }
  // <<<< Set / Save Pin Logic =================================================

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [

          // >>> Background Gradient ===========================================
          Container(
            height: size.height,
            width: size.width,
            decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xff0F172A), Color(0xff111827), Color(0xff1E293B),],),),
          ),
          // <<< Background Gradient ===========================================

          // >>> Glow Effect ===================================================
          Positioned(
            top: -120,
            left: -80,
            child: Container(height: 250, width: 250, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue.withValues(alpha: .25),),),
          ),
          Positioned(
            bottom: -120,
            right: -80,
            child: Container(height: 250, width: 250, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.purple.withValues(alpha: .25),),),
          ),
          // <<< Glow Effect ===================================================

          // >>> Blur Layer ====================================================
          BackdropFilter(filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60,), child: Container(color: Colors.transparent,),),
          // <<< Blur Layer ====================================================

          // >>> Main UI =======================================================
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: Colors.white.withValues(alpha: .08), border: Border.all(color: Colors.white.withValues(alpha: .12),), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .35), blurRadius: 30, offset: const Offset(0, 15),),],),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // >>> Lock Icon =========================================
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Color(0xff7C3AED), Color(0xff2563EB),],), boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: .4), blurRadius: 25, spreadRadius: 2,),],),
                        child: const Icon(Icons.lock_rounded, color: Colors.white, size: 45,),
                      ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack,),
                      // <<< Lock Icon =========================================

                      const SizedBox(height: 28),

                      // >>> Title =============================================
                      const Text("Create Security PIN", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: .5,),),
                      // <<< Title =============================================

                      const SizedBox(height: 10),

                      Text("Set a strong 4 digit PIN to secure\nyour personal reminders", textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: .7), fontSize: 15, height: 1.5,),),

                      const SizedBox(height: 35),

                      // >>> Pinput Field ======================================
                      Pinput(
                        controller: pinController,
                        length: 4,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly,],
                        defaultPinTheme: PinTheme(
                          width: 72,
                          height: 72,
                          textStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white,),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), color: Colors.white.withValues(alpha: .06), border: Border.all(color: Colors.white.withValues(alpha: .08), width: 1.5,),),
                        ),
                        focusedPinTheme: PinTheme(
                          width: 72,
                          height: 72,
                          textStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white,),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), gradient: const LinearGradient(colors: [Color(0xff2563EB), Color(0xff7C3AED),],), boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: .4), blurRadius: 18, spreadRadius: 1,),],),
                        ),

                        submittedPinTheme: PinTheme(
                          width: 72,
                          height: 72,
                          textStyle: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white,),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), color: const Color(0xff1E293B), border: Border.all(color: Colors.greenAccent, width: 1.8,),),
                        ),
                        onCompleted: (_) => savePin(),
                      ),
                      // <<< Pinput Field ======================================

                      const SizedBox(height: 40),

                      // >>> Button ============================================
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : savePin,
                          style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Colors.transparent, shadowColor: Colors.transparent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),), padding: EdgeInsets.zero,),
                          child: Ink(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [Color(0xff2563EB), Color(0xff7C3AED),],),),
                            child: Center(
                              child: isLoading ?
                              const SizedBox(height: 25, width: 25, child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.white,),) :
                              const Text("Save Secure PIN", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: .4,),),
                            ),
                          ),
                        ),
                      ),
                      // <<< Button ============================================

                    ],
                  ),
                ).animate().fade(duration: 500.ms).slideY(begin: .2, end: 0, duration: 600.ms, curve: Curves.easeOut,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}