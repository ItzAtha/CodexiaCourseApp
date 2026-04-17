import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codexia_course_learning/shared/enums/course_level.dart';

class UserCourse {
  final String courseId;
  final String courseName;
  final CourseLevel courseLevel;
  final double progress;
  final Timestamp startDate;
  Timestamp? endDate;

  UserCourse({
    required this.courseId,
    required this.courseName,
    required this.courseLevel,
    required this.progress,
    required this.startDate,
    this.endDate,
  });

  UserCourse.defaultCourse()
    : courseId = '',
      courseName = '',
      courseLevel = CourseLevel.beginner,
      progress = 0.0,
      startDate = Timestamp.now();

  factory UserCourse.fromJson(Map<String, dynamic> json) {
    return UserCourse(
      courseId: json['id'],
      courseName: json['name'],
      courseLevel: CourseLevel.values.firstWhere((level) => level.name == json['level']),
      progress: json['progress'].toDouble(),
      startDate: json['startDate'],
      endDate: json['endDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': courseId,
      'courseName': courseName,
      'courseLevel': courseLevel.name,
      'progress': progress,
      'startDate': startDate.toDate(),
      'endDate': endDate?.toDate(),
    };
  }
}

class UserCourseList {
  final List<UserCourse> courseList;

  UserCourseList({required this.courseList});

  factory UserCourseList.fromJson(List<dynamic> json) {
    return UserCourseList(courseList: json.map((course) => UserCourse.fromJson(course)).toList());
  }

  Map<String, dynamic> toJson() {
    return {'data': courseList.map((course) => course.toJson()).toList()};
  }
}
