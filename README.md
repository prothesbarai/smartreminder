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
      Hive.openBox("biometric_box"),
      Hive.openBox('pin_box'),
    ]);
  }
  /// >>>> Access All box ======================================================
  static Box get biometricBox => Hive.box('biometric_box');
  static Box get pinBox => Hive.box('pin_box');
  /// <<<< Access All box ======================================================
}
```

## Use Case Call From Any Page
```dart
const BiometricSwitchTile(),
```

