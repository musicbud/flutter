import 'package:flutter/material.dart';
import '../../../widgets/common/index.dart';
import '../../../../core/theme/design_system.dart';

class SongCard extends StatelessWidget {
   final String title;
   final String artist;
   final String genre;
   final String? imageUrl;
   final Color accentColor;
   final VoidCallback? onTap;

  const SongCard({
    super.key,
    required this.title,
    required this.artist,
    required this.genre,
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
              color: accentColor.withOpacity(0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.music_note,
                          color: accentColor,
                          size: 30,
                        );
                      },
                    )
                  : Icon(
                      Icons.music_note,
                      color: accentColor,
                      size: 30,
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
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: DesignSystem.spacingSM,
                    vertical: DesignSystem.spacingXS,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
                  ),
                  child: Text(
                    genre,
                    style: DesignSystem.caption.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w500,
                    ),
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
                Icons.favorite,
                color: DesignSystem.primary,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}