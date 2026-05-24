import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:pinput/pinput.dart';
import '../../../core/service/hive_service.dart';

class PinLockScreen extends StatefulWidget {
  final Widget child;

  const PinLockScreen({super.key, required this.child,});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {

  final TextEditingController pinController = TextEditingController();
  late String correctPin;
  bool isLoading = false;
  bool wrongPin = false;


  @override
  void initState() {
    super.initState();
    correctPin = HiveService.pinBox.get('pin', defaultValue: '1234',);
  }


  // >>> Check Pin Logic =======================================================
  Future<void> checkPin() async {
    if (pinController.text.length != 4) {return;}
    setState(() {isLoading = true;wrongPin = false;});
    await Future.delayed(const Duration(milliseconds: 400));
    if (pinController.text == correctPin) {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => widget.child,),);
    } else {
      setState(() {wrongPin = true;isLoading = false;});
      pinController.clear();
      if(!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(behavior: SnackBarBehavior.floating, content: Text("Incorrect PIN"),),);
    }
  }
  // <<< Check Pin Logic =======================================================


  // >>> Delete Number From Pinput Field =======================================
  void deletePin() {
    if (pinController.text.isNotEmpty) {
      final text = pinController.text;
      pinController.text = text.substring(0, text.length - 1);
      pinController.selection = TextSelection.fromPosition(TextPosition(offset: pinController.text.length),);
      setState(() {});
    }
  }
  // <<< Delete Number From Pinput Field =======================================




  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Stack(
        children: [

          // >>> Background ====================================================
          Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xff020617), Color(0xff0F172A), Color(0xff111827),],),),),
          // <<< Background ====================================================

          // >>> Blur ==========================================================
          BackdropFilter(filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60,), child: Container(color: Colors.transparent,),),
          // <<< Blur ==========================================================

          // >>> Main UI =======================================================
          SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(35), color: Colors.white.withValues(alpha: .06), border: Border.all(color: Colors.white.withValues(alpha: .08),), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .35), blurRadius: 30, offset: const Offset(0, 15),),],),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
              
                        // >>> Lock Icon =======================================
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Color(0xff2563EB), Color(0xff7C3AED),],), boxShadow: [BoxShadow(color: Colors.blue.withValues(alpha: .35), blurRadius: 25, spreadRadius: 1,),],),
                          child: const Icon(Icons.lock_rounded, color: Colors.white, size: 40,),
                        ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack,),
                        // <<< Lock Icon =======================================

                        const SizedBox(height: 28),
              
                        const Text("Security Lock", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold,),),
              
                        const SizedBox(height: 10),
              
                        Text("Enter your secret PIN to continue", style: TextStyle(color: Colors.white.withValues(alpha: .65), fontSize: 15,),),
              
                        const SizedBox(height: 35),
              
                        // >>> Pinput ==========================================
                        IgnorePointer(
                          child: Pinput(
                            controller: pinController,
                            length: 4,
                            obscureText: true,
                            defaultPinTheme: PinTheme(
                              width: 50,
                              height: 50,
                              textStyle: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold,),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white.withValues(alpha: .05), border: Border.all(color: Colors.white.withValues(alpha: .08),),),
                            ),
                            focusedPinTheme: PinTheme(
                              width: 50,
                              height: 50,
                              textStyle: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold,),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [Color(0xff2563EB), Color(0xff7C3AED),],),),
                            ),
                            errorPinTheme: PinTheme(
                              width: 50,
                              height: 50,
                              textStyle: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold,),
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.redAccent, width: 2,), color: Colors.red.withValues(alpha: .10),),
                            ),
                            forceErrorState: wrongPin,
                          ),
                        ),
                        // <<< Pinput ==========================================
              
                        const SizedBox(height: 30),
              
                        // >>> Number Pad ======================================
                        Column(
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [numberButton("1"), numberButton("2"), numberButton("3"),],),
                            const SizedBox(height: 15),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [numberButton("4"), numberButton("5"), numberButton("6"),],),
                            const SizedBox(height: 15),
                            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [numberButton("7"), numberButton("8"), numberButton("9"),],),
                            const SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
              
                                // >>> Empty Space =============================
                                const SizedBox(width: 78,),
                                numberButton("0"),
                                // <<< Empty Space =============================
              
                                // >>> Delete Button ===========================
                                GestureDetector(
                                  onTap: deletePin,
                                  child: Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Colors.red.withValues(alpha: .18), Colors.red.withValues(alpha: .08),],), border: Border.all(color: Colors.red.withValues(alpha: .25),),),
                                    child: const Icon(Icons.backspace_rounded, color: Colors.white, size: 20,),
                                  ),
                                ),
                                // <<< Delete Button ===========================
                              ],
                            ),
                          ],
                        ),
                        // <<< Number Pad ======================================
              
                        const SizedBox(height: 30),
              
                        // >>> Unlock Button ===================================
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: isLoading ? null : checkPin,
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, elevation: 0, padding: EdgeInsets.zero, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),),
                            child: Ink(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [Color(0xff2563EB), Color(0xff7C3AED),],),),
                              child: Center(
                                child: isLoading ?
                                const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5,),) :
                                const Text("Unlock Now", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700,),),
                              ),
                            ),
                          ),
                        ),
                        // <<< Unlock Button ===================================
              
                      ],
                    ),
                  ).animate().fade(duration: 450.ms).slideY(begin: .15, end: 0, curve: Curves.easeOut, duration: 550.ms,),
                ),
              ),
            ),
          ),
          // <<< Main UI =======================================================
        ],
      ),
    );
  }


  // >>>> Number Button Design =================================================
  Widget numberButton(String number) {
    return GestureDetector(
      onTap: () {
        if (pinController.text.length >= 4) return;
        pinController.text += number;
        setState(() {});
        if (pinController.text.length == 4) {checkPin();}
      },
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [Colors.white.withValues(alpha: .10), Colors.white.withValues(alpha: .04),],), border: Border.all(color: Colors.white.withValues(alpha: .08),), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: .25), blurRadius: 20, offset: const Offset(0, 10),),],),
        child: Center(child: Text(number, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600,),),),
      ),
    );
  }
  // <<<< Number Button Design =================================================
}