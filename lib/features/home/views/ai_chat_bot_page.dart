import 'dart:async';

import 'package:codexia_course_learning/manager/firebase_manager.dart';
import 'package:codexia_course_learning/shared/models/ai_chat_bot.dart';
import 'package:codexia_course_learning/shared/models/auth_user.dart';
import 'package:codexia_course_learning/shared/providers/auth_user_notifier.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AIChatBotPage extends ConsumerStatefulWidget {
  const AIChatBotPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AIChatBotPageState();
}

class _AIChatBotPageState extends ConsumerState<AIChatBotPage> {
  String? cacheEmail;
  Timer? autoSaveTimer;

  final List<AIChatBot> chatBotList = [];
  final TextEditingController textEditingController = TextEditingController();

  late ChatSession chat;
  late GenerativeModel model;

  void createMessage(String message, bool isUser) {
    Role role = isUser ? Role.user : Role.model;

    AIChatBot chatBot = AIChatBot(message: message, role: role);
    setState(() => chatBotList.add(chatBot));
  }

  List<Widget> getMessageCard() {
    List<Widget> messageCard = [];

    for (var chatBot in chatBotList) {
      messageCard.add(
        Column(
          children: <Widget>[
            Align(
              alignment: chatBot.role == Role.user ? Alignment.centerRight : Alignment.centerLeft,
              child: Card(
                elevation: 0.8,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
                  child: Text(
                    chatBot.message,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Theme.of(context).textTheme.labelSmall?.color,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.0),
          ],
        ),
      );
    }

    return messageCard;
  }

  Future<void> loadChatData() async {
    FirebaseManager manager = FirebaseManager();
    List<Content>? chatHistory;

    AuthUser? authUser = ref.read(authUserProvider).value;
    if (authUser != null) {
      if (await manager.isDataExist('AIChatBot', authUser.email)) {
        Map<String, dynamic>? data = await manager.getData('AIChatBot', authUser.email);
        if (data != null) {
          chatHistory = [];
          AIChatBotList aiChatBotList = AIChatBotList.fromJson(data);
          setState(() => chatBotList.addAll(aiChatBotList.aiChatBotList));

          List<Map<String, dynamic>> aiChatBotList2 = aiChatBotList.toJson()['data'];
          chatHistory.addAll(
            aiChatBotList2.map((aiChatBot) {
              return aiChatBot['role'] == Role.user
                  ? Content.text(aiChatBot['message'])
                  : Content.model([TextPart(aiChatBot['message'])]);
            }).toList(),
          );

          cacheEmail = authUser.email;
        }
      }
    }

    chat = model.startChat(history: chatHistory);
  }

  void startAutoSaveChatData() {
    if (autoSaveTimer != null) {
      autoSaveTimer!.cancel();
    }

    autoSaveTimer = Timer.periodic(Duration(minutes: 3), (timer) {
      if (cacheEmail != null) {
        FirebaseManager manager = FirebaseManager();
        AIChatBotList aiChatBotList = AIChatBotList(aiChatBotList: chatBotList);
        manager.updateData('AIChatBot', cacheEmail!, aiChatBotList.toJson());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    model = FirebaseAI.googleAI(
      auth: FirebaseAuth.instance,
    ).generativeModel(model: 'gemini-3-flash-preview');

    loadChatData();
    startAutoSaveChatData();
  }

  @override
  void dispose() {
    if (cacheEmail != null) {
      FirebaseManager manager = FirebaseManager();
      AIChatBotList aiChatBotList = AIChatBotList(aiChatBotList: chatBotList);
      manager.updateData('AIChatBot', cacheEmail!, aiChatBotList.toJson());
    }

    autoSaveTimer?.cancel();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          if (chatBotList.isEmpty)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.auto_awesome, size: 40.0, color: Theme.of(context).iconTheme.color),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "Hello, ItzAtha!",
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.labelLarge?.color,
                        ),
                      ),
                      Text(
                        "What can I do to help?",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(
                            context,
                          ).textTheme.labelMedium?.color?.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          Positioned.fill(
            child: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [SizedBox(height: 20.0), ...getMessageCard(), SizedBox(height: 80.0)],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 20.0),
              child: Material(
                elevation: 4.0,
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(32.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(32.0),
                  onTap: () {
                    context.pop();
                  },
                  child: Container(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.arrow_back, size: 20.0, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Card(
              clipBehavior: Clip.antiAlias,
              margin: EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                constraints: BoxConstraints(minWidth: double.infinity, minHeight: 80.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: textEditingController,
                      minLines: 1,
                      maxLines: null,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            String value = textEditingController.text;

                            if (value.isEmpty) return;

                            createMessage(value, true);
                            textEditingController.clear();

                            chat
                                .sendMessage(Content.text(value))
                                .then((value) {
                                  String outputText = value.text ?? "";

                                  setState(() {
                                    createMessage(outputText, false);
                                  });
                                })
                                .catchError((error) {
                                  print(error);
                                });
                          },
                          icon: Icon(Icons.send),
                          iconSize: 20.0,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        suffixIconConstraints: BoxConstraints(minWidth: 40.0, minHeight: 40.0),
                        hintText: 'Write prompt here',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
