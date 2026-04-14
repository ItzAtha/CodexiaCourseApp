import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../core/utils/logger.dart';
import '../../shared/providers/auth_user_notifier.dart';
import './models/bottom_navbar.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key, required StatefulNavigationShell navigationShell})
    : _navigationShell = navigationShell;

  final StatefulNavigationShell _navigationShell;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  bool isFloatingActionButtonOpened = false;

  int selectedIndex = 0;
  bool canCloseApp = false;
  DateTime? currentBackPressTime;

  void _onItemTapped(int index) {
    widget._navigationShell.goBranch(
      index,
      initialLocation: index == widget._navigationShell.currentIndex,
    );
  }

  void _onPopInvoked(bool canPop, Object? result) {
    if (selectedIndex != 0) {
      setState(() {
        selectedIndex = 0;
      });
      widget._navigationShell.goBranch(selectedIndex);
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
    final String location = GoRouterState.of(context).uri.path;
    final int segmentCount = location.split('/').where((s) => s.isNotEmpty).length;
    final bool hideNavbar = segmentCount > 1;

    ref.listen(authUserProvider, (previous, next) {
      next.when(
        data: (data) {
          DebugLogger(
            message: "Successfully loaded profile: ${data.username}",
            level: LogLevel.info,
          ).log();
        },
        error: (error, stackTrace) {
          DebugLogger(
            message: "Error loading profile: $error",
            stackTrace: stackTrace,
            level: LogLevel.error,
          ).log();
          Toastification().show(
            context: context,
            title: Text("Couldn't load profile"),
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            alignment: Alignment.bottomCenter,
            autoCloseDuration: Duration(seconds: 2),
            animationDuration: Duration(milliseconds: 500),
          );
        },
        loading: () {
          DebugLogger(message: "Loading profile...", level: LogLevel.info).log();
        },
      );
    });

    return PopScope(
      canPop: canCloseApp,
      onPopInvokedWithResult: (canPop, result) => _onPopInvoked(canPop, result),
      child: Scaffold(
        extendBody: true,
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: !hideNavbar
            ? SpeedDial(
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
                    onTap: () {
                      DebugLogger(message: 'Code Sandbox', level: LogLevel.debug).log();
                    },
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.question_answer),
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                    label: 'Challenges',
                    onTap: () => DebugLogger(message: 'Challenges', level: LogLevel.debug).log(),
                  ),
                  SpeedDialChild(
                    child: const Icon(Icons.psychology),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    label: 'AI Chat Bot',
                    onTap: () {
                      DebugLogger(message: 'AI Chat Bot', level: LogLevel.debug).log();
                      context.pushNamed('ai-chat');
                    },
                  ),
                ],
              )
            : null,
        bottomNavigationBar: !hideNavbar
            ? BottomNavbar(
                onItemSelected: (index) {
                  setState(() => selectedIndex = index);
                  _onItemTapped(selectedIndex);
                },
                onItemSelectedNotifier: ValueNotifier(selectedIndex),
              )
            : null,
        body: widget._navigationShell,
      ),
    );
  }
}
