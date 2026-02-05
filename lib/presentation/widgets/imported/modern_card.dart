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
                margin: widget.margin ?? const EdgeInsets.all(DesignSystem.spacingMD),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? DesignSystem.radiusXL,
                  ),
                  color: _getBackgroundColor(),
                  gradient: _getGradient(),
                  border: _getBorder(),
                  boxShadow: _getShadows(),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? DesignSystem.radiusXL,
                  ),
                  child: Padding(
                    padding: widget.padding ?? const EdgeInsets.all(DesignSystem.spacingLG),
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

  Color _getBackgroundColor() {
    if (widget.backgroundColor != null) return widget.backgroundColor!;

    switch (widget.variant) {
      case ModernCardVariant.primary:
        return DesignSystem.cardBackground;
      case ModernCardVariant.secondary:
        return DesignSystem.surfaceDark;
      case ModernCardVariant.accent:
        return DesignSystem.surfaceLight;
      case ModernCardVariant.gradient:
        return Colors.transparent;
      case ModernCardVariant.elevated:
        return DesignSystem.cardBackground;
      case ModernCardVariant.outlined:
        return Colors.transparent;
    }
  }

  Gradient? _getGradient() {
    if (widget.customGradient != null) return widget.customGradient;

    switch (widget.variant) {
      case ModernCardVariant.gradient:
        return DesignSystem.gradientCard;
      case ModernCardVariant.accent:
        return DesignSystem.gradientPrimary;
      default:
        return null;
    }
  }

  Border? _getBorder() {
    if (widget.customBorder != null) return widget.customBorder;

    switch (widget.variant) {
      case ModernCardVariant.outlined:
        return Border.all(
          color: DesignSystem.borderColor,
          width: 1.0,
        );
      default:
        return null;
    }
  }

  List<BoxShadow> _getShadows() {
    if (widget.customShadows != null) return widget.customShadows!;

    switch (widget.variant) {
      case ModernCardVariant.elevated:
        return _isHovered
            ? DesignSystem.shadowLarge
            : DesignSystem.shadowMedium;
      case ModernCardVariant.primary:
      case ModernCardVariant.secondary:
      case ModernCardVariant.accent:
        return _isHovered
            ? DesignSystem.shadowLarge
            : DesignSystem.shadowMedium;
      default:
        return _isHovered
            ? DesignSystem.shadowMedium
            : DesignSystem.shadowSmall;
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
              borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
              color: DesignSystem.surfaceDark,
            ),
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildIconFallback();
                      },
                    ),
                  )
                : _buildIconFallback(),
          ),

          const SizedBox(height: DesignSystem.spacingMD),

          // Title and Subtitle
          Text(
            title,
            style: DesignSystem.titleMedium.copyWith(
              color: DesignSystem.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: DesignSystem.spacingXS),

          Text(
            subtitle,
            style: DesignSystem.bodySmall.copyWith(
              color: DesignSystem.textMuted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: DesignSystem.spacingMD),

          // Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Play Button
              Container(
                padding: const EdgeInsets.all(DesignSystem.spacingSM),
                decoration: BoxDecoration(
                  color: DesignSystem.primaryRed,
                  borderRadius: BorderRadius.circular(DesignSystem.radiusCircular),
                ),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: DesignSystem.onPrimary,
                  size: 20,
                ),
              ),

              // Like Button
              Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? DesignSystem.primaryRed : DesignSystem.textMuted,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconFallback() {
    return Container(
      decoration: BoxDecoration(
        gradient: DesignSystem.gradientCard,
        borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
      ),
      child: Icon(
        icon ?? Icons.music_note,
        color: iconColor ?? DesignSystem.primaryRed,
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
    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: onTap,
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 30,
            backgroundColor: DesignSystem.primaryRed,
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? const Icon(
                    Icons.person,
                    color: DesignSystem.onPrimary,
                    size: 32,
                  )
                : null,
          ),

          const SizedBox(width: DesignSystem.spacingMD),

          // Name and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: DesignSystem.titleMedium.copyWith(
                    color: DesignSystem.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: DesignSystem.spacingXS),
                  Text(
                    subtitle!,
                    style: DesignSystem.bodySmall.copyWith(
                      color: DesignSystem.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Actions
          if (actions != null) ...[
            const SizedBox(width: DesignSystem.spacingSM),
            ...actions!,
          ],
        ],
      ),
    );
  }
}
