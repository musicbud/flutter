import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Abstract base class for section header widgets.
/// Provides consistent layout and styling for section headers with optional actions.
///
/// **Common Properties:**
/// - [title] - Header title text (required)
/// - [onActionPressed] - Callback for action button (optional)
/// - [actionText] - Text for action button (optional)
/// - [padding] - Padding around the header
/// - [titleStyle] - Custom style for title text
/// - [actionStyle] - Custom style for action text
///
/// **Common Methods:**
/// - [_buildTitle] - Title widget (must be implemented)
/// - [_buildAction] - Action button/section (must be implemented)
/// - [_buildDefaultTitle] - Default title widget
/// - [_buildDefaultAction] - Default action button
///
/// **Usage:**
/// ```dart
/// class CustomHeader extends BaseSectionHeader {
///   const CustomHeader({
///     super.key,
///     required super.title,
///     super.onActionPressed,
///     super.actionText,
///   });
///
///   @override
///   Widget _buildTitle(BuildContext context) {
///     return Text(
///       title,
///       style: getDesignSystemTypography(context).headlineSmall,
///     );
///   }
///
///   @override
///   Widget _buildAction(BuildContext context) {
///     if (onActionPressed != null && actionText != null) {
///       return TextButton(
///         onPressed: onActionPressed,
///         child: Text(actionText!),
///       );
///     }
///     return const SizedBox.shrink();
///   }
/// }
/// ```
abstract class BaseSectionHeader extends StatelessWidget {
  /// Header title text (required)
  final String title;

  /// Callback for action button (optional)
  final VoidCallback? onActionPressed;

  /// Text for action button (optional)
  final String? actionText;

  /// Padding around the header
  final EdgeInsetsGeometry? padding;

  /// Custom style for title text
  final TextStyle? titleStyle;

  /// Custom style for action text
  final TextStyle? actionStyle;

  /// Whether to show a divider below the header
  final bool showDivider;

  /// Color of the divider
  final Color? dividerColor;

  /// Main axis alignment for the header layout
  final MainAxisAlignment mainAxisAlignment;

  /// Cross axis alignment for the header layout
  final CrossAxisAlignment crossAxisAlignment;

  /// Constructor for BaseSectionHeader
  const BaseSectionHeader({
    super.key,
    required this.title,
    this.onActionPressed,
    this.actionText,
    this.padding,
    this.titleStyle,
    this.actionStyle,
    this.showDivider = false,
    this.dividerColor,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final designColors = theme.designSystem?.designSystemColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: padding ?? EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: [
              // Title section
              _buildTitle(context),

              // Action section
              if (onActionPressed != null && actionText != null)
                _buildAction(context),
            ],
          ),
        ),

        // Divider
        if (showDivider) ...[
          SizedBox(height: DesignSystem.spacingMD),
          _buildDivider(context),
        ],
      ],
    );
  }

  /// Build the title widget - must be implemented by subclasses
  /// Should return the title text widget
  @protected
  Widget _buildTitle(BuildContext context);

  /// Build the action button/section - must be implemented by subclasses
  /// Should return action button or SizedBox.shrink() if no action
  @protected
  Widget _buildAction(BuildContext context);

  /// Build the divider widget
  @protected
  Widget _buildDivider(BuildContext context) {
    final theme = Theme.of(context);
    final designColors = theme.designSystem?.designSystemColors;

    return Divider(
      height: 1,
      thickness: 1,
      color: dividerColor ?? DesignSystem.border,
    );
  }

  /// Default title widget implementation
  @protected
  Widget _buildDefaultTitle(BuildContext context) {
    final theme = Theme.of(context);
    final designColors = theme.designSystem?.designSystemColors;

    return Expanded(
      child: Text(
        title,
        style: titleStyle ?? DesignSystem.headlineSmall.copyWith(
          color: DesignSystem.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  /// Default action button implementation
  @protected
  Widget _buildDefaultAction(BuildContext context) {
    if (onActionPressed != null && actionText != null) {
      final theme = Theme.of(context);
      final designColors = theme.designSystem?.designSystemColors;

      return TextButton(
        onPressed: onActionPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingMD,
            vertical: DesignSystem.spacingSM,
          ),
        ),
        child: Text(
          actionText!,
          style: actionStyle ?? DesignSystem.labelLarge.copyWith(
            color: DesignSystem.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  /// Helper method to get design system colors
  @protected
  DesignSystemColors getDesignSystemColors(BuildContext context) {
    return Theme.of(context).designSystemColors ?? DesignSystemColors(
      primary: DesignSystem.primary,
      secondary: DesignSystem.secondary,
      surface: DesignSystem.surface,
      background: DesignSystem.background,
      onSurface: DesignSystem.onSurface,
      onSurfaceVariant: DesignSystem.onSurfaceVariant,
      error: DesignSystem.error,
      success: DesignSystem.success,
      warning: DesignSystem.warning,
      info: DesignSystem.info,
      accentBlue: DesignSystem.accentBlue,
      accentPurple: DesignSystem.accentPurple,
      accentGreen: DesignSystem.accentGreen,
      accentOrange: DesignSystem.accentOrange,
      border: DesignSystem.border,
      overlay: DesignSystem.overlay,
      surfaceContainer: DesignSystem.surfaceContainer,
      surfaceContainerHigh: DesignSystem.surfaceContainerHigh,
      surfaceContainerHighest: DesignSystem.surfaceContainerHighest,
      onPrimary: DesignSystem.onPrimary,
      onError: DesignSystem.onError,
      onErrorContainer: DesignSystem.onErrorContainer,
    );
  }

  /// Helper method to get design system typography
  @protected
  DesignSystemTypography getDesignSystemTypography(BuildContext context) {
    return Theme.of(context).designSystemTypography ?? DesignSystemTypography(
      displayLarge: DesignSystem.displayLarge,
      displayMedium: DesignSystem.displayMedium,
      displaySmall: DesignSystem.displaySmall,
      headlineLarge: DesignSystem.headlineLarge,
      headlineMedium: DesignSystem.headlineMedium,
      headlineSmall: DesignSystem.headlineSmall,
      titleLarge: DesignSystem.titleLarge,
      titleMedium: DesignSystem.titleMedium,
      titleSmall: DesignSystem.titleSmall,
      bodyLarge: DesignSystem.bodyLarge,
      bodyMedium: DesignSystem.bodyMedium,
      bodySmall: DesignSystem.bodySmall,
      labelLarge: DesignSystem.labelLarge,
      labelMedium: DesignSystem.labelMedium,
      labelSmall: DesignSystem.labelSmall,
      caption: DesignSystem.caption,
      overline: DesignSystem.overline,
      arabicText: DesignSystem.arabicText,
    );
  }

  /// Helper method to get design system spacing
  @protected
  DesignSystemSpacing getDesignSystemSpacing(BuildContext context) {
    return Theme.of(context).designSystemSpacing ?? const DesignSystemSpacing();
  }

  /// Helper method to get design system radius
  @protected
  DesignSystemRadius getDesignSystemRadius(BuildContext context) {
    return Theme.of(context).designSystemRadius ?? const DesignSystemRadius();
  }
}