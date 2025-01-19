import 'package:flutter/material.dart';
import 'package:musicbud_flutter/domain/models/common_genre.dart';

class GenreListItem extends StatelessWidget {
  final CommonGenre genre;
  final VoidCallback? onTap;

  const GenreListItem({Key? key, required this.genre, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
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
                  child: _buildPlaceholder(),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              flex: 1,
              child: Text(
                genre.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
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
}
