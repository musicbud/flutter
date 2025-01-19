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
      leading: album.imageUrls?.isNotEmpty == true
          ? CircleAvatar(
              backgroundImage: NetworkImage(album.imageUrls!.first),
              radius: 25,
            )
          : const CircleAvatar(
              child: Icon(Icons.album),
              radius: 25,
            ),
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
      trailing: album.isLiked
          ? const Icon(Icons.favorite, color: Colors.red)
          : const Icon(Icons.favorite_border),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
