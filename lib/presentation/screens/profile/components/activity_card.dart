import 'package:flutter/material.dart';
// MIGRATED: import '../../../widgets/common/index.dart';
import '../../widgets/enhanced/enhanced_widgets.dart';
import '../../../../core/theme/design_system.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String description;
  final String timeAgo;
  final IconData icon;
  final Color iconColor;
  final VoidCallback? onTap;

  const ActivityCard({
    super.key,
    required this.title,
    required this.description,
    required this.timeAgo,
    required this.icon,
    required this.iconColor,
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
            padding: const EdgeInsets.all(DesignSystem.spacingSM),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
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
                ),
                const SizedBox(height: DesignSystem.spacingXS),
                Text(
                  description,
                  style: DesignSystem.bodySmall.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: DesignSystem.spacingXS),
                Text(
                  timeAgo,
                  style: DesignSystem.caption.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: DesignSystem.onSurfaceVariant,
            size: 20,
          ),
        ],
      ),
    );
  }
}