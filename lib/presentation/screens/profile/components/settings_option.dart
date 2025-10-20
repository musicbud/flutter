import 'package:flutter/material.dart';
import '../../../../models/settings_option.dart';
// MIGRATED: import '../../../widgets/common/index.dart';
import '../../widgets/enhanced/enhanced_widgets.dart';
import '../../../../core/theme/design_system.dart';

class SettingsOption extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onTap;

  const SettingsOption({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return ModernCard(
      variant: ModernCardVariant.secondary,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(DesignSystem.spacingSM),
            decoration: BoxDecoration(
              color: DesignSystem.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
            ),
            child: Icon(
              icon,
              color: DesignSystem.onSurfaceVariant,
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
                  subtitle,
                  style: DesignSystem.bodySmall.copyWith(
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