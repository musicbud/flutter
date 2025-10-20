import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
// MIGRATED: import '../../../widgets/common/index.dart';
import '../../widgets/enhanced/enhanced_widgets.dart';

class ReleaseCard extends StatelessWidget {
  final String title;
  final String artist;
  final String type;
  final String? imageUrl;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;

  const ReleaseCard({
    super.key,
    required this.title,
    required this.artist,
    required this.type,
    this.imageUrl,
    required this.icon,
    required this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ModernCard(
        variant: ModernCardVariant.primary,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
                color: accentColor.withValues(alpha: 0.1),
              ),
              child: (imageUrl?.isNotEmpty ?? false)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
                      child: Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      icon,
                      color: accentColor,
                      size: 48,
                    ),
            ),
            const SizedBox(height: DesignSystem.spacingMD),
            Text(
              title,
              style: DesignSystem.titleMedium.copyWith(
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
              type,
              style: DesignSystem.caption.copyWith(
                color: DesignSystem.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: DesignSystem.spacingMD),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                const Icon(
                  Icons.favorite_border,
                  color: DesignSystem.onSurfaceVariant,
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}