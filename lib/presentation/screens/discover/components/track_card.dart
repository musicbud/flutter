import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../widgets/common/index.dart';

class TrackCard extends StatelessWidget {
  final String title;
  final String artist;
  final String genre;
  final String? imageUrl;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;

  const TrackCard({
    super.key,
    required this.title,
    required this.artist,
    required this.genre,
    this.imageUrl,
    required this.icon,
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
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
              color: accentColor.withValues(alpha: 0.1),
            ),
            child: (imageUrl?.isNotEmpty ?? false)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    icon,
                    color: accentColor,
                    size: 30,
                  ),
          ),
          const SizedBox(width: DesignSystem.spacingMD),
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
                  genre,
                  style: DesignSystem.caption.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(DesignSystem.spacingSM),
            decoration: BoxDecoration(
              color: DesignSystem.primary,
              borderRadius: BorderRadius.circular(DesignSystem.radiusCircular),
            ),
            child: Icon(
              Icons.play_arrow,
              color: DesignSystem.onPrimary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}