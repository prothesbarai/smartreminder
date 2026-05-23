import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/biometric_provider.dart';
import '../logic/biometric_service.dart';

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

        /// >>> Enable =========================================================
        if(value){
          final authenticated = await BiometricService.authenticate();
          if(authenticated){
            await biometricProvider.setEnabled(true);
            if(context.mounted){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Biometric Lock Enabled"),),);
            }
          }
        }
        /// <<< Enable =========================================================

        /// >>> Disable ========================================================
        else {
          await biometricProvider.setEnabled(false);
          if(context.mounted){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Biometric Lock Disabled"),),);
          }
        }
        /// <<< Disable ========================================================

      },
    );
  }
}