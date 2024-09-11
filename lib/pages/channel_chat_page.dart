import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:intl/intl.dart';
import 'package:musicbud_flutter/pages/channel_admin_page.dart';
import 'package:musicbud_flutter/pages/spotify_control_page.dart';

class ChannelChatPage extends StatefulWidget {
  final ChatService chatService;
  final int channelId;
  final String channelName;
  final String currentUsername;

  const ChannelChatPage({
    Key? key,
    required this.chatService,
    required this.channelId,
    required this.channelName,
    required this.currentUsername,
  }) : super(key: key);

  @override
  _ChannelChatPageState createState() => _ChannelChatPageState();
}

class _ChannelChatPageState extends State<ChannelChatPage> {
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  final TextEditingController _messageController = TextEditingController();
  bool _isAdminOrModerator = false;

  @override
  void initState() {
    super.initState();
    _fetchMessages();
    _checkAdminStatus();
  }

  Future<void> _fetchMessages() async {
    try {
      final response = await widget.chatService.getChannelMessages(widget.channelId);
      if (response['status'] == 'success' && response['messages'] is List) {
        setState(() {
          _messages = List<Map<String, dynamic>>.from(response['messages'] as List);
          _isLoading = false;
        });
      } else {
        throw Exception('Invalid response format');
      }
    } catch (e) {
      print('Error fetching messages: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load messages. Please try again.')),
      );
    }
  }

  Future<void> _checkAdminStatus() async {
    try {
      final roles = await widget.chatService.checkChannelRoles(widget.channelId);
      setState(() {
        _isAdminOrModerator = roles['is_admin'] == true || roles['is_moderator'] == true;
      });
    } catch (e) {
      print('Error checking user roles: $e');
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        final response = await widget.chatService.sendChannelMessage(
          widget.channelId,
          widget.currentUsername,
          _messageController.text,
        );
        if (response['status'] == 'success') {
          _messageController.clear();
          await _fetchMessages();
        } else {
          throw Exception(response['message'] ?? 'Failed to send message');
        }
      } catch (e) {
        print('Error sending message: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send message. Please try again.')),
        );
      }
    }
  }

  void _navigateToAdminPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChannelAdminPage(
          channelId: widget.channelId,
          chatService: widget.chatService,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.channelName),
        // Remove all actions from here
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final content = message['content'] as String? ?? 'No content';
                      final user = message['user'] as String? ?? 'Unknown user';
                      final timestamp = message['timestamp'] as String? ?? '';
                      final DateTime? dateTime = DateTime.tryParse(timestamp);
                      final formattedDate = dateTime != null
                          ? DateFormat('yyyy-MM-dd HH:mm').format(dateTime.toLocal())
                          : 'Unknown date';

                      return ListTile(
                        title: Text(content),
                        subtitle: Text('$user - $formattedDate'),
                        tileColor: user == widget.currentUsername ? Colors.blue[50] : null,
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
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _isAdminOrModerator
          ? FloatingActionButton(
              onPressed: _navigateToAdminPage,
              child: Icon(Icons.admin_panel_settings),
              tooltip: 'Channel Admin',
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

