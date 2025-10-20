import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

enum ModernCardVariant {
  primary,
  secondary,
  accent,
  gradient,
  elevated,
  outlined,
}

class ModernCard extends StatefulWidget {
  final Widget child;
  final ModernCardVariant variant;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? borderRadius;
  final VoidCallback? onTap;
  final bool enableHover;
  final Color? backgroundColor;
  final List<BoxShadow>? customShadows;
  final Gradient? customGradient;
  final Border? customBorder;

  const ModernCard({
    super.key,
    required this.child,
    this.variant = ModernCardVariant.primary,
    this.padding,
    this.margin,
    this.borderRadius,
    this.onTap,
    this.enableHover = true,
    this.backgroundColor,
    this.customShadows,
    this.customGradient,
    this.customBorder,
  });

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.02,
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
    if (!widget.enableHover) return;

    setState(() {
      _isHovered = isHovered;
    });

    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
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
              onTap: widget.onTap,
              child: Container(
                margin: widget.margin ?? EdgeInsets.all(design.designSystemSpacing.md),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? design.designSystemRadius.xl,
                  ),
                  color: _getBackgroundColor(design),
                  gradient: _getGradient(design),
                  border: _getBorder(design),
                  boxShadow: _getShadows(design),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? design.designSystemRadius.xl,
                  ),
                  child: Padding(
                    padding: widget.padding ?? EdgeInsets.all(design.designSystemSpacing.lg),
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Color _getBackgroundColor(DesignSystemThemeExtension design) {
    if (widget.backgroundColor != null) return widget.backgroundColor!;

    switch (widget.variant) {
      case ModernCardVariant.primary:
        return design.designSystemColors.cardBackground;
      case ModernCardVariant.secondary:
        return design.designSystemColors.surfaceDark;
      case ModernCardVariant.accent:
        return design.designSystemColors.surfaceLight;
      case ModernCardVariant.gradient:
        return Colors.transparent;
      case ModernCardVariant.elevated:
        return design.designSystemColors.cardBackground;
      case ModernCardVariant.outlined:
        return Colors.transparent;
    }
  }

  Gradient? _getGradient(DesignSystemThemeExtension design) {
    if (widget.customGradient != null) return widget.customGradient;

    switch (widget.variant) {
      case ModernCardVariant.gradient:
        return design.designSystemGradients.card;
      case ModernCardVariant.accent:
        return design.designSystemGradients.accent;
      default:
        return null;
    }
  }

  Border? _getBorder(DesignSystemThemeExtension design) {
    if (widget.customBorder != null) return widget.customBorder;

    switch (widget.variant) {
      case ModernCardVariant.outlined:
        return Border.all(
          color: design.designSystemColors.borderColor,
          width: 1.0,
        );
      default:
        return null;
    }
  }

  List<BoxShadow> _getShadows(DesignSystemThemeExtension design) {
    if (widget.customShadows != null) return widget.customShadows!;

    switch (widget.variant) {
      case ModernCardVariant.elevated:
        return _isHovered
            ? design.designSystemShadows.cardHover
            : design.designSystemShadows.card;
      case ModernCardVariant.primary:
      case ModernCardVariant.secondary:
      case ModernCardVariant.accent:
        return _isHovered
            ? design.designSystemShadows.cardHover
            : design.designSystemShadows.card;
      default:
        return _isHovered
            ? design.designSystemShadows.medium
            : design.designSystemShadows.small;
    }
  }
}

// Specialized card variants for common use cases
class MusicCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? imageUrl;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final bool isPlaying;
  final bool isLiked;

  const MusicCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.imageUrl,
    this.icon,
    this.iconColor,
    this.onTap,
    this.isPlaying = false,
    this.isLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image/Icon Section
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(design.designSystemRadius.lg),
              color: design.designSystemColors.surfaceDark,
            ),
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(design.designSystemRadius.lg),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildIconFallback(design);
                      },
                    ),
                  )
                : _buildIconFallback(design),
          ),

          SizedBox(height: design.designSystemSpacing.md),

          // Title and Subtitle
          Text(
            title,
            style: design.designSystemTypography.titleMedium.copyWith(
              color: design.designSystemColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: design.designSystemSpacing.xs),

          Text(
            subtitle,
            style: design.designSystemTypography.bodySmall.copyWith(
              color: design.designSystemColors.textMuted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: design.designSystemSpacing.md),

          // Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Play Button
              Container(
                padding: EdgeInsets.all(design.designSystemSpacing.sm),
                decoration: BoxDecoration(
                  color: design.designSystemColors.primaryRed,
                  borderRadius: BorderRadius.circular(design.designSystemRadius.circular),
                ),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: design.designSystemColors.white,
                  size: 20,
                ),
              ),

              // Like Button
              Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? design.designSystemColors.primaryRed : design.designSystemColors.textMuted,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconFallback(DesignSystemThemeExtension design) {
    return Container(
      decoration: BoxDecoration(
        gradient: design.designSystemGradients.card,
        borderRadius: BorderRadius.circular(design.designSystemRadius.lg),
      ),
      child: Icon(
        icon ?? Icons.music_note,
        color: iconColor ?? design.designSystemColors.primaryRed,
        size: 48,
      ),
    );
  }
}

// Note: ProfileCard moved to dedicated cards/profile_card.dart file
