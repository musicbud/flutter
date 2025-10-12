import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
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
                borderRadius: BorderRadius.circular(DesignSystem.radiusCircular),
                color: accentColor.withOpacity(0.1),
              ),
              child: (imageUrl?.isNotEmpty ?? false)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(DesignSystem.radiusCircular),
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
            const SizedBox(height: DesignSystem.spacingSM),
            Text(
              name,
              style: DesignSystem.bodySmall.copyWith(
                color: DesignSystem.onSurface,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              genre,
              style: DesignSystem.caption.copyWith(
                color: DesignSystem.onSurfaceVariant,
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