import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../widgets/common/index.dart';

class ArtistCard extends StatelessWidget {
  final String name;
  final String genre;
  final String? imageUrl;
  final Color accentColor;
  final VoidCallback? onTap;

  const ArtistCard({
    super.key,
    required this.name,
    required this.genre,
    this.imageUrl,
    required this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return SizedBox(
      width: 100,
      child: ModernCard(
        variant: ModernCardVariant.primary,
        onTap: onTap,
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(appTheme.radius.circular),
                color: accentColor.withValues(alpha: 0.1),
              ),
              child: (imageUrl?.isNotEmpty ?? false)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(appTheme.radius.circular),
                      child: Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      color: accentColor,
                      size: 40,
                    ),
            ),
            SizedBox(height: appTheme.spacing.sm),
            Text(
              name,
              style: appTheme.typography.bodySmall.copyWith(
                color: appTheme.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              genre,
              style: appTheme.typography.caption.copyWith(
                color: appTheme.colors.textMuted,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}