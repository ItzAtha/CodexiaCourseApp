import 'package:codexia_course_learning/features/chat/widgets/chat_message_bubble.dart';
import 'package:flutter/material.dart';

import '../models/chat_message.dart';

class ChatPlaceholder extends StatelessWidget {
  final double? spacer;
  final List<ChatMessageBubble> children;

  const ChatPlaceholder({super.key, required this.children, this.spacer = 8.0});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < children.length; i++)
          if (children[i].role == Role.user)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Align(alignment: Alignment.centerRight, child: children[i]),
                SizedBox(height: spacer),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(alignment: Alignment.centerLeft, child: children[i]),
                if (i != children.length - 1) SizedBox(height: spacer),
              ],
            ),
      ],
    );
  }
}
