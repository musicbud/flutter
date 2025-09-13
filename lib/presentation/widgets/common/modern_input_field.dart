import "package:flutter/material.dart";
import "../../constants/app_constants.dart";

class ModernInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ModernInputFieldSize size;
  final Color? customBackgroundColor;
  final Color? customBorderColor;
  final TextStyle? customTextStyle;
  final TextStyle? customLabelStyle;
  final TextStyle? customHintStyle;
  final ModernInputFieldVariant variant;

  const ModernInputField({
    super.key,
    this.controller,
    this.hintText,
    this.enabled = true,
    this.onChanged,
    this.onTap,
    this.size = ModernInputFieldSize.medium,
    this.customBackgroundColor,
    this.customBorderColor,
    this.customTextStyle,
    this.customLabelStyle,
    this.customHintStyle,
    this.variant = ModernInputFieldVariant.outlined,
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
        onTap: widget.onTap,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
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
  filled,
  outlined,
}
