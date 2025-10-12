import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/design_system.dart';
import '../components/discover_action_card.dart';
import '../discover_content_manager.dart';

class DiscoverMoreSection extends StatelessWidget {
  const DiscoverMoreSection({super.key});

  @override
  Widget build(BuildContext context) {
    final manager = context.read<DiscoverContentManager>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover More',
            style: DesignSystem.headlineSmall.copyWith(
              color: DesignSystem.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingMD),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: manager.getDiscoverActions(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                // Fallback to default actions on error
                final fallbackActions = [
                  {
                    'title': 'Create Playlist',
                    'subtitle': 'Build your perfect mix',
                    'icon': Icons.playlist_add,
                    'accentColor': Colors.green,
                  },
                  {
                    'title': 'Follow Artists',
                    'subtitle': 'Stay updated with favorites',
                    'icon': Icons.person_add,
                    'accentColor': Colors.orange,
                  },
                ];

                return Row(
                  children: [
                    ...fallbackActions.map((action) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: fallbackActions.last == action ? 0 : DesignSystem.spacingMD,
                        ),
                        child: DiscoverActionCard(
                          title: action['title'] as String,
                          subtitle: action['subtitle'] as String,
                          icon: action['icon'] as IconData,
                          accentColor: action['accentColor'] as Color,
                          onTap: () {
                            // Handle discover action card tap
                          },
                        ),
                      ),
                    )),
                  ],
                );
              }

              final actions = snapshot.data ?? [];
              if (actions.isEmpty) {
                return const Center(child: Text('No actions available'));
              }

              return Row(
                children: [
                  ...actions.map((action) => Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: actions.last == action ? 0 : DesignSystem.spacingMD,
                      ),
                      child: DiscoverActionCard(
                        title: action['title'] as String,
                        subtitle: action['subtitle'] as String,
                        icon: _parseIcon(action['icon']),
                        accentColor: _parseColor(action['accentColor']),
                        onTap: () {
                          // Handle discover action card tap
                        },
                      ),
                    ),
                  )),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  IconData _parseIcon(dynamic iconData) {
    if (iconData is IconData) return iconData;
    if (iconData is String) {
      switch (iconData) {
        case 'playlist_add':
          return Icons.playlist_add;
        case 'person_add':
          return Icons.person_add;
        case 'music_note':
          return Icons.music_note;
        default:
          return Icons.star;
      }
    }
    return Icons.star;
  }

  Color _parseColor(dynamic colorData) {
    if (colorData is Color) return colorData;
    if (colorData is int) return Color(colorData);
    return Colors.blue;
  }
}