import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/enums/course_level.dart';
import '../../../home/models/course_card.dart';

class ReactJSCourse extends StatefulWidget {
  const ReactJSCourse({super.key});

  @override
  State<ReactJSCourse> createState() => _ReactJSCourseState();
}

class _ReactJSCourseState extends State<ReactJSCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ReactJS Framework"),
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
                    "In this course, you will learn the fundamentals of ReactJS framework: ",
                courseImage: "reactjs-background.png",
                courseRoutePath: 'reactjs-beginner',
                courseLevel: CourseLevel.beginner,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description: "In this course, you will learn the advanced of ReactJS framework: ",
                courseImage: "reactjs-background.png",
                courseRoutePath: 'reactjs-intermediate',
                courseLevel: CourseLevel.intermediate,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description: "In this course, you will learn the top-level ReactJS framework: ",
                courseImage: "reactjs-background.png",
                courseRoutePath: 'reactjs-expert',
                courseLevel: CourseLevel.expert,
              ).create(context),
              CourseCard(
                type: CardType.courseDetail,
                description: "In this course, you will learning mastering of ReactJS framework.",
                courseImage: "reactjs-background.png",
                courseRoutePath: 'reactjs-master',
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
