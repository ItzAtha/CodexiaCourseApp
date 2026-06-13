import 'package:codexia_course_learning/services/string_duration_converter.dart';
import 'package:codexia_course_learning/shared/enums/course_level.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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

    @Default({}) Map<CourseLevel, List<CourseModule>>? modules,
  }) = _Course;

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  List<CourseLevel> get validLevels {
    return levels.where((level) => level != CourseLevel.unknown).toList();
  }
}

@freezed
abstract class CourseModule with _$CourseModule {
  const factory CourseModule({
    required String moduleId,
    required int order,
    required String title,
    required String description,
    required int expAmount,

    @StringDurationConverter() required Duration duration,
    @Default([]) List<CourseLesson> lessons,
  }) = _CourseModule;

  factory CourseModule.fromJson(Map<String, dynamic> json) => _$CourseModuleFromJson(json);
}

@freezed
abstract class CourseLesson with _$CourseLesson {
  const factory CourseLesson({
    required String lessonId,
    required String title,

    @Default({}) Map<ContentType, String> content,
  }) = _CourseLesson;

  factory CourseLesson.fromJson(Map<String, dynamic> json) => _$CourseLessonFromJson(json);
}
