import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../widgets/common/section_header.dart';
import '../components/artist_card.dart';
import '../discover_content_manager.dart';

class FeaturedArtistsSection extends StatelessWidget {
  final VoidCallback? onViewAllPressed;

  const FeaturedArtistsSection({
    super.key,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);
    final artists = DiscoverContentManager.getFeaturedArtists();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Featured Artists',
            actionText: 'View All',
            onActionPressed: onViewAllPressed,
          ),
          SizedBox(height: appTheme.spacing.md),
          SizedBox(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ...artists.map((artist) => Padding(
                  padding: EdgeInsets.only(right: appTheme.spacing.md),
                  child: ArtistCard(
                    name: artist['name'] as String,
                    genre: artist['genre'] as String,
                    imageUrl: artist['imageUrl'] as String?,
                    accentColor: (artist['accentColor'] as Color?) ?? Colors.blue,
                    onTap: () {
                      // Handle artist card tap
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