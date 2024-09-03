import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_track.dart';

class TrackListItem extends StatelessWidget {
  final CommonTrack track;
  final VoidCallback? onTap;

  const TrackListItem({Key? key, required this.track, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              track.images.isNotEmpty
                  ? Image.network(
                      track.images.first.url,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.music_note, size: 100),
                    )
                  : Icon(Icons.music_note, size: 100),
              SizedBox(height: 8),
              Expanded(
                child: Text(
                  track.name,
                  style: Theme.of(context).textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
