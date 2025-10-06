import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';

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
    final theme = Theme.of(context);

    // Debug logging to validate theme extension initialization
    final designSystem = theme.designSystem;
    print('DEBUG: theme.designSystem is null: ${designSystem == null}');
    if (designSystem != null) {
      print('DEBUG: designSystemColors is null: ${designSystem.designSystemColors == null}');
      print('DEBUG: designSystemSpacing is null: ${designSystem.designSystemSpacing == null}');
      print('DEBUG: designSystemRadius is null: ${designSystem.designSystemRadius == null}');
    }

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
                margin: widget.margin ?? EdgeInsets.all(theme.designSystem?.designSystemSpacing.md ?? 16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? theme.designSystem?.designSystemRadius.xl ?? 31.0,
                  ),
                  color: _getBackgroundColor(theme),
                  gradient: _getGradient(theme),
                  border: _getBorder(theme),
                  boxShadow: _getShadows(theme),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius ?? theme.designSystem?.designSystemRadius.xl ?? 31.0,
                  ),
                  child: Padding(
                    padding: widget.padding ?? EdgeInsets.all(theme.designSystem?.designSystemSpacing.lg ?? 24.0),
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

  Color _getBackgroundColor(ThemeData theme) {
    if (widget.backgroundColor != null) return widget.backgroundColor!;

    switch (widget.variant) {
      case ModernCardVariant.primary:
        return theme.designSystem?.designSystemColors.surfaceContainer ?? const Color(0xFF1A1A1A);
      case ModernCardVariant.secondary:
        return theme.designSystem?.designSystemColors.surfaceContainerHigh ?? const Color(0xFF282828);
      case ModernCardVariant.accent:
        return theme.designSystem?.designSystemColors.surfaceContainerHighest ?? const Color(0xFF3E3E3E);
      case ModernCardVariant.gradient:
        return Colors.transparent;
      case ModernCardVariant.elevated:
        return theme.designSystem?.designSystemColors.surfaceContainer ?? const Color(0xFF1A1A1A);
      case ModernCardVariant.outlined:
        return Colors.transparent;
    }
  }

  Gradient? _getGradient(ThemeData theme) {
    if (widget.customGradient != null) return widget.customGradient;

    switch (widget.variant) {
      case ModernCardVariant.gradient:
        return theme.designSystem?.designSystemGradients.card ?? DesignSystem.gradientCard;
      case ModernCardVariant.accent:
        return theme.designSystem?.designSystemGradients.accent ?? DesignSystem.gradientAccent;
      default:
        return null;
    }
  }

  Border? _getBorder(ThemeData theme) {
    if (widget.customBorder != null) return widget.customBorder;

    switch (widget.variant) {
      case ModernCardVariant.outlined:
        return Border.all(
          color: theme.designSystem?.designSystemColors.border ?? Colors.grey,
          width: 1.0,
        );
      default:
        return null;
    }
  }

  List<BoxShadow> _getShadows(ThemeData theme) {
    if (widget.customShadows != null) return widget.customShadows!;

    switch (widget.variant) {
      case ModernCardVariant.elevated:
        return _isHovered
            ? theme.designSystem?.designSystemShadows.cardHover ?? []
            : theme.designSystem?.designSystemShadows.card ?? [];
      case ModernCardVariant.primary:
      case ModernCardVariant.secondary:
      case ModernCardVariant.accent:
        return _isHovered
            ? theme.designSystem?.designSystemShadows.cardHover ?? []
            : theme.designSystem?.designSystemShadows.card ?? [];
      default:
        return _isHovered
            ? theme.designSystem?.designSystemShadows.medium ?? []
            : theme.designSystem?.designSystemShadows.small ?? [];
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
              borderRadius: BorderRadius.circular(theme.designSystem?.designSystemRadius.lg ?? 24.0),
              color: theme.designSystem?.designSystemColors.surfaceContainerHigh ?? const Color(0xFF282828),
            ),
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(theme.designSystem?.designSystemRadius.lg ?? 24.0),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildIconFallback(theme);
                      },
                    ),
                  )
                : _buildIconFallback(theme),
          ),

          SizedBox(height: theme.designSystem?.designSystemSpacing.md ?? 16.0),

          // Title and Subtitle
          Text(
            title,
            style: theme.designSystem?.designSystemTypography.titleMedium.copyWith(
              color: theme.designSystem?.designSystemColors.onSurface,
            ) ?? const TextStyle(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: theme.designSystem?.designSystemSpacing.xs ?? 8.0),

          Text(
            subtitle,
            style: theme.designSystem?.designSystemTypography.bodySmall.copyWith(
              color: theme.designSystem?.designSystemColors.onSurfaceVariant,
            ) ?? const TextStyle(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: theme.designSystem?.designSystemSpacing.md ?? 16.0),

          // Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Play Button
              Container(
                padding: EdgeInsets.all(theme.designSystem?.designSystemSpacing.sm ?? 12.0),
                decoration: BoxDecoration(
                  color: theme.designSystem?.designSystemColors.primary ?? const Color(0xFFFE2C54),
                  borderRadius: BorderRadius.circular(theme.designSystem?.designSystemRadius.circular ?? 50.0),
                ),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: theme.designSystem?.designSystemColors.onPrimary ?? Colors.white,
                  size: 20,
                ),
              ),

              // Like Button
              Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? theme.designSystem?.designSystemColors.primary ?? const Color(0xFFFE2C54) : theme.designSystem?.designSystemColors.onSurfaceVariant ?? const Color(0xFFB3B3B3),
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconFallback(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: theme.designSystem?.designSystemGradients.card ?? DesignSystem.gradientCard,
        borderRadius: BorderRadius.circular(theme.designSystem?.designSystemRadius.lg ?? 24.0),
      ),
      child: Icon(
        icon ?? Icons.music_note,
        color: iconColor ?? theme.designSystem?.designSystemColors.primary ?? const Color(0xFFFE2C54),
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
    final theme = Theme.of(context);

    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: onTap,
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.designSystem?.designSystemColors.primary ?? const Color(0xFFFE2C54),
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? Icon(
                    Icons.person,
                    color: theme.designSystem?.designSystemColors.onPrimary ?? Colors.white,
                    size: 32,
                  )
                : null,
          ),

          SizedBox(width: theme.designSystem?.designSystemSpacing.md ?? 16.0),

          // Name and Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: theme.designSystem?.designSystemTypography.titleMedium.copyWith(
                    color: theme.designSystem?.designSystemColors.onSurface,
                  ) ?? const TextStyle(),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: theme.designSystem?.designSystemSpacing.xs ?? 8.0),
                  Text(
                    subtitle!,
                    style: theme.designSystem?.designSystemTypography.bodySmall.copyWith(
                      color: theme.designSystem?.designSystemColors.onSurfaceVariant,
                    ) ?? const TextStyle(),
                  ),
                ],
              ],
            ),
          ),

          // Actions
          if (actions != null) ...[
            SizedBox(width: theme.designSystem?.designSystemSpacing.sm ?? 12.0),
            ...actions!,
          ],
        ],
      ),
    );
  }
}