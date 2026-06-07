import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smartreminder/core/local_payment/bkash_payment_page.dart';
import 'package:smartreminder/features/user_account_with_plan/service/user_account_service.dart';

import '../../../core/utils/app_colors.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  String _selected = 'monthly';

  // >>> Plan Data (Coin Based) ================================================
  static const _plans = {
    'weekly':  {'label': 'Weekly',  'bdt': '490',   'days': '7',  'badge': null},
    'monthly': {'label': 'Monthly', 'bdt': '1,600', 'days': '30', 'badge': null},
    'yearly':  {'label': 'Yearly',  'bdt': '4,000', 'days': '365','badge': 'Best Value'},
  };
  // <<< Plan Data (Coin Based) ================================================

  @override
  Widget build(BuildContext context) {
    final selected = _plans[_selected]!;
    final user = UserAccountService.getAccount();

    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),),
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                // >>> Main Scrollable Content ===================================
                Column(
                  children: [

                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // >>> Top Image Grid ==================================
                        const _TopImageGrid(),
                        // <<< Top Image Grid ==================================

                        Positioned(
                          top: 70.h,
                          left: 0,
                          right: 0,
                          child: Column(
                            children: [
                              Container(
                                width: 72.w,
                                height: 72.h,
                                decoration: BoxDecoration(gradient: AppGradients.blue, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.blue1.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 1)],),
                                child: Center(child: FaIcon(FontAwesomeIcons.gem, color: Colors.white, size: 40.sp,),)
                              ),
                              const SizedBox(height: 8),
                              Text("PREMIUM", style: TextStyle(color: Colors.black, fontSize: 35.sp, fontWeight: FontWeight.w900, letterSpacing: 1.5,),),
                              const SizedBox(height: 8),
                              Text("Spend Money, Unlock Full Power", style: TextStyle(color: Color(0xFF555555), fontSize: 13.sp,),),
                            ],
                          ),
                        ),
                      ],
                    ),


                    // >>> Features List =======================================
                    Padding(
                      padding: EdgeInsets.only(left: 28.w,right: 28.w,top: 28.h),
                      child: Column(
                        children: [
                          _FeatureRow(text: "Remove All Ads"),
                          SizedBox(height: 10.h),
                          _FeatureRow(text: "Unlimited AI Reminders"),
                          SizedBox(height: 10.h),
                          _FeatureRow(text: "Priority Support"),
                        ],
                      ),
                    ),
                    // <<< Features List =======================================

                    SizedBox(height: 24.h),


                  ],
                ),
                // <<< Main Scrollable Content =================================

                // >>> Close Button ============================================
                Positioned(
                  top: MediaQuery.of(context).padding.top + 55.h,
                  right: 20.w,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40.w, height: 40.h,
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.45), shape: BoxShape.circle),
                      child: Icon(Icons.close, color: Colors.white, size: 20.sp),
                    ),
                  ),
                ),
                // <<< Close Button ============================================
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 28.w,right: 28.w,),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // >>> Plan Selection ========================================
                  Column(
                    children: [
                      // >>> Yearly
                      _PlanCard(
                        label: _plans['yearly']!['label'] as String,
                        bdt: double.parse(_plans['yearly']!['bdt'].toString().replaceAll(',', '')),
                        days: _plans['yearly']!['days'] as String,
                        badge: _plans['yearly']!['badge'],
                        isSelected: _selected == 'yearly',
                        onTap: () => setState(() => _selected = 'yearly'),
                      ),
                      SizedBox(height: 12.h),
                      // >>>> Monthly + Weekly
                      Row(
                        children: [
                          Expanded(child: _PlanCard(label: "Monthly", bdt: 1600, days: "30", isSelected: _selected == 'monthly', onTap: () => setState(() => _selected = 'monthly'),),),
                          SizedBox(width: 12.w),
                          Expanded(child: _PlanCard(label: "Weekly", bdt: 490, days: "7", isSelected: _selected == 'weekly', onTap: () => setState(() => _selected = 'weekly'),),),
                        ],
                      ),
                    ],
                  ),
                  // <<< Plan Selection ========================================

                  SizedBox(height: 14.h),

                  // >>> Subscription Note =====================================
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 28), child: Text("You will spend ${selected['bdt']} BDT for ${selected['days']} days \nof Premium access.", textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF888888), fontSize: 12, height: 1.5),),),
                  const SizedBox(height: 4),
                  const Text("No subscription. Pay once with coins.", style: TextStyle(color: Color(0xFF888888), fontSize: 12)),
                  // <<< Subscription Note =====================================

                  SizedBox(height: 14.h),

                  // >>> Coin Balance ==========================================
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
                    margin: EdgeInsets.only(bottom: 15.h,top: 15.h),
                    decoration: BoxDecoration(color: AppColors.blue1.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(32.r), border: Border.all(color: AppColors.blue1),),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Your Coin Balance : ", style: TextStyle(color: Color(0xFF555555), fontSize: 13.sp)),
                        Text("${user.coinBalance} Coins", style: TextStyle(color: AppColors.blue1.withValues(alpha: 0.9), fontSize: 14.sp, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  // <<< Coin Balance ==========================================

                  // >>> Unlock Button =========================================
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.055,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BkashPaymentPage(amount: double.parse(selected['bdt'].toString().replaceAll(',', '')),bkashNumber: "01317818826",),));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue1,foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.r)), elevation: 0,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.monetization_on_rounded, size: 20.sp),
                          const SizedBox(width: 8),
                          Text("Unlock ${selected['bdt']} BDT", style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w700, letterSpacing: 0.5),),
                        ],
                      ),
                    ),
                  ),
                  // <<< Unlock Button =========================================

                  SizedBox(height: 15.h),

                  // >>> Footer Links ==========================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(onTap: () {}, child: const Text("Privacy Policy", style: TextStyle(color: Color(0xFF555555), fontSize: 12))),
                      const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("|", style: TextStyle(color: Color(0xFFCCCCCC)))),
                      GestureDetector(onTap: () {}, child: const Text("Terms Of Services", style: TextStyle(color: Color(0xFF555555), fontSize: 12))),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  // <<< Footer Links ==========================================
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// >>> Top Image Grid Widget ===================================================
class _TopImageGrid extends StatelessWidget {
  const _TopImageGrid();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .25,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // >>> BG Image
          Image.asset("assets/images/sp.png", fit: BoxFit.fill,),

