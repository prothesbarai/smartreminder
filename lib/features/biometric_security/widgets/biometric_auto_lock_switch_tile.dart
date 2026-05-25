import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/biometric_provider.dart';

class AutoLockSwitchTile extends StatelessWidget {

  const AutoLockSwitchTile({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BiometricProvider>();

    // >>> will hide if biometric is off
    if (!provider.enabled) {
      return const SizedBox.shrink();
    }

    return SwitchListTile(
      secondary: const Icon(Icons.lock_clock),
      title: const Text("Auto Lock"),
      subtitle: Text(provider.autoLockEnabled ? "Auto Lock Enabled" : "Auto Lock Disabled",),
      value: provider.autoLockEnabled,
      onChanged: (value) async {
        await provider.setAutoLock(value);
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value ? "Auto Lock Enabled" : "Auto Lock Disabled",),),);
      },
    );
  }
}