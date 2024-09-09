import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/chat_service.dart';

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
        child: Text('This is the Chat Home Page'),
      ),
    );
  }
}
