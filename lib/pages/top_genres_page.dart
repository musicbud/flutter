import 'package:flutter/material.dart';

class TopGenresPage extends StatelessWidget {
  const TopGenresPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Genres'),
      ),
      body: Center(
        child: Text('Top Genres Content'),
      ),
    );
  }
}
