import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/enums/course_level.dart';
import '../../../home/models/course_card.dart';

class CPPCourse extends StatefulWidget {
  const CPPCourse({super.key});

  @override
  State<CPPCourse> createState() => _CPPCourseState();
}

class _CPPCourseState extends State<CPPCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("C Development"),
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
                    "In this course, you will learn the fundamentals of C programming language: ",
                courseImage: "c-background.png",
                courseRoutePath: 'c-beginner',
                courseLevel: CourseLevel.beginner,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description:
                    "In this course, you will learn the advanced of C programming language: ",
                courseImage: "c-background.png",
                courseRoutePath: 'c-intermediate',
                courseLevel: CourseLevel.intermediate,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description:
                    "In this course, you will learn the top-level C programming language: ",
                courseImage: "c-background.png",
                courseRoutePath: 'c-expert',
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
