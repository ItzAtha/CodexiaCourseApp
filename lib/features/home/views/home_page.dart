import 'dart:math';

import 'package:codexia_course_learning/shared/enums/course_level.dart';
import 'package:codexia_course_learning/shared/models/course.dart';
import 'package:codexia_course_learning/shared/providers/course_list_notifier.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../shared/models/auth_user.dart';
import '../../../shared/models/user_course.dart';
import '../../../shared/providers/auth_user_notifier.dart';
import '../widgets/app_bar.dart';
import '../widgets/progress_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final carouselController = PageController(viewportFraction: 0.85);
  final UniqueKey skeletonizerKey = UniqueKey();

  Widget loadCourseData() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                        child: Row(
                          children: <Widget>[
                            const Bone.icon(size: 16.0),
                            const SizedBox(width: 5.0),
                            Bone.text(
                              width: 60.0,
                              fontSize: 14.0,
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                          ],
                        ),
                      ),
                      Bone(width: 80.0, height: 24.0, borderRadius: BorderRadius.circular(12.0)),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  Row(
                    children: <Widget>[
                      const Bone.icon(size: 50.0),
                      const SizedBox(width: 15.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Bone.text(
                            width: 180.0,
                            fontSize: 16.0,
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          const SizedBox(height: 25.0),
                          Bone.text(fontSize: 16.0, borderRadius: BorderRadius.circular(7.0)),
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
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxHeight: 150.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "You don't have any courses progress yet. Start learning now to track your progress here!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Theme.of(context).textTheme.labelSmall?.color,
                ),
              ),
              const SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget hasCourseData({
    required List<Course> courseListData,
    required List<UserCourseProgress> courseProgressList,
  }) {
    return ExpandablePageView.builder(
      controller: carouselController,
      clipBehavior: Clip.none,
      itemCount: courseProgressList.length,
      itemBuilder: (BuildContext context, int index) {
        UserCourseProgress courseProgress = courseProgressList[index];
        Course? course = courseListData.firstWhere((c) => c.courseId == courseProgress.courseId);

        UserLevelProgress levelProgress = courseProgress.levelProgress.firstWhere(
          (levelProgress) => levelProgress.levelName == courseProgress.lastAccessedLevel,
        );
        double progress = levelProgress.completedModules.length / levelProgress.totalModules;

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
              child: ProgressCard(
                title: course.name,
                lastAccessedDate: courseProgress.lastAccessedAt.toIso8601String().split('T')[0],
                level: CourseLevel.values.firstWhere(
                  (e) => e.toString().split('.').last == courseProgress.lastAccessedLevel,
                  orElse: () => CourseLevel.beginner,
                ),
                progress: progress,
                courseImage: '${course.name.split(' ')[0].toLowerCase()}.svg',
              ).create(context),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authUserState = ref.watch(authUserProvider);
    final courseListData = ref.watch(courseListProvider);

    AuthUser? authUser = authUserState.value;
    List<UserCourseProgress>? userCourseProgress = authUser?.coursesProgress;

    return Scaffold(
      appBar: const HomeAppBar(),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 25.0),
            authUserState.isLoading || courseListData.isLoading
                ? loadCourseData()
                : userCourseProgress != null
                ? hasCourseData(
                    courseListData: courseListData.requireValue,
                    courseProgressList: userCourseProgress,
                  )
                : noCourseData(),
          ],
        ),
      ),
    );
  }
}
