import 'package:codexia_course_learning/core/app_constants.dart';
import 'package:codexia_course_learning/features/course/course_content.dart';
import 'package:codexia_course_learning/shared/enums/course_level.dart';
import 'package:codexia_course_learning/shared/models/course.dart';
import 'package:codexia_course_learning/shared/providers/auth_user_notifier.dart';
import 'package:codexia_course_learning/shared/providers/course_list_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/models/course/course_lesson.dart';
import '../../shared/models/course/course_module.dart';
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
  List<int> indexLesson = [];

  int currentPage = 0;
  int lastPage = 0;
  double completedProgress = 0.0;

  UserCourseProgress? courseProgress;
  UserLevelProgress? levelProgress;
  late PageController pageController;

  void onQuizChange(int quizIndex) {
    setState(() => indexLesson.insert(quizIndex, quizIndex));
  }

  void loadProgressData() async {
    final (authUserState, courseListState) = await (
      ref.read(authUserProvider.future),
      ref.read(courseListProvider.future),
    ).wait;

    courseProgress = authUserState.coursesProgress
        .where((progress) => progress.courseId == widget._courseId)
        .firstOrNull;

    levelProgress = courseProgress?.levels
        .where((progress) => progress.levelId == widget._level.name.toLowerCase())
        .firstOrNull;

    levelProgress ??= UserLevelProgress(
      levelId: widget._level.name.toLowerCase(),
      completedLesson: {},
    );

    setState(() {
      if (listEquals(
        levelProgress?.completedLesson[widget._moduleId],
        widget._lessons.map((lesson) => lesson.lessonId).toSet().toList(),
      )) {
        completedProgress = 1.0;
        return;
      }

      int previousIndexPage = levelProgress?.completedLesson[widget._moduleId]?.length ?? 0;
      currentPage = lastPage = previousIndexPage;
      completedProgress = currentPage / (widget._lessons.length - 1);

      pageController.animateToPage(
        previousIndexPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });

    title = courseListState
        .where((course) => course.courseId == widget._courseId)
        .first
        .modules[widget._level]
        ?.where((module) => module.moduleId == widget._moduleId)
        .first
        .title;
  }

  Future<void> updateProgress() async {
    int totalExp = courseProgress?.totalExp ?? 0;

    if (listEquals(
      levelProgress?.completedLesson[widget._moduleId],
      widget._lessons.take(lastPage).map((lesson) => lesson.lessonId).toSet().toList(),
    )) {
      debugPrint("No user progress change! Skipping...");
      return;
    }

    if (levelProgress?.completedLesson[widget._moduleId]?.length == widget._lessons.length) {
      return;
    }

    List<Course> courseList = await ref.read(courseListProvider.future);
    Course? course = courseList.where((c) => c.courseId == widget._courseId).firstOrNull;
    if (course != null) {
      List<CourseModule> modules =
          course.modules.entries
              .where((entry) => entry.key.name == widget._level.name)
              .map((value) => value.value)
              .firstOrNull ??
          [];
      CourseModule? module = modules.where((m) => m.moduleId == widget._moduleId).firstOrNull;
      if (module != null) {
        totalExp += module.expAmount;
      }
    }

    Map<String, List<String>> completedLesson = {...?levelProgress?.completedLesson};
    List<String> completedLessonList = widget._lessons
        .take(lastPage)
        .map((lesson) => lesson.lessonId)
        .toSet()
        .toList();

    completedLesson.update(
      widget._moduleId,
      (value) => completedLessonList,
      ifAbsent: () => completedLessonList,
    );

    UserCourseProgress updatedProgress = courseProgress != null
        ? courseProgress!.copyWith(
            totalExp: totalExp,
            lastAccessedLevel: widget._level.name.toLowerCase(),
            lastAccessedModule: widget._moduleId,
            lastAccessedLesson: widget._lessons[currentPage].lessonId,
            lastAccessedAt: DateTime.now(),
            levels: [
              ...courseProgress!.levels.where(
                (level) => level.levelId != widget._level.name.toLowerCase(),
              ),
              UserLevelProgress(
                levelId: widget._level.name.toLowerCase(),
                completedLesson: completedLesson,
              ),
            ],
          )
        : UserCourseProgress(
            courseId: widget._courseId,
            totalExp: totalExp,
            lastAccessedLevel: widget._level.name.toLowerCase(),
            lastAccessedModule: widget._moduleId,
            lastAccessedLesson: widget._lessons[currentPage].lessonId,
            lastAccessedAt: DateTime.now(),
            levels: [
              UserLevelProgress(
                levelId: widget._level.name.toLowerCase(),
                completedLesson: completedLesson,
              ),
            ],
          );

    await ref.read(authUserProvider.notifier).updateCourses(updatedProgress);
  }

  @override
  void initState() {
    super.initState();

    indexLesson.addAll(
      widget._lessons
          .asMap()
          .entries
          .where((entry) => entry.value is MaterialLesson)
          .map((entry) => entry.key),
    );

    pageController = PageController(initialPage: 0);
    loadProgressData();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? ""),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () async {
            await updateProgress();

            if (context.mounted) {
              context.pop();
            }
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
          Container(
            padding: const EdgeInsets.only(
              top: AppSizes.p16,
              bottom: AppSizes.p16,
              left: AppSizes.p24,
              right: AppSizes.p24,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Lesson Progress",
                      style: TextStyle(
                        fontSize: AppSizes.sTextSize,
                        color: Theme.of(
                          context,
                        ).textTheme.labelSmall?.color?.withValues(alpha: 0.8),
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          "Page ${currentPage + 1} of ${widget._lessons.length}",
                          style: TextStyle(
                            fontSize: AppSizes.sTextSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              context,
                            ).textTheme.labelSmall?.color?.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(width: 2.5),
                        Text(
                          "•",
                          style: TextStyle(
                            fontSize: AppSizes.sTextSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              context,
                            ).textTheme.labelSmall?.color?.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(width: 2.5),
                        Text(
                          NumberFormat.percentPattern().format(completedProgress),
                          style: TextStyle(
                            fontSize: AppSizes.sTextSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(
                              context,
                            ).textTheme.labelSmall?.color?.withValues(alpha: 0.8),
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
              padding: const EdgeInsets.symmetric(horizontal: AppSizes.p8),
              child: CourseContent(
                lessons: widget._lessons,
                controller: pageController,
                onQuizChange: (isChange) => onQuizChange(isChange),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSizes.p16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(24.0),
                topLeft: Radius.circular(24.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  spreadRadius: 1.5,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
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
                        icon: Icon(
                          Icons.arrow_back_ios,
                          size: 16.0,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        label: Text(
                          "Previous",
                          style: TextStyle(
                            fontSize: AppSizes.mTextSize,
                            color: Theme.of(context).textTheme.labelSmall?.color,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                ElevatedButton.icon(
                  onPressed: !indexLesson.contains(currentPage)
                      ? null
                      : () async {
                          if (currentPage == widget._lessons.length - 1) {
                            if (!listEquals(
                              levelProgress?.completedLesson[widget._moduleId],
                              widget._lessons.map((lesson) => lesson.lessonId).toSet().toList(),
                            )) {
                              lastPage += 1;
                              await updateProgress();
                            }

                            if (context.mounted) {
                              context.pop();
                              return;
                            }
                          }

                          setState(() {
                            currentPage++;

                            if (lastPage < currentPage) {
                              if (listEquals(
                                levelProgress?.completedLesson[widget._moduleId],
                                widget._lessons.map((lesson) => lesson.lessonId).toSet().toList(),
                              )) {
                                completedProgress = 1.0;
                              } else {
                                completedProgress = currentPage / (widget._lessons.length - 1);
                              }

                              lastPage = currentPage;
                            }

                            pageController.animateToPage(
                              currentPage,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          });
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
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
