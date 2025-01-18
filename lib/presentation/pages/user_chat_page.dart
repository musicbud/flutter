import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:intl/intl.dart';

class UserChatPage extends StatefulWidget {
  final ChatService chatService;
  final String currentUsername;
  final String otherUsername;

  const UserChatPage({
    Key? key,
    required this.chatService,
    required this.currentUsername,
    required this.otherUsername,
  }) : super(key: key);

  @override
  _UserChatPageState createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  List<Map<String, dynamic>> _messages = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _validateAndFetchMessages();
  }

  void _validateAndFetchMessages() {
    if (widget.currentUsername.isEmpty || widget.otherUsername.isEmpty) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Invalid usernames. Cannot fetch messages.';
      });
    } else {
      _fetchMessages();
    }
  }

  Future<void> _fetchMessages() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    print('Fetching messages for currentUsername: ${widget.currentUsername}, otherUsername: ${widget.otherUsername}');

    try {
      final response = await widget.chatService.getUserMessages(
        widget.currentUsername,
        widget.otherUsername,
      );

      if (response['messages'] is List) {
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
        _hasError = true;
        _errorMessage = 'Failed to load messages. Please try again.';
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      try {
        final response = await widget.chatService.sendUserMessage(
          widget.currentUsername,
          widget.otherUsername,
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
          const SnackBar(content: Text('Failed to send message. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUsername),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(child: Text(_errorMessage))
              : _buildChatList(),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        final content = message['content'] as String? ?? 'No content';
        final user = message['user__username'] as String? ?? 'Unknown user';
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
    );
  }

  // ... rest of the class implementation
}
