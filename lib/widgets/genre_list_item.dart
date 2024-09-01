import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_genre.dart';

class GenreListItem extends StatelessWidget {
  final CommonGenre genre;

  const GenreListItem({Key? key, required this.genre}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(genre.name ?? 'Unknown Genre'),
      leading: Icon(Icons.music_note),
    );
  }
}
