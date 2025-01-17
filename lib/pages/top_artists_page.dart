import 'package:flutter/material.dart';
import '../widgets/top_artists_horizontal_list.dart';

class TopArtistsPage extends StatelessWidget {
  const TopArtistsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Artists'),
      ),
      body: ListView(
        children: [
          TopArtistsHorizontalList(),
        ],
      ),
    );
  }
}