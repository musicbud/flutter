import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:musicbud_flutter/pages/channel_list_page.dart';
import 'package:musicbud_flutter/pages/user_list_page.dart';

class ChatHomePage extends StatelessWidget {
  final ChatService chatService;
  final String currentUsername;

  const ChatHomePage({
    Key? key,
    required this.chatService,
    required this.currentUsername,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'Channels'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UserListPage(
              chatService: chatService,
              currentUsername: currentUsername,
            ),
            ChannelListPage(
              chatService: chatService,
              currentUsername: currentUsername,
            ),
          ],
        ),
      ),
    );
  }
}
