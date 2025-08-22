import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';

/// Reusable Input Field Component based on Figma Design
class AppInputField extends StatefulWidget {
  final String? label;
  final String? hintText;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onEditingComplete;
  final FormFieldValidator<String>? validator;
  final AppInputVariant variant;
  final AppInputSize size;
  final bool isFullWidth;
  final EdgeInsetsGeometry? contentPadding;
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? textColor;
  final Color? hintColor;

  const AppInputField({
    super.key,
    this.label,
    this.hintText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.validator,
    this.variant = AppInputVariant.default_,
    this.size = AppInputSize.medium,
    this.isFullWidth = true,
    this.contentPadding,
    this.borderRadius,
    this.backgroundColor,
    this.borderColor,
    this.textColor,
    this.hintColor,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  late FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isFullWidth ? double.infinity : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null) ...[
            Text(
              widget.label!,
              style: _getLabelStyle(),
            ),
            SizedBox(height: AppTheme.spacingS),
          ],
          _buildInputField(),
          if (widget.errorText != null) ...[
            SizedBox(height: AppTheme.spacingS),
            Text(
              widget.errorText!,
              style: AppTheme.overline.copyWith(
                color: AppTheme.errorRed,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInputField() {
    final inputDecoration = _getInputDecoration();
    final inputSize = _getInputSize();

    return Container(
      height: inputSize.height,
      child: TextFormField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        enabled: widget.enabled,
        readOnly: widget.readOnly,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        onTap: widget.onTap,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onSubmitted,
        onEditingComplete: widget.onEditingComplete,
        validator: widget.validator,
        style: _getTextStyle(),
        decoration: inputDecoration,
      ),
    );
  }

  InputDecoration _getInputDecoration() {
    final defaultPadding = _getDefaultPadding();
    final defaultBorderRadius = _getDefaultBorderRadius();

    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: _getHintStyle(),
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon,
      filled: true,
      fillColor: widget.backgroundColor ?? _getDefaultBackgroundColor(),
      contentPadding: widget.contentPadding ?? defaultPadding,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          widget.borderRadius ?? defaultBorderRadius,
        ),
        borderSide: BorderSide(
          color: widget.borderColor ?? _getDefaultBorderColor(),
          width: 1,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          widget.borderRadius ?? defaultBorderRadius,
        ),
        borderSide: BorderSide(
          color: widget.borderColor ?? _getDefaultBorderColor(),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          widget.borderRadius ?? defaultBorderRadius,
        ),
        borderSide: BorderSide(
          color: AppTheme.primaryPink,
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          widget.borderRadius ?? defaultBorderRadius,
        ),
        borderSide: BorderSide(
          color: AppTheme.errorRed,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          widget.borderRadius ?? defaultBorderRadius,
        ),
        borderSide: BorderSide(
          color: AppTheme.errorRed,
          width: 1,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          widget.borderRadius ?? defaultBorderRadius,
        ),
        borderSide: BorderSide(
          color: AppTheme.neutralGray,
          width: 1,
        ),
      ),
    );
  }

  Size _getInputSize() {
    switch (widget.size) {
      case AppInputSize.small:
        return const Size(0, 40);
      case AppInputSize.medium:
        return const Size(0, 48);
      case AppInputSize.large:
        return const Size(0, 56);
      case AppInputSize.xlarge:
        return const Size(0, 64);
    }
  }

