import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_anime.dart';

class AnimeListItem extends StatelessWidget {
  final CommonAnime anime;
  final VoidCallback? onTap;

  const AnimeListItem({
    Key? key,
    required this.anime,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Image.network(
              anime.imageUrl,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                anime.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
