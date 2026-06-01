import 'package:codexia_course_learning/shared/models/user_course.dart';

class AuthUser {
  String username;
  String? displayName;
  String email;
  String? avatar;
  List<UserCourseProgress> coursesProgress;

  AuthUser({
    required this.username,
    this.displayName,
    required this.email,
    this.avatar,
    required this.coursesProgress,
  });

  AuthUser.defaultUser() : username = 'Guest', email = '', coursesProgress = [];

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      username: json['username'],
      displayName: json['displayName'],
      email: json['email'],
      avatar: json['avatar'],
      coursesProgress: json['courseProgress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'displayName': displayName,
      'email': email,
      'avatar': avatar,
      'courseProgress': coursesProgress.map((progress) => progress.toJson()).toList(),
    };
  }

  AuthUser copyWith({
    String? username,
    String? Function()? displayName,
    String? email,
    String? Function()? avatar,
    List<UserCourseProgress>? coursesProgress,
  }) {
    return AuthUser(
      username: username ?? this.username,
      displayName: displayName != null ? displayName() : this.displayName,
      email: email ?? this.email,
      avatar: avatar != null ? avatar() : this.avatar,
      coursesProgress: coursesProgress ?? this.coursesProgress,
    );
  }
}
