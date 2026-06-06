---
---
---
---
---
---

# Flutter Google Mobile Ads Module – A to Z Guide (বাংলা)

## 1. Main.dart এ কী করতে হবে

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();   // ← আগে Firebase
  // >>> For Ads Purpose =======================================================
  AdsManager.initialize();
  // <<< For Ads Purpose =======================================================
  runApp(MyApp());
}
```
- **AdsManager.initialize();** এ **await** না দিলে => 
    **Ads initialization background এ শুরু হবে।** 
    **Flutter সঙ্গে সঙ্গে runApp() চালাবে।**
    **App দ্রুত open হবে।**
    **SplashScreen/UI আগে দেখা যাবে।** 
    **Ads পরে ready হবে।** 
    **Ads background এ load হবে।**

- App বন্ধ হওয়ার সময় Root widget-এর dispose() এ: main.dart file এ

```dart
@override
void dispose() {
  AdsManager.dispose();  // ← lifecycle observer বন্ধ করে
  super.dispose();
}
```

- Splash Screen for Ads Load 
- SplashScreen-এ AdsManager.stateNotifier listen করে Ads Ready হলে navigate

```dart
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
  AdsManager.stateNotifier.removeListener(_onAdsStateChanged); // avoid memory leak
  super.dispose();
}
  // <<< When Ads Ready Then Navigate Home =====================================
```
এতে:
Ads 5 সেকেন্ডের মধ্যে ready হলে → সাথে সাথে HomeScreen।
Ads ready না হলেও → 5 সেকেন্ড পরে HomeScreen।
User কখনো SplashScreen-এ আটকে থাকবে না।
একাধিকবার Navigate হওয়ার ঝুঁকি থাকবে না, কারণ _navigated guard আছে।

---

## 2. AndroidManifest.xml

`android/app/src/main/AndroidManifest.xml`

```xml
<manifest>
    <application>
        
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>

    </application>
</manifest>
```

## iOS — ios/Runner/Info.plist
```xml
<!-- এটা না দিলে iOS-এ app crash করবে -->
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-xxxxxxxxxxxxxxxx~xxxxxxxxxx</string>

<!-- iOS 14+ এর জন্য tracking permission -->
<key>NSUserTrackingUsageDescription</key>
<string>This identifier will be used to deliver personalized ads to you.</string>
```

Google AdMob App ID বসাতে হবে।

---

## 3. প্রতিটি ফাইল কী কাজ করে

### AdsManager
সব Ads initialize করে।

### AdsConfig
Ads enable/disable এবং test mode control করে।

### AdsIds
সব Ad Unit ID রাখে।

### AdsAnalytics
Ad loaded, failed, revenue log করে।

### BannerAdHelper
Banner তৈরি করে।

### AdaptiveBannerWidget
Responsive Banner দেখায়।

### CollapsibleBannerWidget
Collapsible Banner দেখায়।

### InterstitialHelper
Interstitial load/show করে।

### InterstitialFrequencyController
কত click পরে ad দেখাবে control করে।

### RewardedAdsHelper
Rewarded Ad show করে।

### RewardedInterstitialHelper
Rewarded Interstitial show করে।

### AppOpenAdHelper
App resume/open হলে App Open Ad দেখায়।

### AppOpenLifecycleManager
Lifecycle observe করে App Open trigger করে।

---

# 4. Banner Ad UI তে ব্যবহার

```dart
Scaffold(
  body: Column(
    children: [

      Expanded(
        child: YourScreen(),
      ),

      const AdaptiveBannerWidget(),
    ],
  ),
);
```

অথবা

```dart
bottomNavigationBar: const AdaptiveBannerWidget(),
```

---

# 5. Collapsible Banner

```dart
bottomNavigationBar: const CollapsibleBannerWidget(),
```

---

# 6. Interstitial Ad ব্যবহার

Page Change / Button Click এর আগে

```dart
await InterstitialHelper.showIfEligible(
  frequency: 3,
  cooldownSeconds: 60,
);
```

উদাহরণ

```dart
onPressed: () async {

  await InterstitialHelper.showIfEligible();

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const DetailsPage(),
    ),
  );
}
```

---

# 7. Rewarded Ad ব্যবহার

```dart
final result = await RewardedAdsHelper.show(
  rewardAmount: 100,
  rewardType: "coins",
);

