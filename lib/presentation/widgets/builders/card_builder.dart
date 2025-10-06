import 'package:flutter/material.dart';
import '../../core/theme/design_system.dart';
import '../common/index.dart';

/// A builder class for composing card components with common patterns.
/// Provides a fluent API for building cards with consistent styling and behavior.
///
/// **Features:**
/// - Fluent API for easy card composition
/// - Built-in support for common card variants
/// - Customizable padding, margins, and styling
/// - Support for actions, headers, and footers
/// - Consistent with app's design system
///
/// **Usage:**
/// ```dart
/// final card = CardBuilder()
///   .withVariant(CardVariant.primary)
///   .withPadding(DesignSystem.spacingMD)
///   .withHeader(
///     title: 'Card Title',
///     subtitle: 'Card Subtitle',
///   )
///   .withContent(
///     child: Text('Card content goes here'),
///   )
///   .withActions([
///     TextButton(onPressed: () {}, child: Text('Cancel')),
///     ElevatedButton(onPressed: () {}, child: Text('Save')),
///   ])
///   .build();
/// ```
class CardBuilder {
  CardVariant _variant = CardVariant.primary;
  EdgeInsetsGeometry? _padding;
  EdgeInsetsGeometry? _margin;
  BorderRadius? _borderRadius;
  List<BoxShadow>? _shadows;
  Color? _backgroundColor;
  VoidCallback? _onTap;
  Widget? _header;
  Widget? _content;
  Widget? _footer;
  List<Widget>? _actions;
  bool _isInteractive = false;
  double? _elevation;

  /// Creates a new CardBuilder instance
  CardBuilder();

  /// Sets the card variant for consistent styling
  CardBuilder withVariant(CardVariant variant) {
    _variant = variant;
    return this;
  }

  /// Sets custom padding for the card content
  CardBuilder withPadding(EdgeInsetsGeometry padding) {
    _padding = padding;
    return this;
  }

  /// Sets custom margin for the card
  CardBuilder withMargin(EdgeInsetsGeometry margin) {
    _margin = margin;
    return this;
  }

  /// Sets custom border radius for the card
  CardBuilder withBorderRadius(BorderRadius borderRadius) {
    _borderRadius = borderRadius;
    return this;
  }

  /// Sets custom shadows for the card
  CardBuilder withShadows(List<BoxShadow> shadows) {
    _shadows = shadows;
    return this;
  }

  /// Sets custom background color for the card
  CardBuilder withBackgroundColor(Color color) {
    _backgroundColor = color;
    return this;
  }

  /// Makes the card interactive with tap callback
  CardBuilder withOnTap(VoidCallback onTap) {
    _onTap = onTap;
    _isInteractive = true;
    return this;
  }

  /// Sets the card header widget
  CardBuilder withHeader({
    String? title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
  }) {
    _header = _buildHeader(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      titleStyle: titleStyle,
      subtitleStyle: subtitleStyle,
    );
    return this;
  }

  /// Sets the main content widget
  CardBuilder withContent({required Widget child}) {
    _content = child;
    return this;
  }

  /// Sets the card footer widget
  CardBuilder withFooter({required Widget child}) {
    _footer = child;
    return this;
  }

  /// Sets action buttons for the card
  CardBuilder withActions(List<Widget> actions) {
    _actions = actions;
    return this;
  }

  /// Sets custom elevation for the card
  CardBuilder withElevation(double elevation) {
    _elevation = elevation;
    return this;
  }

  /// Builds and returns the final card widget
  Widget build() {
    final theme = _getThemeData();
    final card = Container(
      margin: _margin,
      decoration: BoxDecoration(
        color: _backgroundColor ?? theme.color,
        borderRadius: _borderRadius ?? BorderRadius.circular(DesignSystem.radiusLG),
        boxShadow: _shadows ?? theme.shadows,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: _onTap,
          borderRadius: _borderRadius ?? BorderRadius.circular(DesignSystem.radiusLG),
          child: Container(
            padding: _padding ?? EdgeInsets.all(DesignSystem.spacingMD),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_header != null) ...[
                  _header!,
                  SizedBox(height: DesignSystem.spacingMD),
                ],
                if (_content != null) _content!,
                if (_footer != null) ...[
                  SizedBox(height: DesignSystem.spacingMD),
                  _footer!,
                ],
                if (_actions != null && _actions!.isNotEmpty) ...[
                  SizedBox(height: DesignSystem.spacingMD),
                  _buildActionsRow(),
                ],
              ],
            ),
          ),
        ),
      ),
    );

    return card;
  }

  Widget _buildHeader({
    String? title,
    String? subtitle,
    Widget? leading,
    Widget? trailing,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
  }) {
    return Row(
      children: [
        if (leading != null) ...[
          leading,
          SizedBox(width: DesignSystem.spacingSM),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Text(
                  title,
                  style: titleStyle ?? DesignSystem.titleMedium.copyWith(
                    color: DesignSystem.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              if (subtitle != null) ...[
                SizedBox(height: DesignSystem.spacingXXS),
                Text(
                  subtitle,
                  style: subtitleStyle ?? DesignSystem.bodySmall.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: DesignSystem.spacingSM),
          trailing,
        ],
      ],
    );
  }

  Widget _buildActionsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: _actions!.map((action) {
        if (_actions!.indexOf(action) > 0) {
          return Padding(
            padding: EdgeInsets.only(left: DesignSystem.spacingSM),
            child: action,
          );
        }
        return action;
      }).toList(),
    );
  }

  _CardThemeData _getThemeData() {
    switch (_variant) {
      case CardVariant.primary:
        return _CardThemeData(
          color: DesignSystem.surfaceContainer,
          shadows: DesignSystem.shadowCard,
        );
      case CardVariant.secondary:
        return _CardThemeData(
          color: DesignSystem.surfaceContainerHigh,
          shadows: DesignSystem.shadowSmall,
        );
      case CardVariant.accent:
        return _CardThemeData(
          color: DesignSystem.primary.withValues(alpha: 0.1),
          shadows: DesignSystem.shadowMedium,
        );
      case CardVariant.outlined:
        return _CardThemeData(
          color: Colors.transparent,
          shadows: [],
        );
    }
  }
}

/// Theme data for card variants
class _CardThemeData {
  final Color color;
  final List<BoxShadow> shadows;

  const _CardThemeData({
    required this.color,
    required this.shadows,
  });
}

/// Card variant enumeration
enum CardVariant {
  /// Primary card style - standard surface container
  primary,

  /// Secondary card style - higher surface container
  secondary,

  /// Accent card style - primary color tinted background
  accent,

  /// Outlined card style - transparent with border
  outlined,
}

/// Extension for quick card creation
extension CardBuilderExtension on Widget {
  /// Wraps widget in a CardBuilder for quick styling
  CardBuilder get card => CardBuilder().withContent(child: this);
}