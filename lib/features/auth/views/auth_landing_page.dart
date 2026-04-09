import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthLandingPage extends StatefulWidget {
  const AuthLandingPage({super.key});

  @override
  State<StatefulWidget> createState() => _AuthLandingPageState();
}

class _AuthLandingPageState extends State<AuthLandingPage> {
  late final List<Widget> carouselPage = [
    Container(
      color: Colors.red,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text("Page 1", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
      ),
    ),
    Container(
      color: Colors.yellow,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text("Page 2", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
      ),
    ),
    Container(
      color: Colors.green,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text("Page 3", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        ),
      ),
    ),
    Container(
      color: Colors.cyan,
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to Codexia Course Learning",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.goNamed('register');
                    },
                    child: Text(
                      "Get Started",
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Codexia Learning Course"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x990984E3), Color(0xFF0984E3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
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
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
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
