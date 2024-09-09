import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:musicbud_flutter/pages/channel_details_page.dart';

class ChatListPage extends StatefulWidget {
  final ChatService chatService;

  const ChatListPage({Key? key, required this.chatService}) : super(key: key);

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<dynamic> _channels = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loginAndFetchChannels();
  }

  Future<void> _loginAndFetchChannels() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Login with provided credentials
      final loginResult = await widget.chatService.login('mahmwood', 'password');
      print('Login result: $loginResult');
      print('Access token after login: ${widget.chatService.accessToken}');

      if (!loginResult['success']) {
        // Handle login failure
        setState(() {
          _isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Failed'),
            content: Text(loginResult['message']),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      // Add a small delay to ensure any asynchronous operations complete
      await Future.delayed(Duration(seconds: 1));

      // Get channel list
      final channelList = await widget.chatService.getChannelList();
      print('Channel list: $channelList');

      setState(() {
        _channels = channelList;
        _isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat List')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _channels.isEmpty
              ? Center(child: Text('No channels available'))
              : ListView.builder(
                  itemCount: _channels.length,
                  itemBuilder: (context, index) {
                    final channel = _channels[index];
                    return ListTile(
                      title: Text(channel['name'] ?? 'Unnamed Channel'),
                      subtitle: Text(channel['description'] ?? 'No description'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChannelDetailsPage(
                              channelId: channel['id'],
                              dio: widget.chatService.dio,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
