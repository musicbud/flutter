import 'package:flutter/material.dart';
import '../../widgets/search_filter_chip.dart';

class SearchFilters extends StatelessWidget {
  final List<String> selectedTypes;
  final ValueChanged<String> onFilterToggled;

  const SearchFilters({
    super.key,
    required this.selectedTypes,
    required this.onFilterToggled,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          SearchFilterChip(
            label: 'Users',
            icon: Icons.person,
            selected: selectedTypes.contains('user'),
            onSelected: (_) => onFilterToggled('user'),
          ),
          const SizedBox(width: 8),
          SearchFilterChip(
            label: 'Music',
            icon: Icons.music_note,
            selected: selectedTypes.contains('music'),
            onSelected: (_) => onFilterToggled('music'),
          ),
          const SizedBox(width: 8),
          SearchFilterChip(
            label: 'Playlists',
            icon: Icons.queue_music,
            selected: selectedTypes.contains('playlist'),
            onSelected: (_) => onFilterToggled('playlist'),
          ),
          const SizedBox(width: 8),
          SearchFilterChip(
            label: 'Events',
            icon: Icons.event,
            selected: selectedTypes.contains('event'),
            onSelected: (_) => onFilterToggled('event'),
          ),
          const SizedBox(width: 8),
          SearchFilterChip(
            label: 'Channels',
            icon: Icons.forum,
            selected: selectedTypes.contains('channel'),
            onSelected: (_) => onFilterToggled('channel'),
          ),
        ],
      ),
    );
  }
}