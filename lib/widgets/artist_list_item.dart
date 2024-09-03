import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_artist.dart';

class ArtistListItem extends StatelessWidget {
  final CommonArtist artist;
  final VoidCallback? onTap;

  const ArtistListItem({Key? key, required this.artist, this.onTap}) : super(key: key);

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
                artist.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText2?.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    final imageUrl = artist.images.isNotEmpty ? artist.images[0].url : null;
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildPlaceholder();
    }
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        Icons.person,
        color: Colors.grey[600],
        size: 40,
      ),
    );
  }
}
