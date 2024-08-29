import 'package:flutter/material.dart';

class TopGenresHorizontalList extends StatelessWidget {
  const TopGenresHorizontalList({super.key});

  @override
  Widget build(BuildContext context) {
    // Replace this with actual genre data
    final List<String> genres = ['Rock', 'Pop', 'Hip Hop', 'Jazz', 'Classical'];

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: genres.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Chip(
            label: Text(genres[index]),
          ),
        );
      },
    );
  }
}
