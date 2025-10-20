import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/design_system/design_system.dart';

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
        horizontal: MusicBudSpacing.md,
        vertical: MusicBudSpacing.xs,
      ),
      decoration: MusicBudComponents.cardDecoration.copyWith(
        border: isPlaying
            ? Border.all(color: MusicBudColors.primaryRed, width: 2)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
          child: Padding(
            padding: const EdgeInsets.all(MusicBudSpacing.sm),
            child: Row(
              children: [
                // Album/Track artwork
                _buildArtwork(),
                const SizedBox(width: MusicBudSpacing.md),
                
                // Title and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: MusicBudTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) ...[ 
                        const SizedBox(height: MusicBudSpacing.xs),
                        Text(
                          subtitle!,
                          style: MusicBudTypography.bodySmall.copyWith(
                            color: MusicBudColors.textSecondary,
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
        borderRadius: BorderRadius.circular(MusicBudSpacing.radiusMd),
        color: MusicBudColors.backgroundSecondary,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(MusicBudSpacing.radiusMd),
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
      color: MusicBudColors.backgroundSecondary,
      child: const Icon(
        Icons.music_note,
        color: MusicBudColors.textSecondary,
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
            ? MusicBudColors.primaryRed
            : MusicBudColors.primaryRed.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isPlaying ? Icons.pause : Icons.play_arrow,
        color: isPlaying
            ? MusicBudColors.textOnPrimary
            : MusicBudColors.primaryRed,
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
      decoration: MusicBudComponents.cardDecoration.copyWith(
        border: isPlaying
            ? Border.all(color: MusicBudColors.primaryRed, width: 2)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(MusicBudSpacing.radiusLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Album/Track artwork
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(MusicBudSpacing.radiusLg),
                      topRight: Radius.circular(MusicBudSpacing.radiusLg),
                    ),
                    color: MusicBudColors.backgroundSecondary,
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(MusicBudSpacing.radiusLg),
                      topRight: Radius.circular(MusicBudSpacing.radiusLg),
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
                padding: const EdgeInsets.all(MusicBudSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: MusicBudTypography.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: MusicBudSpacing.xs),
                      Text(
                        subtitle!,
                        style: MusicBudTypography.bodySmall.copyWith(
                          color: MusicBudColors.textSecondary,
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
      color: MusicBudColors.backgroundSecondary,
      child: const Center(
        child: Icon(
          Icons.music_note,
          color: MusicBudColors.textSecondary,
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
        horizontal: MusicBudSpacing.md,
        vertical: MusicBudSpacing.xs,
      ),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(MusicBudSpacing.radiusSm),
          color: MusicBudColors.backgroundSecondary,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(MusicBudSpacing.radiusSm),
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
        style: MusicBudTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: MusicBudTypography.bodySmall.copyWith(
                color: MusicBudColors.textSecondary,
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
      color: MusicBudColors.backgroundSecondary,
      child: const Icon(
        Icons.music_note,
        color: MusicBudColors.textSecondary,
        size: 20,
      ),
    );
  }
}
