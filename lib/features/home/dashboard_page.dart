import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:toastification/toastification.dart';

import '../../core/utils/logger.dart';
import './views/home_page.dart';
import './views/course_page.dart';
import './views/community_page.dart';
import './views/setting_page.dart';
import './models/bottom_navbar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool isFloatingActionButtonOpened = false;

  int selectedIndex = 0;
  bool canCloseApp = false;
  DateTime? currentBackPressTime;

  final List<Widget> pages = [HomePage(), CoursePage(), CommunityPage(), SettingPage()];

  void _onPopInvoked(bool canPop, Object? result) {
    if (selectedIndex != 0) {
      setState(() {
        selectedIndex = 0;
      });
      return;
    }

    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
      currentBackPressTime = now;
      Toastification().show(
        context: context,
        title: Text("Press back again to exit"),
        type: ToastificationType.info,
        style: ToastificationStyle.flat,
        alignment: Alignment.bottomCenter,
        autoCloseDuration: Duration(seconds: 2),
        animationDuration: Duration(milliseconds: 500),
      );

      // Disable pop invoke and close the toast after 2s timeout
      Future.delayed(Duration(seconds: 2), () => setState(() => canCloseApp = false));
      setState(() => canCloseApp = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canCloseApp,
      onPopInvokedWithResult: (canPop, result) => _onPopInvoked(canPop, result),
      child: Scaffold(
        extendBody: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          spacing: 3,
          foregroundColor: Color(0xFFF5F6FA),
          backgroundColor: Color(0xFF00CEC9),
          childPadding: const EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          overlayColor: Colors.black,
          overlayOpacity: 0.5,
          elevation: 8.0,
          animationCurve: Curves.easeInOut,
          labelTransitionBuilder: (widget, animation) =>
              ScaleTransition(scale: animation, child: widget),
          animationDuration: const Duration(milliseconds: 300),
          children: [
            SpeedDialChild(
              child: const Icon(Icons.code),
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              label: 'Code Sandbox',
              onTap: () => DebugLogger(message: 'Code Sandbox', level: LogLevel.debug).log(),
            ),
            SpeedDialChild(
              child: const Icon(Icons.question_answer),
              backgroundColor: Colors.orangeAccent,
              foregroundColor: Colors.white,
              label: 'Challenges',
              onTap: () => DebugLogger(message: 'Challenges', level: LogLevel.debug).log(),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavbar(
          onItemSelected: (index) {
            setState(() => selectedIndex = index);
          },
          onItemSelectedNotifier: ValueNotifier(selectedIndex),
        ),
        body: PageTransitionSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) => FadeThroughTransition(
            fillColor: Colors.transparent,
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          ),
          child: pages[selectedIndex],
        ),
      ),
    );
  }
}
