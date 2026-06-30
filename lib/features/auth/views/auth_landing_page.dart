import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_constants.dart' hide ToastAnimations;

class AuthLandingPage extends StatefulWidget {
  const AuthLandingPage({super.key});

  @override
  State<StatefulWidget> createState() => _AuthLandingPageState();
}

class _AuthLandingPageState extends State<AuthLandingPage> {
  late final List<Widget> carouselPage = [
    Container(
      color: Colors.red,
      child: const Padding(
        padding: EdgeInsets.all(AppSizes.p16),
        child: Center(
          child: Text("Page 1", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
      ),
    ),
    Container(
      color: Colors.yellow,
      child: const Padding(
        padding: EdgeInsets.all(AppSizes.p16),
        child: Center(
          child: Text("Page 2", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
      ),
    ),
    Container(
      color: Colors.green,
      child: const Padding(
        padding: EdgeInsets.all(AppSizes.p16),
        child: Center(
          child: Text("Page 3", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
      ),
    ),
    Container(
      color: Colors.cyan,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Codexia Course Learning",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.goNamed(AppRoutes.loginRoute.name);
                    },
                    child: const Text(
                      "Get Started",
                      style: TextStyle(fontSize: AppSizes.mTextSize, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ];

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = false;
    final themeMode = AdaptiveTheme.of(context).mode;
    if (themeMode == AdaptiveThemeMode.system) {
      isDarkMode = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    } else {
      isDarkMode = themeMode == AdaptiveThemeMode.dark;
    }

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: Stack(
            children: [
              PageView.builder(
                itemCount: carouselPage.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return carouselPage[index];
                },
              ),
              Positioned(
                bottom: 25.0,
                left: 0,
                right: 0,
                child: PageViewIndicator(currentIndex: currentPage, pageCount: carouselPage.length),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageViewIndicator extends StatelessWidget {
  final int currentIndex;
  final int pageCount;

  const PageViewIndicator({super.key, required this.currentIndex, required this.pageCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => AnimatedScale(
          scale: currentIndex == index ? 1.5 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            width: 8.0,
            height: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: AppSizes.p8 / 2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentIndex == index ? Colors.white : Colors.white54,
            ),
          ),
        ),
      ),
    );
  }
}
