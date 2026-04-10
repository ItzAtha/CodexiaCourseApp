import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../home/models/course_card.dart';

class PlatformIOCourse extends StatefulWidget {
  const PlatformIOCourse({super.key});

  @override
  State<PlatformIOCourse> createState() => _PlatformIOCourseState();
}

class _PlatformIOCourseState extends State<PlatformIOCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PlatformIO Framework"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back),
          style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
        ),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CourseCard(
                type: CardType.courseDetail,
                description:
                    "In this course, you will learn the fundamentals of PlatformIO framework: ",
                courseImage: "platformio-background.png",
                courseRoutePath: 'platformio-beginner',
                courseLevel: CourseLevel.beginner,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description:
                    "In this course, you will learn the advanced of PlatformIO framework: ",
                courseImage: "platformio-background.png",
                courseRoutePath: 'platformio-intermediate',
                courseLevel: CourseLevel.intermediate,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description: "In this course, you will learn the top-level PlatformIO framework: ",
                courseImage: "platformio-background.png",
                courseRoutePath: 'platformio-expert',
                courseLevel: CourseLevel.expert,
              ).create(context),
              CourseCard(
                type: CardType.courseDetail,
                description: "In this course, you will learning mastering of PlatformIO framework.",
                courseImage: "platformio-background.png",
                courseRoutePath: 'platformio-master',
                courseLevel: CourseLevel.master,
              ).create(context),
              SizedBox(height: 80.0),
            ],
          ),
        ),
      ),
    );
  }
}
