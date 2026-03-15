import 'package:animations/animations.dart';
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
      appBar: AppBar(title: Text("Python Development"), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              OpenContainer(
                  tappable: false,
                  closedElevation: 0.0,
                  openElevation: 4.0,
                  closedColor: Color(0xFFF5F6FA),
                  openColor: Color(0xFFF5F6FA),
                  transitionType: ContainerTransitionType.fadeThrough,
                  transitionDuration: Duration(milliseconds: 800),
                  closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  closedBuilder: (context, openAction) {
                    return Card(
                      elevation: 4.0,
                      clipBehavior: Clip.antiAlias,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 10.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 120.0,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: -40.0,
                                  left: 0,
                                  right: 0,
                                  child: Image.asset("assets/images/python-background.png"),
                                ),

                                Positioned(
                                  right: 10.0,
                                  top: 10.0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 4.0,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.green.shade100,
                                          Colors.green.shade300,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Text(
                                      "Beginner Level",
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.green.shade900,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  "What you'll learn",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                Text(
                                  "In this course, you will learn the fundamentals of python programming language: python syntax, data type, operator, conditional statements, looping, conditional looping, and functions.",
                                  textAlign: TextAlign.justify,
                                ),
                                Divider(
                                  thickness: 1.0,
                                  color: Colors.grey.shade400,
                                  height: 20.0,
                                ),
                                ElevatedButton(
                                  onPressed: openAction,
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                      Color(0xFF0984E3),
                                    ),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    "Get Started",
                                    style: TextStyle(
                                      color: Color(0xFFF5F6FA),
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  openBuilder: (context, closeAction) => PythonBeginner()
              ),
              SizedBox(height: 10.0),
              Card(
                elevation: 4.0,
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 10.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 120.0,
                      child: Stack(
                        children: [
                          Positioned(
                            top: -40.0,
                            left: 0,
                            right: 0,
                            child: Image.asset("assets/images/python-background.png"),
                          ),

                          Positioned(
                            right: 10.0,
                            top: 10.0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.orange.shade100,
                                    Colors.orange.shade300,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                "Intermediate Level",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.orange.shade900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "What you'll learn",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "In this course, you will learn advanced of the Python programming language: Collections, Processing data in files, Modules, Class, Inheritance, Polymorphism, Encapsulation, Abstraction, Enum, and Exception handling.",
                            textAlign: TextAlign.justify,
                          ),
                          Divider(
                            thickness: 1.0,
                            color: Colors.grey.shade400,
                            height: 20.0,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Color(0xFF0984E3),
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            child: Text(
                              "Get Started",
                              style: TextStyle(
                                color: Color(0xFFF5F6FA),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Card(
                elevation: 4.0,
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.symmetric(
                  horizontal: 4.0,
                  vertical: 10.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 120.0,
                      child: Stack(
                        children: [
                          Positioned(
                            top: -40.0,
                            left: 0,
                            right: 0,
                            child: Image.asset("assets/images/python-background.png"),
                          ),

                          Positioned(
                            right: 10.0,
                            top: 10.0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.red.shade100,
                                    Colors.red.shade300,
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Text(
                                "Expert Level",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.red.shade900,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "What you'll learn",
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            "In this course, you will learn the top-level Python programming language: GUI, HTTP, and Web Server.",
                            textAlign: TextAlign.justify,
                          ),
                          Divider(
                            thickness: 1.0,
                            color: Colors.grey.shade400,
                            height: 20.0,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                                Color(0xFF0984E3),
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ),
                            child: Text(
                              "Get Started",
                              style: TextStyle(
                                color: Color(0xFFF5F6FA),
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
