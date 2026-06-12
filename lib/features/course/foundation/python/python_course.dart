import 'package:codexia_course_learning/features/home/widgets/course_module_card.dart';
import 'package:codexia_course_learning/shared/enums/course_level.dart';
import 'package:codexia_course_learning/shared/models/user_course.dart';
import 'package:codexia_course_learning/shared/providers/auth_user_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/app_constants.dart' show AppSizes, AppColors, ToastAnimations;
import '../../../../core/utils/logger.dart';
import '../../../../shared/models/course.dart';
import '../../../../shared/providers/course_list_notifier.dart';

class PythonCourse extends ConsumerStatefulWidget {
  const PythonCourse({super.key, required this.courseId});

  final String courseId;

  @override
  ConsumerState<PythonCourse> createState() => _PythonCourseState();
}

class _PythonCourseState extends ConsumerState<PythonCourse> {
  double overallProgress = 0.0;
  int completedModules = 0;
  int totalModules = 0;

  Course? course;
  List<List<Widget>> modulesCarouselPage = [];
  CourseLevel currentCourseLevel = CourseLevel.beginner;

  late PageController? pageController;

  Future<void> loadCourseStats() async {
    final authUser = await ref.read(authUserProvider.future);

    Map<CourseLevel, List<CourseModule>>? modulesData = course?.modules;
    UserCourseProgress? courseProgress = authUser.coursesProgress
        .where((course) => course.courseId == widget.courseId)
        .firstOrNull;

    if (modulesData != null && courseProgress != null) {
      UserLevelProgress? levelProgress = courseProgress.levelProgress
          .where((level) => level.levelName == currentCourseLevel.name.toLowerCase())
          .firstOrNull;

      if (levelProgress != null) {
        setState(() {
          completedModules = levelProgress.completedModules.length;
          totalModules = levelProgress.totalModules;
          overallProgress = completedModules / totalModules;
        });
      }
    }
  }

