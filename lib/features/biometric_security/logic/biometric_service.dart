import 'package:local_auth/local_auth.dart';

class BiometricService {
  static final LocalAuthentication _auth = LocalAuthentication();

  /// >>> Check Device Support =================================================
  static Future<bool> isSupported() async {
    return await _auth.isDeviceSupported();
  }
  /// <<< Check Device Support =================================================


  /// >>> Check Biometrics Available ===========================================
  static Future<bool> hasBiometrics() async {
    final available = await _auth.canCheckBiometrics;
    return available;
  }
  /// <<< Check Biometrics Available ===========================================


  /// >>> Authenticate User ====================================================
  static Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Authenticate to access app',
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } catch (e) {
      return false;
    }
  }
  /// <<< Authenticate User ====================================================

}