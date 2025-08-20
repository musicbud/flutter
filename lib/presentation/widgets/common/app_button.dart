import 'package:flutter/material.dart';

/// A reusable button widget with consistent styling
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final Widget? icon;
  final bool isLoading;
  final bool isOutlined;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height = 48,
    this.borderRadius = 12,
    this.padding,
    this.icon,
    this.isLoading = false,
    this.isOutlined = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            backgroundColor: backgroundColor ?? Colors.transparent,
            foregroundColor: textColor ?? Colors.white,
            side: BorderSide(
              color: textColor ?? Colors.white,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            minimumSize: Size(width ?? double.infinity, height),
          )
        : ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? const Color(0xFFFF6B8F),
            foregroundColor: textColor ?? Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            minimumSize: Size(width ?? double.infinity, height),
          );

    final button = isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: _buildButtonContent(),
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: _buildButtonContent(),
          );

    return button;
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            textColor ?? Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon!,
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}