import 'package:flutter/material.dart';
import '../../core/theme/design_system.dart';

class MusicCardData {
  final String id;
  final String artistName;
  final String songTitle;
  final String? imageUrl;

  const MusicCardData({
    required this.id,
    required this.artistName,
    required this.songTitle,
    this.imageUrl,
  });
}

class MusicCardList extends StatelessWidget {
  final List<MusicCardData> songs;
  final void Function(MusicCardData) onSongTap;
  final void Function(MusicCardData, bool) onLikeToggle;

  const MusicCardList({
    super.key,
    required this.songs,
    required this.onSongTap,
    required this.onLikeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingLG),
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];
        return MusicCard(
          song: song,
          onTap: () => onSongTap(song),
          onLikeToggle: (isLiked) => onLikeToggle(song, isLiked),
        );
      },
    );
  }
}

class MusicCard extends StatefulWidget {
  final MusicCardData song;
  final VoidCallback onTap;
  final void Function(bool) onLikeToggle;

  const MusicCard({
    super.key,
    required this.song,
    required this.onTap,
    required this.onLikeToggle,
  });

  @override
  State<MusicCard> createState() => _MusicCardState();
}

class _MusicCardState extends State<MusicCard> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: DesignSystem.spacingMD),
        padding: const EdgeInsets.all(DesignSystem.spacingSM),
        decoration: BoxDecoration(
          color: DesignSystem.surfaceContainer,
          borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        ),
        child: Row(
          children: [
            // Album Art
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(DesignSystem.radiusSM),
                image: widget.song.imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(widget.song.imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: DesignSystem.surfaceContainerHigh,
              ),
              child: widget.song.imageUrl == null
                  ? const Icon(
                      Icons.music_note,
                      color: DesignSystem.onSurfaceVariant,
                      size: 30,
                    )
                  : null,
            ),
            const SizedBox(width: DesignSystem.spacingMD),

            // Song Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.song.songTitle,
                    style: DesignSystem.titleSmall.copyWith(
                      color: DesignSystem.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.song.artistName,
                    style: DesignSystem.bodySmall.copyWith(
                      color: DesignSystem.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: DesignSystem.spacingMD),

            // Like Button
            IconButton(
              icon: Icon(
                _isLiked ? Icons.favorite : Icons.favorite_border,
                color: _isLiked ? DesignSystem.pinkAccent : DesignSystem.onSurfaceVariant,
              ),
              onPressed: () {
                setState(() {
                  _isLiked = !_isLiked;
                });
                widget.onLikeToggle(_isLiked);
              },
            ),
          ],
        ),
      ),
    );
  }
}
