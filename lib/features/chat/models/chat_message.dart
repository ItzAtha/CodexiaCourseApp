import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message.freezed.dart';

part 'chat_message.g.dart';

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum Role { user, model }

@Freezed(unionKey: 'type')
abstract class ChatMessage with _$ChatMessage {
  const ChatMessage._();

  @FreezedUnionValue("BOT")
  const factory ChatMessage.bot({
    @JsonKey(name: 'id') required String chatId,

    required String content,
    required Role role,
    required DateTime timestamp,
  }) = BotMessage;

  @FreezedUnionValue("USER")
  const factory ChatMessage.user({
    @JsonKey(name: 'id') required String chatId,

    required String content,
    required String senderId,
    required DateTime timestamp,
  }) = UserMessage;

  factory ChatMessage.fromJson(Map<String, dynamic> json) => _$ChatMessageFromJson(json);
}
