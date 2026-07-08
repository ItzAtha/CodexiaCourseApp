import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codexia_course_learning/features/chat/models/user_chat_channel.dart';
import 'package:codexia_course_learning/features/chat/widgets/chat_placeholder.dart';
import 'package:codexia_course_learning/shared/models/auth_user.dart';
import 'package:codexia_course_learning/shared/providers/auth_user_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:toastification/toastification.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/app_constants.dart' hide AppRoutes;
import '../../models/chat_message.dart';
import '../../widgets/chat_message_bubble.dart';

class AIChatBotPage extends ConsumerStatefulWidget {
  const AIChatBotPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AIChatBotPageState();
}

class _AIChatBotPageState extends ConsumerState<AIChatBotPage> {
  UserChatChannel? chatChannel;
  DocumentSnapshot? lastDocumentSnapshot;

  final List<ChatMessageBubble> chatBubbles = [];
  final List<UserChatChannel> chatChannelList = [];

  final ValueNotifier<bool> showScrollableButton = ValueNotifier<bool>(false);

  final ScrollController scrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController();

  late ChatSession chat;
  late GenerativeModel model;

  Future<void> sendMessage({required String message}) async {
    List<ChatMessage> chatMessages = List.from(chatChannel?.messages ?? []);

    chatMessages.add(
      ChatMessage.bot(
        chatId: const Uuid().v4(),
        content: message,
        role: Role.user,
        timestamp: DateTime.now(),
      ),
    );

    setState(() {
      chatBubbles.add(ChatMessageBubble(message: message, role: Role.user));
      chatBubbles.add(const ChatMessageBubble(message: "Thinking...", role: Role.model));
    });

    GenerateContentResponse? response;
    try {
      response = await chat.sendMessage(Content.text(message));
    } catch (error) {
      debugPrint("Error sending message: $error");
      Toastification().show(
        title: const Text(
          "AI Generating Error",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        description: const Text(
          "Something went wrong. Please try again.",
          style: TextStyle(color: Colors.white),
        ),
        type: ToastificationType.error,
        alignment: Alignment.topCenter,
        backgroundColor: Colors.red.shade400,
        icon: const Icon(Icons.error, color: Colors.white),
        autoCloseDuration: ToastAnimations.closeDuration,
        animationDuration: ToastAnimations.animationDuration,
      );
      return;
    }

    String responseText = response.text?.trim() ?? "";
    chatBubbles[chatBubbles.length - 1] = const ChatMessageBubble(message: "", role: Role.model);

    if (responseText.isNotEmpty) {
      debugPrint(responseText);

      chatMessages.add(
        ChatMessage.bot(
          chatId: const Uuid().v4(),
          content: responseText,
          role: Role.model,
          timestamp: DateTime.now(),
        ),
      );

      if (chatChannel == null) {
        String channelId = const Uuid().v4();
        chatChannel = UserChatChannel(
          channelId: channelId,
          title: "Test Aja",
          type: ChatType.user_to_model,
          lastConversation: DateTime.now(),
          messages: chatMessages,
        );
      } else {
        chatChannel = chatChannel?.copyWith(
          lastConversation: DateTime.now(),
          messages: chatMessages,
        );
      }

      for (final char in responseText.split('')) {
        await Future.delayed(const Duration(milliseconds: 1));

        setState(() {
          chatBubbles[chatBubbles.length - 1] = ChatMessageBubble(
            message: chatBubbles.last.message + char,
            role: Role.model,
          );
        });
      }
    } else {
      debugPrint("No response text received from the AI model.");
    }
  }

  Future<void> loadChannelData({bool reload = false}) async {
    if (!reload) {
      await ref.read(authUserProvider.notifier).loadChatChannels(ChatType.user_to_model);
    } else {
      chatChannelList.clear();
    }
    final authUser = ref.read(authUserProvider);

    authUser.when(
      data: (data) {
        List<UserChatChannel> channels = data.chatChannels ?? [];
        if (channels.isNotEmpty) {
          setState(() => chatChannelList.addAll(channels));
        }
      },
      error: (error, stackTrace) {
        Toastification().show(
          title: const Text(
            "Failed Load Channel",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          description: const Text(
            "An error occurred when load chat channels. Please try again.",
            style: TextStyle(color: Colors.white),
          ),
          type: ToastificationType.error,
          alignment: Alignment.topCenter,
          backgroundColor: Colors.red.shade400,
          icon: const Icon(Icons.error, color: Colors.white),
          autoCloseDuration: ToastAnimations.closeDuration,
          animationDuration: ToastAnimations.animationDuration,
        );
        debugPrintStack(stackTrace: stackTrace);
      },
      loading: () {
        debugPrint("Loading AI Chat Channels....");
      },
    );
  }

  Future<void> loadChatData({required String channelId, int maxLoad = 6}) async {
    final lastDocumentLoad = await ref
        .read(authUserProvider.notifier)
        .loadChatMessages(channelId, lastDocumentLoad: lastDocumentSnapshot, maxLoad: maxLoad);

    if (lastDocumentLoad != null) {
      lastDocumentSnapshot = lastDocumentLoad;

      await loadChannelData(reload: true);
      chatChannel = chatChannelList.where((channel) => channel.channelId == channelId).firstOrNull;

      if (chatChannel != null) {
        List<ChatMessage> chatMessage = chatChannel?.messages ?? [];
        List<Content> chatHistories = [];

        setState(() {
          chatBubbles.clear();
          chatBubbles.addAll(
            chatMessage.map((message) {
              if (message is BotMessage) {
                if (message.role == Role.user) {
                  chatHistories.add(Content.text(message.content));
                } else {
                  chatHistories.add(Content.model([TextPart(message.content)]));
                }
                return ChatMessageBubble(message: message.content, role: message.role);
              }
              return null;
            }).whereType<ChatMessageBubble>(),
          );
        });

        chat = model.startChat(history: chatHistories);
        return;
      } else {
        Toastification().show(
          title: const Text(
            "Error Loading Chat",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          description: const Text(
            "An error occurred when loading chat data. Please try again.",
            style: TextStyle(color: Colors.white),
          ),
          type: ToastificationType.error,
          alignment: Alignment.topCenter,
          backgroundColor: Colors.red.shade400,
          icon: const Icon(Icons.error, color: Colors.white),
          autoCloseDuration: ToastAnimations.closeDuration,
          animationDuration: ToastAnimations.animationDuration,
        );
      }
    }
  }

  Future<bool> saveMessageHistory() async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null || chatChannel == null) return false;

      final String userId = currentUser.uid;
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final DocumentReference channelRef = firestore
          .collection('Users')
          .doc(userId)
          .collection('ChatChannels')
          .doc(chatChannel!.channelId);

      final List<ChatMessage> messages = chatChannel?.messages ?? [];

      await firestore.runTransaction((transaction) async {
        List<DocumentSnapshot> msgSnapshots = [];
        List<DocumentReference> msgRefs = [];

        for (ChatMessage message in messages) {
          final DocumentReference msgRef = channelRef
              .collection('ChatMessages')
              .doc(message.chatId);
          msgRefs.add(msgRef);

          final snapshot = await transaction.get(msgRef);
          msgSnapshots.add(snapshot);
        }

        transaction.set(channelRef, chatChannel?.toDatabaseMap(), SetOptions(merge: true));

        for (int i = 0; i < messages.length; i++) {
          final snapshot = msgSnapshots[i];
          final msgRef = msgRefs[i];
          final message = messages[i];

          if (!snapshot.exists) {
            transaction.set(msgRef, message.toJson());
          } else {
            debugPrint("Message ${message.chatId} already exists. Skipping to prevent overwrite.");
          }
        }
      });

      return true;
    } catch (e) {
      debugPrint("Failed to save message history: $e");
      return false;
    }
  }

