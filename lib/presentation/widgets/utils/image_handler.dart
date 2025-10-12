import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/design_system.dart';

/// Utility class for handling image loading, caching, and error states.
/// Provides consistent image handling across the application.
///
/// **Features:**
/// - Cached network image loading
/// - Placeholder and error widgets
/// - Consistent styling with design system
/// - Image validation and fallbacks
/// - Customizable loading and error states
///
/// **Usage:**
/// ```dart
/// // Basic usage with default placeholder
/// ImageHandler.network(
///   context: context,
///   imageUrl: 'https://example.com/image.jpg',
///   width: 100,
///   height: 100,
/// );
///
/// // With custom placeholder and error widget
/// ImageHandler.network(
///   context: context,
///   imageUrl: 'https://example.com/image.jpg',
///   width: 100,
///   height: 100,
///   placeholder: CustomLoadingWidget(),
///   errorWidget: CustomErrorWidget(),
/// );
///
/// // With custom image type
/// ImageHandler.asset(
///   context: context,
///   assetPath: 'assets/images/music_icon.png',
///   width: 48,
///   height: 48,
/// );
/// ```
class ImageHandler {
  /// Private constructor to prevent instantiation
  ImageHandler._();

  /// Build a cached network image with consistent styling
  static Widget network({
    required BuildContext context,
    required String? imageUrl,
    required double width,
    required double height,
    Widget? placeholder,
    Widget? errorWidget,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    bool showPlayButton = false,
    VoidCallback? onPlayPressed,
  }) {
    // Return placeholder if URL is null or empty
    if (imageUrl == null || imageUrl.isEmpty) {
      return _buildPlaceholderImage(
        context: context,
        width: width,
        height: height,
        borderRadius: borderRadius,
      );
    }

    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.md),
        color: design.designSystemColors.surfaceContainer,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.md),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Main image
            CachedNetworkImage(
              imageUrl: imageUrl,
              fit: fit,
              placeholder: (context, url) => placeholder ?? _buildDefaultPlaceholder(context),
              errorWidget: (context, url, error) => errorWidget ?? _buildDefaultErrorWidget(context),
            ),

            // Play button overlay
            if (showPlayButton)
              Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.md),
                  gradient: design.designSystemGradients.overlay,
                ),
                child: Center(
                  child: _buildPlayButton(context, onPlayPressed),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Build an asset image with consistent styling
  static Widget asset({
    required BuildContext context,
    required String assetPath,
    required double width,
    required double height,
    BoxFit fit = BoxFit.cover,
    BorderRadius? borderRadius,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.md),
        color: design.designSystemColors.surfaceContainer,
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.md),
        child: Image.asset(
          assetPath,
          fit: fit,
          color: color,
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderImage(
              context: context,
              width: width,
              height: height,
              borderRadius: borderRadius,
            );
          },
        ),
      ),
    );
  }

  /// Build a placeholder image widget
  static Widget _buildPlaceholderImage({
    required BuildContext context,
    required double width,
    required double height,
    BorderRadius? borderRadius,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(design.designSystemRadius.md),
        gradient: design.designSystemGradients.card,
      ),
      child: Icon(
        Icons.music_note,
        size: width * 0.3,
        color: design.designSystemColors.onSurfaceVariant,
      ),
    );
  }

  /// Build default placeholder widget for loading states
  static Widget _buildDefaultPlaceholder(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: DesignSystem.gradientCard,
      ),
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(DesignSystem.primary),
          ),
        ),
      ),
    );
  }

  /// Build default error widget for failed image loads
  static Widget _buildDefaultErrorWidget(BuildContext context) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Container(
      decoration: BoxDecoration(
        gradient: design.designSystemGradients.card,
      ),
      child: Icon(
        Icons.broken_image,
        size: 32,
        color: design.designSystemColors.onSurfaceVariant,
      ),
    );
  }

  /// Build play button overlay
  static Widget _buildPlayButton(BuildContext context, VoidCallback? onPressed) {
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: DesignSystem.primary,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Icons.play_arrow_rounded,
          size: 32,
          color: DesignSystem.onPrimary,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }

  /// Validate if an image URL is valid
  static bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return false;

    // Basic URL validation
    final uri = Uri.tryParse(url);
    if (uri == null || !uri.hasScheme) return false;

    // Check for common image extensions
    final imageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
    final lowerUrl = url.toLowerCase();

    return imageExtensions.any((ext) => lowerUrl.contains(ext)) ||
           lowerUrl.contains('unsplash') ||
           lowerUrl.contains('placeholder') ||
           lowerUrl.contains('image');
  }

  /// Get a default music-themed placeholder for different contexts
  static Widget getMusicPlaceholder({
    required BuildContext context,
    required double size,
    IconData? icon,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: design.designSystemGradients.card,
        borderRadius: BorderRadius.circular(design.designSystemRadius.md),
      ),
      child: Icon(
        icon ?? Icons.music_note,
        size: size * 0.4,
        color: design.designSystemColors.onSurfaceVariant,
      ),
    );
  }

  /// Get a default user avatar placeholder
  static Widget getAvatarPlaceholder({
    required BuildContext context,
    required double size,
  }) {
    final theme = Theme.of(context);
    final design = theme.extension<DesignSystemThemeExtension>()!;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: design.designSystemGradients.card,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Icon(
        Icons.person,
        size: size * 0.4,
        color: design.designSystemColors.onSurfaceVariant,
      ),
    );
  }
}