import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

/// A reusable section header widget with title and optional action button.
/// Provides consistent styling for section headers across the app.
///
/// Features:
/// - Title text with customizable styling
/// - Optional action button with text
/// - Consistent spacing and typography
/// - Support for custom padding and styling
/// - Theme-aware colors and typography
class SectionHeader extends StatelessWidget {
  /// The title text to display
  final String title;

  /// Optional action button text (e.g., "See All", "View More")
  final String? actionText;

  /// Callback when the action button is pressed
  final VoidCallback? onActionPressed;

  /// Custom padding around the header
  final EdgeInsetsGeometry? padding;

  /// Custom text style for the title
  final TextStyle? titleStyle;

  /// Custom text style for the action button
  final TextStyle? actionStyle;

  /// Whether to show a divider below the header
  final bool showDivider;

  /// Color of the divider
  final Color? dividerColor;

  /// Alignment of the header content
  final CrossAxisAlignment? crossAxisAlignment;

  /// Whether the action button should be styled as a text button or outlined button
  final bool actionIsOutlined;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionPressed,
    this.padding,
    this.titleStyle,
    this.actionStyle,
    this.showDivider = false,
    this.dividerColor,
    this.crossAxisAlignment,
    this.actionIsOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding ?? EdgeInsets.symmetric(horizontal: design.designSystemSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              Expanded(
                child: Text(
                  title,
                  style: titleStyle ?? design.designSystemTypography.headlineSmall.copyWith(
                    color: design.designSystemColors.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // Action button
              if (actionText != null && onActionPressed != null) ...[
                const SizedBox(width: 16),
                actionIsOutlined
                    ? OutlinedButton(
                        onPressed: onActionPressed,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: design.designSystemColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(design.designSystemRadius.md),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: design.designSystemSpacing.md,
                            vertical: design.designSystemSpacing.sm,
                          ),
                        ),
                        child: Text(
                          actionText!,
                          style: actionStyle ?? design.designSystemTypography.labelLarge.copyWith(
                            color: design.designSystemColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : TextButton(
                        onPressed: onActionPressed,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: design.designSystemSpacing.md,
                            vertical: design.designSystemSpacing.sm,
                          ),
                        ),
                        child: Text(
                          actionText!,
                          style: actionStyle ?? design.designSystemTypography.labelLarge.copyWith(
                            color: design.designSystemColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ],
            ],
          ),
        ),

        // Divider
        if (showDivider) ...[
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: dividerColor ?? design.designSystemColors.border,
            margin: EdgeInsets.symmetric(horizontal: design.designSystemSpacing.lg),
          ),
        ],
      ],
    );
  }
}