import 'package:flutter/material.dart';
import '../base/base_card.dart';
import '../../../../core/theme/design_system.dart';


/// A reusable action card widget for interactive cards.
/// Commonly used for navigation items, settings options, quick actions, etc.
///
/// Features:
/// - Leading icon with customizable size and color
/// - Title and description text
/// - Optional trailing widget (arrow, button, etc.)
/// - Tap gesture support with visual feedback
/// - Consistent theming and spacing
/// - Optional background and border customization
class ActionCard extends BaseCard {
  /// The leading icon to display
  final IconData icon;

  /// The title text
  final String title;

  /// The description text (optional)
  final String? description;

  /// Optional trailing widget (e.g., arrow icon, button)
  final Widget? trailing;

  /// Size of the leading icon (defaults to 24)
  final double iconSize;

  /// Color of the leading icon
  final Color? iconColor;

  /// Text style for the title
  final TextStyle? titleStyle;

  /// Text style for the description
  final TextStyle? descriptionStyle;

  /// Whether to show a subtle border
  final bool showBorder;

  /// Whether to show a chevron/arrow at the end
  final bool showChevron;

  /// Color of the chevron icon
  final Color? chevronColor;

  const ActionCard({
    super.key,
    super.onTap,
    super.padding,
    super.backgroundColor,
    super.borderRadius,
    super.showElevation,
    super.elevation,
    required this.icon,
    required this.title,
    this.description,
    this.trailing,
    this.iconSize = 24,
    this.iconColor,
    this.titleStyle,
    this.descriptionStyle,
    this.showBorder = false,
    this.showChevron = true,
    this.chevronColor,
  });

  @override
  Widget buildCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: showBorder
            ? Border.all(
                color: DesignSystem.border,
                width: 1,
              )
            : null,
      ),
      child: Row(
        children: [
          // Leading Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (iconColor ?? DesignSystem.primary).withAlpha((255 * 0.1).round()),
              borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
            ),
            child: Icon(
              icon,
              size: iconSize,
              color: iconColor ?? DesignSystem.primary,
            ),
          ),

          const SizedBox(width: DesignSystem.spacingMD),

          // Content Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  title,
                  style: titleStyle ?? DesignSystem.titleMedium.copyWith(
                    color: DesignSystem.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Description
                if (description != null) ...[
                  const SizedBox(height: DesignSystem.spacingXXS),
                  Text(
                    description!,
                    style: descriptionStyle ?? DesignSystem.bodySmall.copyWith(
                      color: DesignSystem.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Trailing Section
          if (trailing != null) ...[
            const SizedBox(width: DesignSystem.spacingMD),
            trailing!,
          ] else if (showChevron) ...[
            const SizedBox(width: DesignSystem.spacingMD),
            Icon(
              Icons.chevron_right,
              size: 20,
              color: chevronColor ?? DesignSystem.onSurfaceVariant,
            ),
          ],
        ],
      ),
    );
  }
}