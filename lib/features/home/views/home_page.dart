import 'dart:math';

import 'package:codexia_course_learning/features/home/models/app_bar.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';

import '../models/progress_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final carouselController = PageController(viewportFraction: 0.85);

  final progressCardList = [
    ProgressCard(
      title: "Python Development",
      startDate: "07 Sept 2024",
      level: Level.intermediate,
      progress: 0.65,
      courseImage: "python.svg",
    ),
    ProgressCard(
      title: "Flutter Framework Development",
      startDate: "15 Aug 2024",
      level: Level.expert,
      progress: 0.48,
      courseImage: "flutter.svg",
    ),
    ProgressCard(
      title: "Java Development",
      startDate: "01 Oct 2024",
      level: Level.beginner,
      progress: 0.87,
      courseImage: "java.svg",
    ),
    ProgressCard(
      title: "React JS Library",
      startDate: "20 Aug 2024",
      level: Level.intermediate,
      progress: 0.32,
      courseImage: "reactjs.svg",
    ),
    ProgressCard(
      title: "Arduino Development",
      startDate: "10 Sept 2024",
      level: Level.expert,
      progress: 0.72,
      courseImage: "arduino.svg",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 25.0),
            ExpandablePageView.builder(
              controller: carouselController,
              clipBehavior: Clip.none,
              itemCount: progressCardList.length,
              itemBuilder: (BuildContext context, int index) {
                if (!carouselController.position.haveDimensions) {
                  return const SizedBox();
                }
                return AnimatedBuilder(
                  animation: carouselController,
                  builder: (context, child) {
                    double scale = 1.0;
                    if (carouselController.position.haveDimensions) {
                      scale = max(0.8, 1 - (carouselController.page! - index).abs() * 0.2);
                    }
                    return Transform.scale(
                      scale: scale,
                      child: progressCardList[index].create(context),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
