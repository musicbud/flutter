import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../widgets/common/index.dart';

class MusicCategoryCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const MusicCategoryCard({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(DesignSystem.spacingMD),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 32,
            ),
          ),
          const SizedBox(height: DesignSystem.spacingSM),
          Text(
            title,
            style: DesignSystem.titleSmall.copyWith(
              color: DesignSystem.onSurface,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: DesignSystem.spacingXS),
          Text(
            count,
            style: DesignSystem.caption.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}