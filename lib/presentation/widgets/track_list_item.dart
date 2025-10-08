import 'package:flutter/material.dart';
import '../../../models/track.dart';

class TrackListItem extends StatelessWidget {
  final Track track;
  final VoidCallback? onTap;
  final VoidCallback? onPlayPressed;

  const TrackListItem({
    super.key,
    required this.track,
    this.onTap,
    this.onPlayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: track.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(track.imageUrl!, fit: BoxFit.cover),
              )
            : const Icon(Icons.music_note, color: Colors.grey),
      ),
      title: Text(track.name),
      subtitle: track.artist != null ? Text(track.artist!.name) : null,
      trailing: IconButton(
        icon: const Icon(Icons.play_arrow),
        onPressed: onPlayPressed,
      ),
      onTap: onTap,
    );
  }
}