import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../components/release_card.dart';
import '../discover_content_manager.dart';

class NewReleasesSection extends StatelessWidget {
  const NewReleasesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final releases = DiscoverContentManager.getNewReleases();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'New Releases',
            style: appTheme.typography.headlineH7.copyWith(
              color: appTheme.colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: appTheme.spacing.md),
          SizedBox(
            height: 280,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...releases.map((release) => Padding(
                  padding: EdgeInsets.only(right: appTheme.spacing.md),
                  child: ReleaseCard(
                    title: release['title'] as String,
                    artist: release['artist'] as String,
                    type: release['type'] as String,
                    imageUrl: release['imageUrl'] as String?,
                    icon: (release['icon'] as IconData?) ?? Icons.music_note,
                    accentColor: (release['accentColor'] as Color?) ?? Colors.blue,
                    onTap: () {
                      // Handle new release card tap
                    },
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}