import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_artist.dart';

class ArtistListItem extends StatelessWidget {
  final CommonArtist artist;
  final VoidCallback? onTap;

  const ArtistListItem({Key? key, required this.artist, this.onTap}) : super(key: key);

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
              artist.images.isNotEmpty
                  ? Image.network(
                      artist.images.first.url,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.person, size: 100),
                    )
                  : Icon(Icons.person, size: 100),
              SizedBox(height: 8),
              Expanded(
                child: Text(
                  artist.name,
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
