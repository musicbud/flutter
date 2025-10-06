import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../widgets/common/section_header.dart';
import '../components/track_card.dart';
import '../discover_content_manager.dart';

class TrendingTracksSection extends StatelessWidget {
  final VoidCallback? onViewAllPressed;

  const TrendingTracksSection({
    super.key,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final tracks = DiscoverContentManager.getTrendingTracks();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Trending Tracks',
            actionText: 'View All',
            onActionPressed: onViewAllPressed,
          ),
          SizedBox(height: appTheme.spacing.md),
          Column(
            children: tracks.map((track) => Padding(
              padding: EdgeInsets.only(bottom: appTheme.spacing.md),
              child: TrackCard(
                title: track['title'] as String,
                artist: track['artist'] as String,
                genre: track['genre'] as String,
                imageUrl: track['imageUrl'] as String?,
                icon: (track['icon'] as IconData?) ?? Icons.music_note,
                accentColor: (track['accentColor'] as Color?) ?? Colors.blue,
                onTap: () {
                  // Handle track card tap
                },
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}