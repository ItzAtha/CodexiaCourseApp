import 'package:freezed_annotation/freezed_annotation.dart';

import '../course.dart';

part 'course_lesson.freezed.dart';

part 'course_lesson.g.dart';

@freezed
abstract class CourseLesson with _$CourseLesson {
  const factory CourseLesson({
    required String lessonId,
    required String title,

    @Default({}) Map<ContentType, String> content,
  }) = _CourseLesson;

  factory CourseLesson.fromJson(Map<String, dynamic> json) => _$CourseLessonFromJson(json);
}
