import 'package:flutter/material.dart';
import 'package:musicbud_flutter/domain/models/common_album.dart';

class AlbumListItem extends StatelessWidget {
  final CommonAlbum album;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const AlbumListItem({
    Key? key,
    required this.album,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: album.imageUrl != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(album.imageUrl!),
              radius: 25,
            )
          : const CircleAvatar(
              radius: 25,
              child: Icon(Icons.album),
            ),
      trailing: album.isLiked
          ? const Icon(Icons.favorite, color: Colors.red)
          : const Icon(Icons.favorite_border),
      title: Text(
        album.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        album.artistName ?? 'Unknown Artist',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      onLongPress: onLongPress,
    );
  }
}
