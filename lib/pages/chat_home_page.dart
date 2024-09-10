import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:musicbud_flutter/pages/channel_list_page.dart';
import 'package:musicbud_flutter/pages/user_list_page.dart';

class ChatHomePage extends StatelessWidget {
  final ChatService chatService;

  const ChatHomePage({Key? key, required this.chatService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChannelListPage(chatService: chatService),
                  ),
                );
              },
              child: Text('Go to Channel List'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserListPage(chatService: chatService),
                  ),
                );
              },
              child: Text('Go to User List'),
            ),
          ],
        ),
      ),
    );
  }
}
