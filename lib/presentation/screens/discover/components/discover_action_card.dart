import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../widgets/common/index.dart';

class DiscoverActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final VoidCallback? onTap;

  const DiscoverActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      variant: ModernCardVariant.accent,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(DesignSystem.spacingLG),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 32,
            ),
          ),
        const SizedBox(height: DesignSystem.spacingMD),
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
            subtitle,
            style: DesignSystem.caption.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}