import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../common/image_with_fallback.dart';

/// A list tile for displaying a music track
///
/// Example:
/// ```dart
/// TrackTile(
///   title: 'Song Title',
///   artist: 'Artist Name',
///   imageUrl: track.artworkUrl,
///   onTap: () => playTrack(),
///   onPlayTap: () => playNow(),
/// )
/// ```
class TrackTile extends StatelessWidget {
  final String title;
  final String? artist;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onPlayTap;
  final VoidCallback? onMoreTap;
  final bool isPlaying;
  final String? duration;
  final Widget? trailing;

  const TrackTile({
    super.key,
    required this.title,
    this.artist,
    this.imageUrl,
    this.onTap,
    this.onPlayTap,
    this.onMoreTap,
    this.isPlaying = false,
    this.duration,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ImageWithFallback.square(
        imageUrl: imageUrl,
        size: 50,
        borderRadius: DesignSystem.radiusSM,
        fallbackIcon: Icons.music_note,
      ),
      title: Text(
        title,
        style: DesignSystem.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
          color: isPlaying ? DesignSystem.primary : null,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: artist != null
          ? Text(
              artist!,
              style: DesignSystem.bodySmall.copyWith(
                color: DesignSystem.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: trailing ??
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (duration != null)
                Padding(
                  padding: const EdgeInsets.only(right: DesignSystem.spacingSM),
                  child: Text(
                    duration!,
                    style: DesignSystem.bodySmall.copyWith(
                      color: DesignSystem.onSurfaceVariant,
                    ),
                  ),
                ),
              if (onPlayTap != null)
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: DesignSystem.primary,
                  ),
                  onPressed: onPlayTap,
                ),
              if (onMoreTap != null)
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: onMoreTap,
                ),
            ],
          ),
    );
  }
}

/// A list tile for displaying an album
class AlbumTile extends StatelessWidget {
  final String title;
  final String? artist;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;
  final String? year;
  final int? trackCount;

  const AlbumTile({
    super.key,
    required this.title,
    this.artist,
    this.imageUrl,
    this.onTap,
    this.onMoreTap,
    this.year,
    this.trackCount,
  });

  @override
  Widget build(BuildContext context) {
    String? subtitle;
    if (artist != null && year != null) {
      subtitle = '$artist • $year';
    } else if (artist != null) {
      subtitle = artist;
    } else if (year != null) {
      subtitle = year;
    }

    return ListTile(
      onTap: onTap,
      leading: ImageWithFallback.square(
        imageUrl: imageUrl,
        size: 56,
        borderRadius: DesignSystem.radiusSM,
        fallbackIcon: Icons.album,
      ),
      title: Text(
        title,
        style: DesignSystem.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: DesignSystem.bodySmall.copyWith(
                color: DesignSystem.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: onMoreTap != null
          ? IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: onMoreTap,
            )
          : (trackCount != null
              ? Text(
                  '$trackCount songs',
                  style: DesignSystem.bodySmall.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                )
              : null),
    );
  }
}

/// A list tile for displaying an artist
class ArtistTile extends StatelessWidget {
  final String name;
  final String? genre;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onFollowTap;
  final bool isFollowing;

  const ArtistTile({
    super.key,
    required this.name,
    this.genre,
    this.imageUrl,
    this.onTap,
    this.onFollowTap,
    this.isFollowing = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ImageWithFallback.circular(
        imageUrl: imageUrl,
        size: 56,
        fallbackIcon: Icons.person,
      ),
      title: Text(
        name,
        style: DesignSystem.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: genre != null
          ? Text(
              genre!,
              style: DesignSystem.bodySmall.copyWith(
                color: DesignSystem.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: onFollowTap != null
          ? IconButton(
              icon: Icon(
                isFollowing ? Icons.favorite : Icons.favorite_border,
                color: isFollowing ? DesignSystem.error : null,
              ),
              onPressed: onFollowTap,
            )
          : null,
    );
  }
}

/// A list tile for displaying a playlist
class PlaylistTile extends StatelessWidget {
  final String title;
  final String? description;
  final String? imageUrl;
  final VoidCallback? onTap;
  final VoidCallback? onMoreTap;
  final int? trackCount;
  final String? creator;

  const PlaylistTile({
    super.key,
    required this.title,
    this.description,
    this.imageUrl,
    this.onTap,
    this.onMoreTap,
    this.trackCount,
    this.creator,
  });

  @override
  Widget build(BuildContext context) {
    String? subtitle;
    if (creator != null && trackCount != null) {
      subtitle = 'By $creator • $trackCount songs';
    } else if (creator != null) {
      subtitle = 'By $creator';
    } else if (trackCount != null) {
      subtitle = '$trackCount songs';
    } else if (description != null) {
      subtitle = description;
    }

    return ListTile(
      onTap: onTap,
      leading: ImageWithFallback.square(
        imageUrl: imageUrl,
        size: 56,
        borderRadius: DesignSystem.radiusSM,
        fallbackIcon: Icons.queue_music,
      ),
      title: Text(
        title,
        style: DesignSystem.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: DesignSystem.bodySmall.copyWith(
                color: DesignSystem.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: onMoreTap != null
          ? IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: onMoreTap,
            )
          : null,
    );
  }
}

/// A compact track tile for dense lists
class CompactTrackTile extends StatelessWidget {
  final String title;
  final String? artist;
  final VoidCallback? onTap;
  final bool isPlaying;
  final int? trackNumber;

  const CompactTrackTile({
    super.key,
    required this.title,
    this.artist,
    this.onTap,
    this.isPlaying = false,
    this.trackNumber,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: onTap,
      leading: trackNumber != null
          ? SizedBox(
              width: 24,
              child: Center(
                child: Text(
                  '$trackNumber',
                  style: DesignSystem.bodySmall.copyWith(
                    color: isPlaying
                        ? DesignSystem.primary
                        : DesignSystem.onSurfaceVariant,
                  ),
                ),
              ),
            )
          : Icon(
              isPlaying ? Icons.play_arrow : Icons.music_note,
              color: isPlaying ? DesignSystem.primary : DesignSystem.onSurfaceVariant,
              size: 20,
            ),
      title: Text(
        title,
        style: DesignSystem.bodyMedium.copyWith(
          color: isPlaying ? DesignSystem.primary : null,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: artist != null
          ? Text(
              artist!,
              style: DesignSystem.bodySmall.copyWith(
                color: DesignSystem.onSurfaceVariant,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: isPlaying
          ? Icon(
              Icons.volume_up,
              size: 20,
              color: DesignSystem.primary,
            )
          : null,
    );
  }
}
