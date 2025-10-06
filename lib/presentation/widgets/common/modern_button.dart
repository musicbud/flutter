import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

enum ModernButtonVariant {
  primary,
  secondary,
  accent,
  outline,
  text,
  gradient,
}

enum ModernButtonSize {
  small,
  medium,
  large,
  extraLarge,
}

class ModernButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final ModernButtonVariant variant;
  final ModernButtonSize size;
  final IconData? icon;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isFullWidth;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final Color? customColor;
  final Gradient? customGradient;
  final TextStyle? textStyle;
  final Widget? child;

  const ModernButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ModernButtonVariant.primary,
    this.size = ModernButtonSize.medium,
    this.icon,
    this.trailingIcon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.padding,
    this.borderRadius,
    this.customColor,
    this.customGradient,
    this.textStyle,
    this.child,
  });

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _shadowAnimation;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _shadowAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _onHover(true),
            onExit: (_) => _onHover(false),
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              onTap: widget.onPressed,
              child: Container(
                width: widget.isFullWidth ? double.infinity : null,
                padding: _getPadding(appTheme),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? _getBorderRadius(appTheme),
                  ),
                  color: _getBackgroundColor(appTheme),
                  gradient: _getGradient(appTheme),
                  border: _getBorder(appTheme),
                  boxShadow: _getShadows(appTheme),
                ),
                child: _buildContent(appTheme),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(AppTheme appTheme) {
    if (widget.isLoading) {
      return SizedBox(
        height: _getIconSize(appTheme),
        width: _getIconSize(appTheme),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getTextColor(appTheme),
          ),
        ),
      );
    }

    final content = widget.child ?? Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.icon != null) ...[
          Icon(
            widget.icon,
            size: _getIconSize(appTheme),
            color: _getTextColor(appTheme),
          ),
          if (widget.text.isNotEmpty) SizedBox(width: appTheme.spacing.sm),
        ],
        if (widget.text.isNotEmpty)
          Flexible(
            child: Text(
              widget.text,
              style: _getTextStyle(appTheme),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (widget.trailingIcon != null) ...[
          if (widget.text.isNotEmpty) SizedBox(width: appTheme.spacing.sm),
          Icon(
            widget.trailingIcon,
            size: _getIconSize(appTheme),
            color: _getTextColor(appTheme),
          ),
        ],
      ],
    );

    return content;
  }

  EdgeInsetsGeometry _getPadding(AppTheme appTheme) {
    if (widget.padding != null) return widget.padding!;

    switch (widget.size) {
      case ModernButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: appTheme.spacing.md,
          vertical: appTheme.spacing.sm,
        );
      case ModernButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: appTheme.spacing.lg,
          vertical: appTheme.spacing.md,
        );
      case ModernButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: appTheme.spacing.xl,
          vertical: appTheme.spacing.lg,
        );
      case ModernButtonSize.extraLarge:
        return EdgeInsets.symmetric(
          horizontal: appTheme.spacing.xxl,
          vertical: appTheme.spacing.xl,
        );
    }
  }

  double _getBorderRadius(AppTheme appTheme) {
    switch (widget.size) {
      case ModernButtonSize.small:
        return appTheme.radius.sm;
      case ModernButtonSize.medium:
        return appTheme.radius.md;
      case ModernButtonSize.large:
        return appTheme.radius.lg;
      case ModernButtonSize.extraLarge:
        return appTheme.radius.xl;
    }
  }

  double _getIconSize(AppTheme appTheme) {
    switch (widget.size) {
      case ModernButtonSize.small:
        return 16;
      case ModernButtonSize.medium:
        return 20;
      case ModernButtonSize.large:
        return 24;
      case ModernButtonSize.extraLarge:
        return 28;
    }
  }

  Color _getBackgroundColor(AppTheme appTheme) {
    if (widget.customColor != null) return widget.customColor!;

    if (widget.onPressed == null) {
      return appTheme.colors.textMuted;
    }

    switch (widget.variant) {
      case ModernButtonVariant.primary:
        return appTheme.colors.primaryRed;
      case ModernButtonVariant.secondary:
        return appTheme.colors.surfaceDark;
      case ModernButtonVariant.accent:
        return appTheme.colors.accentBlue;
      case ModernButtonVariant.outline:
      case ModernButtonVariant.text:
      case ModernButtonVariant.gradient:
        return Colors.transparent;
    }
  }

  Gradient? _getGradient(AppTheme appTheme) {
    if (widget.customGradient != null) return widget.customGradient;

    if (widget.variant == ModernButtonVariant.gradient) {
      return appTheme.gradients.primaryGradient;
    }
    return null;
  }

  Border? _getBorder(AppTheme appTheme) {
    switch (widget.variant) {
      case ModernButtonVariant.outline:
        return Border.all(
          color: _getBorderColor(appTheme),
          width: 1.5,
        );
      default:
        return null;
    }
  }

  Color _getBorderColor(AppTheme appTheme) {
    if (widget.onPressed == null) return appTheme.colors.textMuted;

    switch (widget.variant) {
      case ModernButtonVariant.outline:
        return appTheme.colors.primaryRed;
      default:
        return Colors.transparent;
    }
  }

  Color _getTextColor(AppTheme appTheme) {
    if (widget.onPressed == null) return appTheme.colors.textMuted;

    switch (widget.variant) {
      case ModernButtonVariant.primary:
      case ModernButtonVariant.accent:
        return appTheme.colors.white;
      case ModernButtonVariant.secondary:
        return appTheme.colors.textPrimary;
      case ModernButtonVariant.outline:
        return appTheme.colors.primaryRed;
      case ModernButtonVariant.text:
        return appTheme.colors.primaryRed;
      case ModernButtonVariant.gradient:
        return appTheme.colors.white;
    }
  }

  TextStyle _getTextStyle(AppTheme appTheme) {
    if (widget.textStyle != null) return widget.textStyle!;

    switch (widget.size) {
      case ModernButtonSize.small:
        return appTheme.typography.caption.copyWith(
          color: _getTextColor(appTheme),
          fontWeight: FontWeight.w600,
        );
      case ModernButtonSize.medium:
        return appTheme.typography.bodySmall.copyWith(
          color: _getTextColor(appTheme),
          fontWeight: FontWeight.w600,
        );
      case ModernButtonSize.large:
        return appTheme.typography.bodyMedium.copyWith(
          color: _getTextColor(appTheme),
          fontWeight: FontWeight.w600,
        );
      case ModernButtonSize.extraLarge:
        return appTheme.typography.titleSmall.copyWith(
          color: _getTextColor(appTheme),
          fontWeight: FontWeight.w600,
        );
    }
  }

  List<BoxShadow> _getShadows(AppTheme appTheme) {
    if (widget.onPressed == null) return [];

    switch (widget.variant) {
      case ModernButtonVariant.primary:
      case ModernButtonVariant.accent:
      case ModernButtonVariant.gradient:
        return _isHovered
            ? appTheme.shadows.shadowLarge
            : appTheme.shadows.shadowMedium;
      case ModernButtonVariant.secondary:
      case ModernButtonVariant.outline:
        return _isHovered
            ? appTheme.shadows.shadowMedium
            : appTheme.shadows.shadowSmall;
      case ModernButtonVariant.text:
        return [];
    }
  }
}

// Specialized button variants for common use cases
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final ModernButtonSize size;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.size = ModernButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return ModernButton(
      text: text,
      onPressed: onPressed,
      variant: ModernButtonVariant.primary,
      size: size,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final ModernButtonSize size;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.size = ModernButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return ModernButton(
      text: text,
      onPressed: onPressed,
      variant: ModernButtonVariant.secondary,
      size: size,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }
}

class OutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final ModernButtonSize size;

  const OutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.size = ModernButtonSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    return ModernButton(
      text: text,
      onPressed: onPressed,
      variant: ModernButtonVariant.outline,
      size: size,
      icon: icon,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
    );
  }
}

class ModernTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ModernButtonSize size;
  final bool isFullWidth;
  final IconData? icon;
  final Color? textColor;
  final Color? backgroundColor;
  final double? width;
  final double? height;

  const ModernTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ModernButtonSize.medium,
    this.isFullWidth = false,
    this.icon,
    this.textColor,
    this.backgroundColor,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ModernButton(
      text: text,
      onPressed: onPressed,
      variant: ModernButtonVariant.text,
      size: size,
      icon: icon,
      isLoading: false, // Text buttons are not typically loading
      isFullWidth: isFullWidth,
    );
  }
}