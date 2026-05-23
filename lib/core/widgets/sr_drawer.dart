import 'package:flutter/material.dart';
import '../../features/biometric_security/widgets/biometric_switch_tile.dart';

class SrDrawer extends StatefulWidget {
  const SrDrawer({super.key});

  @override
  State<SrDrawer> createState() => _SrDrawerState();
}

class _SrDrawerState extends State<SrDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.green,
      child: ListView(
        padding: EdgeInsets.zero,
        children: const [
          /// Header (optional future use)
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue,),
            child: Text("Settings Menu", style: TextStyle(color: Colors.white, fontSize: 20,),),
          ),

          /// >>> Biometric Lock Tile =========================
          BiometricSwitchTile(),
          Divider(),
        ],
      ),
    );
  }
}