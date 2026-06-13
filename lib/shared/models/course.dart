import 'package:codexia_course_learning/shared/enums/course_level.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'course/course_module.dart';

part 'course.freezed.dart';

part 'course.g.dart';

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum CourseType {
  programmingFoundation("Programming Foundation"),
  databaseStructure("Database Structure"),
  frameworkDevelopment("Framework Development"),
  popularCourse("Popular Course"),
  topRateCourse("Top Rated Course");

  final String name;

  const CourseType(this.name);
}

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum ContentType {
  explain("Explain"),
  hint("Hint"),
  important("Important"),
  conclusion("Conclusion");

  final String name;

  const ContentType(this.name);
}

@freezed
abstract class Course with _$Course {
  const Course._();

  const factory Course({
    @JsonKey(name: 'id') required String courseId,

    required String title,
    required String description,
    required double rating,
    required double popular,
    required CourseType type,

    @JsonKey(unknownEnumValue: CourseLevel.unknown) @Default([]) List<CourseLevel> levels,

    required DateTime createdAt,
    required bool isActive,

    @Default({}) Map<CourseLevel, List<CourseModule>> modules,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, dynamic> toDatabaseMap() {
    final Map<String, dynamic> data = toJson();
    data.remove('modules');
    return data;
  }

  List<CourseLevel> get validLevels {
    return levels.where((level) => level != CourseLevel.unknown).toList();
  }
}
