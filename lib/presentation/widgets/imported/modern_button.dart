import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

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
    setState(() {
      _isHovered = isHovered;
    });
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
                padding: _getPadding(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? _getBorderRadius(),
                  ),
                  color: _getBackgroundColor(),
                  gradient: _getGradient(),
                  border: _getBorder(),
                  boxShadow: _getShadows(),
                ),
                child: _buildContent(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent() {
    if (widget.isLoading) {
      return SizedBox(
        height: _getIconSize(),
        width: _getIconSize(),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getTextColor(),
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
            size: _getIconSize(),
            color: _getTextColor(),
          ),
          if (widget.text.isNotEmpty) const SizedBox(width: DesignSystem.spacingSM),
        ],
        if (widget.text.isNotEmpty)
          Flexible(
            child: Text(
              widget.text,
              style: _getTextStyle(),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (widget.trailingIcon != null) ...[
          if (widget.text.isNotEmpty) const SizedBox(width: DesignSystem.spacingSM),
          Icon(
            widget.trailingIcon,
            size: _getIconSize(),
            color: _getTextColor(),
          ),
        ],
      ],
    );

    return content;
  }
  
  /// Fallback button when DesignSystemThemeExtension is not available
  Widget _buildFallbackButton(BuildContext context) {
    final theme = Theme.of(context);
    
    return ElevatedButton(
      onPressed: widget.isLoading ? null : widget.onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.customColor ?? theme.primaryColor,
        foregroundColor: Colors.white,
        padding: widget.padding ?? const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 8),
        ),
        minimumSize: widget.isFullWidth 
            ? const Size(double.infinity, 48) 
            : null,
      ),
      child: widget.isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 18),
                  if (widget.text.isNotEmpty) const SizedBox(width: 8),
                ],
                if (widget.text.isNotEmpty)
                  Text(
                    widget.text,
                    style: widget.textStyle ?? const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (widget.trailingIcon != null) ...[
                  if (widget.text.isNotEmpty) const SizedBox(width: 8),
                  Icon(widget.trailingIcon, size: 18),
                ],
              ],
            ),
    );
  }

  EdgeInsetsGeometry _getPadding() {
    if (widget.padding != null) return widget.padding!;

    switch (widget.size) {
      case ModernButtonSize.small:
        return const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingMD,
          vertical: DesignSystem.spacingSM,
        );
      case ModernButtonSize.medium:
        return const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingLG,
          vertical: DesignSystem.spacingMD,
        );
      case ModernButtonSize.large:
        return const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingXL,
          vertical: DesignSystem.spacingLG,
        );
      case ModernButtonSize.extraLarge:
        return const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacingXXL,
          vertical: DesignSystem.spacingXL,
        );
    }
  }

  double _getBorderRadius() {
    switch (widget.size) {
      case ModernButtonSize.small:
        return DesignSystem.radiusSM;
      case ModernButtonSize.medium:
        return DesignSystem.radiusMD;
      case ModernButtonSize.large:
        return DesignSystem.radiusLG;
      case ModernButtonSize.extraLarge:
        return DesignSystem.radiusXL;
    }
  }

  double _getIconSize() {
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

  Color _getBackgroundColor() {
    if (widget.customColor != null) return widget.customColor!;

    if (widget.onPressed == null) {
      return DesignSystem.textMuted;
    }

    switch (widget.variant) {
      case ModernButtonVariant.primary:
        return DesignSystem.primaryRed;
      case ModernButtonVariant.secondary:
        return DesignSystem.surfaceDark;
      case ModernButtonVariant.accent:
        return DesignSystem.accentBlue;
      case ModernButtonVariant.outline:
      case ModernButtonVariant.text:
      case ModernButtonVariant.gradient:
        return Colors.transparent;
    }
  }

  Gradient? _getGradient() {
    if (widget.customGradient != null) return widget.customGradient;

    if (widget.variant == ModernButtonVariant.gradient) {
      return DesignSystem.gradientPrimary;
    }
    return null;
  }

  Border? _getBorder() {
    switch (widget.variant) {
      case ModernButtonVariant.outline:
        return Border.all(
          color: _getBorderColor(),
          width: 1.5,
        );
      default:
        return null;
    }
  }

  Color _getBorderColor() {
    if (widget.onPressed == null) return DesignSystem.textMuted;

    switch (widget.variant) {
      case ModernButtonVariant.outline:
        return DesignSystem.primaryRed;
      default:
        return Colors.transparent;
    }
  }

  Color _getTextColor() {
    if (widget.onPressed == null) return DesignSystem.textMuted;

    switch (widget.variant) {
      case ModernButtonVariant.primary:
      case ModernButtonVariant.accent:
        return DesignSystem.onPrimary;
      case ModernButtonVariant.secondary:
        return DesignSystem.textPrimary;
      case ModernButtonVariant.outline:
        return DesignSystem.primaryRed;
      case ModernButtonVariant.text:
        return DesignSystem.primaryRed;
      case ModernButtonVariant.gradient:
        return DesignSystem.onPrimary;
    }
  }

  TextStyle _getTextStyle() {
    if (widget.textStyle != null) return widget.textStyle!;

    switch (widget.size) {
      case ModernButtonSize.small:
        return DesignSystem.caption.copyWith(
          color: _getTextColor(),
          fontWeight: FontWeight.w600,
        );
      case ModernButtonSize.medium:
        return DesignSystem.bodySmall.copyWith(
          color: _getTextColor(),
          fontWeight: FontWeight.w600,
        );
      case ModernButtonSize.large:
        return DesignSystem.bodyMedium.copyWith(
          color: _getTextColor(),
          fontWeight: FontWeight.w600,
        );
      case ModernButtonSize.extraLarge:
        return DesignSystem.titleSmall.copyWith(
          color: _getTextColor(),
          fontWeight: FontWeight.w600,
        );
    }
  }

  List<BoxShadow> _getShadows() {
    if (widget.onPressed == null) return [];

    switch (widget.variant) {
      case ModernButtonVariant.primary:
      case ModernButtonVariant.accent:
      case ModernButtonVariant.gradient:
        return _isHovered
            ? DesignSystem.shadowLarge
            : DesignSystem.shadowMedium;
      case ModernButtonVariant.secondary:
      case ModernButtonVariant.outline:
        return _isHovered
            ? DesignSystem.shadowMedium
            : DesignSystem.shadowSmall;
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
