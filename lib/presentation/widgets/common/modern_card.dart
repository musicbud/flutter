import 'package:flutter/material.dart';
import '../../constants/app_theme.dart';

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
  late Animation<double> _shadowAnimation;
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
    _shadowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
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
              onTap: widget.onTap,
              child: Container(
                margin: widget.margin ?? EdgeInsets.all(appTheme.spacing.md),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? appTheme.radius.xl,
                  ),
                  color: _getBackgroundColor(appTheme),
                  gradient: _getGradient(appTheme),
                  border: _getBorder(appTheme),
                  boxShadow: _getShadows(appTheme),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? appTheme.radius.xl,
                  ),
                  child: Padding(
                    padding: widget.padding ?? EdgeInsets.all(appTheme.spacing.lg),
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

  Color _getBackgroundColor(AppTheme appTheme) {
    if (widget.backgroundColor != null) return widget.backgroundColor!;

    switch (widget.variant) {
      case ModernCardVariant.primary:
        return appTheme.colors.cardBackground;
      case ModernCardVariant.secondary:
        return appTheme.colors.surfaceDark;
      case ModernCardVariant.accent:
        return appTheme.colors.surfaceLight;
      case ModernCardVariant.gradient:
        return Colors.transparent;
      case ModernCardVariant.elevated:
        return appTheme.colors.cardBackground;
      case ModernCardVariant.outlined:
        return Colors.transparent;
    }
  }

  Gradient? _getGradient(AppTheme appTheme) {
    if (widget.customGradient != null) return widget.customGradient;

    switch (widget.variant) {
      case ModernCardVariant.gradient:
        return appTheme.gradients.cardGradient;
      case ModernCardVariant.accent:
        return appTheme.gradients.accentGradient;
      default:
        return null;
    }
  }

  Border? _getBorder(AppTheme appTheme) {
    if (widget.customBorder != null) return widget.customBorder;

    switch (widget.variant) {
      case ModernCardVariant.outlined:
        return Border.all(
          color: appTheme.colors.borderColor,
          width: 1.0,
        );
      default:
        return null;
    }
  }

  List<BoxShadow> _getShadows(AppTheme appTheme) {
    if (widget.customShadows != null) return widget.customShadows!;

    switch (widget.variant) {
      case ModernCardVariant.elevated:
        return _isHovered
            ? appTheme.shadows.shadowCardHover
            : appTheme.shadows.shadowCard;
      case ModernCardVariant.primary:
      case ModernCardVariant.secondary:
      case ModernCardVariant.accent:
        return _isHovered
            ? appTheme.shadows.shadowCardHover
            : appTheme.shadows.shadowCard;
      default:
        return _isHovered
            ? appTheme.shadows.shadowMedium
            : appTheme.shadows.shadowSmall;
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
    final appTheme = AppTheme.of(context);

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
              borderRadius: BorderRadius.circular(appTheme.radius.lg),
              color: appTheme.colors.surfaceDark,
            ),
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(appTheme.radius.lg),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildIconFallback(appTheme);
                      },
                    ),
                  )
                : _buildIconFallback(appTheme),
          ),

          SizedBox(height: appTheme.spacing.md),

          // Title and Subtitle
          Text(
            title,
            style: appTheme.typography.titleMedium.copyWith(
              color: appTheme.colors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: appTheme.spacing.xs),

          Text(
            subtitle,
            style: appTheme.typography.bodySmall.copyWith(
              color: appTheme.colors.textMuted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: appTheme.spacing.md),

          // Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Play Button
              Container(
                padding: EdgeInsets.all(appTheme.spacing.sm),
                decoration: BoxDecoration(
                  color: appTheme.colors.primaryRed,
                  borderRadius: BorderRadius.circular(appTheme.radius.circular),
                ),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: appTheme.colors.white,
                  size: 20,
                ),
              ),

              // Like Button
              Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? appTheme.colors.primaryRed : appTheme.colors.textMuted,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconFallback(AppTheme appTheme) {
    return Container(
      decoration: BoxDecoration(
        gradient: appTheme.gradients.cardGradient,
        borderRadius: BorderRadius.circular(appTheme.radius.lg),
      ),
      child: Icon(
        icon ?? Icons.music_note,
        color: iconColor ?? appTheme.colors.primaryRed,
        size: 48,
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String? subtitle;
  final String? avatarUrl;
  final VoidCallback? onTap;
  final List<Widget>? actions;

  const ProfileCard({
    super.key,
    required this.name,
    this.subtitle,
    this.avatarUrl,
    this.onTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: onTap,
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 30,
            backgroundColor: appTheme.colors.primaryRed,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? Icon(
                    Icons.person,
                    color: appTheme.colors.white,
                    size: 32,
                  )
                : null,
          ),

          SizedBox(width: appTheme.spacing.md),

          // Name and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: appTheme.typography.titleMedium.copyWith(
                    color: appTheme.colors.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: appTheme.spacing.xs),
                  Text(
                    subtitle!,
                    style: appTheme.typography.bodySmall.copyWith(
                      color: appTheme.colors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Actions
          if (actions != null) ...[
            SizedBox(width: appTheme.spacing.sm),
            ...actions!,
          ],
        ],
      ),
    );
  }
}