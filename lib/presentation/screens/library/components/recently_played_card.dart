import 'package:flutter/material.dart';
// MIGRATED: import '../../../widgets/common/index.dart';
import '../../widgets/enhanced/enhanced_widgets.dart';
import '../../../../core/theme/design_system.dart';

class RecentlyPlayedCard extends StatelessWidget {
  final String title;
  final String artist;
  final String timeAgo;
  final String imageUrl;
  final Color accentColor;
  final VoidCallback? onTap;

  const RecentlyPlayedCard({
    super.key,
    required this.title,
    required this.artist,
    required this.timeAgo,
    required this.imageUrl,
    required this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: onTap,
      child: Row(
        children: [
          // Song Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
              color: accentColor.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.music_note,
                    color: accentColor,
                    size: 30,
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: DesignSystem.spacingMD),

          // Song Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  artist,
                  style: DesignSystem.bodySmall.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  timeAgo,
                  style: DesignSystem.caption.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(DesignSystem.spacingSM),
                decoration: BoxDecoration(
                  color: DesignSystem.primary,
                  borderRadius: BorderRadius.circular(DesignSystem.radiusCircular),
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: DesignSystem.onPrimary,
                  size: 20,
                ),
              ),
              const SizedBox(width: DesignSystem.spacingSM),
              const Icon(
                Icons.history,
                color: DesignSystem.onSurfaceVariant,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}