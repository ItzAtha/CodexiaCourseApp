import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../home/models/course_card.dart';

class FlutterCourse extends StatefulWidget {
  const FlutterCourse({super.key});

  @override
  State<FlutterCourse> createState() => _FlutterCourseState();
}

class _FlutterCourseState extends State<FlutterCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter Framework"),
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
                    "In this course, you will learn the fundamentals of Flutter framework: ",
                courseImage: "flutter-background.png",
                courseRoutePath: 'flutter-beginner',
                courseLevel: CourseLevel.beginner,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description: "In this course, you will learn the advanced of Flutter framework: ",
                courseImage: "flutter-background.png",
                courseRoutePath: 'flutter-intermediate',
                courseLevel: CourseLevel.intermediate,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description: "In this course, you will learn the top-level Flutter framework: ",
                courseImage: "flutter-background.png",
                courseRoutePath: 'flutter-expert',
                courseLevel: CourseLevel.expert,
              ).create(context),
              CourseCard(
                type: CardType.courseDetail,
                description: "In this course, you will learning mastering of Flutter framework.",
                courseImage: "flutter-background.png",
                courseRoutePath: 'flutter-master',
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
