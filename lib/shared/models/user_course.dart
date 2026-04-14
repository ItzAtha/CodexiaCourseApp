import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codexia_course_learning/shared/enums/course_level.dart';

class UserCourse {
  final String courseName;
  final CourseLevel courseLevel;
  final double progress;
  final Timestamp startDate;

  UserCourse({
    required this.courseName,
    required this.courseLevel,
    required this.progress,
    required this.startDate,
  });

  factory UserCourse.fromJson(Map<String, dynamic> json) {
    return UserCourse(
      courseName: json['courseName'],
      courseLevel: CourseLevel.values.firstWhere((level) => level.name == json['courseLevel']),
      progress: json['progress'].toDouble(),
      startDate: json['startDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseName': courseName,
      'courseLevel': courseLevel.name,
      'progress': progress,
      'startDate': startDate.toDate(),
    };
  }
}

class UserCourseList {
  final List<UserCourse> courses;

  UserCourseList({required this.courses});

  factory UserCourseList.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonSerialize = json['data'];
    return UserCourseList(
      courses: jsonSerialize.map((course) => UserCourse.fromJson(course)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': courses.map((course) => course.toJson()).toList()};
  }
}
