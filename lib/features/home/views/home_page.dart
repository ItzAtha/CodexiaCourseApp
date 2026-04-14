import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codexia_course_learning/features/home/models/app_bar.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../shared/enums/course_level.dart';
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

  @override
  Widget build(BuildContext context) {
    final authUserState = ref.watch(authUserProvider);
    AuthUser? authUser = authUserState.value;

    UserCourseList? userCourseList = authUser?.courses;
    List<UserCourse> courseList =
        userCourseList?.courses ??
        [
          UserCourse(
            courseName: "Java Development",
            courseLevel: CourseLevel.beginner,
            progress: 0.0,
            startDate: Timestamp.now(),
          ),
        ];

    return Scaffold(
      appBar: HomeAppBar(),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 25.0),
            ExpandablePageView.builder(
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
                      child: Skeletonizer(
                        enabled: authUserState.isLoading,
                        enableSwitchAnimation: true,
                        child: ProgressCard(
                          title: course.courseName,
                          startDate: course.startDate.toDate().toIso8601String().split('T')[0],
                          level: course.courseLevel,
                          progress: course.progress,
                          courseImage: '${course.courseName.toLowerCase().split(' ')[0]}.svg',
                        ).create(context),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
