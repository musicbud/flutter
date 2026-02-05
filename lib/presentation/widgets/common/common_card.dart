import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Reusable card widget with consistent styling and animations
class CommonCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final BoxShadow? shadow;
  final bool enableHover;
  final Duration animationDuration;

  const CommonCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.shadow,
    this.enableHover = true,
    this.animationDuration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    Widget card = Container(
      margin: margin ?? const EdgeInsets.all(DesignSystem.spacingSM),
      decoration: BoxDecoration(
        color: backgroundColor ?? DesignSystem.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(DesignSystem.radiusMD),
        boxShadow: [
          shadow ??
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: elevation ?? 4,
                offset: const Offset(0, 2),
              ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(DesignSystem.radiusMD),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: borderRadius ?? BorderRadius.circular(DesignSystem.radiusMD),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(DesignSystem.spacingMD),
              child: child,
            ),
          ),
        ),
      ),
    );

    if (enableHover && onTap != null) {
      return AnimatedContainer(
        duration: animationDuration,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: card,
        ),
      );
    }

    return card;
  }
}

/// Music item card for tracks, albums, artists
class MusicItemCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isPlaying;
  final bool isLiked;
  final VoidCallback? onLike;
  final VoidCallback? onPlay;
  final EdgeInsetsGeometry? margin;

  const MusicItemCard({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.onTap,
    this.trailing,
    this.isPlaying = false,
    this.isLiked = false,
    this.onLike,
    this.onPlay,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      onTap: onTap,
      margin: margin,
      child: Row(
        children: [
          // Image or placeholder
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
              color: DesignSystem.surfaceContainerHighest,
            ),
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.music_note,
                        color: DesignSystem.onSurfaceVariant,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.music_note,
                    color: DesignSystem.onSurfaceVariant,
                  ),
          ),
          const SizedBox(width: DesignSystem.spacingMD),

          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: DesignSystem.titleMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isPlaying
                        ? DesignSystem.primary
                        : DesignSystem.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: DesignSystem.spacingXS),
                  Text(
                    subtitle!,
                    style: TextStyle(color: DesignSystem.onSurface.withAlpha((255 * 0.7).round())),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Action buttons
          if (onPlay != null || onLike != null || trailing != null) ...[
            const SizedBox(width: DesignSystem.spacingSM),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onPlay != null)
                  IconButton(
                    onPressed: onPlay,
                    icon: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      color: DesignSystem.primary,
                    ),
                  ),
                if (onLike != null)
                  IconButton(
                    onPressed: onLike,
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked
                          ? DesignSystem.error
                          : DesignSystem.onSurfaceVariant,
                    ),
                  ),
                if (trailing != null) trailing!,
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Grid card for albums and playlists
class GridCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final VoidCallback? onTap;
  final Widget? overlay;
  final EdgeInsetsGeometry? margin;

  const GridCard({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.onTap,
    this.overlay,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      onTap: onTap,
      margin: margin,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
                color: DesignSystem.surfaceContainerHighest,
              ),
              child: Stack(
                children: [
                  if (imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
                      child: Image.network(
                        imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(
                            Icons.music_note,
                            size: 48,
                            color: DesignSystem.onSurfaceVariant,
                          ),
                        ),
                      ),
                    )
                  else
                    const Center(
                      child: Icon(
                        Icons.music_note,
                        size: 48,
                        color: DesignSystem.onSurfaceVariant,
                      ),
                    ),
                  if (overlay != null)
                    Positioned.fill(child: overlay!),
                ],
              ),
            ),
          ),

          // Title and subtitle
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(DesignSystem.spacingSM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: DesignSystem.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: DesignSystem.spacingXS),
                    Text(
                      subtitle!,
                      style: TextStyle(color: DesignSystem.onSurface.withAlpha((255 * 0.7).round())),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Section header card
class SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const SectionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.action,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      margin: margin,
      padding: padding ?? const EdgeInsets.all(DesignSystem.spacingMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: DesignSystem.headlineSmall.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: DesignSystem.spacingXS),
                      Text(
                        subtitle!,
                        style: DesignSystem.bodyMedium.copyWith(
                          color: DesignSystem.onSurface.withAlpha((255 * 0.7).round()),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (action != null) action!,
            ],
          ),

          const SizedBox(height: DesignSystem.spacingMD),

          // Content
          child,
        ],
      ),
    );
  }
}
