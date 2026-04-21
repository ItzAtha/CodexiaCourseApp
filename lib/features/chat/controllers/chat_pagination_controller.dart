import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../manager/firebase_manager.dart';
import '../models/chat_model.dart';

class ChatPaginationController {
  final String userId;
  final String chatType;

  ChatModelChannel? chatModelChannel;
  DocumentSnapshot? lastDocumentLoad;

  ChatPaginationController({required this.userId, required this.chatType});

  Future<ChatModelChannel?> initialUserChatChannel() async {
    FirebaseManager manager = FirebaseManager();

    bool isChatHistoryDataExists = await manager.isCollectionEmpty(
      'Users',
      docId: userId,
      subCollectionQuery: [SubCollectionQuery(collection: 'Chats')],
    );

    if (isChatHistoryDataExists) {
      final userChatData = await manager.getDataWithCondition(
        'Users',
        docId: userId,
        subCollectionQuery: [SubCollectionQuery(collection: 'Chats')],
        conditions: [FilterCondition(field: 'type', isEqualTo: 'user_to_$chatType')],
      );

      if (userChatData != null) {
        chatModelChannel = ChatModelChannel(
          chatId: userChatData.$2[0]['id'],
          title: userChatData.$2[0]['title'],
          lastUpdate: DateTime.parse(userChatData.$2[0]['lastUpdate']),
          messages: [],
        );

        return chatModelChannel;
      } else {
        print("No chat history found for user: $userId");
      }
    } else {
      Map<String, dynamic> data = {
        'participants': ["user", chatType],
        'type': "user_to_$chatType",
        'title': null,
        'lastUpdate': DateTime.now().toIso8601String(),
      };

      String? uniqueId = await manager.addData(
        'Users',
        docId: userId,
        subCollectionQuery: [SubCollectionQuery(collection: 'Chats', data: data)],
      );

      if (uniqueId != null) {
        chatModelChannel = ChatModelChannel(
          chatId: uniqueId,
          title: null,
          lastUpdate: DateTime.now(),
          messages: [],
        );
        print("New chat history created with ID: $uniqueId");
      }
    }
    return null;
  }

  Future<List<ChatModel>> loadChatData({int limit = 5}) async {
    FirebaseManager manager = FirebaseManager();
    List<ChatModel> messageHistory = [];

    if (chatModelChannel != null) {
      final isChatHistoryDataExists = await manager.isCollectionEmpty(
        'Users',
        docId: userId,
        subCollectionQuery: [
          SubCollectionQuery(collection: 'Chats', docId: chatModelChannel!.chatId),
          SubCollectionQuery(collection: 'Messages'),
        ],
      );

      if (!isChatHistoryDataExists) {
        print("No message history found for user: $userId");
        return messageHistory;
      }

      final messageData = await manager.getDataWithCondition(
        'Users',
        docId: userId,
        subCollectionQuery: [
          SubCollectionQuery(collection: 'Chats', docId: chatModelChannel!.chatId),
          SubCollectionQuery(collection: 'Messages'),
        ],
        orderBy: OrderBy(field: 'timestamp', descending: true),
        lastDocument: lastDocumentLoad,
        limit: limit,
      );

      if (messageData != null) {
        messageHistory = messageData.$2.map((message) {
          return ChatModel(
            message: message['message'],
            role: message['role'] == 'user' ? Role.user : Role.model,
            timestamp: DateTime.parse(message['timestamp']),
          );
        }).toList();

        lastDocumentLoad = messageData.$1;
        print("Last document loaded: ${lastDocumentLoad?.id}");

        if (chatModelChannel!.messages.isEmpty) {
          chatModelChannel!.messages.addAll(messageHistory.reversed.toList());
        } else {
          chatModelChannel!.messages.insertAll(0, messageHistory.reversed.toList());
        }
      } else {
        print("No message history found for user: $userId");
      }
    }

    return messageHistory;
  }

  Future<bool> saveMessageHistory(String message, Role role, {String? title}) async {
    FirebaseManager manager = FirebaseManager();

    if (chatModelChannel != null) {
      Map<String, dynamic> data = {
        'message': message,
        'role': role.name,
        'timestamp': DateTime.now().toIso8601String(),
      };
      String? uniqueId = await manager.addData(
        'Users',
        docId: userId,
        subCollectionQuery: [
          SubCollectionQuery(collection: 'Chats', docId: chatModelChannel!.chatId),
          SubCollectionQuery(collection: 'Messages', data: data),
        ],
      );

      if (uniqueId != null) {
        await manager.updateData(
          'Users',
          userId,
          subCollectionQuery: [
            SubCollectionQuery(
              collection: 'Chats',
              docId: chatModelChannel!.chatId,
              data: {'lastUpdate': DateTime.now().toIso8601String(), 'title': ?title},
            ),
          ],
        );
      }
    } else {
      print("No chat channel found for user: $userId");
    }

    return false;
  }
}