if(result.success){
   print("User Earned Reward");
}
```

উদাহরণ

```dart
ElevatedButton(
  onPressed: () async {

    final reward =
        await RewardedAdsHelper.show(
          rewardAmount: 50,
        );

    if(reward.success){

      coins += reward.reward;

    }
  },
  child: const Text("Watch Ad"),
)
```

---

# 8. Rewarded Interstitial

```dart
final result =
 await RewardedInterstitialHelper.show(
    rewardAmount: 50,
 );
```

---

# 9. App Open Ad

তুমি already setup করে ফেলেছো।

```dart
AppOpenLifecycleManager.instance.initialize();
```

App background থেকে resume করলে ad show হবে।

---

# AdsState কী এবং কেন বানানো হয়েছিল?
- AdsState হলো একটা data class যেটা দিয়ে বোঝা যায় — কোন ad এখন loaded আছে, কোনটা নেই। এটা মূলত UI কে ads-এর current status জানানোর জন্য ব্যবহার হয়।
-  ধরো তুমি একটা "Watch Ad" button দেখাতে চাও — কিন্তু rewarded ad এখনো load হয়নি। তাহলে button টা দেখানো উচিত না বা disabled রাখা উচিত।
- uses "Watch Ad" button — enable/disable
```dart
ValueListenableBuilder<AdsState>(
  valueListenable: AdsManager.stateNotifier,
  builder: (context, state, _) {
    return ElevatedButton(
      onPressed: state.rewardedLoaded
          ? () async {
              final result = await RewardedAdsHelper.show(rewardAmount: 50);
              if (result.success) { /* reward দাও */ }
            }
          : null, // null মানে button disabled
      child: Text(state.rewardedLoaded ? 'Watch Ad' : 'Ad Loading...'),
    );
  },
),
```

- শুধু একটা value check করতে চাইলে
```dart
// একবার check — rebuild লাগবে না এমন জায়গায়
if (AdsManager.state.rewardedLoaded) {
  await RewardedAdsHelper.show(rewardAmount: 50);
}
```

# 10. কোন Ad কোথায় ব্যবহার করবে

## Banner

ভালো জায়গা

- Home Page
- Category Page
- News List
- Product List

খারাপ জায়গা

- Login Page
- Payment Page
- OTP Screen

---

## Interstitial

ভালো জায়গা

- ২-৫ page navigation পর
- Level Complete
- Article Close

খারাপ জায়গা

- App Open এর সাথে সাথে
- Back Button press করলেই
- প্রতি click এ

---

## Rewarded

ভালো জায়গা

- Extra Coins
- Unlock Feature
- Bonus Life
- Premium Content

Reward user কে অবশ্যই কিছু দিতে হবে।

---

## Rewarded Interstitial

ভালো জায়গা

- Bonus Continue
- Unlock Next Step

---

## App Open

ভালো জায়গা

- App Resume
- Cold Start

খুব ঘনঘন না।

---

# 11. Play Store Policy Safe Setup

Recommended

- Banner = Always
- Interstitial = Every 3-5 Click
- Cooldown = 60-120 sec
- Rewarded = User Action
- App Open = 5 minute cooldown

Never

- Accident click তৈরি করা
- Button এর খুব কাছে Banner
- Reward না দিয়ে Rewarded ব্যবহার
- Payment Screen এ Ad
- Exit আটকিয়ে Ad

---

# 12. Production Release Checklist

```dart
AdsConfig.isTestMode = false;
```

তারপর

```dart
_androidBannerProd
_androidInterstitialProd
_androidRewardedProd
_androidRewardedInterstitialProd
_androidNativeProd
_androidAppOpenProd
```

সব Production ID বসাতে হবে।

---

# 13. Recommended Structure

Home Screen
- Banner

Category Screen
- Banner

Details Screen
- Interstitial on navigation

Premium Unlock
- Rewarded

App Resume
- App Open

---

এই Architecture Play Store friendly, reusable এবং scalable।

# Final Uses Test Ads Screen
```dart
import 'package:flutter/material.dart';
import 'package:smartreminder/screens/temp_page.dart';
import '../features/ads/ads_manager.dart';
import '../features/ads/banner/adaptive_banner_widget.dart';
import '../features/ads/banner/collapsible_banner_widget.dart';
import '../features/ads/interstitial/interstitial_helper.dart';
import '../features/ads/rewarded/rewarded_ads_helper.dart';
import '../features/ads/rewarded_interstitial/rewarded_interstitial_helper.dart';
import '../features/ads/models/ads_state.dart';
class AdsTestScreen extends StatefulWidget {
  const AdsTestScreen({super.key});

