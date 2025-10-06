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
  final String title;

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
    required this.title,
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
          SizedBox(height: theme.designSystemSpacing.xl),
        ],

        // Content section
        _buildContent(context),

        // Action section
        if (actionText != null && actionCallback != null) ...[
          SizedBox(height: theme.designSystemSpacing.xl),
          _buildAction(context),
        ],
      ],
    );

    if (centerContent) {
      content = Center(child: content);
    }

    return Padding(
      padding: padding ?? EdgeInsets.all(theme.designSystemSpacing.xl),
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

  /// Default icon widget implementation
  @protected
  Widget _buildDefaultIcon(BuildContext context) {
    if (icon == null) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final designColors = theme.designSystemColors;

    return Container(
      padding: EdgeInsets.all(theme.designSystemSpacing.lg),
      decoration: BoxDecoration(
        color: theme.designSystemColors.surfaceContainer,
        borderRadius: BorderRadius.circular(theme.designSystemRadius.xl),
      ),
      child: Icon(
        icon,
        size: iconSize,
        color: theme.designSystemColors.onSurfaceVariant,
      ),
    );
  }

  /// Default content layout implementation
  @protected
  Widget _buildDefaultContent(BuildContext context) {
    final theme = Theme.of(context);
    final designColors = theme.designSystemColors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        Text(
          title,
          style: theme.designSystemTypography.titleMedium.copyWith(
            color: theme.designSystemColors.onSurface,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),

        // Message
        if (message != null) ...[
          SizedBox(height: theme.designSystemSpacing.md),
          Text(
            message!,
            style: theme.designSystemTypography.bodyMedium.copyWith(
              color: theme.designSystemColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }

  /// Default action button implementation
  @protected
  Widget _buildDefaultAction(BuildContext context) {
    if (actionText != null && actionCallback != null) {
      return ElevatedButton(
        onPressed: actionCallback,
        style: ElevatedButton.styleFrom(
          backgroundColor: getDesignSystemColors(context).primary,
          foregroundColor: getDesignSystemColors(context).onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(getDesignSystemRadius(context).md),
          ),
        ),
        child: Text(
          actionText!,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  /// Helper method to get design system colors
  @protected
  DesignSystemColors getDesignSystemColors(BuildContext context) {
    return Theme.of(context).designSystemColors;
  }

  /// Helper method to get design system typography
  @protected
  DesignSystemTypography getDesignSystemTypography(BuildContext context) {
    return Theme.of(context).designSystemTypography;
  }

  /// Helper method to get design system spacing
  @protected
  DesignSystemSpacing getDesignSystemSpacing(BuildContext context) {
    return Theme.of(context).designSystemSpacing;
  }

  /// Helper method to get design system radius
  @protected
  DesignSystemRadius getDesignSystemRadius(BuildContext context) {
    return Theme.of(context).designSystemRadius;
  }
}