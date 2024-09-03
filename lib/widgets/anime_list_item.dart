import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_anime.dart';

class AnimeListItem extends StatelessWidget {
  final CommonAnime anime;
  final VoidCallback? onTap;

  const AnimeListItem({Key? key, required this.anime, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(anime.title),
      subtitle: Text(anime.status),
      leading: anime.imageUrl.isNotEmpty
          ? Image.network(anime.imageUrl, width: 50, height: 50)
          : Icon(Icons.movie),
      onTap: onTap,
    );
  }
}
