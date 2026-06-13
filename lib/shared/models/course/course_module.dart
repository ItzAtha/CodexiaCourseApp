import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../services/string_duration_converter.dart';
import 'course_lesson.dart';

part 'course_module.freezed.dart';

part 'course_module.g.dart';

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
