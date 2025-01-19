import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_event.dart';
import 'package:musicbud_flutter/blocs/chat/chat_state.dart';

class UserChatPage extends StatefulWidget {
  final String currentUsername;
  final String otherUsername;

  const UserChatPage({
    Key? key,
    required this.currentUsername,
    required this.otherUsername,
  }) : super(key: key);

  @override
  _UserChatPageState createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _validateAndFetchMessages();
  }

  void _validateAndFetchMessages() {
    if (widget.currentUsername.isEmpty || widget.otherUsername.isEmpty) {
      return;
    }
    _fetchMessages();
  }

  void _fetchMessages() {
    context.read<ChatBloc>().add(ChatUserMessagesRequested(
          currentUsername: widget.currentUsername,
          otherUsername: widget.otherUsername,
        ));
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      context.read<ChatBloc>().add(ChatUserMessageSent(
            senderUsername: widget.currentUsername,
            recipientUsername: widget.otherUsername,
            content: _messageController.text,
          ));
      _messageController.clear();
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatUserMessageSentSuccess) {
          _fetchMessages(); // Refresh messages after sending
        } else if (state is ChatFailure) {
          _showSnackBar('Error: ${state.error}');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.otherUsername),
          ),
          body: Column(
            children: [
              Expanded(
                child: _buildMessageList(state),
              ),
              _buildMessageInput(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMessageList(ChatState state) {
    if (widget.currentUsername.isEmpty || widget.otherUsername.isEmpty) {
      return const Center(
        child: Text('Invalid usernames. Cannot fetch messages.'),
      );
    }

    if (state is ChatLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ChatUserMessagesLoaded) {
      if (state.messages.isEmpty) {
        return const Center(child: Text('No messages yet'));
      }

      return ListView.builder(
        itemCount: state.messages.length,
        itemBuilder: (context, index) {
          final message = state.messages[index];
          final formattedDate = '${message.createdAt.year}-'
              '${message.createdAt.month.toString().padLeft(2, '0')}-'
              '${message.createdAt.day.toString().padLeft(2, '0')} '
              '${message.createdAt.hour.toString().padLeft(2, '0')}:'
              '${message.createdAt.minute.toString().padLeft(2, '0')}';

          return ListTile(
            title: Text(message.content),
            subtitle: Text('${message.senderUsername} - $formattedDate'),
            tileColor: message.senderUsername == widget.currentUsername
                ? Colors.blue[50]
                : null,
          );
        },
      );
    }

    if (state is ChatFailure) {
      return Center(child: Text('Error: ${state.error}'));
    }

    return const Center(child: Text('No messages available'));
  }

  Widget _buildMessageInput() {
    return Padding(
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
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
