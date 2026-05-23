import 'package:flutter/material.dart';
import 'package:smartreminder/core/service/hive_service.dart';
import '../../../screens/home_screen.dart';

class SetupPinScreen extends StatelessWidget {
  final TextEditingController pinController = TextEditingController();

  SetupPinScreen({super.key});

  void savePin(BuildContext context) {
    HiveService.pinBox.put('pin', pinController.text);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()),);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Set 4 digit PIN",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () => savePin(context),
              child: const Text("Save PIN"),
            ),
          ],
        ),
      ),
    );
  }
}