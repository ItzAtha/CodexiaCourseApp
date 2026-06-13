import 'package:freezed_annotation/freezed_annotation.dart';

import '../course.dart';

part 'course_lesson.freezed.dart';

part 'course_lesson.g.dart';

@Freezed(unionKey: 'type')
sealed class CourseLesson with _$CourseLesson {
  const CourseLesson._();

  const factory CourseLesson.material({
    @JsonKey(name: 'id') required String lessonId,

    required String title,

    @Default({}) Map<ContentType, String> content,
  }) = MaterialLesson;

  const factory CourseLesson.quiz({
    @JsonKey(name: 'id') required String lessonId,

    required String title,

    @Default({}) Map<ContentType, String> content,
  }) = QuizLesson;

  factory CourseLesson.fromJson(Map<String, dynamic> json) => _$CourseLessonFromJson(json);
}
