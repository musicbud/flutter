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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 24.0), // Placeholder
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
          const SizedBox(height: 16.0), // Placeholder
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
    return Divider(
      height: 1,
      thickness: 1,
      color: dividerColor ?? const Color(0xFF000000), // Placeholder
    );
  }


  /// Helper method to get design system colors
  @protected
  DesignSystemColors getDesignSystemColors(BuildContext context) {
    return Theme.of(context).designSystemColors ?? const DesignSystemColors(
      primary: Color(0xFF000000), // Placeholder
      secondary: Color(0xFF000000),
      surface: Color(0xFF000000),
      background: Color(0xFF000000),
      onSurface: Color(0xFF000000),
      onSurfaceVariant: Color(0xFF000000),
      error: Color(0xFF000000),
      success: Color(0xFF000000),
      warning: Color(0xFF000000),
      info: Color(0xFF000000),
      accentBlue: Color(0xFF000000),
      accentPurple: Color(0xFF000000),
      accentGreen: Color(0xFF000000),
      accentOrange: Color(0xFF000000),
      border: Color(0xFF000000),
      overlay: Color(0xFF000000),
      surfaceContainer: Color(0xFF000000),
      surfaceContainerHigh: Color(0xFF000000),
      surfaceContainerHighest: Color(0xFF000000),
      onPrimary: Color(0xFF000000),
      onError: Color(0xFF000000),
      onErrorContainer: Color(0xFF000000),
      textMuted: Color(0xFF000000),
      primaryRed: Color(0xFF000000),
      white: Color(0xFF000000),
      surfaceDark: Color(0xFF000000),
      surfaceLight: Color(0xFF000000),
      cardBackground: Color(0xFF000000),
      borderColor: Color(0xFF000000),
      textPrimary: Color(0xFF000000),
    );
  }

  /// Helper method to get design system typography
  @protected
  DesignSystemTypography getDesignSystemTypography(BuildContext context) {
    return Theme.of(context).designSystemTypography ?? DesignSystemTypography(
      displayLarge: const TextStyle(),
      displayMedium: const TextStyle(),
      displaySmall: const TextStyle(),
      headlineLarge: const TextStyle(),
      headlineMedium: const TextStyle(),
      headlineSmall: const TextStyle(),
      titleLarge: const TextStyle(),
      titleMedium: const TextStyle(),
      titleSmall: const TextStyle(),
      bodyLarge: const TextStyle(),
      bodyMedium: const TextStyle(),
      bodySmall: const TextStyle(),
      labelLarge: const TextStyle(),
      labelMedium: const TextStyle(),
      labelSmall: const TextStyle(),
      caption: const TextStyle(),
      overline: const TextStyle(),
      arabicText: const TextStyle(),
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