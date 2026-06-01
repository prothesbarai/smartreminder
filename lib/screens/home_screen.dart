import 'package:flutter/material.dart';
import 'package:smartreminder/core/widgets/sr_bottom_navigation_bar.dart';
import 'package:smartreminder/core/widgets/sr_drawer.dart';
import '../core/config/config.dart';
import '../core/widgets/exit_app_alert_dialogue.dart';
import '../core/widgets/sr_app_bar.dart';
import '../features/reminder_generate/screens/reminder_list_screen.dart';
import '../features/reminder_generate/widgets/reminder_form_popup.dart';
import '../features/schedule_suggest/screens/schedule_list_screen.dart';
import '../features/schedule_suggest/widgets/schedule_form_popup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  int currentIndex = 0;
  final screens = const [ReminderListScreen(),ScheduleListScreen()];
  void onTabChange(int index){setState(() {currentIndex = index;});}

  // >>> Every Page AppBar Title and Icon ======================================
  SrAppBar buildAppBar() {
    switch (currentIndex) {
      case 0:
        return SrAppBar(
          appBarTitle: "Reminder",
          actions: [
            IconButton(icon: const Icon(Icons.add_alert), onPressed: () {ReminderFormPopup.show(context, isEdit: false);},),
            const SizedBox(width: 10),
          ],
        );
      case 1:
        return SrAppBar(
          appBarTitle: "Schedule",
          actions: [
            IconButton(icon: const Icon(Icons.calendar_month), onPressed: () {ScheduleFormPopup.show(context);},),
            const SizedBox(width: 10),
          ],
        );
      default:
        return const SrAppBar(appBarTitle: "Smart Reminder");
    }
  }
  // <<< Every Page AppBar Title and Icon ======================================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: Config.app == "Android" ? false : true,
      onPopInvokedWithResult: (didPop, dynamic) {  if (didPop) {return;}  BasicAlertDialogue.willPopScope(context);},
      child: Scaffold(
        appBar: buildAppBar(),
        drawer: const SrDrawer(),
        body: screens[currentIndex],
        bottomNavigationBar: SrBottomNavigationBar(currentIndex: currentIndex, onTap: onTabChange),
      ),
    );
  }
}
