import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';

enum AppButtonVariant {
  primary,
  secondary,
  text,
  ghost,
}

enum AppButtonSize {
  small,
  medium,
  large,
  xlarge,
}

/// Reusable Button Component based on Figma Design
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final Color? textColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final bool isOutlined;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.textColor,
    this.borderColor,
    this.backgroundColor,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return SizedBox(
      width: width,
      height: _getHeight(),
      child: ElevatedButton(
        onPressed: (isDisabled || isLoading) ? null : onPressed,
        style: _getButtonStyle(appTheme),
        child: _buildContent(appTheme),
      ),
    );
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return 40;
      case AppButtonSize.medium:
        return 48;
      case AppButtonSize.large:
        return 56;
      case AppButtonSize.xlarge:
        return 64;
    }
  }

  ButtonStyle _getButtonStyle(AppTheme appTheme) {
    Color? buttonColor;
    Color? buttonTextColor;
    Color? buttonBorderColor;
    EdgeInsetsGeometry? padding;

    // Set colors based on variant
    switch (variant) {
      case AppButtonVariant.primary:
        buttonColor = backgroundColor ?? appTheme.colors.primaryRed;
        buttonTextColor = textColor ?? appTheme.colors.white;
        buttonBorderColor = borderColor ?? appTheme.colors.primaryRed;
        break;
      case AppButtonVariant.secondary:
        buttonColor = backgroundColor ?? appTheme.colors.transparent;
        buttonTextColor = textColor ?? appTheme.colors.primaryRed;
        buttonBorderColor = borderColor ?? appTheme.colors.primaryRed;
        break;
      case AppButtonVariant.text:
        buttonColor = backgroundColor ?? appTheme.colors.transparent;
        buttonTextColor = textColor ?? appTheme.colors.primaryRed;
        buttonBorderColor = borderColor ?? appTheme.colors.transparent;
        break;
      case AppButtonVariant.ghost:
        buttonColor = backgroundColor ?? appTheme.colors.transparent;
        buttonTextColor = textColor ?? appTheme.colors.white;
        buttonBorderColor = borderColor ?? appTheme.colors.lightGray;
        break;
    }

    // Set padding based on size
    switch (size) {
      case AppButtonSize.small:
        padding = EdgeInsets.symmetric(
          horizontal: appTheme.spacing.md,
          vertical: appTheme.spacing.sm,
        );
        break;
      case AppButtonSize.medium:
        padding = EdgeInsets.symmetric(
          horizontal: appTheme.spacing.lg,
          vertical: appTheme.spacing.md,
        );
        break;
      case AppButtonSize.large:
        padding = EdgeInsets.symmetric(
          horizontal: appTheme.spacing.xl,
          vertical: appTheme.spacing.lg,
        );
        break;
      case AppButtonSize.xlarge:
        padding = EdgeInsets.symmetric(
          horizontal: appTheme.spacing.xxl,
          vertical: appTheme.spacing.xl,
        );
        break;
    }

    return ElevatedButton.styleFrom(
      backgroundColor: isOutlined ? appTheme.colors.transparent : buttonColor,
      foregroundColor: buttonTextColor,
      side: isOutlined || buttonBorderColor != appTheme.colors.transparent
          ? BorderSide(color: buttonBorderColor, width: 2)
          : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(appTheme.radius.md),
      ),
      padding: padding,
      elevation: isOutlined ? 0 : (variant == AppButtonVariant.primary ? 4 : 0),
      shadowColor: isOutlined ? null : appTheme.colors.primaryRed.withValues(alpha:  0.3),
    );
  }

  Widget _buildContent(AppTheme appTheme) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == AppButtonVariant.primary
                ? appTheme.colors.white
                : appTheme.colors.primaryRed,
          ),
        ),
      );
    }

    final List<Widget> children = [];

    if (icon != null) {
      children.add(Icon(icon, size: _getIconSize()));
      children.add(SizedBox(width: appTheme.spacing.sm));
    }

    children.add(Text(
      text,
      style: _getTextStyle(appTheme),
    ));

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
      case AppButtonSize.xlarge:
        return 28;
    }
  }

  TextStyle _getTextStyle(AppTheme appTheme) {
    switch (size) {
      case AppButtonSize.small:
        return appTheme.typography.titleSmall.copyWith(
          fontWeight: FontWeight.w600,
        );
      case AppButtonSize.medium:
        return appTheme.typography.titleMedium.copyWith(
          fontWeight: FontWeight.w600,
        );
      case AppButtonSize.large:
        return appTheme.typography.titleLarge.copyWith(
          fontWeight: FontWeight.w600,
        );
      case AppButtonSize.xlarge:
        return appTheme.typography.headlineH7.copyWith(
          fontWeight: FontWeight.w600,
        );
    }
  }

  // Helper methods for common button styles
  static AppButton primary({
    required String text,
    required VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    IconData? icon,
    bool isLoading = false,
    double? width,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.primary,
      size: size,
      icon: icon,
      isLoading: isLoading,
      width: width,
    );
  }

  static AppButton secondary({
    required String text,
    required VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    IconData? icon,
    bool isLoading = false,
    double? width,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.secondary,
      size: size,
      icon: icon,
      isLoading: isLoading,
      width: width,
    );
  }

  static AppButton ghost({
    required String text,
    required VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    IconData? icon,
    bool isLoading = false,
    double? width,
    Color? textColor,
    Color? borderColor,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.ghost,
      size: size,
      icon: icon,
      isLoading: isLoading,
      width: width,
      textColor: textColor,
      borderColor: borderColor,
    );
  }

  static AppButton tag({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.secondary,
      size: AppButtonSize.small,
      icon: icon,
    );
  }

  static AppButton matchNow({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.primary,
      size: AppButtonSize.large,
      icon: icon,
    );
  }
}

// Convenience class for common button patterns
class AppButtons {
  static AppButton primary({
    required String text,
    required VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    IconData? icon,
    bool isLoading = false,
    double? width,
  }) {
    return AppButton.primary(
      text: text,
      onPressed: onPressed,
      size: size,
      icon: icon,
      isLoading: isLoading,
      width: width,
    );
  }

  static AppButton secondary({
    required String text,
    required VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    IconData? icon,
    bool isLoading = false,
    double? width,
  }) {
    return AppButton.secondary(
      text: text,
      onPressed: onPressed,
      size: size,
      icon: icon,
      isLoading: isLoading,
      width: width,
    );
  }

  static AppButton ghost({
    required String text,
    required VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    IconData? icon,
    bool isLoading = false,
    double? width,
    Color? textColor,
    Color? borderColor,
  }) {
    return AppButton.ghost(
      text: text,
      onPressed: onPressed,
      size: size,
      icon: icon,
      isLoading: isLoading,
      width: width,
      textColor: textColor,
      borderColor: borderColor,
    );
  }

  static AppButton tag({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
  }) {
    return AppButton.tag(
      text: text,
      onPressed: onPressed,
      icon: icon,
    );
  }

  static AppButton matchNow({
    required String text,
    required VoidCallback? onPressed,
    IconData? icon,
  }) {
    return AppButton.matchNow(
      text: text,
      onPressed: onPressed,
      icon: icon,
    );
  }
}