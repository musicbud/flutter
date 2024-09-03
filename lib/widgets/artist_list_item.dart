import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_artist.dart';

class ArtistListItem extends StatelessWidget {
  final CommonArtist artist;

  const ArtistListItem({Key? key, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(artist.name ?? 'Unknown Artist'),
      leading: artist.images.isNotEmpty
          ? CircleAvatar(
              backgroundImage: NetworkImage(
                artist.images.isNotEmpty ? artist.images.first.url : 'default_image_url',
              ),
            )
          : CircleAvatar(
              child: Text(artist.name[0]),
            ),
    );
  }
}
