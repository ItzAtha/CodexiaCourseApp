import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:codexia_course_learning/features/home/widgets/course_module_card.dart';
import 'package:codexia_course_learning/routes/app_router.dart';
import 'package:codexia_course_learning/shared/enums/course_level.dart';
import 'package:codexia_course_learning/shared/models/user_course_progress.dart';
import 'package:codexia_course_learning/shared/providers/auth_user_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/app_constants.dart' show AppSizes, AppColors, ToastAnimations;
import '../../../../core/utils/logger.dart';
import '../../../../shared/models/course.dart';
import '../../../../shared/models/course/course_module.dart';
import '../../../../shared/providers/course_list_notifier.dart';

class PythonCourse extends ConsumerStatefulWidget {
  const PythonCourse({super.key, required this.courseId});

  final String courseId;

  @override
  ConsumerState<PythonCourse> createState() => _PythonCourseState();
}

class _PythonCourseState extends ConsumerState<PythonCourse> with RouteAware {
  int totalExp = 0;
  int totalModules = 0;
  int completedModules = 0;
  double overallProgress = 0.0;
  bool isModulesLoaded = false;

  Course? course;
  List<List<Widget>> modulesCarouselPage = [];
  CourseLevel currentCourseLevel = CourseLevel.beginner;

  late PageController? pageController;

  Future<void> loadCourseStats() async {
    final authUser = await ref.read(authUserProvider.future);

    Map<CourseLevel, List<CourseModule>> modulesData = course?.modules ?? {};
    UserCourseProgress? courseProgress = authUser.coursesProgress
        ?.where((course) => course.courseId == widget.courseId)
        .firstOrNull;

    if (modulesData.isNotEmpty && courseProgress != null) {
      List<CourseModule>? modulesList = modulesData[currentCourseLevel];
      int totalMods = modulesList?.length ?? 0;

      UserLevelProgress? levelProgress = courseProgress.levels
          .where((level) => level.levelId == currentCourseLevel.name.toLowerCase())
          .firstOrNull;

      int completedMods = 0;
      double overall = 0.0;

      if (levelProgress != null && totalMods > 0 && modulesList != null) {
        double sumProgress = 0.0;

        for (final module in modulesList) {
          int totalLessons = module.lessons.length;

          final lessonIds = module.lessons
              .map((l) {
                try {
                  return (l as dynamic).lessonId as String;
                } catch (_) {
                  try {
                    return (l as dynamic).id as String;
                  } catch (_) {
                    if (l is String) return l;
                    return null;
                  }
                }
              })
              .whereType<String>()
              .toSet();

          final List<dynamic> rawCompletedIds =
              (levelProgress.completedLesson[module.moduleId] as List<dynamic>?) ?? <dynamic>[];

          final int completedLessons = rawCompletedIds
              .where((id) => id is String && lessonIds.contains(id))
              .length;

          if (totalLessons > 0) {
            double prog = completedLessons / totalLessons;
            sumProgress += prog;
            if (completedLessons >= totalLessons) completedMods++;
          } else {
            sumProgress += 0.0;
          }
        }

        overall = sumProgress / totalMods;
      }

      setState(() {
        totalExp = courseProgress.totalExp;
        completedModules = completedMods;
        totalModules = totalMods;
        overallProgress = overall;
      });
    } else {
      setState(() {
        completedModules = 0;
        totalModules = course?.modules[currentCourseLevel]?.length ?? 0;
        overallProgress = 0.0;
      });
    }
  }

