---
---
---
---
---
---

# 📢 Google Mobile Ads Integration Guide (Production Ready)
# 📢 Google Mobile Ads ইন্টিগ্রেশন গাইড (Production Ready)

## Supported Ads / সাপোর্টেড Ads

✅ Banner Ads  
✅ Interstitial Ads  
✅ Rewarded Ads

❌ Native Ads (Removed / ব্যবহার করা হচ্ছে না)

---

# English Guide

## 1. Initialization

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AdsService.initialize();

  await InterstitialHelper.load();

  await RewardsAdsModule.loadRewardedAd();

  runApp(const MyApp());
}
```

---

## 2. Android Configuration

File:

```text
android/app/src/main/AndroidManifest.xml
```

Inside `<application>`:

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="YOUR_ADMOB_APP_ID"/>
```

Replace with your production AdMob App ID.

---

## 3. Banner Ads

Widget:

```dart
const BannerAdWidget()
```

Example:

```dart
Column(
  children: [
    Expanded(child: HomePage()),
    const BannerAdWidget(),
  ],
)
```

Recommended:

- Home Screen
- Product List
- Settings Page
- Long Scroll Screens

Avoid blocking buttons or content.

---

## 4. Interstitial Ads

Show only during natural transitions.

Examples:

- Screen change
- Action completed
- Game level finished

Check:

```dart
if (InterstitialHelper.isReady) {
  InterstitialHelper.show();
}
```

Example:

```dart
if (InterstitialHelper.isReady) {
  InterstitialHelper.show();
}

Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => const NextPage(),
  ),
);
```

Production Recommendation:

- Show after every 3–5 meaningful actions.
- Never show immediately after app launch.
- Never spam users.

---

## 5. Rewarded Ads

User must explicitly request the reward.

Example:

```dart
if (RewardsAdsModule.isReady) {
  await RewardsAdsModule.showRewardedAd(
    rewardAmount: 10,
    onRewardEarned: (reward) {
      debugPrint("Reward: $reward");
    },
  );
}
```

Use For:

- Coins
- Premium Features
- Extra Lives
- Bonus Content

---

## 6. Ad Lifecycle

### Interstitial

```dart
await InterstitialHelper.load();
```

Load at startup and reload automatically after closing.

### Rewarded

```dart
await RewardsAdsModule.loadRewardedAd();
```

Load at startup and reload automatically after completion.

---

## 7. Test IDs

### Banner

```text
ca-app-pub-3940256099942544/6300978111
```

### Interstitial

```text
ca-app-pub-3940256099942544/1033173712
```

### Rewarded

```text
ca-app-pub-3940256099942544/5224354917
```

### App ID

```text
ca-app-pub-3940256099942544~3347511713
```

---

## 8. Production Checklist

- Replace all test IDs.
- Use real AdMob App ID.
- Test on physical devices.
- Verify AdMob approval.
- Verify Play Store compliance.
- Monitor fill rate and earnings.
- Enable crash reporting and analytics.

---

## 9. Play Store Policy

Allowed:

- Banner Ads
- Interstitial Ads at natural transitions
- Rewarded Ads after user action

Not Allowed:

- Forced Rewarded Ads
- Excessive Interstitial Ads
- Ads blocking app usage
- Ads immediately after launch

---

# বাংলা গাইড

## ১. Initialization

```dart
await AdsService.initialize();
await InterstitialHelper.load();
await RewardsAdsModule.loadRewardedAd();
```

App শুরু হওয়ার সময় SDK initialize করুন।

---

## ২. Android Setup

`AndroidManifest.xml` ফাইলে আপনার AdMob App ID যুক্ত করুন।

```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="YOUR_ADMOB_APP_ID"/>
```

---

## ৩. Banner Ads

ব্যবহার করুন:

```dart
const BannerAdWidget()
```

ভালো জায়গা:

- Home Screen
- Product List
- Settings
- Long Scroll Screen

খেয়াল রাখুন যেন Ads কোনো Button বা Content ঢেকে না ফেলে।

---

## ৪. Interstitial Ads

শুধুমাত্র Natural Transition এ দেখান।

উদাহরণ:

- Page Change
- Form Submit Success
- Game Level Complete

```dart
if (InterstitialHelper.isReady) {
  InterstitialHelper.show();
}
```

Production Tip:

- প্রতি ৩–৫টি Meaningful Action পরে দেখান।
- App Open করার সাথে সাথে দেখাবেন না।

---

## ৫. Rewarded Ads

User নিজে Reward চাইলে তখন দেখান।

ব্যবহার:

- Coin
- Point
- Premium Unlock
- Bonus Feature

---

## ৬. Production Best Practices

✅ Frequency Control ব্যবহার করুন

✅ Analytics Track করুন

✅ Error Logging রাখুন

✅ Real Device Testing করুন

✅ Ad Loading State Handle করুন

❌ User Spam করবেন না

❌ Accidental Click তৈরি করবেন না

---

## ৭. এই Package-এ কী আছে?

- Banner Ads
- Adaptive Banner
- Collapsible Banner
- Interstitial Ads
- Rewarded Ads
- Rewarded Interstitial Ads
- App Open Ads
- Analytics Support

Native Ads অন্তর্ভুক্ত নেই।

---

## ৮. Final Release Checklist

- Production Ad Unit ID বসানো হয়েছে
- App ID বসানো হয়েছে
- Test ID সরানো হয়েছে
- Real Device Test করা হয়েছে
- AdMob Approved
- Play Store Policy Follow করা হয়েছে

Happy Coding 🚀


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

