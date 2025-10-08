import "package:flutter/material.dart";
import '../../../core/theme/design_system.dart';

class ModernInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final ModernInputFieldSize size;
  final Color? customBackgroundColor;
  final Color? customBorderColor;
  final TextStyle? customTextStyle;
  final TextStyle? customLabelStyle;
  final TextStyle? customHintStyle;
  final ModernInputFieldVariant variant;
  final String? label;
  final int? maxLines;

  const ModernInputField({
    super.key,
    this.controller,
    this.hintText,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.size = ModernInputFieldSize.medium,
    this.customBackgroundColor,
    this.customBorderColor,
    this.customTextStyle,
    this.customLabelStyle,
    this.customHintStyle,
    this.variant = ModernInputFieldVariant.outlined,
    this.label,
    this.maxLines,
  });

  @override
  State<ModernInputField> createState() => _ModernInputFieldState();
}

class _ModernInputFieldState extends State<ModernInputField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      type: MaterialType.transparency,
      child: TextFormField(
        controller: widget.controller,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        // onSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        maxLines: widget.maxLines,
        style: widget.customTextStyle ?? theme.designSystem?.designSystemTypography.bodyMedium ?? const TextStyle(),
        decoration: _getInputDecoration(theme),
      ),
    );
  }

  InputDecoration _getInputDecoration(ThemeData theme) {
    final borderRadius = BorderRadius.circular(theme.designSystem?.designSystemRadius.md ?? 8.0);
    final borderSide = BorderSide(
      color: widget.customBorderColor ?? theme.designSystem?.designSystemColors.border ?? Colors.grey,
    );
    final focusedBorderSide = BorderSide(
      color: widget.customBorderColor ?? theme.designSystem?.designSystemColors.primary ?? Colors.blue,
      width: 2,
    );

    var decoration = InputDecoration(
      labelText: widget.label,
      hintText: widget.hintText,
      labelStyle: widget.customLabelStyle ?? theme.designSystem?.designSystemTypography.bodyMedium ?? const TextStyle(),
      hintStyle: widget.customHintStyle ?? theme.designSystem?.designSystemTypography.bodyMedium.copyWith(
        color: theme.designSystem?.designSystemColors.onSurfaceVariant ?? Colors.grey,
      ) ?? const TextStyle(color: Colors.grey),
      filled: widget.variant == ModernInputFieldVariant.filled,
      fillColor: widget.customBackgroundColor ?? (widget.variant == ModernInputFieldVariant.filled
        ? theme.designSystem?.designSystemColors.surfaceContainer ?? Colors.grey.shade100
        : Colors.transparent),
    );

    switch (widget.variant) {
      case ModernInputFieldVariant.outlined:
        decoration = decoration.copyWith(
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: borderSide,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: borderSide,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: focusedBorderSide,
          ),
        );
        break;
      case ModernInputFieldVariant.underlined:
        decoration = decoration.copyWith(
          border: UnderlineInputBorder(
            borderSide: borderSide,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: borderSide,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: focusedBorderSide,
          ),
        );
        break;
      case ModernInputFieldVariant.filled:
        decoration = decoration.copyWith(
          border: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: focusedBorderSide,
          ),
        );
        break;
    }

    // Apply size-specific padding
    final verticalPadding = widget.size == ModernInputFieldSize.small ? (theme.designSystem?.designSystemSpacing.xs ?? 8.0)
      : widget.size == ModernInputFieldSize.medium ? (theme.designSystem?.designSystemSpacing.sm ?? 12.0)
      : (theme.designSystem?.designSystemSpacing.md ?? 16.0);

    return decoration.copyWith(
      contentPadding: EdgeInsets.symmetric(
        horizontal: theme.designSystem?.designSystemSpacing.md ?? 16.0,
        vertical: verticalPadding,
      ),
    );
  }
}

enum ModernInputFieldSize {
  small,
  medium,
  large,
}

enum ModernInputFieldVariant {
  outlined,
  underlined,
  filled,
}
