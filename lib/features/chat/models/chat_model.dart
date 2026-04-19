enum Role { user, model }

class ChatModel {
  final String message;
  final Role role;
  final DateTime timestamp;

  ChatModel({required this.message, required this.role, required this.timestamp});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      message: json['message'],
      role: Role.values.firstWhere((role) => role.name == json['role']),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'role': role.name, 'timestamp': timestamp.toIso8601String()};
  }
}