  @override
  State<AdsTestScreen> createState() => _AdsTestScreenState();
}

class _AdsTestScreenState extends State<AdsTestScreen> {

  void navigatePage(){Navigator.push(context, MaterialPageRoute(builder: (_) => const TempPage(),),);}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (AdsManager.isInitialized)...[
              Text("Ads Ready")
            ],
            Divider(),
            const SizedBox(height: 10,),
            Text("Full Banner ADS"),
            const SizedBox(height: 10,),
            const AdaptiveBannerWidget(),
            Divider(),
            const SizedBox(height: 10,),
            Text("Collapsible Banner"),
            const CollapsibleBannerWidget(),
            const SizedBox(height: 10,),
            Divider(),
            Divider(),
            Divider(),
            Divider(),
            const SizedBox(height: 10,),
            Text("Interstitial Ad"),
            ElevatedButton(
                onPressed: () async {
                  //await InterstitialHelper.showIfEligible(); // >>> Only For Production
                  await InterstitialHelper.show(); // >>> For Testing Purpose
                  if(!mounted) return;
                  navigatePage();
                },
                child: Text("Interstitial Ad")
            ),
            const SizedBox(height: 10,),
            Divider(),

            // >>> For Get Coin From Rewarded ads or RewardedInterstitial ads ==
            ValueListenableBuilder<AdsState>(
              valueListenable: AdsManager.stateNotifier,
              builder: (context, state, _) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // >>> Rewarded Ad =========================================
                    Text("Rewarded Ad"),
                    ElevatedButton(
                      onPressed: state.rewardedLoaded ? () async {
                        final reward = await RewardedAdsHelper.show(rewardAmount: 50);
                        if (reward.success) {debugPrint("Reward earned: ${reward.reward}");}
                      } : null,
                      child: Text(state.rewardedLoaded ? "Watch Ad (+50)" : "Ad Loading..."),
                    ),
                    // <<< Rewarded Ad =========================================
                    const Divider(),
                    const SizedBox(height: 20),

                    // >>> Rewarded Interstitial Ad ============================
                    Text("Rewarded Interstitial Ad"),
                    ElevatedButton(
                      onPressed: state.rewardedInterstitialLoaded ? () async {
                        final reward = await RewardedInterstitialHelper.show(rewardAmount: 100);
                        if (reward.success) {debugPrint("Reward earned: ${reward.reward}");}
                      } : null,
                      child: Text(state.rewardedInterstitialLoaded ? "Watch Ad (+100)" : "Ad Loading..."),
                    ),
                    // <<< Rewarded Interstitial Ad ============================

                  ],
                );
              },
            ),
            // <<< For Get Coin From Rewarded ads or RewardedInterstitial ads ==
          ],
        ),
      )
    );
  }
}
```

---
---
---
---
---
---
# 📌 Reminder Generate Feature
---
---
---
---
---
---

##  🤖 (Android Setup) AndroidManifest.xml Setup
📍 Path: android/app/src/main/AndroidManifest.xml
---

```xml
<!-- Notification Permission (Android 13+) -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<!-- Exact Alarm Permission (Alarm Manager) -->
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.USE_EXACT_ALARM" />
<!-- Restart alarm after reboot -->
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<!-- Device vibration support -->
<uses-permission android:name="android.permission.VIBRATE" />
```
---

Add inside `<application>` tag:

```xml
<!-- For Local Notification Scheduling -->
<receiver
    android:exported="false"
    android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />

<!-- For restoring notifications after reboot -->
<receiver
    android:exported="false"
    android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED" />
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED" />
    </intent-filter>

</receiver>
```

---

## ⚙️ 3. Required Flutter Package

```yaml
dependencies:
  flutter_local_notifications: ^latest_version
```

---

## 🍎 iOS Setup (Info.plist)
📍 Path: ios/Runner/Info.plist
1. Notification Permission
```xml
<key>NSUserNotificationUsageDescription</key>
<string>This app sends reminders and notifications to alert you on time.</string>
``` 
2. Background Modes (Important for scheduled notifications)
```xml
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>processing</string>
    <string>remote-notification</string>
