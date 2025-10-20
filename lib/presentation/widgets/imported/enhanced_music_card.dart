import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/design_system.dart';

/// Enhanced music card widget using MusicBud design system
class EnhancedMusicCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool isPlaying;
  final bool showPlayButton;

  const EnhancedMusicCard({
    super.key,
    this.imageUrl,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
    this.isPlaying = false,
    this.showPlayButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingMD,
        vertical: DesignSystem.spacingXS,
      ),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        border: isPlaying
            ? Border.all(color: DesignSystem.pinkAccent, width: 2)
            : null,
        boxShadow: DesignSystem.shadowCard,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
          child: Padding(
            padding: const EdgeInsets.all(DesignSystem.spacingSM),
            child: Row(
              children: [
                // Album/Track artwork
                _buildArtwork(),
                const SizedBox(width: DesignSystem.spacingMD),
                
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: DesignSystem.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: DesignSystem.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) ...[ 
                        const SizedBox(height: DesignSystem.spacingXS),
                        Text(
                          subtitle!,
                          style: DesignSystem.bodySmall.copyWith(
                            color: DesignSystem.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Trailing widget or play button
                if (trailing != null)
                  trailing!
                else if (showPlayButton)
                  _buildPlayButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArtwork() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        color: DesignSystem.surfaceContainerHigh,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildPlaceholder(),
                errorWidget: (context, url, error) => _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: DesignSystem.surfaceContainerHigh,
      child: const Icon(
        Icons.music_note,
        color: DesignSystem.onSurfaceVariant,
        size: 24,
      ),
    );
  }

  Widget _buildPlayButton() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isPlaying
            ? DesignSystem.pinkAccent
            : DesignSystem.pinkAccent.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isPlaying ? Icons.pause : Icons.play_arrow,
        color: isPlaying
            ? DesignSystem.onPrimary
            : DesignSystem.pinkAccent,
        size: 20,
      ),
    );
  }
}

/// Grid variant of the music card
class EnhancedMusicCardGrid extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool isPlaying;

  const EnhancedMusicCardGrid({
    super.key,
    this.imageUrl,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        border: isPlaying
            ? Border.all(color: DesignSystem.pinkAccent, width: 2)
            : null,
        boxShadow: DesignSystem.shadowCard,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Album/Track artwork
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(DesignSystem.radiusMD),
                      topRight: Radius.circular(DesignSystem.radiusMD),
                    ),
                    color: DesignSystem.surfaceContainerHigh,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(DesignSystem.radiusMD),
                      topRight: Radius.circular(DesignSystem.radiusMD),
                    ),
                    child: imageUrl != null && imageUrl!.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => _buildPlaceholder(),
                            errorWidget: (context, url, error) =>
                                _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),
                ),
              ),
              
              // Title and subtitle
              Padding(
                padding: const EdgeInsets.all(DesignSystem.spacingSM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: DesignSystem.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: DesignSystem.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: DesignSystem.spacingXS),
                      Text(
                        subtitle!,
                        style: DesignSystem.bodySmall.copyWith(
                          color: DesignSystem.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: DesignSystem.surfaceContainerHigh,
      child: const Center(
        child: Icon(
          Icons.music_note,
          color: DesignSystem.onSurfaceVariant,
          size: 48,
        ),
      ),
    );
  }
}

/// Compact music card for lists
class CompactMusicCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  const CompactMusicCard({
    super.key,
    this.imageUrl,
    required this.title,
    this.subtitle,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingMD,
        vertical: DesignSystem.spacingXS,
      ),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
          color: DesignSystem.surfaceContainerHigh,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imageUrl!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => _buildPlaceholder(),
                  errorWidget: (context, url, error) => _buildPlaceholder(),
                )
              : _buildPlaceholder(),
        ),
      ),
      title: Text(
        title,
        style: DesignSystem.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: DesignSystem.onSurface,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: DesignSystem.bodySmall.copyWith(
                color: DesignSystem.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: DesignSystem.surfaceContainerHigh,
      child: const Icon(
        Icons.music_note,
        color: DesignSystem.onSurfaceVariant,
        size: 20,
      ),
    );
  }
}
