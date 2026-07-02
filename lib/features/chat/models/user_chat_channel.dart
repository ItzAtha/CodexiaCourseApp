import 'package:codexia_course_learning/services/chat_message_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'chat_message.dart';

part 'user_chat_channel.freezed.dart';

part 'user_chat_channel.g.dart';

@JsonEnum(fieldRename: FieldRename.screamingSnake)
enum ChatType { user_to_model, user_to_user }

@freezed
abstract class UserChatChannel with _$UserChatChannel {
  const UserChatChannel._();

  const factory UserChatChannel({
    @JsonKey(name: 'id') required String channelId,

    required ChatType type,
    required DateTime lastConversation,

    @ChatMessageConverter() @Default([]) List<ChatMessage> messages,
  }) = _UserChatChannel;

  factory UserChatChannel.fromJson(Map<String, dynamic> json) => _$UserChatChannelFromJson(json);

  Map<String, dynamic> toDatabaseMap() {
    final Map<String, dynamic> data = toJson();
    data.remove('messages');
    return data;
  }
}
