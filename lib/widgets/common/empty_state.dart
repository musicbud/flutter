import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
import '../base/base_state_display.dart';

/// A reusable empty state widget that supports theming
class EmptyState extends BaseStateDisplay {
  const EmptyState({
    super.key,
    super.title,
    super.message,
    super.icon,
    super.actionText,
    super.actionCallback,
    super.iconSize,
    super.padding,
    super.backgroundColor,
    super.centerContent,
  });

  @override
  Widget _buildIcon(BuildContext context) {
    if (icon == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(DesignSystem.radiusXL),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: DesignSystem.onSurfaceVariant,
      ),
    );
  }
}