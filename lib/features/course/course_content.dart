import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_sizes.dart';
import '../../shared/models/course.dart';
import '../../shared/models/course/course_lesson.dart';

class CourseContent extends StatefulWidget {
  final List<CourseLesson> _lessons;
  final PageController? _pageController;

  const CourseContent({
    super.key,
    required List<CourseLesson> lessons,
    required PageController controller,
  }): _lessons = lessons, _pageController = controller;

  @override
  State<StatefulWidget> createState() => CourseContentState();
}

class CourseContentState extends State<CourseContent> {

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget._pageController,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget._lessons.length,
      itemBuilder: (context, index) {
        CourseLesson lesson = widget._lessons[index];

        return Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16, vertical: AppSizes.p8),
            child: Center(
              child: Column(
                children: <Widget>[
                  Text(
                    lesson.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: AppSizes.xxlTextSize,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    lesson.content[ContentType.explain] ?? "",
                    textAlign: TextAlign.justify,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}