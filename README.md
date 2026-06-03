---
---
---
---
---
---
#  📢📱💰 Google Mobile Ads Integration Guide

This project uses the `google_mobile_ads` package to display:

- Banner Ads
- Interstitial Ads
- Rewarded Ads

---

# Initialization

Before using any ad format, initialize the Mobile Ads SDK.

## main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Google Mobile Ads SDK
  await AdsService.initialize();

  // Preload Interstitial Ad
  await InterstitialHelper.load();

  // Preload Rewarded Ad
  await RewardsAdsModule.loadRewardedAd();

  runApp(const MyApp());
}
```

---

# Android Configuration

Add the following inside:

`android/app/src/main/AndroidManifest.xml`

```xml
<application>

    <meta-data
        android:name="com.google.android.gms.ads.APPLICATION_ID"
        android:value="YOUR_ADMOB_APP_ID"/>

</application>
```

Replace:

```text
YOUR_ADMOB_APP_ID
```

with your actual AdMob App ID.

---

# 🏷️ Banner Ads

Banner ads are displayed using the reusable widget:

```dart
BannerAdWidget()
```

## Example

```dart
Scaffold(
  body: Column(
    children: [
      Expanded(
        child: HomePage(),
      ),

      const BannerAdWidget(),
    ],
  ),
);
```

## Recommended Usage

- Home Page
- Product Listing Page
- Settings Page
- Bottom Section of Long Screens

Avoid placing banner ads where they obstruct user interaction.

---

# 🎬 Interstitial Ads

Interstitial ads should be shown during natural transition points.

Examples:

- After completing an action
- Before opening another screen
- After finishing a task

---

## Check Ad Availability

```dart
if (InterstitialHelper.isReady) {
  InterstitialHelper.show();
}
```

---

## Example Navigation

```dart
onPressed: () {

  if (InterstitialHelper.isReady) {
    InterstitialHelper.show();
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const NextPage(),
    ),
  );
}
```

---

## Recommended Usage

Show occasionally:

- Screen transitions
- Action completion
- Game level completion

Do NOT show repeatedly or immediately on app launch.

---

# 🎁 Rewarded Ads

Rewarded Ads should only be displayed after explicit user interaction.

Examples:

- Watch ad and earn coins
- Watch ad and unlock premium content
- Watch ad and receive bonus points

---

## Check Ad Availability

```dart
if (RewardsAdsModule.isReady) {
  // Show rewarded ad
}
```

---

## Example

```dart
ElevatedButton(
  onPressed: () async {

    if (RewardsAdsModule.isReady) {

      await RewardsAdsModule.showRewardedAd(
        rewardAmount: 10,
        onRewardEarned: (reward) {

          debugPrint(
            "User earned reward: $reward",
          );

        },
      );

    }

  },
  child: const Text(
    'Watch Ad',
  ),
)
```

---

## Reward Callback

```dart
onRewardEarned: (reward) {

  // Add coins
  // Unlock feature
  // Give points

}
```

The callback is triggered only when the reward is successfully earned.

---

# 🔄 Ad Lifecycle

Interstitial Ads:

```dart
await InterstitialHelper.load();
```

Loads once during app startup.

After an ad is closed, the next ad is automatically preloaded.

---

Rewarded Ads:

```dart
await RewardsAdsModule.loadRewardedAd();
```

Loads once during app startup.

After an ad is completed or dismissed, the next ad is automatically preloaded.

---

# 🧪 Test Ad Unit IDs

## Banner

```text
ca-app-pub-3940256099942544/6300978111
```

## Interstitial

```text
ca-app-pub-3940256099942544/1033173712
```

## Rewarded

```text
ca-app-pub-3940256099942544/5224354917
```

## App ID

```text
ca-app-pub-3940256099942544~3347511713
```

---

# ✅ Production Release Checklist

Before publishing:

- Replace Test App ID
- Replace Banner Ad Unit ID
- Replace Interstitial Ad Unit ID
- Replace Rewarded Ad Unit ID
- Test on a physical device
- Verify AdMob account approval
- Ensure Play Store policy compliance

---

# 📋 Play Store Policy Notes

Allowed:

- Banner Ads
- Interstitial Ads during natural transitions
- Rewarded Ads after user interaction

Not Allowed:

- Auto-show Rewarded Ads
- Excessive Interstitial Ads
- Ads blocking app functionality
- Ads immediately after app launch

Following these guidelines helps maintain compliance with Google Play and AdMob policies.



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

