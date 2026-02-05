import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A customizable divider widget with optional label.
///
/// Supports:
/// - Horizontal and vertical orientations
/// - Optional label text
/// - Custom colors and thickness
/// - Spacing customization
///
/// Example:
/// ```dart
/// ModernDivider(
///   label: 'OR',
///   thickness: 2,
/// )
/// ```
class ModernDivider extends StatelessWidget {
  const ModernDivider({
    super.key,
    this.label,
    this.color,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.labelPadding,
  });

  final String? label;
  final Color? color;
  final double thickness;
  final double indent;
  final double endIndent;
  final EdgeInsets? labelPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = color ??
        DesignSystem.textMuted.withAlpha(51) ??
        theme.dividerColor;

    if (label == null) {
      return Divider(
        color: dividerColor,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
      );
    }

    return Row(
      children: [
        if (indent > 0) SizedBox(width: indent),
        Expanded(
          child: Container(
            height: thickness,
            color: dividerColor,
          ),
        ),
        Padding(
          padding: labelPadding ??
              const EdgeInsets.symmetric(
                horizontal: DesignSystem.spacingMD,
              ),
          child: Text(
            label!,
            style: (DesignSystem.bodySmall).copyWith(
              color: DesignSystem.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: thickness,
            color: dividerColor,
          ),
        ),
        if (endIndent > 0) SizedBox(width: endIndent),
      ],
    );
  }
}

/// Vertical divider with optional label
class VerticalModernDivider extends StatelessWidget {
  const VerticalModernDivider({
    super.key,
    this.label,
    this.color,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.labelPadding,
  });

  final String? label;
  final Color? color;
  final double thickness;
  final double indent;
  final double endIndent;
  final EdgeInsets? labelPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = color ??
        DesignSystem.textMuted.withAlpha(51) ??
        theme.dividerColor;

    if (label == null) {
      return VerticalDivider(
        color: dividerColor,
        thickness: thickness,
        indent: indent,
        endIndent: endIndent,
      );
    }

    return Column(
      children: [
        if (indent > 0) SizedBox(height: indent),
        Expanded(
          child: Container(
            width: thickness,
            color: dividerColor,
          ),
        ),
        Padding(
          padding: labelPadding ??
              const EdgeInsets.symmetric(
                vertical: DesignSystem.spacingSM,
              ),
          child: Text(
            label!,
            style: (DesignSystem.bodySmall).copyWith(
              color: DesignSystem.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: thickness,
            color: dividerColor,
          ),
        ),
        if (endIndent > 0) SizedBox(height: endIndent),
      ],
    );
  }
}

/// Section divider with larger spacing
class SectionDivider extends StatelessWidget {
  const SectionDivider({
    super.key,
    this.height = 24.0,
    this.color,
  });

  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Center(
        child: ModernDivider(color: color),
      ),
    );
  }
}

/// Dotted divider
class DottedDivider extends StatelessWidget {
  const DottedDivider({
    super.key,
    this.color,
    this.dotSize = 4.0,
    this.spacing = 4.0,
  });

  final Color? color;
  final double dotSize;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = color ??
        DesignSystem.textMuted.withAlpha(51) ??
        theme.dividerColor;

    return LayoutBuilder(
      builder: (context, constraints) {
        final dotCount = (constraints.maxWidth / (dotSize + spacing)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            dotCount,
            (index) => Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: dividerColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}