  Future<void> loadCourseModules() async {
    final authUser = await ref.read(authUserProvider.future);
    modulesCarouselPage.clear();

    Map<CourseLevel, List<CourseModule>>? modulesData = course?.modules;
    UserCourseProgress? courseProgress = authUser.coursesProgress
        ?.where((course) => course.courseId == widget.courseId)
        .firstOrNull;

    if (modulesData != null) {
      for (final modules in modulesData.entries) {
        List<Widget> modulesWidget = [];

        CourseLevel level = modules.key;
        List<CourseModule> courseModulesList = modules.value;

        for (var i = 0; i < courseModulesList.length; i++) {
          CourseModule module = modules.value[i];

          UserLevelProgress? levelProgress = courseProgress?.levels
              .where((lp) => lp.levelId == level.name.toLowerCase())
              .firstOrNull;

          int totalLesson = module.lessons.length;
          final lessonIds = module.lessons
              .map((l) {
                try {
                  return (l as dynamic).lessonId as String;
                } catch (_) {
                  try {
                    return (l as dynamic).id as String;
                  } catch (_) {
                    if (l is String) return l;
                    return null;
                  }
                }
              })
              .whereType<String>()
              .toSet();

          int totalCompleted = 0;
          if (levelProgress != null) {
            final List<dynamic> rawCompleted =
                (levelProgress.completedLesson[module.moduleId] as List<dynamic>?) ?? <dynamic>[];
            totalCompleted = rawCompleted
                .where((id) => id is String && lessonIds.contains(id))
                .length;
          }

          double progress = totalLesson > 0 ? totalCompleted / totalLesson : 0.0;

          bool isLocked;
          if (i == 0) {
            isLocked = false;
          } else {
            if (levelProgress == null) {
              isLocked = true;
            } else {
              CourseModule previousModule = courseModulesList[i - 1];
              try {
                int previousTotalLessons = previousModule.lessons.length;

                final prevLessonIds = previousModule.lessons
                    .map((l) {
                      try {
                        return (l as dynamic).lessonId as String;
                      } catch (_) {
                        try {
                          return (l as dynamic).id as String;
                        } catch (_) {
                          if (l is String) return l;
                          return null;
                        }
                      }
                    })
                    .whereType<String>()
                    .toSet();

                final List<dynamic> prevRawCompleted =
                    (levelProgress.completedLesson[previousModule.moduleId] as List<dynamic>?) ??
                    <dynamic>[];

                int previousCompletedLessons = prevRawCompleted
                    .where((id) => id is String && prevLessonIds.contains(id))
                    .length;

                isLocked = previousCompletedLessons < previousTotalLessons;
              } catch (e) {
                isLocked = true;
              }
            }
          }

          Widget moduleWidget =
              CourseModuleCard(
                    course!.courseId,
                    level,
                    module,
                    progress.isNaN ? 0.0 : progress,
                    isLocked: isLocked,
                  )
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

    setState(() => isModulesLoaded = true);
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    ref.read(courseListProvider.notifier).fetchModules(widget.courseId);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    AppRouter.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    pageController?.dispose();
    AppRouter.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    () async {
      try {
        await ref.read(authUserProvider.notifier).refetchProgress();

        if (context.mounted) {
          loadCourseStats();
          loadCourseModules();
          debugPrint('Successfully refetch progress!');
        }
      } catch (e) {
        debugPrint('Failed to refetch progress: $e');
      }
    }();
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
            debugPrint("Course Models Data:");
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
          title: Text("Python Development", style: Theme.of(context).textTheme.titleLarge),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: ValueListenableBuilder(
            valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
            builder: (_, mode, child) {
              bool isDarkMode = false;
              if (mode == AdaptiveThemeMode.system) {
                isDarkMode = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
              } else {
                isDarkMode = mode == AdaptiveThemeMode.dark;
              }

              return IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                ),
              );
            },
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
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
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
                                Text(
                                  "Overall Progress",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleSmall?.copyWith(color: Colors.white),
                                ),
                                TweenAnimationBuilder<double>(
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOut,
                                  tween: Tween<double>(begin: 0.0, end: overallProgress),
                                  builder: (context, value, child) {
                                    return Text(
                                      NumberFormat.percentPattern().format(value),
                                      style: const TextStyle(
                                        fontSize: 36,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  "$completedModules/$totalModules modules completed",
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 12.0),
                                SizedBox(
                                  width: 180.0,
                                  child: TweenAnimationBuilder<double>(
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeInOut,
                                    tween: Tween<double>(begin: 0.0, end: overallProgress),
                                    builder: (context, value, child) {
                                      return LinearProgressIndicator(
                                        value: value,
                                        backgroundColor: Colors.white24,
                                        color: Colors.white,
                                        minHeight: 8.0,
                                        borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                                      );
                                    },
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
                            child: Column(
                              children: <Widget>[
                                const FaIcon(FontAwesomeIcons.bolt, size: 28, color: Colors.white),
                                const SizedBox(height: 8.0),
                                TweenAnimationBuilder<double>(
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeInOut,
                                  tween: Tween<double>(begin: 0.0, end: totalExp.toDouble()),
                                  builder: (context, value, child) {
                                    return Text(
                                      "${value.toInt()}",
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleLarge?.copyWith(color: Colors.white),
                                    );
                                  },
                                ),
                                Text(
                                  "XP Earned",
                                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
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
                        label: Text(
                          "Beginner",
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(color: AppColors.textLight),
                        ),
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
                        label: Text(
                          "Intermediate",
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(color: AppColors.textLight),
                        ),
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
                        label: Text(
                          "Expert",
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(color: AppColors.textLight),
                        ),
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
                        label: Text(
                          "Master",
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium?.copyWith(color: AppColors.textLight),
                        ),
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
                  child: isModulesLoaded
                      ? PageView.builder(
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
                        )
                      : Column(
                          mainAxisAlignment: .center,
                          children: <Widget>[
                            CircularProgressIndicator(
                              color: AppColors.secondary,
                              backgroundColor: AppColors.secondary.withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              "Loading Modules...",
                              style: Theme.of(
                                context,
                              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w500),
                            ),
                          ],
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
