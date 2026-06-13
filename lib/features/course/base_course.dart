import 'package:codexia_course_learning/core/app_constants.dart';
import 'package:codexia_course_learning/features/course/course_content.dart';
import 'package:codexia_course_learning/shared/enums/course_level.dart';
import 'package:codexia_course_learning/shared/providers/auth_user_notifier.dart';
import 'package:codexia_course_learning/shared/providers/course_list_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/models/course/course_lesson.dart';
import '../../shared/models/user_course_progress.dart';

class BaseCourse extends ConsumerStatefulWidget {
  final String _courseId;
  final CourseLevel _level;
  final String _moduleId;
  final List<CourseLesson> _lessons;

  const BaseCourse({
    super.key,
    required String courseId,
    required CourseLevel level,
    required String moduleId,
    required List<CourseLesson> lessons,
  }) : _courseId = courseId,
       _level = level,
       _moduleId = moduleId,
       _lessons = lessons;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => BaseCourseState();
}

class BaseCourseState extends ConsumerState<BaseCourse> {
  String? title;
  int currentPage = 0;
  int lastPage = 0;
  double completedProgress = 0.0;

  UserCourseProgress? progress;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authUserState = ref.watch(authUserProvider);
    final courseListState = ref.watch(courseListProvider);

    authUserState.whenData((data) {
      progress = data.coursesProgress
          .where((progress) => progress.courseId == widget._courseId)
          .firstOrNull;
    });

    courseListState.whenData((data) {
      title = data
          .where((course) => course.courseId == widget._courseId)
          .first
          .modules?[widget._level]
          ?.where((module) => module.moduleId == widget._moduleId)
          .first
          .title;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ""),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            // progress?.moduleProgress.add(UserModuleProgress(lessonId: widget._moduleId, completedLessons: [for (var lesson in widget._lessons) lesson.id], isComplete: false));
            context.pop();
          },
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: AppSizes.p16,
              bottom: AppSizes.p8,
              left: AppSizes.p24,
              right: AppSizes.p24,
            ),
            child: Column(
              crossAxisAlignment: .start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Lesson Progress",
                      style: TextStyle(fontSize: AppSizes.sTextSize, color: Colors.grey.shade600),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Page ${currentPage + 1} of ${widget._lessons.length}",
                          style: TextStyle(
                            fontSize: AppSizes.sTextSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 2.5),
                        Text(
                          "•",
                          style: TextStyle(
                            fontSize: AppSizes.sTextSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 2.5),
                        Text(
                          NumberFormat.percentPattern().format(completedProgress),
                          style: TextStyle(
                            fontSize: AppSizes.sTextSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  tween: Tween<double>(begin: 0.0, end: completedProgress),
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.3),
                      color: AppColors.primary,
                      minHeight: 10.0,
                      borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.lerp(
                              AppColors.primary.withValues(alpha: 0.6),
                              AppColors.secondary,
                              value,
                            ) ??
                            AppColors.primary.withValues(alpha: 0.6),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12.0),
                PageViewIndicator(currentIndex: currentPage, pageCount: widget._lessons.length),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.p8),
              child: CourseContent(lessons: widget._lessons, controller: pageController),
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                currentPage >= 1
                    ? OutlinedButton.icon(
                        onPressed: () {
                          setState(() => currentPage--);
                          pageController.animateToPage(
                            currentPage,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(120.0, 30.0),
                          side: const BorderSide(color: Colors.grey),
                          overlayColor: Colors.grey.shade400,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                        ),
                        icon: Icon(Icons.arrow_back_ios, size: 16.0, color: Colors.grey.shade700),
                        label: Text(
                          "Previous",
                          style: TextStyle(
                            fontSize: AppSizes.mTextSize,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      if (currentPage == widget._lessons.length - 1) {
                        context.pop();
                        return;
                      } else {
                        currentPage++;
                      }

                      if (lastPage < currentPage) {
                        completedProgress = currentPage / (widget._lessons.length - 1);
                        lastPage = currentPage;
                      }
                    });
                    pageController.animateToPage(
                      currentPage,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    minimumSize: const Size(120.0, 30.0),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  ),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.arrow_forward_ios, size: 16.0, color: Colors.white),
                  label: currentPage != widget._lessons.length - 1
                      ? const Text(
                          "Continue",
                          style: TextStyle(fontSize: AppSizes.mTextSize, color: Colors.white),
                        )
                      : const Text(
                          "Finish",
                          style: TextStyle(fontSize: AppSizes.mTextSize, color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PageViewIndicator extends StatelessWidget {
  final int currentIndex;
  final int pageCount;

  const PageViewIndicator({super.key, required this.currentIndex, required this.pageCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        pageCount,
        (index) => AnimatedContainer(
          width: currentIndex == index ? 42.0 : 24.0,
          height: 8.0,
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(4.0)),
            color: currentIndex == index
                ? AppColors.secondary
                : AppColors.secondary.withValues(alpha: 0.5),
          ),
        ),
      ),
    );
  }
}
