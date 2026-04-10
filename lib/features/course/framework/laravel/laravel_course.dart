import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../home/models/course_card.dart';

class LaravelCourse extends StatefulWidget {
  const LaravelCourse({super.key});

  @override
  State<LaravelCourse> createState() => _LaravelCourseState();
}

class _LaravelCourseState extends State<LaravelCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Laravel Framework"),
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
                    "In this course, you will learn the fundamentals of Laravel framework: ",
                courseImage: "laravel-background.png",
                courseRoutePath: 'laravel-beginner',
                courseLevel: CourseLevel.beginner,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description: "In this course, you will learn the advanced of Laravel framework: ",
                courseImage: "laravel-background.png",
                courseRoutePath: 'laravel-intermediate',
                courseLevel: CourseLevel.intermediate,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description: "In this course, you will learn the top-level Laravel framework: ",
                courseImage: "laravel-background.png",
                courseRoutePath: 'laravel-expert',
                courseLevel: CourseLevel.expert,
              ).create(context),
              SizedBox(height: 80.0),
            ],
          ),
        ),
      ),
    );
  }
}
