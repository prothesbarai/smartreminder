import 'package:flutter/material.dart';

class SrBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const SrBottomNavigationBar({super.key, required this.currentIndex, required this.onTap,});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.surface,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Reminder',),
        BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule',),
      ]
    );
  }
}
