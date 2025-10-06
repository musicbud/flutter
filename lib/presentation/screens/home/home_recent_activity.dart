import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/user_profile/user_profile_bloc.dart';
import '../../../core/theme/design_system.dart';
import '../../widgets/home/recent_activity_list.dart';

class HomeRecentActivity extends StatelessWidget {
  const HomeRecentActivity({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<UserProfileBloc, UserProfileState>(
      builder: (context, state) {
        if (state is MyContentLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (state.contentType == 'played_tracks' && state.content.isNotEmpty) ...[
                _RecentActivitySection(
                  title: 'Recently Played',
                  items: _convertToActivityItems(state.content.take(5).toList()),
                  onSeeAll: () {
                    Navigator.pushNamed(context, '/library', arguments: {'tab': 'recently_played'});
                  },
                ),
                SizedBox(height: DesignSystem.spacingXL),
              ],
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  List<RecentActivityItem> _convertToActivityItems(List<dynamic> items) {
    return items.map((item) {
      String title = '';
      String subtitle = '';
      String imageUrl = '';

      // Extract data based on item type
      if (item is Map<String, dynamic>) {
        title = item['name'] ?? item['title'] ?? 'Unknown';
        subtitle = item['artistName'] ?? item['artist'] ?? '';
        imageUrl = item['albumImageUrl'] ?? item['imageUrl'] ?? '';
      }

      return RecentActivityItem(
        id: item['id']?.toString() ?? title,
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