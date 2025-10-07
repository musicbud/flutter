import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Abstract base class for state display widgets like loading, error, and empty states.
/// Provides consistent layout and styling for different state representations.
///
/// **Common Properties:**
/// - [title] - Primary text content (required)
/// - [message] - Secondary descriptive text (optional)
/// - [icon] - Icon to display (optional)
/// - [actionCallback] - Callback for action button (optional)
/// - [actionText] - Text for action button (optional)
/// - [iconSize] - Size of the icon
/// - [padding] - Padding around the entire widget
///
/// **Common Methods:**
/// - [_buildIcon] - Icon widget (must be implemented)
/// - [_buildContent] - Main content layout (must be implemented)
/// - [_buildAction] - Action button/section (must be implemented)
/// - [_buildDefaultIcon] - Default icon widget
/// - [_buildDefaultContent] - Default content layout
/// - [_buildDefaultAction] - Default action button
///
/// **Usage:**
/// ```dart
/// class CustomState extends BaseStateDisplay {
///   const CustomState({
///     super.key,
///     required super.title,
///     super.message,
///     super.icon,
///     super.actionCallback,
///     super.actionText,
///   });
///
///   @override
///   Widget _buildIcon(BuildContext context) {
///     return Icon(icon ?? Icons.info_outline, size: iconSize);
///   }
///
///   @override
///   Widget _buildContent(BuildContext context) {
///     return Column(
///       children: [
///         Text(title, style: getDesignSystemTypography(context).titleMedium),
///         if (message != null) Text(message!),
///       ],
///     );
///   }
///
///   @override
///   Widget _buildAction(BuildContext context) {
///     if (actionText != null && actionCallback != null) {
///       return ElevatedButton(
///         onPressed: actionCallback,
///         child: Text(actionText!),
///       );
///     }
///     return const SizedBox.shrink();
///   }
/// }
/// ```
abstract class BaseStateDisplay extends StatelessWidget {
  /// Primary text content (required)
  final String? title;

  /// Secondary descriptive text (optional)
  final String? message;

  /// Icon to display (optional)
  final IconData? icon;

  /// Callback for action button (optional)
  final VoidCallback? actionCallback;

  /// Text for action button (optional)
  final String? actionText;

  /// Size of the icon
  final double iconSize;

  /// Padding around the entire widget
  final EdgeInsetsGeometry? padding;

  /// Background color for the state display
  final Color? backgroundColor;

  /// Whether to center the content
  final bool centerContent;

  /// Constructor for BaseStateDisplay
  const BaseStateDisplay({
    super.key,
    this.title,
    this.message,
    this.icon,
    this.actionCallback,
    this.actionText,
    this.iconSize = 64.0,
    this.padding,
    this.backgroundColor,
    this.centerContent = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _buildContentWithTheme(context, theme);
  }

  Widget _buildContentWithTheme(BuildContext context, ThemeData theme) {
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon section
        if (icon != null) ...[
          _buildIcon(context),
          const SizedBox(height: 32.0),
        ],

        // Content section
        _buildContent(context),

        // Action section
        if (actionText != null && actionCallback != null) ...[
          const SizedBox(height: 32.0),
          _buildAction(context),
        ],
      ],
    );

    if (centerContent) {
      content = Center(child: content);
    }

    return Padding(
      padding: padding ?? const EdgeInsets.all(32.0),
      child: Container(
        color: backgroundColor,
        child: content,
      ),
    );
  }

  /// Build the icon widget - must be implemented by subclasses
  /// Should return the icon to display or SizedBox.shrink() if no icon
  @protected
  Widget _buildIcon(BuildContext context);

  /// Build the main content layout - must be implemented by subclasses
  /// Should return the primary content (title, message, etc.)
  @protected
  Widget _buildContent(BuildContext context);

  /// Build the action button/section - must be implemented by subclasses
  /// Should return action button or SizedBox.shrink() if no action
  @protected
  Widget _buildAction(BuildContext context);


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
      displayLarge: TextStyle(),
      displayMedium: TextStyle(),
      displaySmall: TextStyle(),
      headlineLarge: TextStyle(),
      headlineMedium: TextStyle(),
      headlineSmall: TextStyle(),
      titleLarge: TextStyle(),
      titleMedium: TextStyle(),
      titleSmall: TextStyle(),
      bodyLarge: TextStyle(),
      bodyMedium: TextStyle(),
      bodySmall: TextStyle(),
      labelLarge: TextStyle(),
      labelMedium: TextStyle(),
      labelSmall: TextStyle(),
      caption: TextStyle(),
      overline: TextStyle(),
      arabicText: TextStyle(),
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