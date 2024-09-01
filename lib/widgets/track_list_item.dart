import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_track.dart';

class TrackListItem extends StatelessWidget {
  final CommonTrack track;

  const TrackListItem({Key? key, required this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(track.name ?? 'Unknown Track'),
      subtitle: Text(track.artists?.map((artist) => artist.name).join(', ') ?? 'Unknown Artist'),
      leading: track.albumImageUrl != null
          ? Image.network(track.albumImageUrl!, width: 50, height: 50)
          : Icon(Icons.music_note),
    );
  }
}
