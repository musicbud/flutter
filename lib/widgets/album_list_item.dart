import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_album.dart';

class AlbumListItem extends StatelessWidget {
  final CommonAlbum album;

  const AlbumListItem({Key? key, required this.album}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(album.name ?? 'Unknown Album'),
      subtitle: Text(album.artist ?? album.artists?.map((artist) => artist.name).join(', ') ?? 'Unknown Artist'),
      leading: album.imageUrl != null
          ? Image.network(album.imageUrl!, width: 50, height: 50)
          : Icon(Icons.album),
    );
  }
}
