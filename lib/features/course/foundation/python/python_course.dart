import 'package:codexia_course_learning/features/home/models/course_card.dart';
import 'package:flutter/material.dart';

import './beginner/views/python_beginner.dart';

class PythonCourse extends StatefulWidget {
  const PythonCourse({super.key});

  @override
  State<PythonCourse> createState() => _PythonCourseState();
}

class _PythonCourseState extends State<PythonCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Python Development"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
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
                    "In this course, you will learn the fundamentals of python programming language: python syntax, data type, operator, conditional statements, looping, conditional looping, and functions.",
                courseImage: "python-background.png",
                courseMenu: PythonBeginner(),
                courseLevel: CourseLevel.beginner,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description:
                    "In this course, you will learn advanced of the Python programming language: Collections, Processing data in files, Modules, Class, Inheritance, Polymorphism, Encapsulation, Abstraction, Enum, and Exception handling.",
                courseImage: "python-background.png",
                courseMenu: PythonBeginner(),
                courseLevel: CourseLevel.intermediate,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description:
                    "In this course, you will learn the top-level Python programming language: GUI, HTTP, and Web Server.",
                courseImage: "python-background.png",
                courseMenu: PythonBeginner(),
                courseLevel: CourseLevel.expert,
              ).create(context),
            ],
          ),
        ),
      ),
    );
  }
}
