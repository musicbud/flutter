import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_artist.dart';

class ArtistListItem extends StatelessWidget {
  final CommonArtist artist;

  const ArtistListItem({Key? key, required this.artist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(artist.name ?? 'Unknown Artist'),
      leading: artist.imageUrl != null
          ? Image.network(
              artist.imageUrl!,
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.person),
            )
          : Icon(Icons.person),
    );
  }
}
