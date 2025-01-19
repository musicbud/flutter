import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/chat_room/chat_room_bloc.dart';
import '../../blocs/chat_room/chat_room_event.dart';
import '../../blocs/chat_room/chat_room_state.dart';
import '../widgets/loading_indicator.dart';

class ChatRoomPage extends StatefulWidget {
  final String channelId;
  final String currentUsername;

  const ChatRoomPage({
    Key? key,
    required this.channelId,
    required this.currentUsername,
  }) : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchMessages() {
    context
        .read<ChatRoomBloc>()
        .add(ChatRoomMessagesRequested(widget.channelId));
  }

  void _sendMessage() {
    final content = _messageController.text.trim();
    if (content.isEmpty) return;

    context.read<ChatRoomBloc>().add(ChatRoomMessageSent(
          channelId: widget.channelId,
          senderUsername: widget.currentUsername,
          content: content,
        ));
    _messageController.clear();
  }

  void _deleteMessage(String messageId) {
    context.read<ChatRoomBloc>().add(ChatRoomMessageDeleted(
          channelId: widget.channelId,
          messageId: messageId,
        ));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatRoomBloc, ChatRoomState>(
      listener: (context, state) {
        if (state is ChatRoomFailure) {
          _showSnackBar('Error: ${state.error}');
        } else if (state is ChatRoomMessageSentSuccess) {
          _scrollToBottom();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chat Room'),
          ),
          body: Column(
            children: [
              Expanded(
                child: state is ChatRoomLoading
                    ? const Center(child: LoadingIndicator())
                    : state is ChatRoomLoaded
                        ? ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(8.0),
                            itemCount: state.messages.length,
                            itemBuilder: (context, index) {
                              final message = state.messages[index];
                              final isCurrentUser = message.senderUsername ==
                                  widget.currentUsername;

                              return Align(
                                alignment: isCurrentUser
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 4.0,
                                    horizontal: 8.0,
                                  ),
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: isCurrentUser
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[300],
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: isCurrentUser
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        message.senderUsername,
                                        style: TextStyle(
                                          color: isCurrentUser
                                              ? Colors.white70
                                              : Colors.black54,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        message.content,
                                        style: TextStyle(
                                          color: isCurrentUser
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      if (isCurrentUser)
                                        GestureDetector(
                                          onTap: () => _deleteMessage(
                                              message.id.toString()),
                                          child: const Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: Icon(
                                              Icons.delete_outline,
                                              size: 16.0,
                                              color: Colors.white70,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text('Failed to load messages'),
                          ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
