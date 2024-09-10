import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';

class ChannelChatPage extends StatefulWidget {
  final int channelId;
  final String channelName;
  final ChatService chatService;

  const ChannelChatPage({
    Key? key,
    required this.channelId,
    required this.channelName,
    required this.chatService,
  }) : super(key: key);

  @override
  _ChannelChatPageState createState() => _ChannelChatPageState();
}

class _ChannelChatPageState extends State<ChannelChatPage> {
  List<dynamic> messages = [];
  bool isLoading = true;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchMessages();
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await widget.chatService.getChannelMessages(widget.channelId);
      final Map<String, dynamic> responseData = response.data;
      setState(() {
        messages = responseData['messages'] as List<dynamic>;
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
        await widget.chatService.sendMessage(
          widget.channelId,
          _messageController.text,
          'channel',
          widget.channelId,
        );
        _messageController.clear();
        _fetchMessages(); // Refresh messages after sending
      } catch (e) {
        print('Error sending message: $e');
      }
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
                        title: Text('${message['user__username']}: ${message['content']}'),
                        subtitle: Text(message['timestamp']),
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