  EdgeInsetsGeometry _getDefaultPadding() {
    switch (widget.size) {
      case AppInputSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        );
      case AppInputSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingXL,
          vertical: AppTheme.spacingM,
        );
      case AppInputSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingXXL,
          vertical: AppTheme.spacingL,
        );
      case AppInputSize.xlarge:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingXXXL,
          vertical: AppTheme.spacingXL,
        );
    }
  }

  double _getDefaultBorderRadius() {
    switch (widget.variant) {
      case AppInputVariant.default_:
        return AppTheme.radiusXL;
      case AppInputVariant.rounded:
        return AppTheme.radiusXXL;
      case AppInputVariant.square:
        return AppTheme.radiusS;
      case AppInputVariant.pill:
        return AppTheme.radiusCircular;
    }
  }

  Color _getDefaultBackgroundColor() {
    switch (widget.variant) {
      case AppInputVariant.default_:
        return AppTheme.neutralBlack;
      case AppInputVariant.light:
        return AppTheme.neutralWhite;
      case AppInputVariant.transparent:
        return Colors.transparent;
      case AppInputVariant.glass:
        return AppTheme.semiTransparentWhite;
    }
  }

  Color _getDefaultBorderColor() {
    if (_isFocused) {
      return AppTheme.primaryPink;
    }

    switch (widget.variant) {
      case AppInputVariant.default_:
        return AppTheme.transparentWhite;
      case AppInputVariant.light:
        return AppTheme.neutralGray;
      case AppInputVariant.transparent:
        return AppTheme.transparentWhite;
      case AppInputVariant.glass:
        return AppTheme.transparentWhite;
    }
  }

  TextStyle _getLabelStyle() {
    switch (widget.size) {
      case AppInputSize.small:
        return AppTheme.overline.copyWith(
          color: AppTheme.neutralLightGray,
        );
      case AppInputSize.medium:
        return AppTheme.caption.copyWith(
          color: AppTheme.neutralLightGray,
        );
      case AppInputSize.large:
        return AppTheme.bodyH10.copyWith(
          color: AppTheme.neutralLightGray,
        );
      case AppInputSize.xlarge:
        return AppTheme.bodyH9.copyWith(
          color: AppTheme.neutralLightGray,
        );
    }
  }

  TextStyle _getTextStyle() {
    final baseStyle = switch (widget.size) {
      AppInputSize.small => AppTheme.overline,
      AppInputSize.medium => AppTheme.caption,
      AppInputSize.large => AppTheme.bodyH10,
      AppInputSize.xlarge => AppTheme.bodyH9,
    };

    return baseStyle.copyWith(
      color: widget.textColor ?? _getDefaultTextColor(),
    );
  }

  TextStyle _getHintStyle() {
    final baseStyle = switch (widget.size) {
      AppInputSize.small => AppTheme.overline,
      AppInputSize.medium => AppTheme.caption,
      AppInputSize.large => AppTheme.bodyH10,
      AppInputSize.xlarge => AppTheme.bodyH9,
    };

    return baseStyle.copyWith(
      color: widget.hintColor ?? _getDefaultHintColor(),
    );
  }

  Color _getDefaultTextColor() {
    switch (widget.variant) {
      case AppInputVariant.default_:
        return AppTheme.neutralWhite;
      case AppInputVariant.light:
        return AppTheme.neutralText;
      case AppInputVariant.transparent:
        return AppTheme.neutralWhite;
      case AppInputVariant.glass:
        return AppTheme.neutralWhite;
    }
  }

  Color _getDefaultHintColor() {
    switch (widget.variant) {
      case AppInputVariant.default_:
        return AppTheme.neutralLightGray;
      case AppInputVariant.light:
        return AppTheme.neutralGray;
      case AppInputVariant.transparent:
        return AppTheme.neutralLightGray;
      case AppInputVariant.glass:
        return AppTheme.neutralLightGray;
    }
  }
}

/// Input Variants
enum AppInputVariant {
  default_,
  light,
  transparent,
  glass,
}

/// Input Sizes
enum AppInputSize {
  small,
  medium,
  large,
  xlarge,
}

/// Predefined Input Styles for Common Use Cases
class AppInputs {
  /// Search Input Field
  static AppInputField search({
    Key? key,
    String? hintText,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onTap,
  }) {
    return AppInputField(
      key: key,
      hintText: hintText ?? 'What do you want to listen to?',
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      variant: AppInputVariant.outlined,
      size: AppInputSize.medium,
      prefixIcon: Icon(
        Icons.search,
        color: AppTheme.neutralLightGray,
        size: 20,
      ),
      suffixIcon: Icon(
        Icons.mic,
        color: AppTheme.neutralLightGray,
        size: 20,
      ),
    );
  }

  /// Chat Input Field
  static AppInputField chat({
    Key? key,
    String? hintText,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onTap,
  }) {
    return AppInputField(
      key: key,
      hintText: hintText ?? 'Type a message...',
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      variant: AppInputVariant.outlined,
      size: AppInputSize.medium,
      maxLines: 3,
      prefixIcon: Icon(
        Icons.attach_file,
        color: AppTheme.neutralLightGray,
        size: 20,
      ),
      suffixIcon: Icon(
        Icons.send,
        color: AppTheme.primaryPink,
        size: 20,
      ),
    );
  }

  /// Profile Input Field
  static AppInputField profile({
    Key? key,
    String? label,
    String? hintText,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return AppInputField(
      key: key,
      label: label,
      hintText: hintText,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      keyboardType: keyboardType,
      variant: AppInputVariant.outlined,
      size: AppInputSize.medium,
    );
  }

  /// Event Input Field
  static AppInputField event({
    Key? key,
    String? label,
    String? hintText,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
    VoidCallback? onTap,
    TextInputType? keyboardType,
  }) {
    return AppInputField(
      key: key,
      label: label,
      hintText: hintText,
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      keyboardType: keyboardType,
      variant: AppInputVariant.outlined,
      size: AppInputSize.medium,
    );
  }
}