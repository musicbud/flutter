import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';

/// Reusable Button Component based on Figma Design
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final Widget? icon;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.icon,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    final buttonStyle = _getButtonStyle();
    final buttonSize = _getButtonSize();

    if (isLoading) {
      return _buildLoadingButton(buttonStyle, buttonSize);
    }

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: _buildButtonContent(),
        );
      case AppButtonVariant.secondary:
        return OutlinedButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: _buildButtonContent(),
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: onPressed,
          style: buttonStyle,
          child: _buildButtonContent(),
        );
      case AppButtonVariant.ghost:
        return _buildGhostButton(buttonStyle);
    }
  }

  Widget _buildLoadingButton(ButtonStyle buttonStyle, Size buttonSize) {
    return SizedBox(
      height: buttonSize.height,
      child: ElevatedButton(
        onPressed: null,
        style: buttonStyle,
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              variant == AppButtonVariant.primary
                  ? AppTheme.neutralWhite
                  : AppTheme.primaryPink,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGhostButton(ButtonStyle buttonStyle) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.transparentWhite,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppTheme.radiusM,
        ),
        border: Border.all(
          color: AppTheme.transparentWhite,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(
            borderRadius ?? AppTheme.radiusM,
          ),
          child: Container(
            padding: padding ?? _getDefaultPadding(),
            child: _buildButtonContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonContent() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          icon!,
          SizedBox(width: AppTheme.spacingS),
        ],
        Text(
          text,
          style: _getTextStyle(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  ButtonStyle _getButtonStyle() {
    final buttonSize = _getButtonSize();
    final defaultPadding = _getDefaultPadding();

    switch (variant) {
      case AppButtonVariant.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryPink,
          foregroundColor: AppTheme.neutralWhite,
          padding: padding ?? defaultPadding,
          minimumSize: buttonSize,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppTheme.radiusM,
            ),
          ),
          elevation: 0,
          shadowColor: Colors.transparent,
        );
      case AppButtonVariant.secondary:
        return OutlinedButton.styleFrom(
          foregroundColor: AppTheme.primaryPink,
          side: const BorderSide(
            color: AppTheme.primaryPink,
            width: 1,
          ),
          padding: padding ?? defaultPadding,
          minimumSize: buttonSize,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppTheme.radiusM,
            ),
          ),
        );
      case AppButtonVariant.text:
        return TextButton.styleFrom(
          foregroundColor: AppTheme.primaryPink,
          padding: padding ?? defaultPadding,
          minimumSize: buttonSize,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius ?? AppTheme.radiusM,
            ),
          ),
        );
      case AppButtonVariant.ghost:
        return ButtonStyle(
          padding: MaterialStateProperty.all(
            padding ?? defaultPadding,
          ),
          minimumSize: MaterialStateProperty.all(buttonSize),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                borderRadius ?? AppTheme.radiusM,
              ),
            ),
          ),
        );
    }
  }

  Size _getButtonSize() {
    switch (size) {
      case AppButtonSize.small:
        return const Size(80, 32);
      case AppButtonSize.medium:
        return const Size(120, 40);
      case AppButtonSize.large:
        return const Size(160, 48);
      case AppButtonSize.xlarge:
        return const Size(200, 56);
    }
  }

  EdgeInsetsGeometry _getDefaultPadding() {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingM,
          vertical: AppTheme.spacingS,
        );
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingXL,
          vertical: AppTheme.spacingM,
        );
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingXXL,
          vertical: AppTheme.spacingL,
        );
      case AppButtonSize.xlarge:
        return const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingXXXL,
          vertical: AppTheme.spacingXL,
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return AppTheme.overline.copyWith(
          color: _getTextColor(),
        );
      case AppButtonSize.medium:
        return AppTheme.caption.copyWith(
          color: _getTextColor(),
        );
      case AppButtonSize.large:
        return AppTheme.bodyH10.copyWith(
          color: _getTextColor(),
        );
      case AppButtonSize.xlarge:
        return AppTheme.bodyH9.copyWith(
          color: _getTextColor(),
        );
    }
  }

  Color _getTextColor() {
    switch (variant) {
      case AppButtonVariant.primary:
        return AppTheme.neutralWhite;
      case AppButtonVariant.secondary:
      case AppButtonVariant.text:
        return AppTheme.primaryPink;
      case AppButtonVariant.ghost:
        return AppTheme.neutralWhite;
    }
  }
}

/// Button Variants
enum AppButtonVariant {
  primary,
  secondary,
  text,
  ghost,
}

/// Button Sizes
enum AppButtonSize {
  small,
  medium,
  large,
  xlarge,
}

/// Predefined Button Styles for Common Use Cases
class AppButtons {
  static AppButton primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    Widget? icon,
    bool isFullWidth = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.primary,
      size: size,
      isLoading: isLoading,
      icon: icon,
      isFullWidth: isFullWidth,
    );
  }

  static AppButton secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    Widget? icon,
    bool isFullWidth = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.secondary,
      size: size,
      isLoading: isLoading,
      icon: icon,
      isFullWidth: isFullWidth,
    );
  }

  static AppButton ghost({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    Widget? icon,
    bool isFullWidth = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.ghost,
      size: size,
      isLoading: isLoading,
      icon: icon,
      isFullWidth: isFullWidth,
    );
  }

  static AppButton matchNow({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.primary,
      size: AppButtonSize.small,
      isLoading: isLoading,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: AppTheme.spacingM,
      ),
    );
  }

  static AppButton tag({
    Key? key,
    required String text,
    VoidCallback? onPressed,
  }) {
    return AppButton(
      key: key,
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.ghost,
      size: AppButtonSize.small,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingS,
        vertical: AppTheme.spacingM,
      ),
      borderRadius: AppTheme.radiusM,
    );
  }
}