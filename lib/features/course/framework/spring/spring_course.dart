import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../home/models/course_card.dart';

class SpringCourse extends StatefulWidget {
  const SpringCourse({super.key});

  @override
  State<SpringCourse> createState() => _SpringCourseState();
}

class _SpringCourseState extends State<SpringCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Spring Framework"),
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
                    "In this course, you will learn the fundamentals of Spring framework: ",
                courseImage: "spring-background.png",
                courseRoutePath: 'spring-beginner',
                courseLevel: CourseLevel.beginner,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description: "In this course, you will learn the advanced of Spring framework: ",
                courseImage: "spring-background.png",
                courseRoutePath: 'spring-intermediate',
                courseLevel: CourseLevel.intermediate,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description: "In this course, you will learn the top-level Spring framework: ",
                courseImage: "spring-background.png",
                courseRoutePath: 'spring-expert',
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
