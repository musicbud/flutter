import 'package:flutter/material.dart';
import 'package:musicbud_flutter/domain/models/common_manga.dart';

class MangaListItem extends StatelessWidget {
  final CommonManga manga;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const MangaListItem({
    Key? key,
    required this.manga,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: manga.imageUrl != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(manga.imageUrl!),
              radius: 25,
            )
          : const CircleAvatar(
              child: Icon(Icons.book),
              radius: 25,
            ),
      title: Text(
        manga.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: manga.genres?.isNotEmpty == true
          ? Text(
              manga.genres!.join(', '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: manga.isLiked
          ? const Icon(Icons.favorite, color: Colors.red)
          : const Icon(Icons.favorite_border),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
