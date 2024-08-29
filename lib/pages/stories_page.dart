import 'package:flutter/material.dart';

class StoriesPage extends StatelessWidget {
  const StoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stories'),
      ),
      body: Center(
        child: Text('Stories content will be displayed here'),
      ),
    );
  }
}
