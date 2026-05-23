import 'package:flutter/material.dart';
import '../../../core/service/hive_service.dart';

class BiometricProvider extends ChangeNotifier {
  bool _enabled = false;
  bool get enabled => _enabled;
  bool get isLockedEnabled => _enabled;

  /// >>> Init =================================================================
  Future<void> init() async {
    _enabled = HiveService.biometricBox.get('enabled', defaultValue: false,);
    notifyListeners();
  }
  /// <<< Init =================================================================

  /// >>> Toggle ===============================================================
  Future<void> setEnabled(bool value) async {
    _enabled = value;
    await HiveService.biometricBox.put('enabled', value,);
    notifyListeners();
  }
  /// <<< Toggle ===============================================================
}