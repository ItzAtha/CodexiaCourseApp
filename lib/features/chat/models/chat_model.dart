enum Role { user, model }

enum ChatType { userToModel, userToUser }

class ChatModel {
  String message;
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

class ChatModelChannel {
  final String chatId;
  final String? title;
  final DateTime lastUpdate;
  final List<ChatModel> messages;

  ChatModelChannel({
    required this.chatId,
    this.title,
    required this.lastUpdate,
    required this.messages,
  });

  factory ChatModelChannel.fromJson(Map<String, dynamic> json) {
    return ChatModelChannel(
      chatId: json['chatId'],
      title: json['title'],
      lastUpdate: DateTime.parse(json['lastUpdate']),
      messages: (json['messages'] as List).map((message) => ChatModel.fromJson(message)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatId': chatId,
      'title': title,
      'lastUpdate': lastUpdate.toIso8601String(),
      'messages': messages.map((message) => message.toJson()).toList(),
    };
  }
}
