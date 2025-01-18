import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_album.dart';

class AlbumListItem extends StatelessWidget {
  final CommonAlbum album;
  final VoidCallback? onTap;

  const AlbumListItem({
    Key? key,
    required this.album,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(album.name),
      subtitle: Text(album.artist),
      leading: album.imageUrl.isNotEmpty
          ? Image.network(album.imageUrl, width: 50, height: 50)
          : const Icon(Icons.album),
      onTap: onTap,
    );
  }
}