</array>
```
3. Push / Local Notification Support (Optional but safe)
```xml
<key>UNUserNotificationCenter</key>
<true/>
```

---

## Flutter Code Example
📍 `main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // >>> Hive Service ==========================================================
  await HiveService.initHive();
  // <<< Hive Service ==========================================================
  // >>> For Notification ======================================================
  await NotificationService.init();
  // <<< For Notification ======================================================

  // >>> UI Always Portrait Mode ===============================================
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]);
  // <<< UI Always Portrait Mode ===============================================
  runApp(
    MultiProvider(
      providers: [
        // >>>> Remainder Feature Provider =====================================
        ChangeNotifierProvider(create: (_) => ReminderProvider()),
        // <<<< Remainder Feature Provider =====================================
      ],
      child: const ProthesApp(),
    ),
  );
}
```

📍 `hive_service.dart`

```dart
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/reminder_generate/models/hive_model/reminder_hive_model.dart';

class HiveService {
  static Future<void> initHive() async{
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.registerAdapter(ReminderHiveModelAdapter());

    await Future.wait([
      Hive.openBox<ReminderHiveModel>('reminder_box'),
    ]);

  }
  /// >>>> Access All box ======================================================
  static Box<ReminderHiveModel> get remainderBox => Hive.box<ReminderHiveModel>('reminder_box');
/// <<<< Access All box ======================================================
}
```
- Remainder Form PopUp Call From Any Add Button

```dart
ReminderFormPopup.show(context, isEdit: false);
```

---
---
---
---
---
---

# 🔐 Flutter Biometrics Feature Setup
---
---
---
---
---
---
## 📦 Dependencies
Add this package in `pubspec.yaml`:
```yaml
dependencies:
  local_auth: ^3.0.1
```
---

## 🤖 Android Setup (AndroidManifest.xml)
📍 Path: android/app/src/main/AndroidManifest.xml

```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC" />
<uses-permission android:name="android.permission.USE_FINGERPRINT" />
```

---

## 2. Inside `<application>` tag
Make sure this exists:

```xml
<application
    android:label="your_app_name"
    android:icon="@mipmap/ic_launcher"
    android:usesCleartextTraffic="true"
    android:useEmbeddedDex="true"
    >

    <!-- No special biometric config needed here -->

</application>
```
---

## 🍎 iOS Setup (Info.plist)
📍 Path: ios/Runner/Info.plist
Add this key:
```xml
<key>NSFaceIDUsageDescription</key>
<string>We use Face ID / Touch ID to secure your app.</string>
```

---

## 2. Enable Capability
Open Xcode: ios/Runner.xcworkspace
Then:
- Runner → Signing & Capabilities
- Add Capability → **Face ID**
---

## 🧠 Kotlin / Android MainActivity

📍 `MainActivity.kt`

```kotlin
package com.example.app

import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity()
```
---

## Flutter Code Example
📍 `main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // >>> Hive Service ==========================================================
  await HiveService.initHive();
  // <<< Hive Service ==========================================================
  // >>> Initialize Biometric Provider =========================================
  final biometricProvider = BiometricProvider();
  await biometricProvider.init();
  // <<< Initialize Biometric Provider =========================================
  // >>> UI Always Portrait Mode ===============================================
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown,]);
  // <<< UI Always Portrait Mode ===============================================
  runApp(
    MultiProvider(
      providers: [
        // >>>> Bio-Metrics Feature Provider ===================================
        ChangeNotifierProvider.value(value: biometricProvider),
        // <<<< Bio-Metrics Feature Provider ===================================
      ],
      child: const ProthesApp(),
    ),
  );
}
```

📍 `hive_service.dart`

```dart
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import '../../features/reminder_generate/models/hive_model/reminder_hive_model.dart';
class HiveService {
  static Future<void> initHive() async{
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    await Future.wait([
      Hive.openBox("biometric_and_pin_auto_lock_box"),
    ]);
  }
  /// >>>> Access All box ======================================================
  static Box get biometricPinAutoLockBox => Hive.box('biometric_and_pin_auto_lock_box');
  /// <<<< Access All box ======================================================
}
```

## Use Case Call From Any Page
```dart
const BiometricSwitchTile(),
const AutoLockSwitchTile(),
```

