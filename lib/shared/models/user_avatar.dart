class UserAvatar {
  String publicId;
  String? avatarPath;

  UserAvatar({required this.publicId, this.avatarPath});

  factory UserAvatar.fromJson(Map<String, dynamic> json) {
    return UserAvatar(publicId: json['public_id'], avatarPath: json['avatarPath']);
  }

  Map<String, dynamic> toJson() {
    return {'public_id': publicId, 'avatarPath': avatarPath};
  }

  UserAvatar copyWith({String? publicId, String? avatarPath}) {
    return UserAvatar(
      publicId: publicId ?? this.publicId,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}
