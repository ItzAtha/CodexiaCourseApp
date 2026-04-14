import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/enums/course_level.dart';
import '../../../home/models/course_card.dart';

class DartCourse extends StatefulWidget {
  const DartCourse({super.key});

  @override
  State<DartCourse> createState() => _DartCourseState();
}

class _DartCourseState extends State<DartCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dart Development"),
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
                    "In this course, you will learn the fundamentals of Dart programming language: ",
                courseImage: "dart-background.png",
                courseRoutePath: 'dart-beginner',
                courseLevel: CourseLevel.beginner,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description:
                    "In this course, you will learn the advanced of Dart programming language: ",
                courseImage: "dart-background.png",
                courseRoutePath: 'dart-intermediate',
                courseLevel: CourseLevel.intermediate,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description:
                    "In this course, you will learn the top-level Dart programming language: ",
                courseImage: "dart-background.png",
                courseRoutePath: 'dart-expert',
                courseLevel: CourseLevel.expert,
              ).create(context),
              CourseCard(
                type: CardType.courseDetail,
                description:
                    "In this course, you will learning mastering of Dart programming language.",
                courseImage: "dart-background.png",
                courseRoutePath: 'dart-master',
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
