class AuthUser {
  String username;
  String? displayName;
  String email;
  String? avatarPath;

  AuthUser({
    required this.username,
    this.displayName,
    required this.email,
    this.avatarPath,
  });

  AuthUser.defaultUser() : username = 'Guest', email = '';

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      username: json['username'],
      displayName: json['displayName'],
      email: json['email'],
      avatarPath: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'displayName': displayName,
      'email': email,
      'avatar': avatarPath,
    };
  }

  AuthUser copyWith({
    String? username,
    String? displayName,
    String? email,
    String? avatarPath,
  }) {
    return AuthUser(
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}
