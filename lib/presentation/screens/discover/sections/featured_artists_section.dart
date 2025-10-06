import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../models/artist.dart';
import '../../../widgets/common/section_header.dart';
import '../components/artist_card.dart';

class FeaturedArtistsSection extends StatelessWidget {
  final List<Artist> artists;
  final bool isLoading;
  final VoidCallback? onViewAllPressed;

  const FeaturedArtistsSection({
    super.key,
    required this.artists,
    this.isLoading = false,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    scrollDirection: Axis.horizontal,
                    children: artists.isEmpty
                        ? [const Center(child: Text('No artists available'))]
                        : artists.map((artist) => Padding(
                            padding: EdgeInsets.only(right: appTheme.spacing.md),
                            child: ArtistCard(
                              name: artist.name,
                              genre: artist.genres?.first ?? 'Unknown',
                              imageUrl: artist.imageUrls?.first,
                              accentColor: Colors.blue,
                              onTap: () {
                                // Navigate to artist detail
                                Navigator.pushNamed(
                                  context,
                                  '/artist/${artist.id}',
                                  arguments: artist,
                                );
                              },
                            ),
                          )).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}