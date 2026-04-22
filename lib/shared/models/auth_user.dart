import 'package:codexia_course_learning/shared/models/user_course.dart';

class AuthUser {
  String username;
  String? displayName;
  String email;
  String? avatar;
  UserCourseList courses;

  AuthUser({
    required this.username,
    this.displayName,
    required this.email,
    this.avatar,
    required this.courses,
  });

  AuthUser.defaultUser() : username = 'Guest', email = '', courses = UserCourseList(courseList: []);

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      username: json['username'],
      displayName: json['displayName'],
      email: json['email'],
      avatar: json['avatar'],
      courses: json['courses'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'displayName': displayName,
      'email': email,
      'avatar': avatar,
      'courses': courses.toJson(),
    };
  }

  AuthUser copyWith({
    String? username,
    String? Function()? displayName,
    String? email,
    String? Function()? avatar,
    UserCourseList? courses,
  }) {
    return AuthUser(
      username: username ?? this.username,
      displayName: displayName != null ? displayName() : this.displayName,
      email: email ?? this.email,
      avatar: avatar != null ? avatar() : this.avatar,
      courses: courses ?? this.courses,
    );
  }
}
