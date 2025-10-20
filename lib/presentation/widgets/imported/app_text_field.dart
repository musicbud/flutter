import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A reusable text field widget with consistent styling
class AppTextField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final FocusNode? focusNode;
  final EdgeInsetsGeometry? contentPadding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;

  const AppTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.focusNode,
    this.contentPadding,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      readOnly: readOnly,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: backgroundColor ?? const Color.fromARGB(82, 137, 141, 178),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? DesignSystem.borderLight,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? DesignSystem.borderLight,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(
            color: borderColor ?? DesignSystem.primaryContainer,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2,
          ),
        ),
        hintStyle: TextStyle(
          color: DesignSystem.borderLight.withValues(alpha: 0.7),
          fontSize: 16,
        ),
        labelStyle: const TextStyle(
          color: DesignSystem.borderLight,
          fontSize: 16,
        ),
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      ),
      style: const TextStyle(
        color: DesignSystem.borderLight,
        fontSize: 16,
      ),
    );
  }
}