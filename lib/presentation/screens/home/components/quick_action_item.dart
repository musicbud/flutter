import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Individual quick action item data class
class QuickActionData {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const QuickActionData({
    required this.title,
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });
}

/// A reusable quick action item widget
class QuickActionItem extends StatelessWidget {
  final QuickActionData action;

  const QuickActionItem({
    super.key,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onPressed,
        borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingLG,
            vertical: DesignSystem.spacingMD,
          ),
          decoration: BoxDecoration(
            gradient: action.isPrimary
                ? DesignSystem.gradientPrimary
                : DesignSystem.gradientSecondary,
            borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
            boxShadow: DesignSystem.shadowCard,
            border: Border.all(
              color: action.isPrimary
                  ? DesignSystem.primary.withOpacity(0.3)
                  : DesignSystem.border.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                action.icon,
                color: DesignSystem.onPrimary,
                size: 24,
              ),
              const SizedBox(width: DesignSystem.spacingXS),
              Text(
                action.title,
                style: DesignSystem.bodyLarge.copyWith(
                  color: DesignSystem.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A grid of quick action items
class QuickActionGrid extends StatelessWidget {
  final List<QuickActionData> actions;
  final int crossAxisCount;
  final double spacing;

  const QuickActionGrid({
    super.key,
    required this.actions,
    this.crossAxisCount = 2,
    this.spacing = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: 2.5,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        return QuickActionItem(action: actions[index]);
      },
    );
  }
}