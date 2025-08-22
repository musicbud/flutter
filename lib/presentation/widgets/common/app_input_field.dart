import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';

enum AppInputVariant {
  primary,
  secondary,
  outline,
  filled,
  transparent,
  search,
  chat,
}

enum AppInputSize {
  small,
  medium,
  large,
  xlarge,
}

class AppInputField extends StatefulWidget {
  final String? label;
  final String? labelText; // Alias for label
  final String? hint;
  final String? hintText; // Alias for hint
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final int? maxLength;
  final AppInputVariant variant;
  final AppInputSize size;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final InputBorder? focusedBorder;
  final InputBorder? errorBorder;
  final InputBorder? enabledBorder;
  final InputBorder? disabledBorder;
  final Color? fillColor;
  final Color? labelColor;
  final Color? hintColor;
  final Color? textColor;
  final Color? errorColor;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final TextStyle? errorStyle;

  const AppInputField({
    super.key,
    this.label,
    this.labelText,
    this.hint,
    this.hintText,
    this.errorText,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.variant = AppInputVariant.primary,
    this.size = AppInputSize.medium,
    this.contentPadding,
    this.border,
    this.focusedBorder,
    this.errorBorder,
    this.enabledBorder,
    this.disabledBorder,
    this.fillColor,
    this.labelColor,
    this.hintColor,
    this.textColor,
    this.errorColor,
    this.labelStyle,
    this.hintStyle,
    this.textStyle,
    this.errorStyle,
  });

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: widget.labelStyle ??
              appTheme.typography.titleSmall.copyWith(
                color: appTheme.colors.white,
              ),
          ),
          SizedBox(height: appTheme.spacing.sm),
        ],
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          style: widget.textStyle ??
            appTheme.typography.bodyMedium.copyWith(
              color: appTheme.colors.white,
            ),
          decoration: _getInputDecoration(appTheme),
        ),
        if (widget.errorText != null) ...[
          SizedBox(height: appTheme.spacing.sm),
          Text(
            widget.errorText!,
            style: widget.errorStyle ??
              appTheme.typography.caption.copyWith(
                color: appTheme.colors.error,
              ),
          ),
        ],
      ],
    );
  }

  InputDecoration _getInputDecoration(AppTheme appTheme) {
    final baseDecoration = InputDecoration(
      hintText: widget.hint,
      hintStyle: widget.hintStyle ??
        appTheme.typography.bodyMedium.copyWith(
          color: appTheme.colors.lightGray,
        ),
      prefixIcon: widget.prefixIcon,
      suffixIcon: _buildSuffixIcon(),
      contentPadding: widget.contentPadding ?? _getContentPadding(appTheme),
      border: widget.border ?? _getBorder(appTheme),
      focusedBorder: widget.focusedBorder ?? _getFocusedBorder(appTheme),
      errorBorder: widget.errorBorder ?? _getErrorBorder(appTheme),
      enabledBorder: widget.enabledBorder ?? _getEnabledBorder(appTheme),
      disabledBorder: widget.disabledBorder ?? _getDisabledBorder(appTheme),
      filled: widget.variant == AppInputVariant.filled,
      fillColor: widget.fillColor ?? _getFillColor(appTheme),
    );

    return baseDecoration;
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    return widget.suffixIcon;
  }

  EdgeInsetsGeometry _getContentPadding(AppTheme appTheme) {
    switch (widget.size) {
      case AppInputSize.small:
        return EdgeInsets.symmetric(
          horizontal: appTheme.spacing.md,
          vertical: appTheme.spacing.sm,
        );
      case AppInputSize.medium:
        return EdgeInsets.symmetric(
          horizontal: appTheme.spacing.md,
          vertical: appTheme.spacing.md,
        );
      case AppInputSize.large:
        return EdgeInsets.symmetric(
          horizontal: appTheme.spacing.lg,
          vertical: appTheme.spacing.md,
        );
      case AppInputSize.xlarge:
        return EdgeInsets.symmetric(
          horizontal: appTheme.spacing.xl,
          vertical: appTheme.spacing.lg,
        );
    }
  }

  InputBorder _getBorder(AppTheme appTheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(appTheme.radius.md),
      borderSide: BorderSide(
        color: appTheme.colors.primaryRed.withValues(alpha: 0.3),
      ),
    );
  }

  InputBorder _getFocusedBorder(AppTheme appTheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(appTheme.radius.md),
      borderSide: BorderSide(
        color: appTheme.colors.primaryRed,
        width: 2,
      ),
    );
  }

  InputBorder _getErrorBorder(AppTheme appTheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(appTheme.radius.md),
      borderSide: BorderSide(
        color: appTheme.colors.error,
        width: 2,
      ),
    );
  }

  InputBorder _getEnabledBorder(AppTheme appTheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(appTheme.radius.md),
      borderSide: BorderSide(
        color: appTheme.colors.lightGray.withValues(alpha: 0.3),
      ),
    );
  }

  InputBorder _getDisabledBorder(AppTheme appTheme) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(appTheme.radius.md),
      borderSide: BorderSide(
        color: appTheme.colors.lightGray.withValues(alpha: 0.2),
      ),
    );
  }

  Color _getFillColor(AppTheme appTheme) {
    switch (widget.variant) {
      case AppInputVariant.primary:
        return appTheme.colors.white;
      case AppInputVariant.secondary:
        return appTheme.colors.lightGray.withValues(alpha: 0.1);
      case AppInputVariant.outline:
        return appTheme.colors.white;
      case AppInputVariant.filled:
        return appTheme.colors.lightGray.withValues(alpha: 0.1);
      case AppInputVariant.transparent:
        return appTheme.colors.transparent;
      case AppInputVariant.search:
        return appTheme.colors.white;
      case AppInputVariant.chat:
        return appTheme.colors.white;
    }
  }
}

// Factory constructors for common input field types
class AppInputFields {
  static AppInputField search({
    Key? key,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return AppInputField(
      key: key,
      hint: hint ?? 'Search...',
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      prefixIcon: const Icon(Icons.search, color: Colors.grey),
      variant: AppInputVariant.outline,
      size: AppInputSize.medium,
    );
  }

  static AppInputField chat({
    Key? key,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onSubmitted,
  }) {
    return AppInputField(
      key: key,
      hint: hint ?? 'Type a message...',
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      variant: AppInputVariant.filled,
      size: AppInputSize.medium,
    );
  }

  static AppInputField profile({
    Key? key,
    String? label,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
  }) {
    return AppInputField(
      key: key,
      label: label,
      hint: hint,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      variant: AppInputVariant.outline,
      size: AppInputSize.medium,
    );
  }

  static AppInputField event({
    Key? key,
    String? label,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
  }) {
    return AppInputField(
      key: key,
      label: label,
      hint: hint,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      variant: AppInputVariant.outline,
      size: AppInputSize.medium,
    );
  }

  static AppInputField password({
    Key? key,
    String? label,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
  }) {
    return AppInputField(
      key: key,
      label: label,
      hint: hint,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      obscureText: true,
      variant: AppInputVariant.outline,
      size: AppInputSize.medium,
    );
  }

  static AppInputField email({
    Key? key,
    String? label,
    String? hint,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
  }) {
    return AppInputField(
      key: key,
      label: label,
      hint: hint,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      keyboardType: TextInputType.emailAddress,
      variant: AppInputVariant.outline,
      size: AppInputSize.medium,
    );
  }
}