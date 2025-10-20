import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A consistent section header with title and optional action button
///
/// Used throughout the app for section titles with optional "See All" actions.
///
/// Example:
/// ```dart
/// SectionHeader(
///   title: 'Recently Played',
///   onActionTap: () => navigateToAll(),
/// )
/// ```
class SectionHeader extends StatelessWidget {
  /// Section title
  final String title;

  /// Optional subtitle/description
  final String? subtitle;

  /// Action button label (default: "See All")
  final String? actionLabel;

  /// Action button callback
  final VoidCallback? onActionTap;

  /// Custom action widget (overrides actionLabel)
  final Widget? actionWidget;

  /// Title text style
  final TextStyle? titleStyle;

  /// Subtitle text style
  final TextStyle? subtitleStyle;

  /// Action text style
  final TextStyle? actionStyle;

  /// Padding around the header
  final EdgeInsetsGeometry? padding;

  /// Whether to show a divider below the header
  final bool showDivider;

  /// Custom leading widget (e.g., icon)
  final Widget? leading;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onActionTap,
    this.actionWidget,
    this.titleStyle,
    this.subtitleStyle,
    this.actionStyle,
    this.padding,
    this.showDivider = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacingLG,
                vertical: DesignSystem.spacingMD,
              ),
          child: Row(
            children: [
              // Leading widget
              if (leading != null) ...[
                leading!,
                const SizedBox(width: DesignSystem.spacingSM),
              ],

              // Title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: titleStyle ??
                          DesignSystem.headlineSmall.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: subtitleStyle ??
                            DesignSystem.bodySmall.copyWith(
                              color: DesignSystem.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ],
                ),
              ),

              // Action button
              if (actionWidget != null)
                actionWidget!
              else if (onActionTap != null)
                TextButton(
                  onPressed: onActionTap,
                  style: TextButton.styleFrom(
                    foregroundColor: DesignSystem.primary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignSystem.spacingMD,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        actionLabel ?? 'See All',
                        style: actionStyle ??
                            DesignSystem.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // Optional divider
        if (showDivider)
          Divider(
            color: DesignSystem.border,
            thickness: 1,
            height: 1,
          ),
      ],
    );
  }

  /// Factory for a large prominent header
  factory SectionHeader.large({
    required String title,
    String? subtitle,
    VoidCallback? onActionTap,
    String? actionLabel,
    Widget? leading,
  }) {
    return SectionHeader(
      title: title,
      subtitle: subtitle,
      onActionTap: onActionTap,
      actionLabel: actionLabel,
      leading: leading,
      titleStyle: DesignSystem.headlineMedium.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Factory for a small compact header
  factory SectionHeader.small({
    required String title,
    VoidCallback? onActionTap,
    String? actionLabel,
    Widget? leading,
  }) {
    return SectionHeader(
      title: title,
      onActionTap: onActionTap,
      actionLabel: actionLabel,
      leading: leading,
      titleStyle: DesignSystem.titleMedium.copyWith(
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingMD,
        vertical: DesignSystem.spacingSM,
      ),
    );
  }

  /// Factory for a header with divider
  factory SectionHeader.withDivider({
    required String title,
    String? subtitle,
    VoidCallback? onActionTap,
    String? actionLabel,
  }) {
    return SectionHeader(
      title: title,
      subtitle: subtitle,
      onActionTap: onActionTap,
      actionLabel: actionLabel,
      showDivider: true,
    );
  }
}

/// A collapsible section header with expand/collapse functionality
class CollapsibleSectionHeader extends StatelessWidget {
  /// Section title
  final String title;

  /// Whether the section is expanded
  final bool isExpanded;

  /// Callback when expand/collapse is tapped
  final VoidCallback onToggle;

  /// Number of items in the section (optional)
  final int? itemCount;

  /// Custom trailing widget
  final Widget? trailing;

  const CollapsibleSectionHeader({
    super.key,
    required this.title,
    required this.isExpanded,
    required this.onToggle,
    this.itemCount,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingLG,
          vertical: DesignSystem.spacingMD,
        ),
        child: Row(
          children: [
            // Expand/collapse icon
            Icon(
              isExpanded ? Icons.expand_more : Icons.chevron_right,
              color: DesignSystem.onSurface,
            ),
            const SizedBox(width: DesignSystem.spacingSM),

            // Title
            Expanded(
              child: Text(
                title,
                style: DesignSystem.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Item count badge
            if (itemCount != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: DesignSystem.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$itemCount',
                  style: DesignSystem.labelSmall.copyWith(
                    color: DesignSystem.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // Custom trailing widget
            if (trailing != null) ...[
              const SizedBox(width: DesignSystem.spacingSM),
              trailing!,
            ],
          ],
        ),
      ),
    );
  }
}

/// A section header with a count badge
class SectionHeaderWithCount extends StatelessWidget {
  /// Section title
  final String title;

  /// Number of items
  final int count;

  /// Action callback
  final VoidCallback? onActionTap;

  /// Action label
  final String? actionLabel;

  const SectionHeaderWithCount({
    super.key,
    required this.title,
    required this.count,
    this.onActionTap,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return SectionHeader(
      title: '$title ($count)',
      onActionTap: onActionTap,
      actionLabel: actionLabel,
    );
  }
}
