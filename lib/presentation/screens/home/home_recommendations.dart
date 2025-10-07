import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/user_profile/user_profile_bloc.dart';
import '../../../core/theme/design_system.dart';
import '../../widgets/home/recommendations_list.dart';

class HomeRecommendations extends StatelessWidget {
  const HomeRecommendations({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        if (state is MyContentLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.contentType == 'tracks' && state.content.isNotEmpty) ...[
                _RecommendationsSection(
                  title: 'Your Liked Songs',
                  items: _convertToRecommendationItems(state.content.take(5).toList(), 'liked_songs'),
                  onSeeAll: () {
                    Navigator.pushNamed(context, '/library', arguments: {'tab': 'liked_songs'});
                  },
                ),
                const SizedBox(height: DesignSystem.spacingXL),
              ],
              if (state.contentType == 'artists' && state.content.isNotEmpty) ...[
                _RecommendationsSection(
                  title: 'Your Top Artists',
                  items: _convertToRecommendationItems(state.content.take(5).toList(), 'top_artists'),
                  onSeeAll: () {
                    Navigator.pushNamed(context, '/library', arguments: {'tab': 'top_artists'});
                  },
                ),
                const SizedBox(height: DesignSystem.spacingXL),
              ],
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  List<RecommendationItem> _convertToRecommendationItems(List<dynamic> items, String sectionType) {
    return items.map((item) {
      String title = '';
      String subtitle = '';
      String imageUrl = '';
      IconData icon = Icons.music_note;

      // Extract data based on item type
      if (item is Map<String, dynamic>) {
        title = item['name'] ?? item['title'] ?? 'Unknown';
        subtitle = item['artistName'] ?? item['artist'] ?? '';
        imageUrl = item['albumImageUrl'] ?? item['imageUrl'] ?? '';
      }

      // Set appropriate icon based on section type
      switch (sectionType) {
        case 'liked_songs':
          icon = Icons.music_note;
          break;
        case 'top_artists':
          icon = Icons.person;
          break;
        default:
          icon = Icons.music_note;
      }

      return RecommendationItem(
        id: item['id']?.toString() ?? title,
        title: title,
        subtitle: subtitle.isNotEmpty ? subtitle : null,
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
        icon: imageUrl.isEmpty ? icon : null,
        onTap: () {
          // Handle item tap - could navigate to detail screen
        },
      );
    }).toList();
  }
}

class _RecommendationsSection extends StatelessWidget {
  final String title;
  final List<RecommendationItem> items;
  final VoidCallback onSeeAll;

  const _RecommendationsSection({
    required this.title,
    required this.items,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return RecommendationsList(
      title: title,
      items: items,
      onSeeAll: onSeeAll,
    );
  }
}