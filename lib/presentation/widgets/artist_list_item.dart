import 'package:flutter/material.dart';
import 'package:musicbud_flutter/domain/models/common_artist.dart';

class ArtistListItem extends StatelessWidget {
  final CommonArtist artist;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const ArtistListItem({
    Key? key,
    required this.artist,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: artist.imageUrls?.isNotEmpty == true
          ? CircleAvatar(
              backgroundImage: NetworkImage(artist.imageUrls!.first),
              radius: 25,
            )
          : const CircleAvatar(
              radius: 25,
              child: Icon(Icons.person),
            ),
      trailing: artist.isLiked
          ? const Icon(Icons.favorite, color: Colors.red)
          : const Icon(Icons.favorite_border),
      title: Text(
        artist.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: artist.genres?.isNotEmpty == true
          ? Text(
              artist.genres!.join(', '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      onLongPress: onLongPress,
    );
  }
}
