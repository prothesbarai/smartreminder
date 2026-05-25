import 'package:flutter/material.dart';
import '../../../core/service/hive_service.dart';

class BiometricProvider extends ChangeNotifier {
  bool _enabled = false;
  bool _autoLockEnabled = false;
  bool get enabled => _enabled;
  bool get isLockedEnabled => _enabled;
  bool get autoLockEnabled => _autoLockEnabled;

  BiometricProvider() {load();}

  Future<void> load() async {
    _enabled = HiveService.biometricPinAutoLockBox.get('biometric_enabled', defaultValue: false);
    _autoLockEnabled = HiveService.biometricPinAutoLockBox.get('auto_lock', defaultValue: false);
    notifyListeners();
  }


  /// >>> Init =================================================================
  Future<void> init() async {
    _enabled = HiveService.biometricPinAutoLockBox.get('biometric_enabled', defaultValue: false,);
    notifyListeners();
  }
  /// <<< Init =================================================================


  /// >>> Toggle ===============================================================
  Future<void> setEnabled(bool value) async {
    _enabled = value;
    await HiveService.biometricPinAutoLockBox.put('biometric_enabled', value,);
    // >>> If biometric is off, auto lock will also be off
    if (!value) {
      _autoLockEnabled = false;
      await HiveService.biometricPinAutoLockBox.put('auto_lock', false,);
    }
    notifyListeners();
  }
  /// <<< Toggle ===============================================================


  /// >>> Set Auto Lock ========================================================
  Future<void> setAutoLock(bool value) async {
    _autoLockEnabled = value;
    await HiveService.biometricPinAutoLockBox.put('auto_lock', value,);
    notifyListeners();
  }
  /// <<< Set Auto Lock ========================================================


}