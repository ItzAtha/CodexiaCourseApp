import 'dart:math';

import 'package:codexia_course_learning/shared/enums/course_level.dart';
import 'package:codexia_course_learning/shared/models/course.dart';
import 'package:codexia_course_learning/shared/models/course/course_module.dart';
import 'package:codexia_course_learning/shared/providers/course_list_notifier.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../core/app_constants.dart' show AppSizes;
import '../../../shared/models/auth_user.dart';
import '../../../shared/models/course/course_lesson.dart';
import '../../../shared/models/user_course_progress.dart';
import '../../../shared/providers/auth_user_notifier.dart';
import '../widgets/app_bar.dart';
import '../widgets/progress_card.dart';

final progressDataProvider = FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final results = await Future.wait([
    ref.watch(authUserProvider.future),
    ref.watch(courseListProvider.future),
  ]);

  return [results[0], results[1]];
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool isLoadedComplete = false;
  bool isProgressTrackerLoad = false;
  List<ProgressCard> progressCard = [];
  late Future<List<dynamic>> progressData;

  final carouselController = PageController(viewportFraction: 0.9);
  final UniqueKey skeletonizerKey = UniqueKey();

  Widget loadCourseData() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 150.0),
          child: Skeletonizer(
            key: skeletonizerKey,
            enabled: true,
            enableSwitchAnimation: true,
            child: Skeletonizer.zone(
              key: skeletonizerKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Skeleton.unite(
                        key: skeletonizerKey,
                        child: const Row(
                          children: <Widget>[
                            Bone.icon(size: 16.0),
                            SizedBox(width: 5.0),
                            Bone.text(
                              width: 60.0,
                              fontSize: 14.0,
                              borderRadius: BorderRadius.all(Radius.circular(7.0)),
                            ),
                          ],
                        ),
                      ),
                      const Bone(
                        width: 80.0,
                        height: 24.0,
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  const Row(
                    children: <Widget>[
                      Bone.icon(size: 50.0),
                      SizedBox(width: 15.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Bone.text(
                            width: 180.0,
                            fontSize: 16.0,
                            borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          ),
                          SizedBox(height: 25.0),
                          Bone.text(
                            fontSize: 16.0,
                            borderRadius: BorderRadius.all(Radius.circular(7.0)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget noCourseData() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.p16),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.p16),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 150.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "You don't have any courses progress yet. Start learning now to track your progress here!",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadProgressData({
    required List<Course> courseListData,
    required List<UserCourseProgress> courseProgressList,
  }) async {
    for (var index = 0; index < courseProgressList.length; index++) {
      UserCourseProgress courseProgress = courseProgressList[index];

      String courseId = courseProgress.courseId;
      List<UserLevelProgress> levelProgress = courseProgress.levels;

      await ref.read(courseListProvider.notifier).fetchModules(courseId);
      List<Course> courseList = ref.read(courseListProvider).requireValue;
      await ref.read(courseListProvider.notifier).unloadModules(courseId);

      Course? course = courseList.where((b) => b.courseId == courseId).firstOrNull;
      if (course != null) {
        for (final progress in levelProgress) {
          String levelId = progress.levelId;
          Map<String, List<String>> lessons = progress.completedLesson;

          double levelProgress = 0;
          int totalModules =
              course.modules.entries
                  .where((value) => value.key.name.toLowerCase() == levelId)
                  .firstOrNull
                  ?.value
                  .length ??
              0;

          for (final lesson in Map.fromEntries(
            lessons.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
          ).entries) {
            String moduleId = lesson.key;
            List<String> completedLesson = lesson.value;

            List<CourseModule>? modules = course.modules.entries
                .where((value) => value.key.name.toLowerCase() == levelId)
                .map((module) => module.value)
                .firstOrNull;
            if (modules != null) {
              CourseModule? module = modules
                  .where((module) => module.moduleId == moduleId)
                  .firstOrNull;

              if (module != null) {
                List<CourseLesson> lessons = module.lessons;
                levelProgress += completedLesson.length / lessons.length;
              }
            }
          }

          levelProgress = levelProgress / totalModules;
          if (levelProgress < 1.0) {
            progressCard.add(
              ProgressCard(
                title: course.title,
                lastAccessedDate: courseProgress.lastAccessedAt.toIso8601String().split('T')[0],
                level: CourseLevel.values.firstWhere(
                  (level) => level.name.toLowerCase() == courseProgress.lastAccessedLevel,
                  orElse: () => CourseLevel.beginner,
                ),
                progress: levelProgress,
                courseImage: '${course.title.split(' ')[0].toLowerCase()}.svg',
              ),
            );
          }
        }
      }
    }

    setState(() => isLoadedComplete = true);
  }

  @override
  Widget build(BuildContext context) {
    final progressData = ref.watch(progressDataProvider);

    ref.listen(progressDataProvider, (prev, next) {
      next.whenData((data) {
        AuthUser authUser = data[0];
        List<Course> courseListData = data[1];
        List<UserCourseProgress> userCourseProgress = authUser.coursesProgress ?? [];

        if (!isProgressTrackerLoad) {
          loadProgressData(courseListData: courseListData, courseProgressList: userCourseProgress);
          isProgressTrackerLoad = true;
        }
      });
    });

    return Scaffold(
      appBar: const HomeAppBar(),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 25.0),

            progressData.when(
              data: (data) {
                if (!isLoadedComplete) {
                  return loadCourseData();
                }

                if (progressCard.isNotEmpty) {
                  return ExpandablePageView.builder(
                    controller: carouselController,
                    clipBehavior: Clip.none,
                    itemCount: progressCard.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (!carouselController.position.haveDimensions) {
                        return const SizedBox();
                      }

                      return AnimatedBuilder(
                        animation: carouselController,
                        builder: (context, child) {
                          double scale = 1.0;
                          if (carouselController.position.haveDimensions) {
                            scale = max(0.8, 1 - (carouselController.page! - index).abs() * 0.2);
                          }

                          return Transform.scale(
                            scale: scale,
                            child: progressCard[index].create(context),
                          );
                        },
                      );
                    },
                  );
                }
                return noCourseData();
              },
              error: (error, stack) {
                return noCourseData();
              },
              loading: () {
                return loadCourseData();
              },
            ),
          ],
        ),
      ),
    );
  }
}
