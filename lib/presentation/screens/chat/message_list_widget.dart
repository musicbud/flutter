import 'package:flutter/material.dart';
import 'components/message_bubble.dart';

class MessageListWidget extends StatefulWidget {
  final List<dynamic> messages;
  final ScrollController scrollController;

  const MessageListWidget({
    super.key,
    required this.messages,
    required this.scrollController,
  });

  @override
  State<MessageListWidget> createState() => _MessageListWidgetState();
}

class _MessageListWidgetState extends State<MessageListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: widget.scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: widget.messages.length,
      itemBuilder: (context, index) {
        final message = widget.messages[index];
        return MessageBubble(
          text: message['message'] ?? 'Hello! How are you?',
          isMe: message['is_me'] ?? false,
          timestamp: message['timestamp'] ?? DateTime.now(),
          avatarUrl: message['avatar_url'],
          senderAvatarUrl: message['sender_avatar_url'],
        );
      },
    );
  }
}