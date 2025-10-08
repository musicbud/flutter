import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../models/track.dart';
import '../../../widgets/common/section_header.dart';
import '../components/track_card.dart';

class TrendingTracksSection extends StatelessWidget {
  final List<Track> tracks;
  final bool isLoading;
  final VoidCallback? onViewAllPressed;

  const TrendingTracksSection({
    super.key,
    required this.tracks,
    this.isLoading = false,
    this.onViewAllPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
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
              : tracks.isEmpty
                  ? const Center(child: Text('No tracks available'))
                  : Column(
                    children: tracks.map((track) => Padding(
                      padding: EdgeInsets.only(bottom: DesignSystem.spacingMD),
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