          // >>> Glass White Overlay
          Container(color: Colors.white.withValues(alpha: .25),),

          // >>>  Bottom Fade
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(height: (MediaQuery.of(context).size.height * 0.275).clamp(180.0, 260.0), decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.white.withValues(alpha: 0), Colors.white.withValues(alpha: .35), Colors.white.withValues(alpha: .75), Colors.white,],),),),
          ),
        ],
      ),
    );
  }
}
// <<< Top Image Grid Widget ===================================================


// >>> Feature Row Widget ======================================================
class _FeatureRow extends StatelessWidget {
  final String text;
  const _FeatureRow({required this.text});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 26.w, height: 26.h,
          decoration: const BoxDecoration(color: AppColors.blue1, shape: BoxShape.circle),
          child: const Icon(Icons.check, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 12),
        Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
      ],
    );
  }
}
// <<< Feature Row Widget ======================================================


// >>> Plan Card Widget ========================================================
class _PlanCard extends StatelessWidget {
  final String label;
  final double bdt;
  final String days;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({required this.label, required this.bdt, required this.days, this.badge, required this.isSelected, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // >>> Card ==========================================================
          Container(
            margin: badge != null ? EdgeInsets.only(top: 10.h) : EdgeInsets.zero,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h,),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14.r), border: Border.all(color: isSelected ? AppColors.blue1 : const Color(0xFFE0E0E0), width: isSelected ? 2 : 1,), boxShadow: isSelected ? [BoxShadow(color: AppColors.blue1.withValues(alpha: 0.15), blurRadius: 12.r, spreadRadius: 2,)] : [],),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (badge != null)...[
                  SizedBox(height: 8.h),
                ],

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(label, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700,),),
                    if (isSelected)...[
                      Icon(Icons.check_circle, color: AppColors.blue1, size: 22.sp,),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.monetization_on_rounded, size: 14.sp, color: AppColors.blue1,),
                    SizedBox(width: 4.w),
                    Text("$bdt BDT", style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600,),),
                  ],
                ),
                SizedBox(height: 2.h),
                Text("$days days access", style: TextStyle(fontSize: 11.sp, color: const Color(0xFF999999),),),
              ],
            ),
          ),
          // <<< Card ==========================================================


          // >>> Legend Badge ==================================================
          if (badge != null)...[
            Positioned(
              left: 16.w,
              top: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 3.h,),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20.r),),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h,),
                  decoration: BoxDecoration(color: AppColors.blue1, borderRadius: BorderRadius.circular(20.r), border: Border.all(color: AppColors.blue1,),),
                  child: Text(badge!, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: Colors.white,),),
                ),
              ),
            ),
          ],
          // <<< Legend Badge ==================================================
        ],
      ),
    );
  }
}
// <<< Plan Card Widget ========================================================