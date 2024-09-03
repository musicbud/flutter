import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/common_manga.dart';

class MangaListItem extends StatelessWidget {
  final CommonManga manga;
  final VoidCallback? onTap;

  const MangaListItem({Key? key, required this.manga, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(manga.title),
      subtitle: Text(manga.status),
      leading: manga.imageUrl.isNotEmpty
          ? Image.network(manga.imageUrl, width: 50, height: 50)
          : Icon(Icons.book),
      onTap: onTap,
    );
  }
}
