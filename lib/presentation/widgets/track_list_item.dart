import 'package:flutter/material.dart';
import 'package:musicbud_flutter/domain/models/common_track.dart';

class TrackListItem extends StatelessWidget {
  final CommonTrack track;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const TrackListItem({
    Key? key,
    required this.track,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: track.imageUrl != null
          ? CircleAvatar(
              backgroundImage: NetworkImage(track.imageUrl!),
              radius: 25,
            )
          : const CircleAvatar(
              child: Icon(Icons.music_note),
              radius: 25,
            ),
      title: Text(
        track.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        track.artistName ?? 'Unknown Artist',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: track.isLiked
          ? const Icon(Icons.favorite, color: Colors.red)
          : const Icon(Icons.favorite_border),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
