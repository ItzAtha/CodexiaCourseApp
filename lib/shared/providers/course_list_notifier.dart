import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codexia_course_learning/shared/enums/course_level.dart';
import 'package:codexia_course_learning/shared/models/course.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/course/course_lesson.dart';
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
      final modulesCollection = levelsCollection.doc(level.id).collection('Modules');
      final lessonCollection = levelsCollection.doc(level.id).collection('Lessons');

      final (modulesSnapshot, lessonSnapshot) = await (
        modulesCollection.get(),
        lessonCollection.get(),
      ).wait;

      for (var module in modulesSnapshot.docs) {
        final moduleData = module.data();
        List<String> moduleLessons = List<String>.from(moduleData['lessons']);

        List<CourseLesson> lessonsList = lessonSnapshot.docs
            .where((lesson) => moduleLessons.contains(lesson.id))
            .map((lesson) {
              final lessonData = lesson.data();
              print(lessonData);
              return CourseLesson.fromJson(lessonData);
            })
            .toList();

        moduleData['lessons'] = lessonsList;

        modulesList.putIfAbsent(
          CourseLevel.values.firstWhere((l) => l.name.toLowerCase() == level.id),
          () => [],
        );
        modulesList[CourseLevel.values.firstWhere((l) => l.name.toLowerCase() == level.id)]!.add(
          CourseModule.fromJson(moduleData),
        );
      }
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
