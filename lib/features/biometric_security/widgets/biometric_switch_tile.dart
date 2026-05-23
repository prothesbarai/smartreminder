import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/service/hive_service.dart';
import '../logic/biometric_provider.dart';
import '../logic/biometric_service.dart';
import '../pin_fallback_screen/set_up_pin_screen.dart';

class BiometricSwitchTile extends StatelessWidget {

  final EdgeInsetsGeometry? contentPadding;
  final Widget? secondary;
  final String enabledText;
  final String disabledText;
  final String title;

  const BiometricSwitchTile({super.key, this.contentPadding, this.secondary, this.enabledText = "Enabled", this.disabledText = "Disabled", this.title = "Biometric Lock",});

  @override
  Widget build(BuildContext context) {
    final biometricProvider = Provider.of<BiometricProvider>(context);
    return SwitchListTile(
      contentPadding: contentPadding,
      secondary: secondary ?? const Icon(Icons.fingerprint),
      title: Text(title),
      subtitle: Text(biometricProvider.enabled ? enabledText : disabledText,),
      value: biometricProvider.enabled,
        onChanged: (value) async {
          if (value) {
            // >>> First check if there is a PIN
            final pin = HiveService.pinBox.get('pin');

            if (pin == null || pin.toString().isEmpty) {
              // >>> If there is no PIN, it will go to the Setup screen
              if (context.mounted) {
                await Navigator.push(context, MaterialPageRoute(builder: (_) => SetupPinScreen()),);
              }

              // >>> Re-check again (whether the user has set the PIN)
              final newPin = HiveService.pinBox.get('pin');
              if (newPin == null || newPin.toString().isEmpty) {
                return; // >>> Biometrics will not be enabled if you do not set a PIN
              }
            }

            // >>> If you have a PIN, biometrics will be enabled
            final authenticated = await BiometricService.authenticate();
            if (authenticated) {
              if(!context.mounted) return;
              await context.read<BiometricProvider>().setEnabled(true);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Biometric Lock Enabled")),);
              }
            }
          } else {
            // >>> Disable
            await context.read<BiometricProvider>().setEnabled(false);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Biometric Lock Disabled")),);
            }
          }
        }
    );
  }
}