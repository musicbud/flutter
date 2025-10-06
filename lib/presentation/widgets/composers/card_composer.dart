import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
import '../builders/card_builder.dart';

/// A composer class for composing complex card layouts.
/// Provides a fluent API for creating sophisticated card arrangements with multiple sections.
///
/// **Features:**
/// - Multi-section card layouts
/// - Flexible content arrangement
/// - Built-in card variants and styling
/// - Support for overlays and badges
/// - Customizable aspect ratios and sizing
/// - Integration with CardBuilder for consistent styling
///
/// **Usage:**
/// ```dart
/// final complexCard = CardComposer()
///   .withLayout(CardLayout.featured)
///   .withMedia(
///     imageUrl: 'https://example.com/image.jpg',
///     aspectRatio: 16 / 9,
///   )
///   .withHeader(
///     title: 'Featured Content',
///     subtitle: 'Premium content for you',
///     badge: 'Premium',
///   )
///   .withContent(
///     sections: [
///       CardSection(
///         title: 'Description',
///         child: Text('This is the main content...'),
///       ),
///       CardSection(
///         title: 'Actions',
///         child: Row(children: [/* action buttons */]),
///       ),
///     ],
///   )
///   .withFooter(
///     actions: [/* footer actions */],
///   )
///   .build();
/// ```
class CardComposer {
  CardLayout _layout = CardLayout.standard;
  String? _mediaUrl;
  double? _aspectRatio;
  String? _title;
  String? _subtitle;
  String? _badge;
  List<CardSection> _sections = [];
  List<Widget> _footerActions = [];
  CardVariant _variant = CardVariant.primary;
  EdgeInsetsGeometry? _padding;
  EdgeInsetsGeometry? _margin;
  VoidCallback? _onTap;
  bool _isInteractive = false;
  Color? _overlayColor;
  double? _elevation;

  /// Creates a new CardComposer instance
  CardComposer();

  /// Sets the card layout type
  CardComposer withLayout(CardLayout layout) {
    _layout = layout;
    return this;
  }

  /// Sets the media (image/video) for the card
  CardComposer withMedia({
    required String imageUrl,
    double aspectRatio = 16 / 9,
  }) {
    _mediaUrl = imageUrl;
    _aspectRatio = aspectRatio;
    return this;
  }

  /// Sets the card header information
  CardComposer withHeader({
    required String title,
    String? subtitle,
    String? badge,
  }) {
    _title = title;
    _subtitle = subtitle;
    _badge = badge;
    return this;
  }

  /// Sets the main content sections
  CardComposer withContent({required List<CardSection> sections}) {
    _sections = sections;
    return this;
  }

  /// Adds a single content section
  CardComposer withSection(CardSection section) {
    _sections.add(section);
    return this;
  }

  /// Sets the footer actions
  CardComposer withFooter({required List<Widget> actions}) {
    _footerActions = actions;
    return this;
  }

  /// Sets the card variant for styling
  CardComposer withVariant(CardVariant variant) {
    _variant = variant;
    return this;
  }

  /// Sets custom padding for the card
  CardComposer withPadding(EdgeInsetsGeometry padding) {
    _padding = padding;
    return this;
  }

  /// Sets custom margin for the card
  CardComposer withMargin(EdgeInsetsGeometry margin) {
    _margin = margin;
    return this;
  }

  /// Makes the card interactive with tap callback
  CardComposer withOnTap(VoidCallback onTap) {
    _onTap = onTap;
    _isInteractive = true;
    return this;
  }

  /// Sets overlay color for media cards
  CardComposer withOverlayColor(Color color) {
    _overlayColor = color;
    return this;
  }

  /// Sets custom elevation for the card
  CardComposer withElevation(double elevation) {
    _elevation = elevation;
    return this;
  }

  /// Builds and returns the final card widget
  Widget build() {
    return CardBuilder()
        .withVariant(_variant)
        .withPadding(_padding ?? EdgeInsets.all(DesignSystem.spacingMD))
        .withMargin(_margin ?? EdgeInsets.zero)
        .withOnTap(_isInteractive ? _onTap : null)
        .withElevation(_elevation ?? 0)
        .withContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_layout == CardLayout.featured && _mediaUrl != null) ...[
                _buildMediaSection(),
                SizedBox(height: DesignSystem.spacingMD),
              ],
              if (_title != null || _subtitle != null || _badge != null) ...[
                _buildHeaderSection(),
                SizedBox(height: DesignSystem.spacingMD),
              ],
              ..._buildContentSections(),
              if (_footerActions.isNotEmpty) ...[
                SizedBox(height: DesignSystem.spacingMD),
                _buildFooterSection(),
              ],
            ],
          ),
        )
        .build();
  }

  Widget _buildMediaSection() {
    return Container(
      height: _aspectRatio != null ? 200 * (_aspectRatio! / (16 / 9)) : 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
        image: DecorationImage(
          image: NetworkImage(_mediaUrl!),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              _overlayColor ?? Colors.black.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: _badge != null
            ? Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.all(DesignSystem.spacingSM),
                  child: _buildBadge(),
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_title != null) ...[
                Text(
                  _title!,
                  style: DesignSystem.titleLarge.copyWith(
                    color: DesignSystem.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              if (_subtitle != null) ...[
                SizedBox(height: DesignSystem.spacingXXS),
                Text(
                  _subtitle!,
                  style: DesignSystem.bodyMedium.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (_badge != null) _buildBadge(),
      ],
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingSM,
        vertical: DesignSystem.spacingXXS,
      ),
      decoration: BoxDecoration(
        color: DesignSystem.primary,
        borderRadius: BorderRadius.circular(DesignSystem.radiusCircular),
      ),
      child: Text(
        _badge!,
        style: DesignSystem.caption.copyWith(
          color: DesignSystem.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<Widget> _buildContentSections() {
    final sections = <Widget>[];

    for (int i = 0; i < _sections.length; i++) {
      final section = _sections[i];

      if (section.title != null) {
        sections.add(
          Padding(
            padding: EdgeInsets.only(
              top: i > 0 ? DesignSystem.spacingMD : 0,
            ),
            child: Text(
              section.title!,
              style: DesignSystem.titleSmall.copyWith(
                color: DesignSystem.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }

      sections.add(
        Padding(
          padding: EdgeInsets.only(
            top: section.title != null ? DesignSystem.spacingSM : 0,
            bottom: i < _sections.length - 1 ? DesignSystem.spacingMD : 0,
          ),
          child: section.child,
        ),
      );
    }

    return sections;
  }

  Widget _buildFooterSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: _footerActions.map((action) {
        if (_footerActions.indexOf(action) > 0) {
          return Padding(
            padding: EdgeInsets.only(left: DesignSystem.spacingSM),
            child: action,
          );
        }
        return action;
      }).toList(),
    );
  }
}

/// Card layout types
enum CardLayout {
  /// Standard card layout - simple content without media
  standard,

  /// Featured card layout - includes media at the top
  featured,

  /// Compact card layout - minimal spacing and content
  compact,
}

/// Card section data class
class CardSection {
  final String? title;
  final Widget child;

  const CardSection({
    this.title,
    required this.child,
  });
}

/// Extension for quick card composition
extension CardComposerExtension on Widget {
  /// Creates a CardComposer with this widget as content
  CardComposer get card => CardComposer().withContent(
        sections: [CardSection(child: this)],
      );
}