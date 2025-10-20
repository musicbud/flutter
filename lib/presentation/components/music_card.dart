import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';

class MusicCard extends StatelessWidget {
  final String artistName;
  final String songTitle;
  final String? albumArt;
  final VoidCallback? onTap;
  final bool isLiked;
  final VoidCallback? onLikePressed;
  final bool showLikeButton;

  const MusicCard({
    super.key,
    required this.artistName,
    required this.songTitle,
    this.albumArt,
    this.onTap,
    this.isLiked = false,
    this.onLikePressed,
    this.showLikeButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: MusicBudSpacing.sm,
        vertical: MusicBudSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: MusicBudColors.backgroundTertiary,
        borderRadius: BorderRadius.circular(
          MusicBudSpacing.radiusLg,
        ),
        boxShadow: [
          BoxShadow(
            color: MusicBudColors.backgroundPrimary.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            MusicBudSpacing.radiusLg,
          ),
          child: Padding(
            padding: const EdgeInsets.all(MusicBudSpacing.md),
            child: Row(
              children: [
                // Album artwork or placeholder
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      MusicBudSpacing.radiusMd,
                    ),
                    color: MusicBudColors.primaryRed.withValues(alpha: 0.1),
                  ),
                  child: albumArt != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(
                            MusicBudSpacing.radiusMd,
                          ),
                          child: Image.network(
                            albumArt!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return _buildAlbumPlaceholder();
                            },
                          ),
                        )
                      : _buildAlbumPlaceholder(),
                ),
                
                const SizedBox(width: MusicBudSpacing.md),
                
                // Song and artist info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        songTitle,
                        style: MusicBudTypography.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: MusicBudColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        artistName,
                        style: MusicBudTypography.bodyMedium.copyWith(
                          color: MusicBudColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                
                // Like button
                if (showLikeButton)
                  IconButton(
                    onPressed: onLikePressed,
                    icon: Icon(
                      isLiked ? Icons.favorite : Icons.favorite_border,
                      color: isLiked
                          ? MusicBudColors.primaryRed
                          : MusicBudColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          MusicBudSpacing.radiusMd,
        ),
        color: MusicBudColors.primaryRed.withValues(alpha: 0.1),
      ),
      child: const Icon(
        Icons.music_note_rounded,
        size: 28,
        color: MusicBudColors.primaryRed,
      ),
    );
  }
}

class MusicCardList extends StatelessWidget {
  final List<MusicCardData> songs;
  final Function(MusicCardData)? onSongTap;
  final Function(MusicCardData, bool)? onLikeToggle;

  const MusicCardList({
    super.key,
    required this.songs,
    this.onSongTap,
    this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: songs.length,
      padding: const EdgeInsets.symmetric(
        vertical: MusicBudSpacing.sm,
      ),
      itemBuilder: (context, index) {
        final song = songs[index];
        return MusicCard(
          artistName: song.artistName,
          songTitle: song.songTitle,
          albumArt: song.albumArt,
          isLiked: song.isLiked,
          onTap: () => onSongTap?.call(song),
          onLikePressed: () => onLikeToggle?.call(song, !song.isLiked),
        );
      },
    );
  }
}

class MusicCardData {
  final String id;
  final String artistName;
  final String songTitle;
  final String? albumArt;
  final bool isLiked;

  const MusicCardData({
    required this.id,
    required this.artistName,
    required this.songTitle,
    this.albumArt,
    this.isLiked = false,
  });

  MusicCardData copyWith({
    String? id,
    String? artistName,
    String? songTitle,
    String? albumArt,
    bool? isLiked,
  }) {
    return MusicCardData(
      id: id ?? this.id,
      artistName: artistName ?? this.artistName,
      songTitle: songTitle ?? this.songTitle,
      albumArt: albumArt ?? this.albumArt,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}