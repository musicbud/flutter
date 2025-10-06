import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

/// Base widget for section headers with consistent styling
class BaseSectionHeader extends StatelessWidget {
  const BaseSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    this.leading,
    this.trailing,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    this.titleStyle,
    this.subtitleStyle,
    this.actionStyle,
    this.showDivider = false,
    this.dividerColor,
    this.dividerThickness = 1.0,
    this.onTap,
    // New parameters for SectionHeader compatibility
    this.actionText,
    this.onActionPressed,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  /// The main title text
  final String title;

  /// Optional subtitle text
  final String? subtitle;

  /// Optional action widget (e.g., button)
  final Widget? action;

  /// Optional leading widget
  final Widget? leading;

  /// Optional trailing widget
  final Widget? trailing;

  /// Padding around the header
  final EdgeInsets padding;

  /// Custom title text style
  final TextStyle? titleStyle;

  /// Custom subtitle text style
  final TextStyle? subtitleStyle;

  /// Custom action text style
  final TextStyle? actionStyle;

  /// Whether to show a divider below the header
  final bool showDivider;

  /// Color of the divider
  final Color? dividerColor;

  /// Thickness of the divider
  final double dividerThickness;

  /// Callback when the header is tapped
  final VoidCallback? onTap;

  /// Text for action button (alternative to action widget)
  final String? actionText;

  /// Callback when action button is pressed
  final VoidCallback? onActionPressed;

  /// Main axis alignment for the row
  final MainAxisAlignment mainAxisAlignment;

  /// Cross axis alignment for the row
  final CrossAxisAlignment crossAxisAlignment;

  @override
  Widget build(BuildContext context) {
    final effectiveTitleStyle = titleStyle ??
        DesignSystem.headlineSmall.copyWith(
          color: DesignSystem.onSurface,
          fontWeight: FontWeight.w600,
        );

    final effectiveSubtitleStyle = subtitleStyle ??
        DesignSystem.bodySmall.copyWith(
          color: DesignSystem.onSurfaceVariant,
        );

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: mainAxisAlignment,
              crossAxisAlignment: crossAxisAlignment,
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: effectiveTitleStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: effectiveSubtitleStyle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 12),
                  trailing!,
                ],
                if (action != null) ...[
                  const SizedBox(width: 8),
                  action!,
                ] else if (actionText != null && onActionPressed != null) ...[
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: onActionPressed,
                    child: Text(
                      actionText!,
                      style: effectiveTitleStyle?.copyWith(
                        color: DesignSystem.primary,
                        fontWeight: FontWeight.w600,
                      ) ?? TextStyle(
                        color: DesignSystem.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (showDivider) ...[
              const SizedBox(height: 12),
              Divider(
                color: dividerColor ?? DesignSystem.border,
                thickness: dividerThickness,
                height: 1,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Convenience constructors for common use cases
class SectionHeader extends BaseSectionHeader {
  const SectionHeader({
    super.key,
    required super.title,
    super.subtitle,
    super.onTap,
  }) : super(
          showDivider: true,
        );

  const SectionHeader.simple({
    super.key,
    required super.title,
    super.onTap,
  }) : super();

  const SectionHeader.withAction({
    super.key,
    required super.title,
    required Widget action,
    super.subtitle,
    super.onTap,
  }) : super(
          action: action,
        );

  const SectionHeader.withLeading({
    super.key,
    required super.title,
    required Widget leading,
    super.subtitle,
    super.onTap,
  }) : super(
          leading: leading,
        );
}

/// Extension for easy creation of section headers
extension SectionHeaderExtension on String {
  Widget toSectionHeader({
    String? subtitle,
    Widget? action,
    Widget? leading,
    Widget? trailing,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    bool showDivider = false,
    Color? dividerColor,
    double dividerThickness = 1.0,
    VoidCallback? onTap,
  }) {
    return BaseSectionHeader(
      title: this,
      subtitle: subtitle,
      action: action,
      leading: leading,
      trailing: trailing,
      padding: padding,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
      showDivider: showDivider,
      dividerColor: dividerColor,
      dividerThickness: dividerThickness,
      onTap: onTap,
    );
  }
}