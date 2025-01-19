import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/chat/screen/chat_screen_bloc.dart';
import '../../blocs/chat/screen/chat_screen_event.dart';
import '../../blocs/chat/screen/chat_screen_state.dart';
import '../widgets/loading_indicator.dart';

class ChatScreen extends StatefulWidget {
  final String userId;

  const ChatScreen({super.key, required this.userId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    context
        .read<ChatScreenBloc>()
        .add(ChatScreenMessagesRequested(widget.userId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      context.read<ChatScreenBloc>().add(
            ChatScreenMessageSent(
              userId: widget.userId,
              message: message,
            ),
          );
      _messageController.clear();
      _stopTyping();
    }
  }

  void _startTyping() {
    if (!_isTyping) {
      setState(() => _isTyping = true);
      context
          .read<ChatScreenBloc>()
          .add(ChatScreenTypingStarted(widget.userId));
    }
  }

  void _stopTyping() {
    if (_isTyping) {
      setState(() => _isTyping = false);
      context
          .read<ChatScreenBloc>()
          .add(ChatScreenTypingStopped(widget.userId));
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ChatScreenBloc, ChatScreenState>(
          builder: (context, state) {
            if (state is ChatScreenLoaded && state.isTyping) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.userId),
                  const Text(
                    'typing...',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              );
            }
            return Text('Chat with ${widget.userId}');
          },
        ),
      ),
      body: BlocConsumer<ChatScreenBloc, ChatScreenState>(
        listener: (context, state) {
          if (state is ChatScreenFailure) {
            _showErrorSnackBar(state.error);
          }
        },
        builder: (context, state) {
          if (state is ChatScreenInitial || state is ChatScreenLoading) {
            return const LoadingIndicator();
          }

          if (state is ChatScreenLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message =
                          state.messages[state.messages.length - 1 - index];
                      return OutlinedMessageBubble(
                        message: message.content,
                        isUser: message.senderUsername != widget.userId,
                        timestamp: message.createdAt,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextField(
                            controller: _messageController,
                            onChanged: (_) => _startTyping(),
                            onSubmitted: (_) => _sendMessage(),
                            decoration: const InputDecoration(
                              hintText: 'Type a message',
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: _sendMessage,
                        style: OutlinedButton.styleFrom(
                          shape: const CircleBorder(),
                          side:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        child: const Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }
}

class OutlinedMessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final DateTime timestamp;

  const OutlinedMessageBubble({
    Key? key,
    required this.message,
    required this.isUser,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(12),
          color:
              isUser ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(message),
            Text(
              '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