  Future<void> unloadChannelData() async {
    await ref.read(authUserProvider.notifier).unloadChatChannels();
  }

  @override
  void initState() {
    super.initState();

    model = GenerativeModel(
      model: 'gemini-3.5-flash',
      apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
      generationConfig: GenerationConfig(temperature: 0.7),
      safetySettings: [
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
        SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.medium),
      ],
      systemInstruction: Content.system("You are a helpful assistant."),
    );
    chat = model.startChat();

    loadChannelData();

    scrollController.addListener(() async {
      bool isReachBottom =
          scrollController.position.pixels == scrollController.position.minScrollExtent;
      bool isReachTop =
          scrollController.position.pixels == scrollController.position.maxScrollExtent;
      showScrollableButton.value = !isReachBottom;

      if (isReachTop) {
        if (chatChannel != null) {
          loadChatData(channelId: chatChannel?.channelId ?? '');
        }
      }
    });
  }

  @override
  void dispose() {
    saveMessageHistory();
    scrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authUserState = ref.watch(authUserProvider);
    AuthUser? authUser = authUserState.value;

    bool isDarkMode = false;
    final themeMode = AdaptiveTheme.of(context).mode;
    if (themeMode == AdaptiveThemeMode.system) {
      isDarkMode = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    } else {
      isDarkMode = themeMode == AdaptiveThemeMode.dark;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          chatChannel?.title ?? "Codexia AI",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        automaticallyImplyActions: false,
        flexibleSpace: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary.withValues(alpha: 0.6), AppColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        systemOverlayStyle: isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        leading: ValueListenableBuilder(
          valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
          builder: (_, mode, child) {
            bool isDarkMode = false;
            if (mode == AdaptiveThemeMode.system) {
              isDarkMode = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
            } else {
              isDarkMode = mode == AdaptiveThemeMode.dark;
            }

            return IconButton(
              onPressed: () async {
                if (context.mounted) {
                  context.pop();
                }
              },
              icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
              style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.transparent)),
            );
          },
        ),
        actions: <Widget>[
          Builder(
            builder: (context) {
              return ValueListenableBuilder(
                valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
                builder: (_, mode, child) {
                  bool isDarkMode = false;
                  if (mode == AdaptiveThemeMode.system) {
                    isDarkMode = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
                  } else {
                    isDarkMode = mode == AdaptiveThemeMode.dark;
                  }

                  return DrawerButton(
                    onPressed: () async {
                      Scaffold.of(context).openEndDrawer();
                    },
                    color: isDarkMode ? Colors.white : Colors.black,
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.transparent),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      endDrawer: SafeArea(
        child: Drawer(
          elevation: Theme.of(context).drawerTheme.elevation,
          backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
          width: 240.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(color: AppColors.primary),
                child: Text('Chat Histories', style: Theme.of(context).textTheme.titleLarge),
              ),

              Expanded(
                child: chatChannelList.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: chatChannelList.length,
                        itemBuilder: (context, index) {
                          UserChatChannel chatChannel = chatChannelList[index];

                          return ListTile(
                            title: Text(
                              chatChannel.title,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            dense: true,
                            onTap: () async {
                              await loadChatData(channelId: chatChannel.channelId);

                              if (context.mounted) {
                                Scaffold.of(context).closeEndDrawer();
                              }
                            },
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          "No chat history found.",
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            if (chatBubbles.isEmpty)
              Padding(
                padding: const EdgeInsets.all(AppSizes.p16),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.auto_awesome,
                        size: 40.0,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              "Hello, ${authUser?.displayName ?? authUser?.username ?? "Guest"}!",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              "What can I do to help?",
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Theme.of(
                                  context,
                                ).textTheme.titleSmall?.color?.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            Positioned.fill(
              child: SingleChildScrollView(
                controller: scrollController,
                primary: false,
                reverse: true,
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.p16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SizedBox(height: 8.0),
                      ChatPlaceholder(children: <ChatMessageBubble>[...chatBubbles]),
                      const SizedBox(height: 16.0),
                      Text.rich(
                        TextSpan(
                          text: "Powered by ",
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Theme.of(
                              context,
                            ).textTheme.labelSmall?.color?.withValues(alpha: 0.6),
                          ),
                          children: [
                            TextSpan(
                              text: "Google Gemini",
                              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(
                                  context,
                                ).textTheme.labelSmall?.color?.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 80.0),
                    ],
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
                          padding: const EdgeInsets.all(AppSizes.p16),
                          child: Material(
                            elevation: 1.5,
                            surfaceTintColor: Theme.of(context).cardColor,
                            borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                            child: InkWell(
                              borderRadius: const BorderRadius.all(Radius.circular(32.0)),
                              onTap: () {
                                scrollController.animateTo(
                                  scrollController.position.minScrollExtent,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeOut,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(AppSizes.p8),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 28.0,
                                  color: Theme.of(context).iconTheme.color,
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
                  margin: const EdgeInsets.all(0.0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(AppSizes.p16),
                    constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 80.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        TextField(
                          controller: textEditingController,
                          minLines: 1,
                          maxLines: 5,
                          style: Theme.of(context).textTheme.labelLarge,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.send,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () async {
                                String value = textEditingController.text.trim();
                                if (value.isEmpty) return;

                                if (context.mounted) {
                                  textEditingController.clear();
                                  FocusScope.of(context).unfocus();
                                }

                                sendMessage(message: value);
                              },
                              icon: const Icon(Icons.send),
                              iconSize: 20.0,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            suffixIconConstraints: const BoxConstraints(
                              minWidth: 40.0,
                              minHeight: 40.0,
                            ),
                            hintText: 'Write prompt here',
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            ),
                          ),
                          contextMenuBuilder:
                              (BuildContext context, EditableTextState editableTextState) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    iconButtonTheme: IconButtonThemeData(
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.black,
                                        shape: const RoundedRectangleBorder(),
                                        elevation: 0,
                                      ),
                                    ),
                                  ),
                                  child: AdaptiveTextSelectionToolbar.editableText(
                                    editableTextState: editableTextState,
                                  ),
                                );
                              },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
