import 'package:flutter/material.dart';
import '../../widgets/common/section_header.dart';
import 'components/activity_card.dart';
import '../../../core/theme/app_theme.dart';

class ProfileActivityWidget extends StatelessWidget {
  const ProfileActivityWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Recent Activity',
          ),
          SizedBox(height: appTheme.spacing.md),

          // Activity Cards
          const ActivityCard(
            title: 'New Track Added',
            description: 'Added "Midnight Dreams" to your library',
            timeAgo: '2 hours ago',
            icon: Icons.music_note,
            iconColor: Colors.red,
          ),
          SizedBox(height: appTheme.spacing.md),
          const ActivityCard(
            title: 'Playlist Created',
            description: 'Created "Chill Vibes" playlist',
            timeAgo: '1 day ago',
            icon: Icons.playlist_add,
            iconColor: Colors.blue,
          ),
          SizedBox(height: appTheme.spacing.md),
          const ActivityCard(
            title: 'Bud Connected',
            description: 'Sarah Johnson started following you',
            timeAgo: '3 days ago',
            icon: Icons.person_add,
            iconColor: Colors.green,
          ),
        ],
      ),
    );
  }
}