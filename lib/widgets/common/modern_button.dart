import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

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
    final theme = Theme.of(context);

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
                padding: _getPadding(theme),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? _getBorderRadius(theme),
                  ),
                  color: _getBackgroundColor(theme),
                  gradient: _getGradient(theme),
                  border: _getBorder(theme),
                  boxShadow: _getShadows(theme),
                ),
                child: _buildContent(theme),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(ThemeData theme) {
    if (widget.isLoading) {
      return SizedBox(
        height: _getIconSize(theme),
        width: _getIconSize(theme),
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getTextColor(theme),
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
            size: _getIconSize(theme),
            color: _getTextColor(theme),
          ),
          if (widget.text.isNotEmpty) SizedBox(width: theme.designSystem?.designSystemSpacing.sm ?? 8.0),
        ],
        if (widget.text.isNotEmpty)
          Flexible(
            child: Text(
              widget.text,
              style: _getTextStyle(theme),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        if (widget.trailingIcon != null) ...[
          if (widget.text.isNotEmpty) SizedBox(width: theme.designSystem?.designSystemSpacing.sm ?? 8.0),
          Icon(
            widget.trailingIcon,
            size: _getIconSize(theme),
            color: _getTextColor(theme),
          ),
        ],
      ],
    );

    return content;
  }

  EdgeInsetsGeometry _getPadding(ThemeData theme) {
    if (widget.padding != null) return widget.padding!;

    switch (widget.size) {
      case ModernButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: theme.designSystem?.designSystemSpacing.md ?? 16.0,
          vertical: theme.designSystem?.designSystemSpacing.sm ?? 12.0,
        );
      case ModernButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: theme.designSystem?.designSystemSpacing.lg ?? 24.0,
          vertical: theme.designSystem?.designSystemSpacing.md ?? 16.0,
        );
      case ModernButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: theme.designSystem?.designSystemSpacing.xl ?? 32.0,
          vertical: theme.designSystem?.designSystemSpacing.lg ?? 24.0,
        );
      case ModernButtonSize.extraLarge:
        return EdgeInsets.symmetric(
          horizontal: theme.designSystem?.designSystemSpacing.xxl ?? 48.0,
          vertical: theme.designSystem?.designSystemSpacing.xl ?? 32.0,
        );
    }
  }

  double _getBorderRadius(ThemeData theme) {
    switch (widget.size) {
      case ModernButtonSize.small:
        return theme.designSystem?.designSystemRadius.sm ?? 12.0;
      case ModernButtonSize.medium:
        return theme.designSystem?.designSystemRadius.md ?? 16.0;
      case ModernButtonSize.large:
        return theme.designSystem?.designSystemRadius.lg ?? 24.0;
      case ModernButtonSize.extraLarge:
        return theme.designSystem?.designSystemRadius.xl ?? 31.0;
    }
  }

  double _getIconSize(ThemeData theme) {
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

  Color _getBackgroundColor(ThemeData theme) {
    if (widget.customColor != null) return widget.customColor!;

    if (widget.onPressed == null) {
      return theme.designSystem?.designSystemColors.onSurfaceVariant ?? Colors.grey;
    }

    switch (widget.variant) {
      case ModernButtonVariant.primary:
        return theme.designSystem?.designSystemColors.primary ?? Colors.blue;
      case ModernButtonVariant.secondary:
        return theme.designSystem?.designSystemColors.surfaceContainerHigh ?? Colors.grey.shade800;
      case ModernButtonVariant.accent:
        return theme.designSystem?.designSystemColors.accentBlue ?? Colors.blueAccent;
      case ModernButtonVariant.outline:
      case ModernButtonVariant.text:
      case ModernButtonVariant.gradient:
        return Colors.transparent;
    }
  }

  Gradient? _getGradient(ThemeData theme) {
    if (widget.customGradient != null) return widget.customGradient;

    if (widget.variant == ModernButtonVariant.gradient) {
      return theme.designSystem?.designSystemGradients.primary;
    }
    return null;
  }

  Border? _getBorder(ThemeData theme) {
    switch (widget.variant) {
      case ModernButtonVariant.outline:
        return Border.all(
          color: _getBorderColor(theme),
          width: 1.5,
        );
      default:
        return null;
    }
  }

  Color _getBorderColor(ThemeData theme) {
      if (widget.onPressed == null) return theme.designSystem?.designSystemColors.onSurfaceVariant ?? Colors.grey;
  
      switch (widget.variant) {
        case ModernButtonVariant.outline:
          return theme.designSystem?.designSystemColors.primary ?? Colors.blue;
        default:
          return Colors.transparent;
    }
  }

  Color _getTextColor(ThemeData theme) {
      if (widget.onPressed == null) return theme.designSystem?.designSystemColors.onSurfaceVariant ?? Colors.grey;
  
      switch (widget.variant) {
        case ModernButtonVariant.primary:
        case ModernButtonVariant.accent:
          return theme.designSystem?.designSystemColors.onPrimary ?? Colors.white;
        case ModernButtonVariant.secondary:
          return theme.designSystem?.designSystemColors.onSurface ?? Colors.white;
        case ModernButtonVariant.outline:
          return theme.designSystem?.designSystemColors.primary ?? Colors.blue;
        case ModernButtonVariant.text:
          return theme.designSystem?.designSystemColors.primary ?? Colors.blue;
        case ModernButtonVariant.gradient:
          return theme.designSystem?.designSystemColors.onPrimary ?? Colors.white;
    }
  }

  TextStyle _getTextStyle(ThemeData theme) {
    if (widget.textStyle != null) return widget.textStyle!;

    switch (widget.size) {
      case ModernButtonSize.small:
        return theme.designSystem?.designSystemTypography.caption.copyWith(
          color: _getTextColor(theme),
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle();
      case ModernButtonSize.medium:
        return theme.designSystem?.designSystemTypography.labelMedium.copyWith(
          color: _getTextColor(theme),
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle();
      case ModernButtonSize.large:
        return theme.designSystem?.designSystemTypography.bodyMedium.copyWith(
          color: _getTextColor(theme),
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle();
      case ModernButtonSize.extraLarge:
        return theme.designSystem?.designSystemTypography.titleSmall.copyWith(
          color: _getTextColor(theme),
          fontWeight: FontWeight.w600,
        ) ?? const TextStyle();
    }
  }

  List<BoxShadow> _getShadows(ThemeData theme) {
    if (widget.onPressed == null) return [];

    switch (widget.variant) {
      case ModernButtonVariant.primary:
      case ModernButtonVariant.accent:
      case ModernButtonVariant.gradient:
        return _isHovered
            ? theme.designSystem?.designSystemShadows.large ?? []
            : theme.designSystem?.designSystemShadows.medium ?? [];
      case ModernButtonVariant.secondary:
      case ModernButtonVariant.outline:
        return _isHovered
            ? theme.designSystem?.designSystemShadows.medium ?? []
            : theme.designSystem?.designSystemShadows.small ?? [];
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