import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// A network image widget with built-in fallback, loading, and error handling
///
/// Displays network images with graceful degradation to a placeholder when
/// the image fails to load or is null.
///
/// Example:
/// ```dart
/// ImageWithFallback(
///   imageUrl: album.artworkUrl,
///   width: 100,
///   height: 100,
///   borderRadius: 8,
///   fallbackIcon: Icons.album,
/// )
/// ```
class ImageWithFallback extends StatelessWidget {
  /// Network image URL
  final String? imageUrl;

  /// Image width
  final double? width;

  /// Image height
  final double? height;

  /// Border radius
  final double borderRadius;

  /// BoxFit for the image
  final BoxFit fit;

  /// Fallback icon when image fails to load
  final IconData fallbackIcon;

  /// Fallback icon size
  final double fallbackIconSize;

  /// Fallback background color
  final Color? fallbackColor;

  /// Whether to show a loading indicator
  final bool showLoadingIndicator;

  /// Custom placeholder widget
  final Widget? placeholder;

  /// Custom error widget
  final Widget? errorWidget;

  const ImageWithFallback({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.image,
    this.fallbackIconSize = 48,
    this.fallbackColor,
    this.showLoadingIndicator = true,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final widget = imageUrl != null && imageUrl!.isNotEmpty
        ? _buildNetworkImage()
        : _buildFallback();

    if (borderRadius > 0) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: widget,
      );
    }

    return widget;
  }

  Widget _buildNetworkImage() {
    return Image.network(
      imageUrl!,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildFallback();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        if (!showLoadingIndicator) {
          return placeholder ?? _buildFallback();
        }

        return _buildLoading(loadingProgress);
      },
    );
  }

  Widget _buildFallback() {
    return Container(
      width: width,
      height: height,
      color: fallbackColor ?? DesignSystem.surfaceContainerHigh,
      child: Center(
        child: Icon(
          fallbackIcon,
          size: fallbackIconSize,
          color: DesignSystem.onSurfaceVariant.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildLoading(ImageChunkEvent loadingProgress) {
    return Container(
      width: width,
      height: height,
      color: fallbackColor ?? DesignSystem.surfaceContainerHigh,
      child: Center(
        child: CircularProgressIndicator(
          value: loadingProgress.expectedTotalBytes != null
              ? loadingProgress.cumulativeBytesLoaded /
                  loadingProgress.expectedTotalBytes!
              : null,
          strokeWidth: 2,
          color: DesignSystem.primary,
        ),
      ),
    );
  }

  /// Factory for circular/avatar images
  factory ImageWithFallback.circular({
    String? imageUrl,
    required double size,
    IconData fallbackIcon = Icons.person,
    Color? fallbackColor,
    bool showLoadingIndicator = true,
  }) {
    return ImageWithFallback(
      imageUrl: imageUrl,
      width: size,
      height: size,
      borderRadius: size / 2,
      fit: BoxFit.cover,
      fallbackIcon: fallbackIcon,
      fallbackIconSize: size * 0.5,
      fallbackColor: fallbackColor,
      showLoadingIndicator: showLoadingIndicator,
    );
  }

  /// Factory for square thumbnails
  factory ImageWithFallback.square({
    String? imageUrl,
    required double size,
    double borderRadius = DesignSystem.radiusMD,
    IconData fallbackIcon = Icons.image,
    Color? fallbackColor,
    bool showLoadingIndicator = true,
  }) {
    return ImageWithFallback(
      imageUrl: imageUrl,
      width: size,
      height: size,
      borderRadius: borderRadius,
      fit: BoxFit.cover,
      fallbackIcon: fallbackIcon,
      fallbackIconSize: size * 0.4,
      fallbackColor: fallbackColor,
      showLoadingIndicator: showLoadingIndicator,
    );
  }

  /// Factory for album artwork
  factory ImageWithFallback.albumArt({
    String? imageUrl,
    required double size,
    double borderRadius = DesignSystem.radiusMD,
    bool showLoadingIndicator = true,
  }) {
    return ImageWithFallback(
      imageUrl: imageUrl,
      width: size,
      height: size,
      borderRadius: borderRadius,
      fit: BoxFit.cover,
      fallbackIcon: Icons.album,
      fallbackIconSize: size * 0.4,
      showLoadingIndicator: showLoadingIndicator,
    );
  }

  /// Factory for artist images
  factory ImageWithFallback.artist({
    String? imageUrl,
    required double size,
    bool showLoadingIndicator = true,
  }) {
    return ImageWithFallback.circular(
      imageUrl: imageUrl,
      size: size,
      fallbackIcon: Icons.person,
      showLoadingIndicator: showLoadingIndicator,
    );
  }
}

/// A cached network image with memory and disk caching
/// 
/// Note: This is a basic implementation. For production use, consider
/// using the `cached_network_image` package for better performance.
class CachedImageWithFallback extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit fit;
  final IconData fallbackIcon;
  final double fallbackIconSize;
  final Color? fallbackColor;

  const CachedImageWithFallback({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.borderRadius = 0,
    this.fit = BoxFit.cover,
    this.fallbackIcon = Icons.image,
    this.fallbackIconSize = 48,
    this.fallbackColor,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: Implement proper caching using cached_network_image package
    // For now, delegate to ImageWithFallback
    return ImageWithFallback(
      imageUrl: imageUrl,
      width: width,
      height: height,
      borderRadius: borderRadius,
      fit: fit,
      fallbackIcon: fallbackIcon,
      fallbackIconSize: fallbackIconSize,
      fallbackColor: fallbackColor,
    );
  }
}
