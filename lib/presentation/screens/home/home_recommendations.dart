import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/user/user_state.dart';
import '../../../blocs/user/user_event.dart';
import '../../../core/theme/design_system.dart';
import '../../widgets/home/recommendations_list.dart';
import '../../widgets/common/error_state_widget.dart';
import '../../../widgets/common/empty_state.dart';

class HomeRecommendations extends StatelessWidget {
  const HomeRecommendations({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        // Show loading state for initial data load
        if (state is UserInitial || state is UserLoading) {
          return _buildLoadingState();
        }

        // Show error state if there's an error
        if (state is UserError) {
          return _buildErrorState(state.message, () {
            context.read<UserBloc>().add(LoadLikedItems());
            context.read<UserBloc>().add(LoadTopItems());
          });
        }

        // Build content sections
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state is LikedItemsLoaded && state.likedTracks.isNotEmpty) ...[
              _RecommendationsSection(
                title: 'Your Liked Songs',
                items: _convertToRecommendationItems(state.likedTracks.take(5).toList(), 'liked_songs'),
                onSeeAll: () {
                  Navigator.pushNamed(context, '/library', arguments: {'tab': 'liked_songs'});
                },
              ),
              const SizedBox(height: DesignSystem.spacingXL),
            ] else if (state is LikedItemsLoaded && state.likedTracks.isEmpty) ...[
              _buildEmptyState('No liked songs yet', 'Start liking songs to see them here'),
              const SizedBox(height: DesignSystem.spacingXL),
            ],

            if (state is TopItemsLoaded && state.topArtists.isNotEmpty) ...[
              _RecommendationsSection(
                title: 'Your Top Artists',
                items: _convertToRecommendationItems(state.topArtists.take(5).toList(), 'top_artists'),
                onSeeAll: () {
                  Navigator.pushNamed(context, '/library', arguments: {'tab': 'top_artists'});
                },
              ),
              const SizedBox(height: DesignSystem.spacingXL),
            ] else if (state is TopItemsLoaded && state.topArtists.isEmpty) ...[
              _buildEmptyState('No top artists yet', 'Listen to more music to discover your top artists'),
              const SizedBox(height: DesignSystem.spacingXL),
            ],
          ],
        );
      },
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLoadingSection('Your Liked Songs'),
        const SizedBox(height: DesignSystem.spacingXL),
        _buildLoadingSection('Your Top Artists'),
        const SizedBox(height: DesignSystem.spacingXL),
      ],
    );
  }

  Widget _buildLoadingSection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: DesignSystem.headlineSmall.copyWith(
            color: DesignSystem.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: DesignSystem.spacingMD),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 120,
                margin: const EdgeInsets.only(right: DesignSystem.spacingMD),
                decoration: BoxDecoration(
                  color: DesignSystem.surface.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
                ),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message, VoidCallback onRetry) {
    return ErrorStateWidget(
      title: 'Failed to load recommendations',
      message: message,
      onRetry: onRetry,
    );
  }

  Widget _buildEmptyState(String title, String message) {
    return EmptyState(
      title: title,
      message: message,
      icon: Icons.music_note_outlined,
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