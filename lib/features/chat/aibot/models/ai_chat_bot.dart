enum Role { user, model }

class AIChatBot {
  final String message;
  final Role role;

  AIChatBot({required this.message, required this.role});

  factory AIChatBot.fromJson(Map<String, dynamic> json) {
    return AIChatBot(
      message: json['message'],
      role: Role.values.firstWhere((role) => role.name == json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'role': role.name};
  }
}

class AIChatBotList {
  final List<AIChatBot> aiChatBotList;

  AIChatBotList({required this.aiChatBotList});

  factory AIChatBotList.fromJson(Map<String, dynamic> json) {
    List<dynamic> jsonSerialize = json['data'];
    return AIChatBotList(
      aiChatBotList: jsonSerialize.map((course) => AIChatBot.fromJson(course)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': aiChatBotList.map((aiChat) => aiChat.toJson()).toList()};
  }
}
