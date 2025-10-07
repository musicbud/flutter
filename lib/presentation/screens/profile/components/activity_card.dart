import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../widgets/common/index.dart';

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
            padding: EdgeInsets.all(DesignSystem.spacingSM),
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
          SizedBox(width: DesignSystem.spacingMD),
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
                SizedBox(height: DesignSystem.spacingXS),
                Text(
                  description,
                  style: DesignSystem.bodySmall.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: DesignSystem.spacingXS),
                Text(
                  timeAgo,
                  style: DesignSystem.caption.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: DesignSystem.onSurfaceVariant,
            size: 20,
          ),
        ],
      ),
    );
  }
}