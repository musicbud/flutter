import 'package:flutter/material.dart';
import 'package:musicbud_flutter/pages/chat_screen.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            leading: CircleAvatar(
              child: Text('U${index + 1}'),
            ),
            title: Text('User ${index + 1}'),
            subtitle: Text('Last message from User ${index + 1}'),
            trailing: const Text('12:00 PM'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(user: 'User ${index + 1}'),
                ),
              );
            },
          ),
        );
      },
    );
  }
}