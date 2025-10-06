import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ModernInputVariant {
  outlined,
  filled,
  underlined,
}

class ModernInputField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? labelText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final ModernInputVariant variant;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? textStyle;
  final Color? fillColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final double borderRadius;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode? autovalidateMode;
  final FocusNode? focusNode;

  const ModernInputField({
    Key? key,
    this.controller,
    this.hintText,
    this.labelText,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.onSaved,
    this.validator,
    this.variant = ModernInputVariant.outlined,
    this.contentPadding,
    this.hintStyle,
    this.labelStyle,
    this.textStyle,
    this.fillColor,
    this.borderColor,
    this.focusedBorderColor,
    this.borderRadius = 12.0,
    this.inputFormatters,
    this.autovalidateMode,
    this.focusNode,
  }) : super(key: key);

  @override
  State<ModernInputField> createState() => _ModernInputFieldState();
}

class _ModernInputFieldState extends State<ModernInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
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
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: widget.labelStyle ?? theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: (widget.focusedBorderColor ?? theme.colorScheme.primary).withValues(alpha: 0.1),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: TextFormField(
            controller: widget.controller,
            focusNode: _focusNode,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.obscureText,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            maxLines: widget.maxLines,
            minLines: widget.minLines,
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            autovalidateMode: widget.autovalidateMode,
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            onTap: widget.onTap,
            onSaved: widget.onSaved,
            validator: widget.validator,
            style: widget.textStyle ?? theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText,
              errorText: widget.errorText,
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              hintStyle: widget.hintStyle ?? theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              filled: widget.variant == ModernInputVariant.filled,
              fillColor: widget.fillColor ?? (widget.variant == ModernInputVariant.filled
                  ? theme.colorScheme.surface
                  : null),
              border: _getBorder(theme),
              enabledBorder: _getBorder(theme),
              focusedBorder: _getFocusedBorder(theme),
              errorBorder: _getErrorBorder(theme),
              focusedErrorBorder: _getErrorBorder(theme),
              disabledBorder: _getBorder(theme),
            ),
          ),
        ),
      ],
    );
  }

  InputBorder _getBorder(ThemeData theme) {
    final color = widget.borderColor ?? theme.colorScheme.outline;
    final width = _isFocused ? 2.0 : 1.0;

    switch (widget.variant) {
      case ModernInputVariant.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: color, width: width),
        );
      case ModernInputVariant.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide.none,
        );
      case ModernInputVariant.underlined:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: width),
        );
    }
  }

  InputBorder _getFocusedBorder(ThemeData theme) {
    final color = widget.focusedBorderColor ?? theme.colorScheme.primary;

    switch (widget.variant) {
      case ModernInputVariant.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: color, width: 2.0),
        );
      case ModernInputVariant.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: color, width: 2.0),
        );
      case ModernInputVariant.underlined:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: color, width: 2.0),
        );
    }
  }

  InputBorder _getErrorBorder(ThemeData theme) {
    switch (widget.variant) {
      case ModernInputVariant.outlined:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2.0),
        );
      case ModernInputVariant.filled:
        return OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2.0),
        );
      case ModernInputVariant.underlined:
        return UnderlineInputBorder(
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2.0),
        );
    }
  }
}