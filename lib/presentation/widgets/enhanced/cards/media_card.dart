import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A card widget for displaying media items (albums, playlists, artists)
///
/// Displays an image with optional title, subtitle, and tap action.
/// Supports different layouts (square, portrait, landscape).
///
/// Example:
/// ```dart
/// MediaCard(
///   imageUrl: album.artworkUrl,
///   title: album.title,
///   subtitle: album.artist,
///   onTap: () => Navigator.push(...),
///   aspectRatio: 1.0, // Square
/// )
/// ```
class MediaCard extends StatelessWidget {
  /// Media image URL
  final String? imageUrl;

  /// Title text
  final String title;

  /// Subtitle text
  final String? subtitle;

  /// Tap callback
  final VoidCallback? onTap;

  /// Long press callback
  final VoidCallback? onLongPress;

  /// Image aspect ratio (1.0 for square, 0.75 for portrait, 1.5 for landscape)
  final double aspectRatio;

  /// Border radius for the card
  final double borderRadius;

  /// Placeholder icon when image is null
  final IconData? placeholderIcon;

  /// Whether to show a play button overlay
  final bool showPlayButton;

  /// Custom badge widget (e.g., "NEW", "EXPLICIT")
  final Widget? badge;

  /// Width of the card
  final double? width;

  /// Whether to show text below or overlaid on image
  final bool overlayText;

  const MediaCard({
    super.key,
    this.imageUrl,
    required this.title,
    this.subtitle,
    this.onTap,
    this.onLongPress,
    this.aspectRatio = 1.0,
    this.borderRadius = DesignSystem.radiusMD,
    this.placeholderIcon,
    this.showPlayButton = false,
    this.badge,
    this.width,
    this.overlayText = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Card
          _buildImageCard(),

          // Text Content (if not overlaid)
          if (!overlayText) ...[
            const SizedBox(height: DesignSystem.spacingSM),
            _buildTextContent(),
          ],
        ],
      ),
    );
  }

  Widget _buildImageCard() {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            color: DesignSystem.surfaceContainer,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image or Placeholder
                _buildImage(),

                // Play Button Overlay
                if (showPlayButton) _buildPlayButtonOverlay(),

                // Badge
                if (badge != null) _buildBadge(),

                // Text Overlay (if enabled)
                if (overlayText) _buildTextOverlay(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
            ),
          );
        },
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: DesignSystem.surfaceContainerHigh,
      child: Icon(
        placeholderIcon ?? Icons.music_note,
        size: 48,
        color: DesignSystem.onSurfaceVariant.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildPlayButtonOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: DesignSystem.primary.withValues(alpha: 0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Icon(
            Icons.play_arrow,
            color: DesignSystem.onPrimary,
            size: 32,
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Positioned(
      top: 8,
      right: 8,
      child: badge!,
    );
  }

  Widget _buildTextOverlay() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withValues(alpha: 0.8),
            ],
          ),
        ),
        padding: const EdgeInsets.all(DesignSystem.spacingMD),
        child: _buildTextContent(isOverlay: true),
      ),
    );
  }

  Widget _buildTextContent({bool isOverlay = false}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: (isOverlay
                  ? DesignSystem.bodyMedium
                  : DesignSystem.bodyMedium)
              .copyWith(
            color: isOverlay ? Colors.white : DesignSystem.onSurface,
            fontWeight: FontWeight.w600,
          ),
          maxLines: isOverlay ? 2 : 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: DesignSystem.bodySmall.copyWith(
              color: isOverlay
                  ? Colors.white.withValues(alpha: 0.8)
                  : DesignSystem.onSurfaceVariant,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  /// Factory for album cards (square)
  factory MediaCard.album({
    required String? imageUrl,
    required String title,
    required String artist,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool showPlayButton = false,
    Widget? badge,
    double? width,
  }) {
    return MediaCard(
      imageUrl: imageUrl,
      title: title,
      subtitle: artist,
      onTap: onTap,
      onLongPress: onLongPress,
      aspectRatio: 1.0,
      placeholderIcon: Icons.album,
      showPlayButton: showPlayButton,
      badge: badge,
      width: width,
    );
  }

  /// Factory for playlist cards (square)
  factory MediaCard.playlist({
    required String? imageUrl,
    required String title,
    String? trackCount,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool showPlayButton = false,
    Widget? badge,
    double? width,
  }) {
    return MediaCard(
      imageUrl: imageUrl,
      title: title,
      subtitle: trackCount,
      onTap: onTap,
      onLongPress: onLongPress,
      aspectRatio: 1.0,
      placeholderIcon: Icons.queue_music,
      showPlayButton: showPlayButton,
      badge: badge,
      width: width,
    );
  }

  /// Factory for artist cards (circular)
  factory MediaCard.artist({
    required String? imageUrl,
    required String name,
    String? genre,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    double? width,
  }) {
    return MediaCard(
      imageUrl: imageUrl,
      title: name,
      subtitle: genre,
      onTap: onTap,
      onLongPress: onLongPress,
      aspectRatio: 1.0,
      borderRadius: 999, // Fully circular
      placeholderIcon: Icons.person,
      width: width,
    );
  }
}

/// A badge widget for MediaCard overlays
class MediaCardBadge extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;

  const MediaCardBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? DesignSystem.primary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: DesignSystem.labelSmall.copyWith(
          color: textColor ?? DesignSystem.onPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  factory MediaCardBadge.newRelease() {
    return MediaCardBadge(
      label: 'NEW',
      backgroundColor: DesignSystem.secondary,
    );
  }

  factory MediaCardBadge.explicit() {
    return const MediaCardBadge(
      label: 'E',
      backgroundColor: Colors.grey,
    );
  }
}
