import 'package:flutter/material.dart';

class PythonBeginner extends StatefulWidget {
  const PythonBeginner({super.key});

  @override
  State<PythonBeginner> createState() => _PythonBeginnerState();
}

class _PythonBeginnerState extends State<PythonBeginner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Python Beginner"), centerTitle: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              Card(
                elevation: 4.0,
                color: Color(0xFFFCFBFB),
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 42.0,
                      color: Color(0xCC0984E3),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade50, Colors.blue.shade100],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              "10% Completed",
                              style: TextStyle(fontSize: 12.0, color: Colors.blue.shade900),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.lime.shade50, Colors.lime.shade100],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              "7 Modules Left",
                              style: TextStyle(fontSize: 12.0, color: Colors.lime.shade900),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ExpansionTile(
                      title: Text("Introduction to GvRNG", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        "Learn the basics of Python programming language from GvRNG.",
                      ),
                      shape: const Border(),
                      collapsedShape: const Border(),
                      expansionAnimationStyle: AnimationStyle(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        reverseCurve: Curves.easeIn,
                      ),
                      children: <Widget>[
                        Divider(thickness: 1.5, color: Colors.grey.shade300, height: 2.0),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("Introduce GvRNG");
                                  },
                                  leading: Icon(Icons.notes, size: 32.0),
                                  title: Text("Lesson", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("Introduction to GvRNG", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("Writing Function");
                                  },
                                  leading: Icon(Icons.notes, size: 32.0),
                                  title: Text("Lesson", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("Writing Function", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("AI-Generated Practice");
                                  },
                                  leading: Icon(Icons.rocket_launch, size: 32.0),
                                  title: Text("Challenge", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("AI-Generated Practice", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("Condition and Looping Statement");
                                  },
                                  leading: Icon(Icons.notes, size: 32.0),
                                  title: Text("Lesson", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("Condition and Looping Statement", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("Conditional Looping");
                                  },
                                  leading: Icon(Icons.notes, size: 32.0),
                                  title: Text("Lesson", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("Conditional Looping", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("AI-Generated Practice");
                                  },
                                  leading: Icon(Icons.rocket_launch, size: 32.0),
                                  title: Text("Challenge", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("AI-Generated Practice", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("Module 1 Quiz");
                                  },
                                  leading: Icon(Icons.quiz, size: 32.0),
                                  title: Text("Quiz", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("Module 1 Quiz", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 4.0,
                color: Color(0xFFFCFBFB),
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 42.0,
                      color: Color(0xCC0984E3),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade50, Colors.blue.shade100],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              "10% Completed",
                              style: TextStyle(fontSize: 12.0, color: Colors.blue.shade900),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.lime.shade50, Colors.lime.shade100],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              "10 Modules Left",
                              style: TextStyle(fontSize: 12.0, color: Colors.lime.shade900),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ExpansionTile(
                      title: Text("Introduction to Python", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        "Learn the basics of Python programming language.",
                      ),
                      shape: const Border(),
                      collapsedShape: const Border(),
                      expansionAnimationStyle: AnimationStyle(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        reverseCurve: Curves.easeIn,
                      ),
                      children: <Widget>[
                        Divider(thickness: 1.5, color: Colors.grey.shade300, height: 2.0),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("Introduce Python");
                                  },
                                  leading: Icon(Icons.notes, size: 32.0),
                                  title: Text("Lesson", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("Introduction to Python", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("Variable and Data Types");
                                  },
                                  leading: Icon(Icons.notes, size: 32.0),
                                  title: Text("Lesson", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("Variable and Data Types", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("AI-Generated Practice");
                                  },
                                  leading: Icon(Icons.rocket_launch, size: 32.0),
                                  title: Text("Challenge", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("AI-Generated Practice", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("Operator");
                                  },
                                  leading: Icon(Icons.notes, size: 32.0),
                                  title: Text("Lesson", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("Operator", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("Condition and Looping Statement");
                                  },
                                  leading: Icon(Icons.notes, size: 32.0),
                                  title: Text("Lesson", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("Condition and Looping Statement", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("AI-Generated Practice");
                                  },
                                  leading: Icon(Icons.rocket_launch, size: 32.0),
                                  title: Text("Challenge", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("AI-Generated Practice", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("Conditional Looping");
                                  },
                                  leading: Icon(Icons.notes, size: 32.0),
                                  title: Text("Lesson", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("Conditional Looping", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("Function");
                                  },
                                  leading: Icon(Icons.notes, size: 32.0),
                                  title: Text("Lesson", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("Function", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("AI-Generated Practice");
                                  },
                                  leading: Icon(Icons.rocket_launch, size: 32.0),
                                  title: Text("Challenge", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("AI-Generated Practice", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("Module 2 Quiz");
                                  },
                                  leading: Icon(Icons.quiz, size: 32.0),
                                  title: Text("Quiz", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("Module 2 Quiz", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 4.0,
                color: Color(0xFFFCFBFB),
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 42.0,
                      color: Color(0xCC0984E3),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue.shade50, Colors.blue.shade100],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              "10% Completed",
                              style: TextStyle(fontSize: 12.0, color: Colors.blue.shade900),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 4.0,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.lime.shade50, Colors.lime.shade100],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Text(
                              "9 Modules Left",
                              style: TextStyle(fontSize: 12.0, color: Colors.lime.shade900),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ExpansionTile(
                      title: Text("Best Practices in Python", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600)),
                      subtitle: Text(
                        "Learn the best practices in Python programming language.",
                      ),
                      shape: const Border(),
                      collapsedShape: const Border(),
                      expansionAnimationStyle: AnimationStyle(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                        reverseCurve: Curves.easeIn,
                      ),
                      children: <Widget>[
                        Divider(thickness: 1.5, color: Colors.grey.shade300, height: 2.0),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("Debugging in Python");
                                  },
                                  leading: Icon(Icons.notes, size: 32.0),
                                  title: Text("Lesson", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("Debugging in Python", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("Commented Code");
                                  },
                                  leading: Icon(Icons.notes, size: 32.0),
                                  title: Text("Lesson", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("Commented Code", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("N/A");
                                  },
                                  leading: Icon(Icons.edit_note, size: 32.0),
                                  title: Text("Practice", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("N/A", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("AI-Generated Practice");
                                  },
                                  leading: Icon(Icons.rocket_launch, size: 32.0),
                                  title: Text("Challenge", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("AI-Generated Practice", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("User Input");
                                  },
                                  leading: Icon(Icons.notes, size: 32.0),
                                  title: Text("Lesson", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("User Input", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("Data Conversion");
                                  },
                                  leading: Icon(Icons.notes, size: 32.0),
                                  title: Text("Lesson", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("Data Conversion", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("N/A");
                                  },
                                  leading: Icon(Icons.edit_note, size: 32.0),
                                  title: Text("Practice", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("N/A", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("AI-Generated Practice");
                                  },
                                  leading: Icon(Icons.rocket_launch, size: 32.0),
                                  title: Text("Challenge", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("AI-Generated Practice", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                              Card(
                                elevation: 2.0,
                                color: Color(0xFFFCFBFB),
                                clipBehavior: Clip.hardEdge,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
                                child: ListTile(
                                  onTap: () {
                                    print("Module 3 Quiz");
                                  },
                                  leading: Icon(Icons.quiz, size: 32.0),
                                  title: Text("Quiz", style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w600)),
                                  subtitle: Text("Module 3 Quiz", style: TextStyle(fontSize: 15.0)),
                                  trailing: Icon(Icons.arrow_forward_ios, size: 16.0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Card(
              //   elevation: 4.0,
              //   color: Color(0xFFFCFBFB),
              //   margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(15.0),
              //   ),
              //   child: ExpansionTile(
              //     title: Text("Data Structures in Python"),
              //     subtitle: Text(
              //       "Learn about lists, tuples, sets, and dictionaries in Python.",
              //     ),
              //   ),
              // ),
              // Card(
              //   elevation: 4.0,
              //   color: Color(0xFFFCFBFB),
              //   margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(15.0),
              //   ),
              //   child: ExpansionTile(
              //     title: Text("Object-Oriented Programming in Python"),
              //     subtitle: Text(
              //       "Learn about classes, objects, inheritance, and polymorphism in Python.",
              //     ),
              //   ),
              // ),
              // Card(
              //   elevation: 4.0,
              //   color: Color(0xFFFCFBFB),
              //   margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 10.0),
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(15.0),
              //   ),
              //   child: ExpansionTile(
              //     title: Text("Python Libraries"),
              //     subtitle: Text(
              //       "Learn about popular Python libraries such as NumPy, Pandas, and Matplotlib.",
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
