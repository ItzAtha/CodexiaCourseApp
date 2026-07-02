import 'package:codexia_course_learning/features/chat/models/chat_message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class ChatMessageConverter implements JsonConverter<List<ChatMessage>, Map<String, dynamic>> {
  const ChatMessageConverter();

  @override
  List<ChatMessage> fromJson(Map<String, dynamic> json) {
    return json.entries.map((entry) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(entry.value as Map);
      data['chatId'] = entry.key;

      return ChatMessage.fromJson(data);
    }).toList();
  }

  @override
  Map<String, dynamic> toJson(List<ChatMessage> list) {
    final Map<String, dynamic> map = {};
    for (var item in list) {
      final data = item.toJson();
      data.remove('chatId');
      map[item.chatId] = data;
    }
    return map;
  }
}
