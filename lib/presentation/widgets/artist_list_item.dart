import 'package:flutter/material.dart';
import '../../../models/artist.dart';

class ArtistListItem extends StatelessWidget {
  final Artist artist;
  final VoidCallback? onTap;
  final VoidCallback? onFollowPressed;

  const ArtistListItem({
    Key? key,
    required this.artist,
    this.onTap,
    this.onFollowPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
        ),
        child: artist.imageUrl != null
            ? ClipOval(
                child: Image.network(artist.imageUrl!, fit: BoxFit.cover),
              )
            : const Icon(Icons.person, color: Colors.grey),
      ),
      title: Text(artist.name),
      subtitle: artist.genres?.isNotEmpty == true
          ? Text(artist.genres!.join(', '))
          : null,
      trailing: IconButton(
        icon: Icon(
          artist.isLiked ? Icons.favorite : Icons.favorite_border,
          color: artist.isLiked ? Colors.red : null,
        ),
        onPressed: onFollowPressed,
      ),
      onTap: onTap,
    );
  }
}