import 'package:animations/animations.dart';
import 'package:codexia_course_learning/features/home/models/bottom_navbar.dart';
import 'package:codexia_course_learning/features/home/views/home_page.dart';
import 'package:codexia_course_learning/features/home/views/community_page.dart';
import 'package:codexia_course_learning/features/home/views/course_page.dart';
import 'package:codexia_course_learning/features/home/views/setting_page.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  int selectedIndex = 0;
  final List<Widget> pages = [
    HomePage(),
    CoursePage(),
    CommunityPage(),
    SettingPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
