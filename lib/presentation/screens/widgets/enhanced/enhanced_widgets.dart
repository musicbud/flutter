import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

// Enums
enum ModernButtonSize { small, medium, large }
enum ModernInputFieldSize { small, medium, large }
enum ModernCardVariant { primary, secondary }

// PrimaryButton Widget
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final ModernButtonSize? size;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.size = ModernButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null ? Icon(icon) : const SizedBox.shrink(),
      label: Text(text),
    );
  }
}

// ModernInputField Widget
class ModernInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final int maxLines;
  final ModernInputFieldSize? size;
  final Color? customBackgroundColor;

  const ModernInputField({
    super.key,
    this.controller,
    this.hintText,
    this.onChanged,
    this.onSubmitted,
    this.maxLines = 1,
    this.size = ModernInputFieldSize.medium,
    this.customBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: customBackgroundColor ?? DesignSystem.surfaceContainerHighest,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// ModernCard Widget
class ModernCard extends StatelessWidget {
  final Widget child;
  final ModernCardVariant? variant;
  final VoidCallback? onTap;

  const ModernCard({
    super.key,
    required this.child,
    this.variant = ModernCardVariant.primary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    switch (variant) {
      case ModernCardVariant.secondary:
        backgroundColor = DesignSystem.surfaceContainer;
        break;
      case ModernCardVariant.primary:
      default:
        backgroundColor = DesignSystem.surfaceContainer;
        break;
    }

    return Card(
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
      ),
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(DesignSystem.spacingMD),
          child: child,
        ),
      ),
    );
  }
}