import 'dart:async';

import 'package:codexia_course_learning/features/chat/controllers/chat_pagination_controller.dart';
import 'package:codexia_course_learning/features/chat/models/chat_model.dart';
import 'package:codexia_course_learning/features/chat/widgets/chat_bubble.dart';
import 'package:codexia_course_learning/shared/models/auth_user.dart';
import 'package:codexia_course_learning/shared/providers/auth_user_notifier.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/logger.dart';
import '../../widgets/animations/typewriting_effect.dart';

class AIChatBotPage extends ConsumerStatefulWidget {
  const AIChatBotPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AIChatBotPageState();
}

class _AIChatBotPageState extends ConsumerState<AIChatBotPage> {
  int limitDataLoad = 10;
  final ValueNotifier<bool> showScrollableButton = ValueNotifier<bool>(false);

  final ScrollController scrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();

  late ChatSession chat;
  late GenerativeModel model;
  late ChatPaginationController controller;

  Future<void> createMessage(
    String message, {
    required bool isUser,
    bool thinkingMode = false,
  }) async {
    Role role = isUser ? Role.user : Role.model;

    if (role == Role.user) {
      ChatModel chatBot = ChatModel(message: message, role: role, timestamp: DateTime.now());
      controller.chatModelChannel!.messages.add(chatBot);
    } else if (role == Role.model) {
      if (thinkingMode) {
        ChatModel chatBot = ChatModel(message: message, role: role, timestamp: DateTime.now());
        controller.chatModelChannel!.messages.add(chatBot);
        return;
      }

      TypeWritingEffect writingEffect = TypeWritingEffect(
        text: message,
        duration: Duration(microseconds: 900),
      );
      await for (String text in writingEffect.animate()) {
        controller.chatModelChannel!.messages.last.message = text;
        setState(() {});
      }
    }

    bool success = await controller.saveMessageHistory(message, role);
    if (success) {
      print("Message history saved");
    } else {
      print("Message history not saved");
    }
  }

  List<Widget> getMessageCard() {
    List<Widget> messageCard = [];

    if (controller.chatModelChannel == null) return messageCard;
    List<ChatModel> chatHistory = controller.chatModelChannel!.messages;

    for (int i = chatHistory.length - limitDataLoad; i < chatHistory.length; i++) {
      try {
        final chatBot = chatHistory[i];

        messageCard.add(
          Column(
            children: <Widget>[
              Align(
                alignment: chatBot.role == Role.user ? Alignment.centerRight : Alignment.centerLeft,
                child: ChatBubble(
                  context: context,
                  message: chatBot.message,
                  isUser: chatBot.role == Role.user,
                ).build(),
              ),
              SizedBox(height: 4.0),
            ],
          ),
        );
      } catch (_) {}
    }

    return messageCard;
  }

  Future<void> loadChatData() async {
    List<Content>? chatHistory;
    AuthUser? authUser = ref.read(authUserProvider).value;

    if (authUser != null) {
      controller = ChatPaginationController(userId: authUser.email, chatType: "model");

      await controller.initialUserChatChannel().then((value) async {
        print("User chat channel has been initialized!");

        if (value != null) {
          await controller.loadChatData(limit: limitDataLoad).then((value) {
            if (value.isEmpty) return;

            chatHistory = value
                .map((history) {
                  return history.role == Role.user
                      ? Content.text(history.message)
                      : Content.model([TextPart(history.message)]);
                })
                .toList()
                .reversed
                .toList();

            print("User chat history has been loaded!");
          });

          DebugLogger(message: value.toJson(), level: LogLevel.trace).log();
        } else {
          print("No chat channel found");
        }

        setState(() {});
      });
    }

    print("Start chat");
    chat = model.startChat(history: chatHistory);
  }

  @override
  void initState() {
    super.initState();

    model = FirebaseAI.googleAI(
      auth: FirebaseAuth.instance,
    ).generativeModel(model: 'gemini-3.1-flash-lite-preview');

    loadChatData();

    scrollController.addListener(() async {
      bool isReachBottom =
          scrollController.position.pixels == scrollController.position.minScrollExtent;
      bool isReachTop =
          scrollController.position.pixels == scrollController.position.maxScrollExtent;
      showScrollableButton.value = !isReachBottom;

      if (isReachTop) {
        setState(() => limitDataLoad += 10);

        await controller.loadChatData(limit: limitDataLoad).then((value) {
          print("Load chat data");
          setState(() {});
        });
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authUserState = ref.watch(authUserProvider);
    AuthUser? authUser = authUserState.value;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          if (controller.chatModelChannel?.messages.isEmpty ?? true)
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
                        "Hello, ${authUser?.displayName ?? authUser?.username ?? "Guest"}!",
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
              controller: scrollController,
              primary: false,
              reverse: true,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: 32.0),
                    ...getMessageCard(),
                    Text.rich(
                      TextSpan(
                        text: "Powered by ",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Theme.of(
                            context,
                          ).textTheme.labelSmall?.color?.withValues(alpha: 0.6),
                        ),
                        children: [
                          TextSpan(
                            text: "Google Gemini",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(
                                context,
                              ).textTheme.labelSmall?.color?.withValues(alpha: 0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 80.0),
                  ],
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
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

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ValueListenableBuilder<bool>(
                valueListenable: showScrollableButton,
                builder: (context, value, child) {
                  return Visibility(
                    visible: value,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Material(
                          elevation: 4.0,
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(32.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(32.0),
                            onTap: () {
                              scrollController.animateTo(
                                scrollController.position.minScrollExtent,
                                duration: Duration(seconds: 1),
                                curve: Curves.easeOut,
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 24.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              Card(
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
                            onPressed: () async {
                              String value = textEditingController.text.trim();
                              if (value.isEmpty) return;

                              createMessage(value, isUser: true);

                              if (context.mounted) {
                                textEditingController.clear();
                                FocusScope.of(context).unfocus();
                              }

                              await Future.delayed(Duration(milliseconds: 500));
                              createMessage("Thinking....", isUser: false, thinkingMode: true);

                              chat
                                  .sendMessage(Content.text(value))
                                  .then((value) {
                                    String outputText = value.text ?? "";
                                    createMessage(outputText, isUser: false);
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
            ],
          ),
        ],
      ),
    );
  }
}
