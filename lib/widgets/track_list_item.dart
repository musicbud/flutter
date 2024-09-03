import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_track.dart';

class TrackListItem extends StatelessWidget {
  final CommonTrack track;

  const TrackListItem({Key? key, required this.track}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(track.name),
      subtitle: Text(track.artists?.map((artist) => artist.name).join(', ') ?? 'Unknown Artist'),
      leading: track.images.isNotEmpty
          ? Image.network(
              track.images.isNotEmpty ? track.images.first.url : 'default_image_url',
              width: 50,
              height: 50,
            )
          : Icon(Icons.music_note),
    );
  }
}
