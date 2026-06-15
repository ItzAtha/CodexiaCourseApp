import 'package:freezed_annotation/freezed_annotation.dart';

import '../../services/user_level_progress_converter.dart';

part 'user_course_progress.freezed.dart';

part 'user_course_progress.g.dart';

@freezed
abstract class UserCourseProgress with _$UserCourseProgress {
  const UserCourseProgress._();

  const factory UserCourseProgress({
    required String courseId,
    required String lastAccessedLevel,
    required String lastAccessedModule,
    required String lastAccessedLesson,
    required DateTime lastAccessedAt,

    @UserLevelProgressConverter()
    @JsonKey(name: 'levels')
    @Default([])
    List<UserLevelProgress> levels,
  }) = _UserCourseProgress;

  factory UserCourseProgress.fromJson(Map<String, dynamic> json) =>
      _$UserCourseProgressFromJson(json);
}

@freezed
abstract class UserLevelProgress with _$UserLevelProgress {
  const UserLevelProgress._();

  const factory UserLevelProgress({
    required String levelId,
    required List<String> completedModules,

    @JsonKey(name: 'modules') required Map<String, List<String>> completedLesson,
  }) = _UserLevelProgress;

  factory UserLevelProgress.fromJson(Map<String, dynamic> json) =>
      _$UserLevelProgressFromJson(json);
}
