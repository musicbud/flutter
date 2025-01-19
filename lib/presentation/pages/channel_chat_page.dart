import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_bloc.dart';
import 'package:musicbud_flutter/blocs/chat/chat_event.dart';
import 'package:musicbud_flutter/blocs/chat/chat_state.dart';
import 'package:musicbud_flutter/presentation/pages/channel_admin_page.dart';

class ChannelChatPage extends StatefulWidget {
  final String channelId;
  final String channelName;
  final String currentUsername;

  const ChannelChatPage({
    Key? key,
    required this.channelId,
    required this.channelName,
    required this.currentUsername,
  }) : super(key: key);

  @override
  _ChannelChatPageState createState() => _ChannelChatPageState();
}

class _ChannelChatPageState extends State<ChannelChatPage> {
  final TextEditingController _messageController = TextEditingController();
  bool _isAdminOrModerator = false;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _checkAdminStatus();
  }

  void _fetchMessages() {
    context
        .read<ChatBloc>()
        .add(ChatChannelMessagesRequested(widget.channelId));
  }

  void _checkAdminStatus() {
    context.read<ChatBloc>().add(ChatChannelRolesChecked(widget.channelId));
  }

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      context.read<ChatBloc>().add(ChatMessageSent(
            channelId: widget.channelId,
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

  void _navigateToAdminPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChannelAdminPage(
          channelId: widget.channelId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatState>(
      listener: (context, state) {
        if (state is ChatMessageSentSuccess) {
          _fetchMessages(); // Refresh messages after sending
        } else if (state is ChatChannelRolesLoaded) {
          setState(() {
            _isAdminOrModerator = state.roles['is_admin'] == true ||
                state.roles['is_moderator'] == true;
          });
        } else if (state is ChatError) {
          _showSnackBar('Error: ${state.message}');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.channelName),
          ),
          body: Column(
            children: [
              Expanded(
                child: _buildMessageList(state),
              ),
              _buildMessageInput(),
            ],
          ),
          floatingActionButton: _isAdminOrModerator
              ? FloatingActionButton(
                  onPressed: _navigateToAdminPage,
                  tooltip: 'Channel Admin',
                  child: const Icon(Icons.admin_panel_settings),
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }

  Widget _buildMessageList(ChatState state) {
    if (state is ChatLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is ChatChannelMessagesLoaded) {
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

    if (state is ChatError) {
      return Center(child: Text('Error: ${state.message}'));
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
