import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:toastification/toastification.dart';

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

  int selectedIndex = 0;
  bool canCloseApp = false;
  DateTime? currentBackPressTime;

  final List<Widget> pages = [
    HomePage(),
    CoursePage(),
    CommunityPage(),
    SettingPage()
  ];

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
          floatingActionButtonLocation: FloatingActionButtonLocation
              .centerDocked,
          floatingActionButton: FloatingActionButton(
            backgroundColor: Color(0xFF00CEC9),
            shape: const CircleBorder(),
            onPressed: () {
              // TODO: Handle FAB action
            },
            child: const Icon(Icons.add, color: Color(0xFFF5F6FA)),
          ),
          bottomNavigationBar: BottomNavbar(
            onItemSelected: (index) {
              setState(() => selectedIndex = index);
            },
            onItemSelectedNotifier: ValueNotifier(selectedIndex),
          ),
          body: PageTransitionSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
                FadeThroughTransition(
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
