import 'package:flutter/material.dart'; 
import 'package:provider/provider.dart'; 
import 'logic/biometric_lock_screen.dart'; 
import 'logic/biometric_provider.dart';

class BiometricGuard extends StatelessWidget {
  final Widget child;
  const BiometricGuard({super.key, required this.child,});

  @override
  Widget build(BuildContext context) {
    final biometricProvider = Provider.of<BiometricProvider>(context);
    /// >>> If lock enabled → protect screen ===================================
    if (biometricProvider.enabled) { return BiometricLockScreen(child: child,); }
    /// <<< If lock enabled → protect screen ===================================
    return child;
  }
}
