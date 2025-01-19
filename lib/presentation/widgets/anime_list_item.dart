import 'package:flutter/material.dart';
import 'package:musicbud_flutter/domain/models/common_anime.dart';

class AnimeListItem extends StatelessWidget {
  final CommonAnime anime;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const AnimeListItem({
    Key? key,
    required this.anime,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: anime.imageUrl != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(anime.imageUrl!),
              radius: 25,
            )
          : const CircleAvatar(
              radius: 25,
              child: Icon(Icons.movie),
            ),
      trailing: anime.isLiked
          ? const Icon(Icons.favorite, color: Colors.red)
          : const Icon(Icons.favorite_border),
      title: Text(
        anime.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: anime.genres?.isNotEmpty == true
          ? Text(
              anime.genres!.join(', '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      onLongPress: onLongPress,
    );
  }
}
