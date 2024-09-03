import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_track.dart';

class TrackListItem extends StatelessWidget {
  final CommonTrack track;
  final VoidCallback? onTap;

  const TrackListItem({Key? key, required this.track, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 180,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildImage(),
                ),
              ),
            ),
            SizedBox(height: 4),
            Flexible(
              flex: 1,
              child: Text(
                track.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 12),
              ),
            ),
            Flexible(
              flex: 1,
              child: Text(
                _getArtistName(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = track.images.isNotEmpty ? track.images[0].url : null;
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildPlaceholder();
    }
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('Error loading image: $error');
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        Icons.music_note,
        color: Colors.grey[600],
        size: 40,
      ),
    );
  }

  String _getArtistName() {
    // Implement this method based on the structure of your CommonTrack
    // For example:
    // return track.artists.isNotEmpty ? track.artists[0].name : 'Unknown Artist';
    return 'Unknown Artist'; // Replace this with the correct implementation
  }
}
