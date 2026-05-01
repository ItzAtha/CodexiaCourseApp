import 'dart:math';

import 'package:codexia_course_learning/features/home/models/app_bar.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../shared/models/auth_user.dart';
import '../../../shared/models/user_course.dart';
import '../../../shared/providers/auth_user_notifier.dart';
import '../models/progress_card.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          constraints: BoxConstraints(maxHeight: 150.0),
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
                            Bone.icon(size: 16.0),
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
                      Bone.icon(size: 50.0),
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
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(maxHeight: 150.0),
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

  Widget hasCourseData({required List<UserCourse> courseList}) {
    return ExpandablePageView.builder(
      controller: carouselController,
      clipBehavior: Clip.none,
      itemCount: courseList.length,
      itemBuilder: (BuildContext context, int index) {
        UserCourse course = courseList[index];

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
                title: course.courseName,
                startDate: course.startDate.toDate().toIso8601String().split('T')[0],
                level: course.courseLevel,
                progress: course.progress,
                courseImage: '${course.courseName.toLowerCase().split(' ')[0]}.svg',
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
    AuthUser? authUser = authUserState.value;

    UserCourseList? userCourseList = authUser?.courses;
    List<UserCourse>? courseList = userCourseList?.courseList;

    return Scaffold(
      appBar: HomeAppBar(),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 25.0),
            authUserState.isLoading
                ? loadCourseData()
                : courseList != null
                ? hasCourseData(courseList: courseList)
                : noCourseData(),
          ],
        ),
      ),
    );
  }
}
