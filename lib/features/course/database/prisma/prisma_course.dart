import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../home/models/course_card.dart';

class PrismaCourse extends StatefulWidget {
  const PrismaCourse({super.key});

  @override
  State<PrismaCourse> createState() => _PrismaCourseState();
}

class _PrismaCourseState extends State<PrismaCourse> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prisma Database"),
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
                description: "In this course, you will learn the fundamentals of Prisma database: ",
                courseImage: "prisma-background.png",
                courseRoutePath: 'prisma-beginner',
                courseLevel: CourseLevel.beginner,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description: "In this course, you will learn the advanced of Prisma database: ",
                courseImage: "prisma-background.png",
                courseRoutePath: 'prisma-intermediate',
                courseLevel: CourseLevel.intermediate,
              ).create(context),
              SizedBox(height: 10.0),
              CourseCard(
                type: CardType.courseDetail,
                description: "In this course, you will learn the top-level Prisma database: ",
                courseImage: "prisma-background.png",
                courseRoutePath: 'prisma-expert',
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
