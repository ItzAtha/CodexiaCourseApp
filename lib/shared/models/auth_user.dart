import 'package:codexia_course_learning/shared/models/user_avatar.dart';

class AuthUser {
  String username;
  String? displayName;
  String email;
  UserAvatar? avatar;

  AuthUser({required this.username, this.displayName, required this.email, this.avatar});

  AuthUser.defaultUser() : username = 'Guest', email = '';

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      username: json['username'],
      displayName: json['displayName'],
      email: json['email'],
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'displayName': displayName,
      'email': email,
      'avatar': avatar?.toJson(),
    };
  }

  AuthUser copyWith({String? username, String? displayName, String? email, UserAvatar? avatar}) {
    return AuthUser(
      username: username ?? this.username,
      displayName: displayName,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
    );
  }
}
