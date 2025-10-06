import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../components/recently_played_card.dart';

class RecentlyPlayedTab extends StatelessWidget {
  const RecentlyPlayedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recently Played',
          style: DesignSystem.headlineSmall.copyWith(
            color: DesignSystem.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: DesignSystem.spacingMD),

        // Recently Played List - Using static data for now as in original
        Column(
          children: [
            RecentlyPlayedCard(
              title: 'Electric Storm',
              artist: 'Luna Echo',
              timeAgo: '2 hours ago',
              imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
              accentColor: DesignSystem.primary,
            ),
            SizedBox(height: DesignSystem.spacingMD),
            RecentlyPlayedCard(
              title: 'Chill Vibes',
              artist: 'Coastal Vibes',
              timeAgo: '1 day ago',
              imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
              accentColor: DesignSystem.accentBlue,
            ),
            const SizedBox(height: 16),
            RecentlyPlayedCard(
              title: 'Urban Flow',
              artist: 'City Pulse',
              timeAgo: '3 days ago',
              imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
              accentColor: DesignSystem.accentPurple,
            ),
          ],
        ),
      ],
    );
  }
}