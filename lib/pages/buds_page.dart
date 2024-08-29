import 'package:flutter/material.dart';

class BudsPage extends StatelessWidget {
  const BudsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buds'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text('B${index + 1}'),
            ),
            title: Text('Bud ${index + 1}'),
            subtitle: Text('Status of Bud ${index + 1}'),
          );
        },
      ),
    );
  }
}