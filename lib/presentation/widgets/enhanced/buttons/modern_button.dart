import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Button variants for different use cases
enum ModernButtonVariant {
  primary,
  secondary,
  accent,
  outline,
  text,
  gradient,
}

/// Button sizes for different contexts
enum ModernButtonSize {
  small,
  medium,
  large,
  extraLarge,
}

/// A modern, animated button with multiple variants and sizes.
///
/// Supports:
/// - Multiple visual variants (primary, secondary, outline, etc.)
/// - Different sizes (small to extra large)
/// - Loading states
/// - Icons (leading and trailing)
/// - Hover effects
/// - Press animations
/// - Full-width layouts
///
/// Example:
/// ```dart
/// ModernButton(
///   text: 'Continue',
///   variant: ModernButtonVariant.primary,
///   size: ModernButtonSize.large,
///   icon: Icons.arrow_forward,
///   isFullWidth: true,
///   onPressed: () => navigateNext(),
/// )
/// ```
class ModernButton extends StatefulWidget {
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

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    if (mounted) {
      setState(() {
        _isHovered = isHovered;
      });
    }
  }

  void _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _animationController.reverse();
  }

  void _onTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: MouseRegion(
            onEnter: (_) => _onHover(true),
            onExit: (_) => _onHover(false),
            child: GestureDetector(
              onTapDown: widget.onPressed != null ? _onTapDown : null,
              onTapUp: widget.onPressed != null ? _onTapUp : null,
              onTapCancel: _onTapCancel,
              onTap: widget.onPressed,
              child: Container(
                width: widget.isFullWidth ? double.infinity : null,
                padding: _getPadding(design),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? _getBorderRadius(design),
                  ),
                  color: _getBackgroundColor(design),
                  gradient: _getGradient(design),
                  border: _getBorder(design),
                  boxShadow: _getShadows(design),
                ),
                child: _buildContent(design),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(DesignSystemThemeExtension design) {
    if (widget.isLoading) {
      return SizedBox(
        height: _getIconSize(design),
        width: _getIconSize(design),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getTextColor(design),
          ),
        ),
      );
    }

    final content = widget.child ??
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(
                widget.icon,
                size: _getIconSize(design),
                color: _getTextColor(design),
              ),
              if (widget.text.isNotEmpty)
                SizedBox(width: design.designSystemSpacing.sm),
            ],
            if (widget.text.isNotEmpty)
              Flexible(
                child: Text(
                  widget.text,
                  style: _getTextStyle(design),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            if (widget.trailingIcon != null) ...[
              if (widget.text.isNotEmpty)
                SizedBox(width: design.designSystemSpacing.sm),
              Icon(
                widget.trailingIcon,
                size: _getIconSize(design),
                color: _getTextColor(design),
              ),
            ],
          ],
        );

    return content;
  }

  EdgeInsetsGeometry _getPadding(DesignSystemThemeExtension design) {
    if (widget.padding != null) return widget.padding!;

    switch (widget.size) {
      case ModernButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: design.designSystemSpacing.md,
          vertical: design.designSystemSpacing.sm,
        );
      case ModernButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: design.designSystemSpacing.lg,
          vertical: design.designSystemSpacing.md,
        );
      case ModernButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: design.designSystemSpacing.xl,
          vertical: design.designSystemSpacing.lg,
        );
      case ModernButtonSize.extraLarge:
        return EdgeInsets.symmetric(
          horizontal: design.designSystemSpacing.xxl,
          vertical: design.designSystemSpacing.xl,
        );
    }
  }

  double _getBorderRadius(DesignSystemThemeExtension design) {
    switch (widget.size) {
      case ModernButtonSize.small:
        return design.designSystemRadius.sm;
      case ModernButtonSize.medium:
        return design.designSystemRadius.md;
      case ModernButtonSize.large:
        return design.designSystemRadius.lg;
      case ModernButtonSize.extraLarge:
        return design.designSystemRadius.xl;
    }
  }

  double _getIconSize(DesignSystemThemeExtension design) {
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

  Color _getBackgroundColor(DesignSystemThemeExtension design) {
    if (widget.customColor != null) return widget.customColor!;

    if (widget.onPressed == null) {
      return design.designSystemColors.textMuted;
    }

    switch (widget.variant) {
      case ModernButtonVariant.primary:
        return design.designSystemColors.primaryRed;
      case ModernButtonVariant.secondary:
        return design.designSystemColors.surfaceDark;
      case ModernButtonVariant.accent:
        return design.designSystemColors.accentBlue;
      case ModernButtonVariant.outline:
      case ModernButtonVariant.text:
      case ModernButtonVariant.gradient:
        return Colors.transparent;
    }
  }

  Gradient? _getGradient(DesignSystemThemeExtension design) {
    if (widget.customGradient != null) return widget.customGradient;

    if (widget.variant == ModernButtonVariant.gradient) {
      return design.designSystemGradients.primary;
    }
    return null;
  }

  Border? _getBorder(DesignSystemThemeExtension design) {
    switch (widget.variant) {
      case ModernButtonVariant.outline:
        return Border.all(
          color: _getBorderColor(design),
          width: 1.5,
        );
      default:
        return null;
    }
  }

  Color _getBorderColor(DesignSystemThemeExtension design) {
    if (widget.onPressed == null) return design.designSystemColors.textMuted;

    switch (widget.variant) {
      case ModernButtonVariant.outline:
        return design.designSystemColors.primaryRed;
      default:
        return Colors.transparent;
    }
  }

  Color _getTextColor(DesignSystemThemeExtension design) {
    if (widget.onPressed == null) return design.designSystemColors.textMuted;

    switch (widget.variant) {
      case ModernButtonVariant.primary:
      case ModernButtonVariant.accent:
        return design.designSystemColors.white;
      case ModernButtonVariant.secondary:
        return design.designSystemColors.textPrimary;
      case ModernButtonVariant.outline:
        return design.designSystemColors.primaryRed;
      case ModernButtonVariant.text:
        return design.designSystemColors.primaryRed;
      case ModernButtonVariant.gradient:
        return design.designSystemColors.white;
    }
  }

  TextStyle _getTextStyle(DesignSystemThemeExtension design) {
    if (widget.textStyle != null) return widget.textStyle!;

    switch (widget.size) {
      case ModernButtonSize.small:
        return design.designSystemTypography.caption.copyWith(
          color: _getTextColor(design),
          fontWeight: FontWeight.w600,
        );
      case ModernButtonSize.medium:
        return design.designSystemTypography.bodySmall.copyWith(
          color: _getTextColor(design),
          fontWeight: FontWeight.w600,
        );
      case ModernButtonSize.large:
        return design.designSystemTypography.bodyMedium.copyWith(
          color: _getTextColor(design),
          fontWeight: FontWeight.w600,
        );
      case ModernButtonSize.extraLarge:
        return design.designSystemTypography.titleSmall.copyWith(
          color: _getTextColor(design),
          fontWeight: FontWeight.w600,
        );
    }
  }

  List<BoxShadow> _getShadows(DesignSystemThemeExtension design) {
    if (widget.onPressed == null) return [];

    switch (widget.variant) {
      case ModernButtonVariant.primary:
      case ModernButtonVariant.accent:
      case ModernButtonVariant.gradient:
        return _isHovered
            ? design.designSystemShadows.large
            : design.designSystemShadows.medium;
      case ModernButtonVariant.secondary:
      case ModernButtonVariant.outline:
        return _isHovered
            ? design.designSystemShadows.medium
            : design.designSystemShadows.small;
      case ModernButtonVariant.text:
        return [];
    }
  }
}

// Convenience button variants for common use cases

/// Primary button with accent color
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.size = ModernButtonSize.medium,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final ModernButtonSize size;

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

/// Secondary button with muted styling
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.size = ModernButtonSize.medium,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final ModernButtonSize size;

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

/// Outline button with border
class OutlineButton extends StatelessWidget {
  const OutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.size = ModernButtonSize.medium,
  });

  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final ModernButtonSize size;

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

/// Text-only button
class ModernTextButton extends StatelessWidget {
  const ModernTextButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ModernButtonSize.medium,
    this.isFullWidth = false,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final ModernButtonSize size;
  final bool isFullWidth;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return ModernButton(
      text: text,
      onPressed: onPressed,
      variant: ModernButtonVariant.text,
      size: size,
      icon: icon,
      isFullWidth: isFullWidth,
    );
  }
}
