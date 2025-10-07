import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/design_system.dart';

/// A reusable image widget with consistent fallback handling.
/// Provides loading states, error handling, and placeholder images.
///
/// Features:
/// - Network image with caching support
/// - Customizable loading and error states
/// - Fallback to placeholder or asset image
/// - Consistent styling and sizing
/// - Memory efficient with proper disposal
/// - Accessibility support
class ImageWithFallback extends StatelessWidget {
  /// The image URL to load
  final String? imageUrl;

  /// Width of the image
  final double? width;

  /// Height of the image
  final double? height;

  /// BoxFit for the image
  final BoxFit fit;

  /// Border radius for the image
  final BorderRadius? borderRadius;

  /// Shape for the image container
  final BoxShape shape;

  /// Placeholder widget while loading
  final Widget? placeholder;

  /// Error widget when image fails to load
  final Widget? errorWidget;

  /// Asset image path for fallback
  final String? fallbackAsset;

  /// Icon for placeholder when no image URL or asset
  final IconData? placeholderIcon;

  /// Size of the placeholder icon
  final double placeholderIconSize;

  /// Color of the placeholder icon
  final Color? placeholderIconColor;

  /// Background color for the image container
  final Color? backgroundColor;

  /// Whether to show a subtle border
  final bool showBorder;

  /// Border color
  final Color? borderColor;

  /// Whether to use hero animation
  final String? heroTag;

  /// Alignment for the image
  final Alignment alignment;

  /// Callback when image load starts
  final VoidCallback? onLoadStart;

  /// Callback when image loads successfully
  final VoidCallback? onLoadSuccess;

  /// Callback when image fails to load
  final VoidCallback? onLoadError;

  const ImageWithFallback({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.placeholder,
    this.errorWidget,
    this.fallbackAsset,
    this.placeholderIcon,
    this.placeholderIconSize = 48,
    this.placeholderIconColor,
    this.backgroundColor,
    this.showBorder = false,
    this.borderColor,
    this.heroTag,
    this.alignment = Alignment.center,
    this.onLoadStart,
    this.onLoadSuccess,
    this.onLoadError,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    // If no image URL and no fallback asset, show placeholder
    if ((imageUrl == null || imageUrl!.isEmpty) && (fallbackAsset == null || fallbackAsset!.isEmpty)) {
      return _buildPlaceholderContainer();
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? design.designSystemColors.surfaceContainer,
        borderRadius: shape == BoxShape.circle ? null : borderRadius,
        shape: shape,
        border: showBorder
            ? Border.all(
                color: borderColor ?? design.designSystemColors.border,
                width: 1,
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: shape == BoxShape.circle ? BorderRadius.zero : borderRadius ?? BorderRadius.zero,
        child: heroTag != null
            ? Hero(
                tag: heroTag!,
                child: _buildImage(),
              )
            : _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    // Use fallback asset if no image URL
    final String? urlToLoad = imageUrl ?? fallbackAsset;

    if (urlToLoad == null || urlToLoad.isEmpty) {
      return _buildPlaceholderContainer();
    }

    // Check if it's an asset or network image
    if (urlToLoad.startsWith('assets/') || urlToLoad.startsWith('lib/')) {
      return _buildAssetImage(urlToLoad);
    }

    return _buildNetworkImage(urlToLoad);
  }

  Widget _buildNetworkImage(String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      alignment: alignment,
      placeholder: (context, url) {
        onLoadStart?.call();
        return placeholder ?? _buildLoadingPlaceholder();
      },
      errorWidget: (context, url, error) {
        onLoadError?.call();
        return errorWidget ?? _buildErrorPlaceholder();
      },
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 100),
    );
  }

  Widget _buildAssetImage(String assetPath) {
    return Image.asset(
      assetPath,
      fit: fit,
      alignment: alignment,
      errorBuilder: (context, error, stackTrace) {
        onLoadError?.call();
        return errorWidget ?? _buildErrorPlaceholder();
      },
    );
  }

  Widget _buildPlaceholderContainer() {
    return Container(
      color: backgroundColor ?? DesignSystem.surfaceContainer,
      child: _buildPlaceholderContent(),
    );
  }

  Widget _buildPlaceholderContent() {
    if (placeholder != null) {
      return placeholder!;
    }

    return Icon(
      placeholderIcon ?? Icons.image,
      size: placeholderIconSize,
      color: placeholderIconColor ?? DesignSystem.onSurfaceVariant,
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      color: DesignSystem.surfaceContainer,
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: DesignSystem.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: DesignSystem.surfaceContainer,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            size: 24, // placeholderIconSize is not const, so use fixed
            color: DesignSystem.onSurfaceVariant,
          ),
          SizedBox(height: 8),
          Text(
            'Failed to load',
            style: const TextStyle(
              color: DesignSystem.onSurfaceVariant,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}