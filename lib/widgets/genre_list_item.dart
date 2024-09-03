import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_genre.dart';

class GenreListItem extends StatelessWidget {
  final CommonGenre genre;
  final VoidCallback? onTap;

  const GenreListItem({Key? key, required this.genre, this.onTap}) : super(key: key);

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
              Image.network(
                genre.defaultImageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.music_note, size: 100),
              ),
              SizedBox(height: 8),
              Expanded(
                child: Text(
                  genre.name,
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
