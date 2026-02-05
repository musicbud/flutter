import 'package:flutter/material.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

/// Input field size options
enum ModernInputFieldSize {
  small,
  medium,
  large,
}

/// Input field visual variants
enum ModernInputFieldVariant {
  outlined,
  underlined,
  filled,
}

/// A modern, customizable text input field.
///
/// Supports:
/// - Multiple variants (outlined, underlined, filled)
/// - Different sizes
/// - Labels and hints
/// - Prefix and suffix icons
/// - Password obscuring
/// - Custom styling
/// - Multi-line input
///
/// Example:
/// ```dart
/// ModernInputField(
///   label: 'Email',
///   hintText: 'Enter your email',
///   variant: ModernInputFieldVariant.outlined,
///   size: ModernInputFieldSize.large,
///   suffixIcon: Icon(Icons.email),
///   onChanged: (value) => updateEmail(value),
/// )
/// ```
class ModernInputField extends StatefulWidget {
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
    this.prefixIcon,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
    this.errorText,
  });

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
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final String? errorText;

  @override
  State<ModernInputField> createState() => _ModernInputFieldState();
}

class _ModernInputFieldState extends State<ModernInputField> {
  bool _isFocused = false;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.dispose();
    } else {
      _focusNode.removeListener(_onFocusChange);
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: TextFormField(
        controller: widget.controller,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        onTap: widget.onTap,
        focusNode: _focusNode,
        maxLines: widget.obscureText ? 1 : widget.maxLines,
        obscureText: widget.obscureText,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
        style: widget.customTextStyle ?? DesignSystem.bodyMedium,
        decoration: _getInputDecoration(),
      ),
    );
  }

  InputDecoration _getInputDecoration() {
    final borderRadius = BorderRadius.circular(_getBorderRadius());
    final borderSide = BorderSide(
      color: widget.customBorderColor ?? DesignSystem.textMuted,
    );
    final focusedBorderSide = BorderSide(
      color: widget.customBorderColor ?? DesignSystem.primaryRed,
      width: 2,
    );
    final errorBorderSide = BorderSide(
      color: DesignSystem.error,
      width: 2,
    );

    var decoration = InputDecoration(
      labelText: widget.label,
      hintText: widget.hintText,
      errorText: widget.errorText,
      labelStyle: widget.customLabelStyle ??
          DesignSystem.bodyMedium.copyWith(
            color: _isFocused
                ? DesignSystem.primaryRed
                : DesignSystem.textMuted,
          ),
      hintStyle: widget.customHintStyle ??
          DesignSystem.bodyMedium.copyWith(
            color: DesignSystem.textMuted,
          ),
      filled: widget.variant == ModernInputFieldVariant.filled,
      fillColor: widget.customBackgroundColor ??
          (widget.variant == ModernInputFieldVariant.filled
              ? DesignSystem.surfaceDark
              : Colors.transparent),
      suffixIcon: widget.suffixIcon,
      prefixIcon: widget.prefixIcon,
      contentPadding: EdgeInsets.symmetric(
        horizontal: _getHorizontalPadding(),
        vertical: _getVerticalPadding(),
      ),
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
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: errorBorderSide,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: errorBorderSide,
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
          errorBorder: UnderlineInputBorder(
            borderSide: errorBorderSide,
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: errorBorderSide,
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
          errorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: errorBorderSide,
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: errorBorderSide,
          ),
        );
        break;
    }

    return decoration;
  }

  double _getBorderRadius() {
    switch (widget.size) {
      case ModernInputFieldSize.small:
        return DesignSystem.radiusSM;
      case ModernInputFieldSize.medium:
        return DesignSystem.radiusMD;
      case ModernInputFieldSize.large:
        return DesignSystem.radiusLG;
    }
  }

  double _getVerticalPadding() {
    switch (widget.size) {
      case ModernInputFieldSize.small:
        return DesignSystem.spacingSM;
      case ModernInputFieldSize.medium:
        return DesignSystem.spacingMD;
      case ModernInputFieldSize.large:
        return DesignSystem.spacingLG;
    }
  }

  double _getHorizontalPadding() {
    return DesignSystem.spacingMD;
  }
}

// Convenience input field variants

/// Search input field with search icon
class SearchInputField extends StatelessWidget {
  const SearchInputField({
    super.key,
    this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.onSubmitted,
    this.size = ModernInputFieldSize.medium,
  });

  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ModernInputFieldSize size;

  @override
  Widget build(BuildContext context) {
    return ModernInputField(
      controller: controller,
      hintText: hintText,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      size: size,
      variant: ModernInputFieldVariant.filled,
      prefixIcon: const Icon(Icons.search),
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
    );
  }
}

/// Email input field with validation
class EmailInputField extends StatelessWidget {
  const EmailInputField({
    super.key,
    this.controller,
    this.label = 'Email',
    this.onChanged,
    this.onSubmitted,
    this.size = ModernInputFieldSize.medium,
  });

  final TextEditingController? controller;
  final String label;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ModernInputFieldSize size;

  @override
  Widget build(BuildContext context) {
    return ModernInputField(
      controller: controller,
      label: label,
      hintText: 'your@email.com',
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      size: size,
      variant: ModernInputFieldVariant.outlined,
      prefixIcon: const Icon(Icons.email_outlined),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an email';
        }
        if (!value.contains('@')) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }
}

/// Password input field with visibility toggle
class PasswordInputField extends StatefulWidget {
  const PasswordInputField({
    super.key,
    this.controller,
    this.label = 'Password',
    this.onChanged,
    this.onSubmitted,
    this.size = ModernInputFieldSize.medium,
  });

  final TextEditingController? controller;
  final String label;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final ModernInputFieldSize size;

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModernInputField(
      controller: widget.controller,
      label: widget.label,
      hintText: '••••••••',
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      size: widget.size,
      variant: ModernInputFieldVariant.outlined,
      obscureText: _obscureText,
      prefixIcon: const Icon(Icons.lock_outline),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        ),
        onPressed: _toggleVisibility,
      ),
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }
}