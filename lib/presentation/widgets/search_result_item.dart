import 'package:flutter/material.dart';
import '../../../domain/models/search.dart';

class SearchResultItem extends StatelessWidget {
  final SearchItem item;
  final VoidCallback? onTap;

  const SearchResultItem({
    Key? key,
    required this.item,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: _buildLeading(),
      title: Text(item.title),
      subtitle: item.subtitle != null ? Text(item.subtitle!) : null,
      trailing: _buildTrailing(context),
    );
  }

  Widget _buildLeading() {
    if (item.imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.network(
          item.imageUrl!,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
        ),
      );
    }
    return _buildFallbackIcon();
  }

  Widget _buildFallbackIcon() {
    IconData icon;
    switch (item.type) {
      case 'user':
        icon = Icons.person;
        break;
      case 'music':
        icon = Icons.music_note;
        break;
      case 'playlist':
        icon = Icons.queue_music;
        break;
      case 'event':
        icon = Icons.event;
        break;
      case 'channel':
        icon = Icons.forum;
        break;
      default:
        icon = Icons.search;
    }
    return CircleAvatar(child: Icon(icon));
  }

  Widget _buildTrailing(BuildContext context) {
    return Text(
      item.type.toUpperCase(),
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
    );
  }
}
