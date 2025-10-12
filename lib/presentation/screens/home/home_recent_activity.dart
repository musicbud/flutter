import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/main/main_screen_bloc.dart';
import '../../../blocs/main/main_screen_event.dart';
import '../../../blocs/main/main_screen_state.dart';
import '../../../core/theme/design_system.dart';
import '../../../models/common_track.dart';
import '../../widgets/home/recent_activity_list.dart';
import '../../widgets/common/error_state_widget.dart';

class HomeRecentActivity extends StatelessWidget {
  const HomeRecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainScreenBloc, MainScreenState>(
      builder: (context, state) {
        // Show loading state for initial data load
        if (state is MainScreenLoading) {
          return _buildLoadingState();
        }

        // Show error state if there's an error
        if (state is MainScreenFailure) {
          return _buildErrorState(state.error, () {
            context.read<MainScreenBloc>().add(MainScreenRefreshRequested());
          });
        }

        // Show content when data is loaded
        if (state is MainScreenAuthenticated) {
          final recentActivity = state.recentActivity;
          if (recentActivity.isNotEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _RecentActivitySection(
                  title: 'Recently Played',
                  items: _convertToActivityItems(recentActivity.take(5).toList()),
                  onSeeAll: () {
                    Navigator.pushNamed(context, '/library', arguments: {'tab': 'recently_played'});
                  },
                ),
                const SizedBox(height: DesignSystem.spacingXL),
              ],
            );
          } else {
            return _buildEmptyState('No recent activity', 'Start playing music to see your recent tracks here');
          }
        }

        // Default empty state
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recently Played',
          style: DesignSystem.headlineSmall.copyWith(
            color: DesignSystem.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: DesignSystem.spacingMD),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 200,
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
        const SizedBox(height: DesignSystem.spacingXL),
      ],
    );
  }

  Widget _buildErrorState(String message, VoidCallback onRetry) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ErrorStateWidget(
          title: 'Failed to load recent activity',
          message: message,
          onRetry: onRetry,
        ),
        const SizedBox(height: DesignSystem.spacingXL),
      ],
    );
  }

  Widget _buildEmptyState(String title, String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EmptyStateWidget(
          title: title,
          message: message,
          icon: Icons.history_outlined,
        ),
        const SizedBox(height: DesignSystem.spacingXL),
      ],
    );
  }

  List<RecentActivityItem> _convertToActivityItems(List<dynamic> items) {
    return items.map((item) {
      String title = '';
      String subtitle = '';
      String imageUrl = '';
      String id = '';

      // Extract data based on item type
      if (item is Map<String, dynamic>) {
        title = item['name'] ?? item['title'] ?? 'Unknown';
        subtitle = item['artistName'] ?? item['artist'] ?? '';
        imageUrl = item['albumImageUrl'] ?? item['imageUrl'] ?? '';
        id = item['id']?.toString() ?? title;
      } else if (item is CommonTrack) {
        title = item.name;
        subtitle = item.artistName ?? '';
        imageUrl = item.imageUrl ?? '';
        id = item.id ?? item.uid ?? title;
      }

      return RecentActivityItem(
        id: id,
        title: title,
        subtitle: subtitle.isNotEmpty ? subtitle : null,
        imageUrl: imageUrl.isNotEmpty ? imageUrl : null,
        icon: imageUrl.isEmpty ? Icons.history : null,
        onTap: () {
          // Handle item tap - could navigate to detail screen
        },
      );
    }).toList();
  }
}

class _RecentActivitySection extends StatelessWidget {
  final String title;
  final List<RecentActivityItem> items;
  final VoidCallback onSeeAll;

  const _RecentActivitySection({
    required this.title,
    required this.items,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return RecentActivityList(
      title: title,
      items: items,
      onSeeAll: onSeeAll,
    );
  }
}