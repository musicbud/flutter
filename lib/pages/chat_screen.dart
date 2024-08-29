import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String user;

  const ChatScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with $user'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: const <Widget>[
                OutlinedMessageBubble(
                  message: 'User: Hi!',
                  isUser: false,
                ),
                OutlinedMessageBubble(
                  message: 'You: Hello!',
                  isUser: true,
                ),
                // Add more messages here
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Type a message',
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                OutlinedButton(
                  onPressed: () {
                    // Handle send message
                  },
                  style: OutlinedButton.styleFrom(
                    shape: const CircleBorder(),
                    side: BorderSide(color: Theme.of(context).primaryColor),
                  ),
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OutlinedMessageBubble extends StatelessWidget {
  final String message;
  final bool isUser;

  const OutlinedMessageBubble({
    Key? key,
    required this.message,
    required this.isUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(12),
          color: isUser ? Theme.of(context).primaryColor.withOpacity(0.1) : null,
        ),
        child: Text(message),
      ),
    );
  }
}