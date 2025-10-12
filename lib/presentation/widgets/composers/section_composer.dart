import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

/// A composer class for composing sections with headers and content.
/// Provides a fluent API for creating consistent section layouts throughout the app.
///
/// **Features:**
/// - Flexible header configuration with actions
/// - Support for multiple content layouts
/// - Built-in spacing and styling consistency
/// - Responsive design support
/// - Customizable dividers and separators
/// - Integration with existing section headers
///
/// **Usage:**
/// ```dart
/// final section = SectionComposer()
///   .withHeader(
///     title: 'My Section',
///     actionText: 'View All',
///     onActionPressed: () => navigateToList(),
///   )
///   .withContent(
///     child: ListBuilder<String>()
///       .withItems(['Item 1', 'Item 2', 'Item 3'])
///       .withItemBuilder((context, item, index) => ListTile(title: Text(item)))
///       .build(),
///   )
///   .withSpacing(SectionSpacing.compact)
///   .withDivider(true)
///   .build();
/// ```
class SectionComposer {
  String? _title;
  String? _subtitle;
  String? _actionText;
  VoidCallback? _onActionPressed;
  Widget? _leading;
  Widget? _trailing;
  Widget? _content;
  SectionSpacing _spacing = SectionSpacing.standard;
  bool _showDivider = false;
  Color? _dividerColor;
  EdgeInsetsGeometry? _padding;
  TextStyle? _titleStyle;
  TextStyle? _subtitleStyle;
  TextStyle? _actionStyle;
  bool _isCollapsible = false;
  bool _initiallyExpanded = true;
  VoidCallback? _onExpansionChanged;

  /// Creates a new SectionComposer instance
  SectionComposer();

  /// Sets the section header title
  SectionComposer withTitle(String title) {
    _title = title;
    return this;
  }

  /// Sets the section header subtitle
  SectionComposer withSubtitle(String subtitle) {
    _subtitle = subtitle;
    return this;
  }

  /// Sets the action button text and callback
  SectionComposer withAction({
    required String text,
    required VoidCallback onPressed,
  }) {
    _actionText = text;
    _onActionPressed = onPressed;
    return this;
  }

  /// Sets a custom leading widget for the header
  SectionComposer withLeading(Widget leading) {
    _leading = leading;
    return this;
  }

  /// Sets a custom trailing widget for the header
  SectionComposer withTrailing(Widget trailing) {
    _trailing = trailing;
    return this;
  }

  /// Sets the main content widget
  SectionComposer withContent({required Widget child}) {
    _content = child;
    return this;
  }

  /// Sets the spacing configuration for the section
  SectionComposer withSpacing(SectionSpacing spacing) {
    _spacing = spacing;
    return this;
  }

  /// Sets whether to show a divider below the section
  SectionComposer withDivider(bool show) {
    _showDivider = show;
    return this;
  }

  /// Sets custom divider color
  SectionComposer withDividerColor(Color color) {
    _dividerColor = color;
    return this;
  }

  /// Sets custom padding for the entire section
  SectionComposer withPadding(EdgeInsetsGeometry padding) {
    _padding = padding;
    return this;
  }

  /// Sets custom title text style
  SectionComposer withTitleStyle(TextStyle style) {
    _titleStyle = style;
    return this;
  }

  /// Sets custom subtitle text style
  SectionComposer withSubtitleStyle(TextStyle style) {
    _subtitleStyle = style;
    return this;
  }

  /// Sets custom action text style
  SectionComposer withActionStyle(TextStyle style) {
    _actionStyle = style;
    return this;
  }

  /// Makes the section collapsible/expandable
  SectionComposer withCollapsible({
    bool initiallyExpanded = true,
    VoidCallback? onExpansionChanged,
  }) {
    _isCollapsible = true;
    _initiallyExpanded = initiallyExpanded;
    _onExpansionChanged = onExpansionChanged;
    return this;
  }

  /// Builds and returns the final section widget
  Widget build() {
    if (_isCollapsible) {
      return _buildCollapsibleSection();
    }

    return _buildStandardSection();
  }

  Widget _buildStandardSection() {
    return Container(
      padding: _padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_title != null || _leading != null || _trailing != null) ...[
            _buildHeader(),
            SizedBox(height: _spacing.contentSpacing),
          ],
          if (_content != null) _content!,
          if (_showDivider) ...[
            SizedBox(height: _spacing.dividerSpacing),
            _buildDivider(),
          ],
        ],
      ),
    );
  }

  Widget _buildCollapsibleSection() {
    return Container(
      padding: _padding,
      child: ExpansionTile(
        initiallyExpanded: _initiallyExpanded,
        onExpansionChanged: (expanded) {
          if (_onExpansionChanged != null) {
            _onExpansionChanged!();
          }
        },
        title: _buildHeaderTitle(),
        children: [
          if (_content != null) ...[
            SizedBox(height: _spacing.contentSpacing),
            _content!,
          ],
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        if (_leading != null) ...[
          _leading!,
          const SizedBox(width: DesignSystem.spacingSM),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_title != null) ...[
                Text(
                  _title!,
                  style: _titleStyle ?? DesignSystem.headlineSmall.copyWith(
                    color: DesignSystem.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              if (_subtitle != null) ...[
                const SizedBox(height: DesignSystem.spacingXXS),
                Text(
                  _subtitle!,
                  style: _subtitleStyle ?? DesignSystem.bodySmall.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
        if (_trailing != null) ...[
          const SizedBox(width: DesignSystem.spacingSM),
          _trailing!,
        ],
        if (_actionText != null && _onActionPressed != null) ...[
          const SizedBox(width: DesignSystem.spacingSM),
          TextButton(
            onPressed: _onActionPressed,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacingMD,
                vertical: DesignSystem.spacingSM,
              ),
            ),
            child: Text(
              _actionText!,
              style: _actionStyle ?? DesignSystem.labelLarge.copyWith(
                color: DesignSystem.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildHeaderTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_title != null) ...[
          Text(
            _title!,
            style: _titleStyle ?? DesignSystem.headlineSmall.copyWith(
              color: DesignSystem.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
        if (_subtitle != null) ...[
          const SizedBox(height: DesignSystem.spacingXXS),
          Text(
            _subtitle!,
            style: _subtitleStyle ?? DesignSystem.bodySmall.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: _dividerColor ?? DesignSystem.border,
    );
  }
}

/// Spacing configurations for sections
enum SectionSpacing {
  /// Compact spacing - minimal padding and margins
  compact(
    headerSpacing: 8,
    contentSpacing: 12,
    dividerSpacing: 16,
  ),

  /// Standard spacing - balanced padding and margins
  standard(
    headerSpacing: 16,
    contentSpacing: 20,
    dividerSpacing: 24,
  ),

  /// Comfortable spacing - generous padding and margins
  comfortable(
    headerSpacing: 24,
    contentSpacing: 32,
    dividerSpacing: 40,
  );

  const SectionSpacing({
    required this.headerSpacing,
    required this.contentSpacing,
    required this.dividerSpacing,
  });

  final double headerSpacing;
  final double contentSpacing;
  final double dividerSpacing;
}

/// Extension for quick section creation
extension SectionComposerExtension on String {
  /// Creates a SectionComposer with this string as the title
  SectionComposer get section => SectionComposer().withTitle(this);
}