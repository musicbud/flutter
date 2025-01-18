import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:musicbud_flutter/services/chat_service.dart';

class ChatRoomPage extends StatefulWidget {
  final int channelId;
  final Dio dio;

  const ChatRoomPage({Key? key, required this.channelId, required this.dio})
      : super(key: key);

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late ChatService chatService;
  List<dynamic> _messages = [];
  bool _isLoading = true;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    chatService = ChatService(widget.dio);
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await chatService.getChannelMessages(widget.channelId);
      if (response.statusCode == 200) {
        setState(() {
          _messages = response.data['messages'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching messages: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _sendMessage() async {
    final content = _messageController.text;
    if (content.isEmpty) return;

    try {
      final response = await chatService.sendMessage({
        'content': content,
        'recipient_type': 'channel',
        'recipient_id': widget.channelId,
      });

      if (!mounted) return;

      if (response['status'] == 'success') {
        setState(() {
          _messages.insert(0, {
            'content': content,
            'username': 'You',
            'timestamp': DateTime.now().toIso8601String(),
          });
          _messageController.clear();
        });
      } else {
        _showSnackBar('Error: ${response['message']}');
      }
    } catch (e) {
      print('Error sending message: $e');
      if (!mounted) return;
      _showSnackBar('An error occurred. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat Room')),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ListTile(
                        title: Text(message['username']),
                        subtitle: Text(message['content']),
                        trailing: Text(message['timestamp']),
                      );
                    },
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
                      hintText: 'Enter your message',
                    ),
                  ),
                ),
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
  }
}
