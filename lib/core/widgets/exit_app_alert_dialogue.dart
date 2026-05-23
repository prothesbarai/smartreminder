import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';
import '../utils/app_string.dart';

class BasicAlertDialogue extends StatelessWidget {
  const BasicAlertDialogue({super.key});

  static Future<bool> willPopScope(BuildContext context) async{
    final shouldExit = await showDialog<bool>(context: context, builder: (context) => const BasicAlertDialogue(),);
    return shouldExit??false;
  }


  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(38.r), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 45, spreadRadius: 3, offset: const Offset(0, 25),), BoxShadow(color: AppColors.dangerColor.withValues(alpha: 0.18), blurRadius: 50, spreadRadius: 1,),],),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(38.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: Container(
              /// >>> GLASS EFFECT =============================================
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(38.r), border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1.4.w,), gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.white.withValues(alpha: 0.14), Colors.white.withValues(alpha: 0.06), Colors.white.withValues(alpha: 0.02),],),),
              child: Stack(
                children: [
                  /// >>> TOP LIGHT ============================================
                  Positioned(
                    top: -120.h,
                    right: -40.w,
                    child: Container(
                      height: 260.h,
                      width: 260.w,
                      decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [AppColors.dangerColor.withValues(alpha: 0.35), AppColors.dangerColor.withValues(alpha: 0.12), Colors.transparent,],),),
                    ),
                  ),
                  /// <<< TOP LIGHT ============================================

                  /// >>> BOTTOM BLUE LIGHT ====================================
                  Positioned(
                    bottom: -140.h,
                    left: -60.w,
                    child: Container(
                      height: 280.h,
                      width: 280.w,
                      decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Colors.blueAccent.withValues(alpha: .18), Colors.blueAccent.withValues(alpha: .06), Colors.transparent,],),),
                    ),
                  ),
                  /// <<< BOTTOM BLUE LIGHT ====================================

                  /// >>> TOP SHINY GLASS REFLECTION ===========================
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(height: 140.h, decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white.withValues(alpha: 0.12), Colors.transparent,],),),),
                  ),
                  /// <<< TOP SHINY GLASS REFLECTION ===========================

                  /// >>>> SIDE REFLECTION =====================================
                  Positioned(
                    top: -10.h,
                    left: -40.w,
                    child: Transform.rotate(
                      angle: -0.5,
                      child: Container(
                        height: 200.h,
                        width: 80.w,
                        decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.white.withValues(alpha: 0.12), Colors.transparent,],),),
                      ),
                    ),
                  ),
                  /// <<<< SIDE REFLECTION =====================================

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h,),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // >>> PREMIUM ICON ====================================
                        Container(
                          padding: EdgeInsets.all(15.r),
                          decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.dangerColor, const Color(0xffFF4D8D),],), border: Border.all(color: Colors.white.withValues(alpha: 0.18),), boxShadow: [BoxShadow(color: AppColors.dangerColor.withValues(alpha: 0.55), blurRadius: 35, spreadRadius: 4,),],),
                          child: Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withValues(alpha: 0.15), border: Border.all(color: Colors.white.withValues(alpha: 0.15),),),
                            child: Icon(Icons.power_settings_new_rounded, color: Colors.white, size: 30.sp,),
                          ),
                        ),
                        // <<< PREMIUM ICON ====================================


                        SizedBox(height: 15.h),

                        // >>> TITLE ===========================================
                        Text(AppString.exitTitle, style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.w900, letterSpacing: 1, shadows: [Shadow(color: Colors.black.withValues(alpha: 0.35), blurRadius: 12,),],),),
                        // <<< TITLE ===========================================

                        SizedBox(height: 10.h),

                        // >>> DESCRIPTION =====================================
                        Text(AppString.exitDescriptionEn, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: 0.82), fontSize: 15.sp, height: 1.7, fontWeight: FontWeight.w500,),),
                        SizedBox(height: 2.h),
                        Text(AppString.exitDescriptionBn, textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withValues(alpha: 0.58), fontSize: 13.sp, height: 1.5,),),
                        // <<< DESCRIPTION =====================================

                        SizedBox(height: 20.h),

                        /// >>> BUTTONS ========================================
                        Row(
                          children: [

                            // >>>> CANCEL BUTTON ==============================
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22.r),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: Container(
                                    height: 50.h,
                                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(22.r), border: Border.all(color: Colors.white.withValues(alpha: 0.10),),),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(22.r),
                                        onTap: () {Navigator.pop(context, false);},
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.close_rounded, color: Colors.white70, size: 22.sp,),
                                            SizedBox(width: 8.w),
                                            Text(AppString.negativeButton, style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w700,),),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // <<<< CANCEL BUTTON ==============================

                            SizedBox(width: 16.w),

                            // >>>> EXIT BUTTON ================================
                            Expanded(
                              child: Container(
                                height: 50.h,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(22.r), gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [AppColors.dangerColor, const Color(0xffFF3D71),],), border: Border.all(color: Colors.white.withValues(alpha: 0.12),), boxShadow: [BoxShadow(color: AppColors.dangerColor.withValues(alpha: 0.45), blurRadius: 28, offset: const Offset(0, 12),),],),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(22.r),
                                    onTap: () {Navigator.pop(context, true);SystemNavigator.pop();},
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.logout_rounded, color: Colors.white, size: 22.sp,),
                                        SizedBox(width: 8.w),
                                        Text(AppString.positiveButton, style: TextStyle(color: Colors.white, fontSize: 15.sp, fontWeight: FontWeight.w800,),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // <<<< EXIT BUTTON ================================
                          ],
                        ),
                        /// <<< BUTTONS ========================================
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}