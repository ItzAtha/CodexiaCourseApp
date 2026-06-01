import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codexia_course_learning/shared/models/course.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_list_notifier.g.dart';

@riverpod
class CourseListNotifier extends _$CourseListNotifier {
  final coursesCollection = FirebaseFirestore.instance.collection('Courses');

  @override
  Future<List<Course>> build() async {
    return _loadCourseData();
  }

  Future<List<Course>> _loadCourseData() async {
    List<Course> courseList = [];

    final QuerySnapshot coursesSnapshot = await coursesCollection.get();
    for (var course in coursesSnapshot.docs) {
      courseList.add(Course.fromJson(course.data() as Map<String, dynamic>));
    }

    return courseList;
  }

  Future<void> fetchModules(String courseId) async {
    List<CourseModule> modulesList = [];

    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final String userId = currentUser.uid;
      String provider = currentUser.providerData.isNotEmpty
          ? currentUser.providerData[0].providerId
          : 'anonymous';

      final String userDocId = '${userId}_$provider';

      final levelsCollection = coursesCollection.doc(courseId).collection('Levels');
      final levelsSnapshot = await levelsCollection.get();

      for (var level in levelsSnapshot.docs) {
        final modulesCollection = levelsCollection.doc(level.id).collection('Modules');
        final modulesSnapshot = await modulesCollection.get();

        for (var module in modulesSnapshot.docs) {
          final moduleData = module.data();

          moduleData['totalLessons'] = (moduleData['lessons'] as List).length;

          final moduleProgressCollection = await FirebaseFirestore.instance
              .collection('Users')
              .doc(userDocId)
              .collection('CourseProgress')
              .doc(courseId)
              .collection('Modules')
              .doc(module.id)
              .get();

          if (moduleProgressCollection.exists) {
            final moduleProgressData = moduleProgressCollection.data();
            int totalLessonCompleted = (moduleProgressData?['completedLessons'] ?? []).length;
            int totalLessons = (moduleData['lessons'] as List).length;
            double calcProgress = totalLessonCompleted / totalLessons;
            moduleData['progress'] = calcProgress;
            moduleData['isLocked'] = false;
          } else {
            moduleData['progress'] = 0.0;
            moduleData['isLocked'] = true;
          }

          modulesList.add(CourseModule.fromJson(moduleData));
          print("Modules: ID ${module.id}, Data: $moduleData");
        }
      }

      final courses = state.value != null
          ? List<Course>.from(state.value!)
          : await _loadCourseData();
      final idx = courses.indexWhere((course) => course.courseId == courseId);
      if (idx != -1) {
        courses[idx] = courses[idx].copyWith(modules: () => modulesList);
        state = AsyncData(courses);
      } else {
        print('Course with id $courseId not found when updating modules.');
      }
    }
  }
}
