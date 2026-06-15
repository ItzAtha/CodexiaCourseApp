import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codexia_course_learning/shared/enums/course_level.dart';
import 'package:codexia_course_learning/shared/models/course.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/course/course_module.dart';

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
    Map<CourseLevel, List<CourseModule>> modulesList = {};

    final levelsCollection = coursesCollection.doc(courseId).collection('Levels');
    final levelsSnapshot = await levelsCollection.get();

    for (var level in levelsSnapshot.docs) {
      List<CourseModule> modules = [];
      final moduleLevel = CourseLevel.values.firstWhere((l) => l.name.toLowerCase() == level.id);

      final modulesCollection = levelsCollection.doc(level.id).collection('Modules');
      final lessonCollection = levelsCollection.doc(level.id).collection('Lessons');

      final (modulesSnapshot, lessonSnapshot) = await (
        modulesCollection.get(),
        lessonCollection.get(),
      ).wait;

      for (var module in modulesSnapshot.docs) {
        List<Map<String, dynamic>> lessons = [];
        final moduleData = module.data();

        for (var lesson in lessonSnapshot.docs) {
          final lessonData = lesson.data();

          if (lessonData['id'].startsWith(moduleData['id'])) {
            lessons.add(lessonData);
          }
        }

        moduleData['lessons'] = lessons;
        modules.add(CourseModule.fromJson(moduleData));
      }

      modulesList[moduleLevel] = modules;
    }

    final courses = state.value != null ? List<Course>.from(state.value!) : await _loadCourseData();
    final idx = courses.indexWhere((course) => course.courseId == courseId);
    if (idx != -1) {
      courses[idx] = courses[idx].copyWith(modules: modulesList);
      state = AsyncData(courses);
    } else {
      print('Course with id $courseId not found when fetching modules.');
    }
  }

  Future<void> unloadModules(String courseId) async {
    final courses = state.value != null ? List<Course>.from(state.value!) : await _loadCourseData();
    final idx = state.value?.indexWhere((course) => course.courseId == courseId) ?? -1;
    if (idx != -1) {
      courses[idx] = courses[idx].copyWith(modules: {});
      state = AsyncData(courses);
    } else {
      print('Course with id $courseId not found when unload modules.');
    }
  }
}
