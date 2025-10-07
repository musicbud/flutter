import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../components/download_card.dart';

class DownloadsTab extends StatelessWidget {
  const DownloadsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Downloaded Music',
          style: DesignSystem.headlineSmall.copyWith(
            color: DesignSystem.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: DesignSystem.spacingMD),

        // Downloads Grid - Using static data for now as in original
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: DesignSystem.spacingMD,
            mainAxisSpacing: DesignSystem.spacingMD,
            childAspectRatio: 0.8,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return DownloadCard(
              title: 'Album ${index + 1}',
              artist: 'Artist ${index + 1}',
              trackCount: '${(index + 1) * 8} tracks',
              imageUrl: 'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop',
              accentColor: DesignSystem.accentOrange,
            );
          },
        ),
      ],
    );
  }
}