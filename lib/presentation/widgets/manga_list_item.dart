import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_manga.dart';

class MangaListItem extends StatelessWidget {
  final CommonManga manga;
  final VoidCallback? onTap;

  const MangaListItem({
    Key? key,
    required this.manga,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            if (manga.imageUrl.isNotEmpty)
              Image.network(
                manga.imageUrl,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                manga.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
