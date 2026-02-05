import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/design_system.dart';
import '../base/base_card.dart';
import 'media_card_overlay.dart';
import 'media_card_content.dart';

/// A reusable media card widget for displaying music, artists, playlists, etc.
/// Provides consistent styling and layout for media items across the app.
///
/// Features:
/// - Image with fallback handling
/// - Title and subtitle text
/// - Optional action buttons/menu
/// - Consistent theming and spacing
/// - Tap gesture support
class MediaCard extends BaseCard {
  /// The image URL for the media item
  final String? imageUrl;

  /// The title text (e.g., song name, artist name, playlist name)
  final String title;

  /// The subtitle text (e.g., artist name, track count, description)
  final String? subtitle;

  /// Optional action buttons to display in the card
  final List<Widget>? actions;

  /// Height of the image section
  final double? imageHeight;

  /// Width of the image section
  final double? imageWidth;

  /// Whether to show a play button overlay on the image
  final bool showPlayButton;

  /// Custom play button widget (if null, uses default circular play button)
  final Widget? playButton;

  /// Border radius for the image
  final BorderRadius? imageBorderRadius;

  const MediaCard({
    super.key,
    super.onTap,
    super.shape,
    super.padding,
    super.backgroundColor,
    super.borderRadius,
    super.showElevation,
    super.elevation,
    this.imageUrl,
    required this.title,
    this.subtitle,
    this.actions,
    this.imageHeight = 140,
    this.imageWidth,
    this.showPlayButton = false,
    this.playButton,
    this.imageBorderRadius,
  });

  @override
  Widget buildCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image Section
        _buildImageSection(context),

        const SizedBox(height: DesignSystem.spacingMD),

        // Content Section
        MediaCardContent(
          title: title,
          subtitle: subtitle,
        ),

        // Actions Section
        if (actions != null && actions!.isNotEmpty) ...[
          const SizedBox(height: DesignSystem.spacingMD),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: actions!,
          ),
        ],
      ],
    );
  }

  Widget _buildImageSection(BuildContext context) {
    return Container(
      height: imageHeight,
      width: imageWidth ?? double.infinity,
      decoration: BoxDecoration(
        borderRadius: imageBorderRadius ?? BorderRadius.circular(DesignSystem.radiusMD),
        color: DesignSystem.surfaceContainer,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          _buildImage(),

          // Play Button Overlay
          MediaCardOverlay(
            show: showPlayButton,
            playButton: playButton,
            borderRadius: imageBorderRadius ?? BorderRadius.circular(DesignSystem.radiusMD),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildPlaceholderImage();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
      child: CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholderImage(),
        errorWidget: (context, url, error) => _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        gradient: DesignSystem.gradientCard,
      ),
      child: const Icon(
        Icons.music_note,
        size: 48,
        color: DesignSystem.onSurfaceVariant,
      ),
    );
  }
}
