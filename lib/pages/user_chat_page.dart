import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';

class UserChatPage extends StatefulWidget {
  final String userUsername;
  final String otherUsername;
  final ChatService chatService;

  const UserChatPage({Key? key, required this.userUsername, required this.otherUsername, required this.chatService}) : super(key: key);

  @override
  _UserChatPageState createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  List<dynamic> _messages = [];
  bool _isLoading = true;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await widget.chatService.getUserMessages(widget.userUsername, widget.otherUsername);
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

  Future<void> _sendMessage() async {
    final content = _messageController.text;
    if (content.isEmpty) return;

    try {
      final response = await widget.chatService.sendUserMessage({
        'recipient_username': widget.otherUsername,
        'content': content,
      });

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        setState(() {
          _messages.insert(0, {
            'content': content,
            'username': 'You', // Replace with actual username if available
            'timestamp': DateTime.now().toIso8601String(),
          });
          _messageController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.data['message']}')),
        );
      }
    } catch (e) {
      print('Error sending message: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.otherUsername}')),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
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
                    decoration: InputDecoration(
                      hintText: 'Enter your message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
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
