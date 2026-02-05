import 'package:flutter/material.dart';

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
/// - [buildIcon] - Icon widget (must be implemented)
/// - [buildContent] - Main content layout (must be implemented)
/// - [buildAction] - Action button/section (must be implemented)
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
///   Widget buildIcon(BuildContext context) {
///     return Icon(icon ?? Icons.info_outline, size: iconSize);
///   }
///
///   @override
///   Widget buildContent(BuildContext context) {
///     return Column(
///       children: [
///         Text(title, style: DesignSystem.titleMedium),
///         if (message != null) Text(message!),
///       ],
///     );
///   }
///
///   @override
///   Widget buildAction(BuildContext context) {
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
          buildIcon(context),
          const SizedBox(height: 32.0),
        ],

        // Content section
        buildContent(context),

        // Action section
        if (actionText != null && actionCallback != null) ...[
          const SizedBox(height: 32.0),
          buildAction(context),
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
  Widget buildIcon(BuildContext context);

  /// Build the main content layout - must be implemented by subclasses
  /// Should return the primary content (title, message, etc.)
  @protected
  Widget buildContent(BuildContext context);

  /// Build the action button/section - must be implemented by subclasses
  /// Should return action button or SizedBox.shrink() if no action
  @protected
  Widget buildAction(BuildContext context);
}