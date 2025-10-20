import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../models/artist.dart';
// MIGRATED: import '../../../widgets/common/section_header.dart';
import '../components/artist_card.dart';
import '../../widgets/enhanced/enhanced_widgets.dart';

class FeaturedArtistsSection extends StatelessWidget {
  final List<Artist> artists;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback? onViewAllPressed;
  final VoidCallback? onRetry;

  const FeaturedArtistsSection({
    super.key,
    required this.artists,
    this.isLoading = false,
    this.hasError = false,
    this.errorMessage,
    this.onViewAllPressed,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Featured Artists',
            actionText: 'View All',
            onActionPressed: onViewAllPressed,
          ),
          const SizedBox(height: DesignSystem.spacingMD),
          SizedBox(
            height: 120,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : hasError
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              errorMessage ?? 'Failed to load featured artists',
                              style: DesignSystem.bodyMedium.copyWith(
                                color: DesignSystem.error,
                              ),
                            ),
                            const SizedBox(height: DesignSystem.spacingMD),
                            ElevatedButton(
                              onPressed: onRetry,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        children: artists.isEmpty
                            ? [const Center(child: Text('No artists available'))]
                            : artists.map((artist) => Padding(
                                padding: const EdgeInsets.only(right: DesignSystem.spacingMD),
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