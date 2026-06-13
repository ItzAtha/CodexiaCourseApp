import 'package:codexia_course_learning/services/level_progress_list_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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

    @LevelProgressListConverter() @Default([]) List<UserLevelProgress> levelProgress,
  }) = _UserCourseProgress;

  factory UserCourseProgress.fromJson(Map<String, dynamic> json) =>
      _$UserCourseProgressFromJson(json);
}

@freezed
abstract class UserLevelProgress with _$UserLevelProgress {
  const UserLevelProgress._();

  const factory UserLevelProgress({
    required String levelName,
    required List<String> completedModules,
    required int totalModules,
  }) = _UserLevelProgress;

  factory UserLevelProgress.fromJson(Map<String, dynamic> json) =>
      _$UserLevelProgressFromJson(json);

  factory UserLevelProgress.fromEntry(MapEntry<String, dynamic> entry) {
    final Map<String, dynamic> data = Map<String, dynamic>.from(entry.value as Map);
    data['levelProgress'] = entry.key;
    return UserLevelProgress.fromJson(data);
  }

  MapEntry<String, dynamic> toMap() {
    final Map<String, dynamic> data = toJson();

    data.remove('levelProgress');
    return MapEntry(levelName, data);
  }
}

@freezed
abstract class UserModuleProgress with _$UserModuleProgress {
  const UserModuleProgress._();

  const factory UserModuleProgress({
    required String lessonId,
    required List<String> completedLessons,
    required int totalLessons,
  }) = _UserModuleProgress;

  factory UserModuleProgress.fromJson(Map<String, dynamic> json) =>
      _$UserModuleProgressFromJson(json);
}
