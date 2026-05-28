import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codexia_course_learning/shared/models/course.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_list_notifier.g.dart';

@riverpod
class CourseListNotifier extends _$CourseListNotifier {
  @override
  Future<List<Course>> build() async {
    return _loadCourseData();
  }

  Future<List<Course>> _loadCourseData() async {
    List<Course> courseList = [];

    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final CollectionReference coursesCollection = firestore.collection('Courses');
    final QuerySnapshot coursesSnapshot = await coursesCollection.get();

    for (var doc in coursesSnapshot.docs) {
      courseList.add(Course.fromJson(doc.data() as Map<String, dynamic>));
    }

    return courseList;
  }
}
