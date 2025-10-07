import 'package:flutter/material.dart';
import '../../../widgets/common/index.dart';
import '../../../../core/theme/design_system.dart';

class PlaylistCard extends StatelessWidget {
  final String title;
  final String trackCount;
  final String imageUrl;
  final Color accentColor;
  final VoidCallback? onTap;

  const PlaylistCard({
    super.key,
    required this.title,
    required this.trackCount,
    required this.imageUrl,
    required this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Playlist Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
              color: accentColor.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.playlist_play,
                    color: accentColor,
                    size: 48,
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Playlist Info
          Text(
            title,
            style: DesignSystem.titleSmall.copyWith(
              color: DesignSystem.onSurface,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: DesignSystem.spacingXS),
          Text(
            trackCount,
            style: DesignSystem.caption.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingMD),

          // Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(DesignSystem.spacingSM),
                decoration: BoxDecoration(
                  color: DesignSystem.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: DesignSystem.onPrimary,
                  size: 20,
                ),
              ),
              const Icon(
                Icons.more_vert,
                color: DesignSystem.onSurfaceVariant,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}