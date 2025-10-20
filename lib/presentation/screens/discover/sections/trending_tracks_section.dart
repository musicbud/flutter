import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../models/track.dart';
// MIGRATED: import '../../../widgets/common/section_header.dart';
import '../components/track_card.dart';
import '../../widgets/enhanced/enhanced_widgets.dart';

class TrendingTracksSection extends StatelessWidget {
  final List<Track> tracks;
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback? onViewAllPressed;
  final VoidCallback? onRetry;

  const TrendingTracksSection({
    super.key,
    required this.tracks,
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
            title: 'Trending Tracks',
            actionText: 'View All',
            onActionPressed: onViewAllPressed,
          ),
          const SizedBox(height: DesignSystem.spacingMD),
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : hasError
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            errorMessage ?? 'Failed to load trending tracks',
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
                  : tracks.isEmpty
                      ? const Center(child: Text('No tracks available'))
                      : Column(
                        children: tracks.map((track) => Padding(
                          padding: const EdgeInsets.only(bottom: DesignSystem.spacingMD),
                          child: TrackCard(
                              title: track.name,
                              artist: track.artistName ?? 'Unknown Artist',
                              genre: null, // Track doesn't have genre field
                              imageUrl: track.imageUrl,
                              icon: Icons.music_note,
                              accentColor: Colors.blue,
                              onTap: () {
                                // Navigate to track detail or play track
                                Navigator.pushNamed(
                                  context,
                                  '/track/${track.id}',
                                  arguments: track,
                                );
                              },
                            ),
                          )).toList(),
                        ),
        ],
      ),
    );
  }
}