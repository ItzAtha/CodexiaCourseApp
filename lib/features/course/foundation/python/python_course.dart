import 'package:codexia_course_learning/features/home/widgets/course_module_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/app_constants.dart' show AppSizes, AppColors;

class PythonCourse extends StatefulWidget {
  const PythonCourse({super.key});

  @override
  State<PythonCourse> createState() => _PythonCourseState();
}

class _PythonCourseState extends State<PythonCourse> {
  final courseModulesList = [
    CourseModuleCard(
      1,
      "Python Basics",
      "Introduction & setup",
      8,
      150,
      1.0,
      const Duration(hours: 2, minutes: 30),
    ),
    CourseModuleCard(
      2,
      "Variables & Types",
      "Core data manipulation",
      6,
      120,
      1.0,
      const Duration(hours: 1, minutes: 45),
    ),
    CourseModuleCard(
      3,
      "Control Flow",
      "Condition & loop",
      10,
      200,
      0.65,
      const Duration(hours: 3, minutes: 0),
    ),
    CourseModuleCard(
      4,
      "Function & Scope",
      "Reusable code blocks",
      7,
      200,
      0.65,
      const Duration(hours: 2, minutes: 15),
      isLocked: true,
    ),
    CourseModuleCard(
      5,
      "Data Structures",
      "List, dicts & sets",
      9,
      200,
      0.65,
      const Duration(hours: 2, minutes: 45),
      isLocked: true,
    ),
    CourseModuleCard(
      6,
      "String Methods",
      "Text processing tools",
      5,
      200,
      0.65,
      const Duration(hours: 1, minutes: 30),
      isLocked: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Python Development"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
          style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary.withValues(alpha: 0.6), AppColors.primary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            right: AppSizes.p16,
            left: AppSizes.p16,
            top: AppSizes.p16,
          ),
          child: Column(
            children: <Widget>[
              Card(
                elevation: 2.0,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary.withValues(alpha: 0.75), AppColors.primary],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSizes.p16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Overall Progress", style: TextStyle(color: Colors.white)),
                              Text(
                                "55%",
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "2/6 modules completed",
                                style: TextStyle(
                                  fontSize: AppSizes.smTextSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 12.0),
                              SizedBox(
                                width: 180.0,
                                child: LinearProgressIndicator(
                                  value: 0.55,
                                  backgroundColor: Colors.white24,
                                  color: Colors.white,
                                  minHeight: 8,
                                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 110,
                          padding: const EdgeInsets.all(AppSizes.p12),
                          decoration: BoxDecoration(
                            color: AppColors.primary.toMaterialColor.shade700,
                            borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                          ),
                          child: const Column(
                            children: <Widget>[
                              FaIcon(FontAwesomeIcons.bolt, size: 28, color: Colors.white),
                              SizedBox(height: 8.0),
                              Text(
                                "453",
                                style: TextStyle(
                                  fontSize: AppSizes.xlTextSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "XP Earned",
                                style: TextStyle(
                                  fontSize: AppSizes.smTextSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(AppSizes.p8),
                child: Row(
                  children: <Widget>[
                    OutlinedButton(
                      onPressed: () => {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green.shade300,
                        minimumSize: const Size(120.0, 40.0),
                        side: BorderSide(color: Colors.green.shade400),
                      ),
                      child: Text(
                        "Beginner",
                        style: TextStyle(color: Theme.of(context).textTheme.labelSmall?.color),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    OutlinedButton(
                      onPressed: () => {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.orange.shade300,
                        minimumSize: const Size(120.0, 40.0),
                        side: BorderSide(color: Colors.orange.shade400),
                      ),
                      child: Text(
                        "Intermediate",
                        style: TextStyle(color: Theme.of(context).textTheme.labelSmall?.color),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    OutlinedButton(
                      onPressed: () => {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red.shade300,
                        minimumSize: const Size(120.0, 40.0),
                        side: BorderSide(color: Colors.red.shade400),
                      ),
                      child: Text(
                        "Expert",
                        style: TextStyle(color: Theme.of(context).textTheme.labelSmall?.color),
                      ),
                    ),
                    const SizedBox(width: 12.0),
                    OutlinedButton(
                      onPressed: () => {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.purple.shade300,
                        minimumSize: const Size(120.0, 40.0),
                        side: BorderSide(color: Colors.purple.shade400),
                      ),
                      child: Text(
                        "Master",
                        style: TextStyle(color: Theme.of(context).textTheme.labelSmall?.color),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: AppSizes.p16),
                  itemCount: courseModulesList.length,
                  itemBuilder: (context, index) {
                    return courseModulesList[index];
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 12.0);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
