import 'package:codexia_course_learning/core/app_constants.dart' show AppColors, AppSizes;
import 'package:codexia_course_learning/features/chat/models/chat_message.dart';
import 'package:flutter/material.dart';

import '../factory/chat_factory.dart';

class ChatMessageBubble extends StatelessWidget {
  final String message;
  final Role role;

  const ChatMessageBubble({super.key, required this.message, required this.role});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: role == Role.user ? 1.0 : 0.0,
      clipBehavior: Clip.antiAlias,
      color: role == Role.user
          ? AppColors.secondary.withValues(alpha: 0.5)
          : Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.p8, horizontal: AppSizes.p12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        child: role == Role.user
            ? Text(message, style: Theme.of(context).textTheme.labelLarge)
            : Text.rich(TextSpan(children: ChatFactory(message: message).format())),
      ),
    );
  }
}
