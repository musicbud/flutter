import "package:flutter/material.dart";
import "../../../../core/theme/design_system.dart";

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
  final bool obscureText;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;

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
    this.obscureText = false,
    this.suffixIcon,
    this.validator,
    this.prefixIcon,
  });

  @override
  State<ModernInputField> createState() => _ModernInputFieldState();
}

class _ModernInputFieldState extends State<ModernInputField> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: TextFormField(
        controller: widget.controller,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        // onSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        obscureText: widget.obscureText,
        style: widget.customTextStyle ?? DesignSystem.bodyMedium,
        decoration: _getInputDecoration(context),
        validator: widget.validator,
      ),
    );
  }

  InputDecoration _getInputDecoration(BuildContext context) {
    final borderRadius = BorderRadius.circular(DesignSystem.radiusMD);
    final borderSide = BorderSide(
      color: widget.customBorderColor ?? DesignSystem.borderColor,
    );
    final focusedBorderSide = const BorderSide(
      color: DesignSystem.primary,
      width: 2,
    );

    var decoration = InputDecoration(
      labelText: widget.label,
      hintText: widget.hintText,
      labelStyle: widget.customLabelStyle ?? DesignSystem.bodyMedium,
      hintStyle: widget.customHintStyle ?? DesignSystem.bodyMedium.copyWith(
        color: DesignSystem.onSurfaceVariant,
      ),
      filled: widget.variant == ModernInputFieldVariant.filled,
      fillColor: widget.customBackgroundColor ?? (widget.variant == ModernInputFieldVariant.filled
        ? DesignSystem.surfaceContainer
        : Colors.transparent),
      suffixIcon: widget.suffixIcon,
      prefixIcon: widget.prefixIcon,
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
            borderRadius: borderRadius,
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
    final verticalPadding = widget.size == ModernInputFieldSize.small ? 8.0 
      : widget.size == ModernInputFieldSize.medium ? 12.0 
      : 16.0;
    
    return decoration.copyWith(
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
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