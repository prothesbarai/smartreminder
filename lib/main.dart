import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smartreminder/screens/home_screen.dart';
import 'core/service/hive_service.dart';
import 'core/utils/app_colors.dart';
import 'features/ads/ads_manager.dart';
import 'features/biometric_security/biometric_guard.dart';
import 'features/reminder_generate/providers/reminder_provider.dart';
import 'features/reminder_generate/services/notification_service.dart';
import 'features/biometric_security/logic/biometric_provider.dart';
import 'features/schedule_suggest/providers/schedule_provider.dart';
import 'features/user_account_with_plan/plan/plan_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // >>> Hive Service ==========================================================
  await HiveService.initHive();
  // <<< Hive Service ==========================================================

  // >>> VALIDATE SUBSCRIPTION =================================================
  PlanService.validateSubscription();
  // <<< VALIDATE SUBSCRIPTION =================================================

  // >>> Initialize Biometric Provider =========================================
  final biometricProvider = BiometricProvider();
  await biometricProvider.init();
  // <<< Initialize Biometric Provider =========================================

  // >>> For Notification ======================================================
  await NotificationService.init();
  // <<< For Notification ======================================================

  // >>> UI Always Portrait Mode ===============================================
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]);
  // <<< UI Always Portrait Mode ===============================================


  // >>> For Ads Purpose =======================================================
  await AdsManager.initialize();
  // <<< For Ads Purpose =======================================================

  runApp(
    MultiProvider(
      providers: [
        // >>>> Remainder Feature Provider =====================================
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
        // <<<< Remainder Feature Provider =====================================

        // >>>> Bio-Metrics Feature Provider ===================================
        ChangeNotifierProvider.value(value: biometricProvider),
        // <<<< Bio-Metrics Feature Provider ===================================

        // >>>> Schedule Suggest Provider ======================================
        ChangeNotifierProvider(create: (_) => ScheduleProvider(),),
        // <<<< Schedule Suggest Provider ======================================
      ],
      child: const ProthesApp(),
    ),
  );
}

class ProthesApp extends StatelessWidget {
  const ProthesApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411, 869),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(
          useMaterial3: false,
          appBarTheme: AppBarThemeData(backgroundColor: AppColors.secondaryColor,centerTitle: true,foregroundColor: AppColors.primaryColor,elevation: 1,iconTheme: IconThemeData(color: AppColors.primaryColor)),
          drawerTheme: DrawerThemeData(backgroundColor: AppColors.primaryColor,shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(20),bottomRight: Radius.circular(20)))),
        ),
        home: BiometricGuard(child: const HomeScreen(),)
      ),
    );
  }
}
