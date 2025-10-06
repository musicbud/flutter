import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../widgets/common/index.dart';

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
    final appTheme = AppTheme.of(context);

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
                borderRadius: BorderRadius.circular(appTheme.radius.lg),
                color: accentColor.withValues(alpha: 0.1),
              ),
              child: (imageUrl?.isNotEmpty ?? false)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(appTheme.radius.lg),
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
            SizedBox(height: appTheme.spacing.md),
            Text(
              title,
              style: appTheme.typography.titleMedium.copyWith(
                color: appTheme.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: appTheme.spacing.xs),
            Text(
              artist,
              style: appTheme.typography.bodySmall.copyWith(
                color: appTheme.colors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              type,
              style: appTheme.typography.caption.copyWith(
                color: appTheme.colors.textMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: appTheme.spacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(appTheme.spacing.sm),
                  decoration: BoxDecoration(
                    color: appTheme.colors.primaryRed,
                    borderRadius: BorderRadius.circular(appTheme.radius.circular),
                  ),
                  child: Icon(
                    Icons.play_arrow,
                    color: appTheme.colors.white,
                    size: 20,
                  ),
                ),
                Icon(
                  Icons.favorite_border,
                  color: appTheme.colors.textMuted,
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