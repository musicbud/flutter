import 'package:flutter/material.dart';
import '../../widgets/common/section_header.dart';
import 'components/music_category_card.dart';
import '../../../core/theme/app_theme.dart';

class ProfileMusicWidget extends StatelessWidget {
  const ProfileMusicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'My Music',
          ),
          SizedBox(height: appTheme.spacing.md),

          // Music Categories
          Row(
            children: [
              Expanded(
                child: MusicCategoryCard(
                  title: 'Playlists',
                  count: '12',
                  icon: Icons.playlist_play,
                  iconColor: appTheme.colors.accentBlue,
                ),
              ),
              SizedBox(width: appTheme.spacing.md),
              Expanded(
                child: MusicCategoryCard(
                  title: 'Liked Songs',
                  count: '89',
                  icon: Icons.favorite,
                  iconColor: appTheme.colors.primaryRed,
                ),
              ),
              SizedBox(width: appTheme.spacing.md),
              Expanded(
                child: MusicCategoryCard(
                  title: 'Downloads',
                  count: '23',
                  icon: Icons.download,
                  iconColor: appTheme.colors.accentGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}