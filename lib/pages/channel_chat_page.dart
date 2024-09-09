import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';

class ChannelChatPage extends StatefulWidget {
  final ChatService chatService;
  final int channelId;
  final String channelName;

  const ChannelChatPage({Key? key, required this.chatService, required this.channelId, required this.channelName}) : super(key: key);

  @override
  _ChannelChatPageState createState() => _ChannelChatPageState();
}

class _ChannelChatPageState extends State<ChannelChatPage> {
  List<dynamic> messages = [];
  final TextEditingController _messageController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChannelMessages();
    _connectWebSocket();
  }

  Future<void> _fetchChannelMessages() async {
    try {
      final channelMessages = await widget.chatService.getChannelMessages(widget.channelId.toString());
      setState(() {
        messages = channelMessages.data as List<dynamic>;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching channel messages: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        final response = await widget.chatService.sendMessageData({
            'channel_id': widget.channelId,
            'content': _messageController.text,
            'recipient_type': 'channel',
            'recipient_id': widget.channelId,
        });
        if (response.data['status'] == 'success') {
          _messageController.clear();
          _fetchChannelMessages(); // Refresh messages after sending
        } else {
          print('Failed to send message: ${response.data['message']}');
        }
      } catch (e) {
        print('Error sending message: $e');
      }
    }
  }

  void _connectWebSocket() {
    // Implement WebSocket connection logic here
    // Use a package like 'web_socket_channel' to manage WebSocket connections
  }

  void _performAction(String action, int userId) async {
    try {
      final response = await widget.chatService.performAction(action, widget.channelId.toString(), userId.toString());
      if (response.data['status'] == 'success') {
        _fetchChannelMessages(); // Refresh messages after action
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.data['message'])));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.data['message']}')));
      }
    } catch (e) {
      print('Error performing action: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.channelName)),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ListTile(
                        title: Text('${message['user__username']}: ${message['content']}'), // Adjust based on your message model
                        trailing: message['is_admin'] || message['is_moderator']
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_circle),
                                    onPressed: () => _performAction('kick', message['user_id']),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.remove_moderator),
                                    onPressed: () => _performAction('remove_moderator', message['user_id']),
                                  ),
                                ],
                              )
                            : null,
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
                      hintText: 'Type a message',
                      border: OutlineInputBorder(),
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

