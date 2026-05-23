import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../core/service/hive_service.dart';

class PinLockScreen extends StatefulWidget {
  final Widget child;

  const PinLockScreen({super.key, required this.child});

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {

  String inputPin = "";
  String correctPin = "";

  @override
  void initState() {
    super.initState();
    correctPin = HiveService.pinBox.get('pin', defaultValue: '1234');
  }

  void _checkPin() {
    if (inputPin == correctPin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => widget.child),
      );
    } else {
      setState(() => inputPin = "");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Wrong PIN")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Text(
                "Enter PIN",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),

              const SizedBox(height: 20),

              Text(
                inputPin.replaceAll(RegExp(r'.'), '*'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  letterSpacing: 5,
                ),
              ),

              const SizedBox(height: 20),

              Wrap(
                spacing: 10,
                children: List.generate(10, (index) {
                  return ElevatedButton(
                    onPressed: () {
                      setState(() {
                        inputPin += index.toString();
                      });
                    },
                    child: Text("$index"),
                  );
                }),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: _checkPin,
                child: const Text("Unlock"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}