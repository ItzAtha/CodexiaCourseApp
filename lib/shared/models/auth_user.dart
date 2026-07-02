import 'package:codexia_course_learning/shared/models/user_course_progress.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_user.freezed.dart';

part 'auth_user.g.dart';

@freezed
abstract class AuthUser with _$AuthUser {
  const AuthUser._();

  const factory AuthUser({
    @JsonKey(name: 'id') required String userId,

    required String username,
    required String email,

    String? displayName,
    @Default('https://cdn-icons-png.flaticon.com/128/3135/3135715.png') String? avatar,

    required DateTime createdAt,
    required DateTime lastSignIn,

    @Default([]) List<UserCourseProgress>? coursesProgress,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) => _$AuthUserFromJson(json);
}