  Future<void> loadCourseModules() async {
    final authUser = await ref.read(authUserProvider.future);

    Map<CourseLevel, List<CourseModule>>? modulesData = course?.modules;
    UserCourseProgress? courseProgress = authUser.coursesProgress
        .where((course) => course.courseId == widget.courseId)
        .firstOrNull;

    if (modulesData != null && courseProgress != null) {
      for (final modules in modulesData.entries) {
        List<Widget> modulesWidget = [];

        CourseLevel level = modules.key;
        List<CourseModule> courseModulesList = modules.value;

        for (var i = 0; i < courseModulesList.length; i++) {
          CourseModule module = modules.value[i];
          UserModuleProgress? moduleProgress = courseProgress.moduleProgress
              .where((m) => m.moduleId == module.moduleId)
              .firstOrNull;

          int totalLesson = module.lessons.length;
          int totalCompleted = moduleProgress?.completedLessons.length ?? 0;
          double progress = totalCompleted / totalLesson;

          bool isLocked = false;
          if (i >= 1) {
            CourseModule moduleTemp = modules.value[i - 1];
            UserLevelProgress? levelProgress = courseProgress.levelProgress
                .where((level) => level.levelName == currentCourseLevel.name.toLowerCase())
                .firstOrNull;

            if (levelProgress != null) {
              try {
                isLocked = levelProgress.completedModules[i - 1] != moduleTemp.moduleId;
              } catch (e) {
                isLocked = true;
              }
            }
          }

          Widget moduleWidget =
              CourseModuleCard(course!.courseId, level, module, progress, isLocked: isLocked)
                  .animate(delay: Duration(milliseconds: 250 * i))
                  .moveY(
                    duration: const Duration(milliseconds: 500),
                    begin: 20,
                    end: 0,
                    curve: Curves.easeInOut,
                  )
                  .fadeIn(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
          modulesWidget.add(moduleWidget);
        }

        setState(() => modulesCarouselPage.add(modulesWidget));
      }
    } else {
      DebugLogger(
        message: "Failed to load course modules data, modules is empty!",
        level: LogLevel.info,
      ).log();
    }
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    ref.read(courseListProvider.notifier).fetchModules(widget.courseId);
  }

  @override
  void dispose() {
    pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(courseListProvider, (previous, next) {
      next.when(
        data: (data) {
          course = data.firstWhere((course) => course.courseId == widget.courseId);

          if (course != null) {
            loadCourseStats();
            loadCourseModules();
            print("Course Models Data:");
            DebugLogger(message: course!.toJson(), level: LogLevel.trace).log();
          } else {
            DebugLogger(message: "Failed to get course data", level: LogLevel.info).log();
          }
        },
        error: (error, stackTrace) {
          DebugLogger(
            message: "Error loading course modules data: $error",
            stackTrace: stackTrace,
            level: LogLevel.error,
          ).log();
          Toastification().show(
            context: context,
            title: const Text("Couldn't load course modules"),
            type: ToastificationType.error,
            style: ToastificationStyle.flat,
            alignment: Alignment.bottomCenter,
            autoCloseDuration: ToastAnimations.closeDuration,
            animationDuration: ToastAnimations.animationDuration,
          );
        },
        loading: () {
          DebugLogger(message: "Loading course modules...", level: LogLevel.info).log();
        },
      );
    });

    return PopScope(
      onPopInvokedWithResult: (_, _) {
        ref.read(courseListProvider.notifier).unloadModules(widget.courseId);
        ref.read(authUserProvider.notifier).refetchProgress();
      },
      child: Scaffold(
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
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  "Overall Progress",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "${(overallProgress * 100).toInt()}%",
                                  style: const TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  "$completedModules/$totalModules modules completed",
                                  style: const TextStyle(
                                    fontSize: AppSizes.smTextSize,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12.0),
                                SizedBox(
                                  width: 180.0,
                                  child: LinearProgressIndicator(
                                    value: overallProgress,
                                    backgroundColor: Colors.white24,
                                    color: Colors.white,
                                    minHeight: 8,
                                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
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
                      FilterChip(
                        label: const Text("Beginner", style: TextStyle(fontSize: 14.0)),
                        onSelected: (selected) {
                          setState(() => currentCourseLevel = CourseLevel.beginner);
                          pageController?.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          loadCourseStats();
                        },
                        selected: currentCourseLevel == CourseLevel.beginner,
                        selectedColor: Colors.green.shade400,
                        backgroundColor: Colors.green.shade100,
                        side: BorderSide(color: Colors.green.shade700, width: 1.5),
                      ),
                      const SizedBox(width: 12.0),
                      FilterChip(
                        label: const Text("Intermediate", style: TextStyle(fontSize: 14.0)),
                        onSelected: (selected) {
                          setState(() => currentCourseLevel = CourseLevel.intermediate);
                          pageController?.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          loadCourseStats();
                        },
                        selected: currentCourseLevel == CourseLevel.intermediate,
                        selectedColor: Colors.orange.shade400,
                        backgroundColor: Colors.orange.shade100,
                        side: BorderSide(color: Colors.orange.shade700, width: 1.5),
                      ),
                      const SizedBox(width: 12.0),
                      FilterChip(
                        label: const Text("Expert", style: TextStyle(fontSize: 14.0)),
                        onSelected: (selected) {
                          setState(() => currentCourseLevel = CourseLevel.expert);
                          pageController?.animateToPage(
                            2,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          loadCourseStats();
                        },
                        selected: currentCourseLevel == CourseLevel.expert,
                        selectedColor: Colors.red.shade400,
                        backgroundColor: Colors.red.shade100,
                        side: BorderSide(color: Colors.red.shade700, width: 1.5),
                      ),
                      const SizedBox(width: 12.0),
                      FilterChip(
                        label: const Text("Master", style: TextStyle(fontSize: 14.0)),
                        onSelected: (selected) {
                          setState(() => currentCourseLevel = CourseLevel.master);
                          pageController?.animateToPage(
                            3,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                          loadCourseStats();
                        },
                        selected: currentCourseLevel == CourseLevel.master,
                        selectedColor: Colors.purple.shade400,
                        backgroundColor: Colors.purple.shade100,
                        side: BorderSide(color: Colors.purple.shade700, width: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: modulesCarouselPage.length,
                    itemBuilder: (context, index) {
                      List<Widget> modulesWidget = modulesCarouselPage[index];

                      return ListView.separated(
                        padding: const EdgeInsets.only(bottom: AppSizes.p16),
                        itemCount: modulesWidget.length,
                        itemBuilder: (context, index) {
                          return modulesWidget[index];
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(height: 12.0);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
