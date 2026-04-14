import 'package:codexia_course_learning/features/home/models/course_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/enums/course_level.dart';

class JavaCourse extends StatefulWidget {
  const JavaCourse({super.key});

  @override
  State<JavaCourse> createState() => _JavaCourseState();
}

class _JavaCourseState extends State<JavaCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Java Development"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.pop(context),
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
                    "In this course, you will learn the fundamentals of Java programming language: data type, operator, conditional statements, looping, and functions.",
                courseImage: "java-background.png",
                courseRoutePath: 'java-beginner',
                courseLevel: CourseLevel.beginner,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description:
                    "In this course, you will learn advanced of the Java programming language: Collections, Processing data in files, Class, Inheritance, Polymorphism, Encapsulation, Abstraction, Interface, Nested Class, Enum, and Exception handling.",
                courseImage: "java-background.png",
                courseRoutePath: 'java-intermediate',
                courseLevel: CourseLevel.intermediate,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description:
                    "In this course, you will learn the top-level Java programming language: GUI and HTTP.",
                courseImage: "java-background.png",
                courseRoutePath: 'java-expert',
                courseLevel: CourseLevel.expert,
              ).create(context),
              CourseCard(
                type: CardType.courseDetail,
                description:
                    "In this course, you will learning mastering of Java programming language.",
                courseImage: "java-background.png",
                courseRoutePath: 'java-master',
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
