import 'package:codexia_course_learning/shared/enums/course_level.dart';

enum CourseType {
  programmingFoundation("Programming Foundation"),
  databaseStructures("Database Structures"),
  frameworkDevelopment("Framework Development");

  final String name;

  const CourseType(this.name);
}

class Course {
  String courseId;
  String name;
  String description;
  double rating;
  double popular;
  CourseType type;
  List<CourseLevel> levels;
  DateTime createdAt;
  bool isActive;

  Course(
    this.courseId,
    this.name,
    this.description,
    this.rating,
    this.popular,
    this.type,
    this.levels,
    this.createdAt,
    this.isActive,
  );

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      json['id'],
      json['title'],
      json['description'],
      json['rating'].toDouble(),
      json['popular'].toDouble(),
      CourseType.values.firstWhere((e) => e.name == json['type']),
      (json['level'] as List)
          .map((level) => CourseLevel.values.firstWhere((e) => e.name == level))
          .toList(),
      DateTime.parse(json['createdAt']),
      json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': courseId,
      'title': name,
      'description': description,
      'rating': rating,
      'popular': popular,
      'type': type.name,
      'level': levels.map((level) => level.name).toList(),
      'createdAt': createdAt.toIso8601String(),
      'isActive': isActive,
    };
  }
}
