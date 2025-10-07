import 'package:flutter/material.dart';
import '../../widgets/common/section_header.dart';
import 'components/music_category_card.dart';
import '../../../core/theme/design_system.dart';

class ProfileMusicWidget extends StatelessWidget {
  const ProfileMusicWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'My Music',
          ),
          SizedBox(height: DesignSystem.spacingMD),

          // Music Categories
          Row(
            children: [
              Expanded(
                child: MusicCategoryCard(
                  title: 'Playlists',
                  count: '12',
                  icon: Icons.playlist_play,
                  iconColor: DesignSystem.accentBlue,
                ),
              ),
              SizedBox(width: DesignSystem.spacingMD),
              Expanded(
                child: MusicCategoryCard(
                  title: 'Liked Songs',
                  count: '89',
                  icon: Icons.favorite,
                  iconColor: DesignSystem.primary,
                ),
              ),
              SizedBox(width: DesignSystem.spacingMD),
              Expanded(
                child: MusicCategoryCard(
                  title: 'Downloads',
                  count: '23',
                  icon: Icons.download,
                  iconColor: DesignSystem.accentGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}