import 'package:flutter/material.dart';
import '../../core/theme/design_system.dart';
import '../builders/card_builder.dart';

/// A factory class for creating specific card types.
/// Provides pre-configured card builders for common use cases in the music app.
///
/// **Features:**
/// - Pre-configured card types for music content
/// - Consistent styling and behavior
/// - Easy customization and extension
/// - Integration with existing card widgets
/// - Support for music-specific card patterns
///
/// **Usage:**
/// ```dart
/// final factory = CardFactory();
///
/// // Create different card types
/// final playlistCard = factory.createPlaylistCard(
///   title: 'My Playlist',
///   trackCount: '25 tracks',
///   imageUrl: 'https://example.com/playlist.jpg',
///   accentColor: DesignSystem.primary,
///   onTap: () => navigateToPlaylist(),
/// );
///
/// final artistCard = factory.createArtistCard(
///   name: 'Artist Name',
///   genre: 'Pop',
///   followerCount: '1.2M followers',
///   imageUrl: 'https://example.com/artist.jpg',
///   onTap: () => navigateToArtist(),
/// );
/// ```
class CardFactory {
  /// Creates a playlist card with consistent styling
  Widget createPlaylistCard({
    required String title,
    required String trackCount,
    required String imageUrl,
    required Color accentColor,
    VoidCallback? onTap,
    double? elevation,
    EdgeInsetsGeometry? margin,
  }) {
    return CardBuilder()
        .withVariant(CardVariant.primary)
        .withElevation(elevation ?? 2)
        .withMargin(margin ?? EdgeInsets.all(DesignSystem.spacingXS))
        .withOnTap(onTap ?? () {})
        .withContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Playlist Image
              Container(
                height: 120,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
                  color: accentColor.withOpacity(0.1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.playlist_play,
                        color: accentColor,
                        size: 48,
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: DesignSystem.spacingMD),

              // Playlist Info
              Text(
                title,
                style: DesignSystem.titleSmall.copyWith(
                  color: DesignSystem.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: DesignSystem.spacingXS),
              Text(
                trackCount,
                style: DesignSystem.caption.copyWith(
                  color: DesignSystem.onSurfaceVariant,
                ),
              ),

              SizedBox(height: DesignSystem.spacingMD),

              // Action Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(DesignSystem.spacingSM),
                    decoration: BoxDecoration(
                      color: DesignSystem.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: DesignSystem.onPrimary,
                      size: 20,
                    ),
                  ),
                  Icon(
                    Icons.more_vert,
                    color: DesignSystem.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        )
        .build();
  }

  /// Creates an artist card with consistent styling
  Widget createArtistCard({
    required String name,
    required String genre,
    required String followerCount,
    required String imageUrl,
    VoidCallback? onTap,
    double? elevation,
    EdgeInsetsGeometry? margin,
  }) {
    return CardBuilder()
        .withVariant(CardVariant.primary)
        .withElevation(elevation ?? 2)
        .withMargin(margin ?? EdgeInsets.all(DesignSystem.spacingXS))
        .withOnTap(onTap ?? () {})
        .withContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Artist Image
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
                  color: DesignSystem.surfaceContainerHigh,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        color: DesignSystem.onSurfaceVariant,
                        size: 48,
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: DesignSystem.spacingMD),

              // Artist Info
              Text(
                name,
                style: DesignSystem.titleMedium.copyWith(
                  color: DesignSystem.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: DesignSystem.spacingXS),
              Text(
                genre,
                style: DesignSystem.bodySmall.copyWith(
                  color: DesignSystem.onSurfaceVariant,
                ),
              ),
              SizedBox(height: DesignSystem.spacingXS),
              Text(
                followerCount,
                style: DesignSystem.caption.copyWith(
                  color: DesignSystem.onSurfaceVariant,
                ),
              ),

              SizedBox(height: DesignSystem.spacingMD),

              // Follow Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesignSystem.primary,
                    foregroundColor: DesignSystem.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
                    ),
                    padding: EdgeInsets.symmetric(vertical: DesignSystem.spacingSM),
                  ),
                  child: Text('Follow'),
                ),
              ),
            ],
          ),
        )
        .build();
  }

  /// Creates a track/song card with consistent styling
  Widget createTrackCard({
    required String title,
    required String artist,
    required String album,
    required String imageUrl,
    required Duration duration,
    VoidCallback? onTap,
    VoidCallback? onPlay,
    VoidCallback? onAddToPlaylist,
    double? elevation,
    EdgeInsetsGeometry? margin,
  }) {
    return CardBuilder()
        .withVariant(CardVariant.primary)
        .withElevation(elevation ?? 1)
        .withMargin(margin ?? EdgeInsets.symmetric(vertical: DesignSystem.spacingXXS))
        .withOnTap(onTap ?? () {})
        .withContent(
          child: Row(
            children: [
              // Track Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
                  color: DesignSystem.surfaceContainerHigh,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.music_note,
                        color: DesignSystem.onSurfaceVariant,
                        size: 24,
                      );
                    },
                  ),
                ),
              ),

              SizedBox(width: DesignSystem.spacingMD),

              // Track Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: DesignSystem.titleSmall.copyWith(
                        color: DesignSystem.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: DesignSystem.spacingXXS),
                    Text(
                      artist,
                      style: DesignSystem.bodySmall.copyWith(
                        color: DesignSystem.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: DesignSystem.spacingXXS),
                    Text(
                      album,
                      style: DesignSystem.caption.copyWith(
                        color: DesignSystem.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Duration
              Text(
                _formatDuration(duration),
                style: DesignSystem.bodySmall.copyWith(
                  color: DesignSystem.onSurfaceVariant,
                ),
              ),

              SizedBox(width: DesignSystem.spacingMD),

              // Actions
              Row(
                children: [
                  IconButton(
                    onPressed: onPlay,
                    icon: Icon(
                      Icons.play_circle_fill,
                      color: DesignSystem.primary,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: onAddToPlaylist,
                    icon: Icon(
                      Icons.more_vert,
                      color: DesignSystem.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        .build();
  }

  /// Creates an album card with consistent styling
  Widget createAlbumCard({
    required String title,
    required String artist,
    required String year,
    required String imageUrl,
    required int trackCount,
    VoidCallback? onTap,
    double? elevation,
    EdgeInsetsGeometry? margin,
  }) {
    return CardBuilder()
        .withVariant(CardVariant.primary)
        .withElevation(elevation ?? 2)
        .withMargin(margin ?? EdgeInsets.all(DesignSystem.spacingXS))
        .withOnTap(onTap ?? () {})
        .withContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Album Cover
              Container(
                height: 160,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
                  color: DesignSystem.surfaceContainerHigh,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.album,
                        color: DesignSystem.onSurfaceVariant,
                        size: 48,
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: DesignSystem.spacingMD),

              // Album Info
              Text(
                title,
                style: DesignSystem.titleMedium.copyWith(
                  color: DesignSystem.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: DesignSystem.spacingXS),
              Text(
                artist,
                style: DesignSystem.bodyMedium.copyWith(
                  color: DesignSystem.onSurfaceVariant,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: DesignSystem.spacingXS),
              Text(
                '$year • $trackCount tracks',
                style: DesignSystem.caption.copyWith(
                  color: DesignSystem.onSurfaceVariant,
                ),
              ),

              SizedBox(height: DesignSystem.spacingMD),

              // Play Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.play_arrow, size: 20),
                  label: Text('Play'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesignSystem.primary,
                    foregroundColor: DesignSystem.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
                    ),
                    padding: EdgeInsets.symmetric(vertical: DesignSystem.spacingSM),
                  ),
                ),
              ),
            ],
          ),
        )
        .build();
  }

  /// Creates a statistics card for displaying metrics
  Widget createStatsCard({
    required String title,
    required String value,
    required IconData icon,
    Color? iconColor,
    VoidCallback? onTap,
    double? elevation,
    EdgeInsetsGeometry? margin,
  }) {
    return CardBuilder()
        .withVariant(CardVariant.secondary)
        .withElevation(elevation ?? 1)
        .withMargin(margin ?? EdgeInsets.all(DesignSystem.spacingXS))
        .withOnTap(onTap)
        .withContent(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: iconColor ?? DesignSystem.primary,
              ),
              SizedBox(height: DesignSystem.spacingSM),
              Text(
                value,
                style: DesignSystem.titleLarge.copyWith(
                  color: DesignSystem.onSurface,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: DesignSystem.spacingXS),
              Text(
                title,
                style: DesignSystem.bodySmall.copyWith(
                  color: DesignSystem.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        )
        .build();
  }

  /// Creates a feature/highlight card
  Widget createFeatureCard({
    required String title,
    required String description,
    required String imageUrl,
    required String badge,
    VoidCallback? onTap,
    double? elevation,
    EdgeInsetsGeometry? margin,
  }) {
    return CardBuilder()
        .withVariant(CardVariant.accent)
        .withElevation(elevation ?? 3)
        .withMargin(margin ?? EdgeInsets.all(DesignSystem.spacingXS))
        .withOnTap(onTap ?? () {})
        .withContent(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignSystem.radiusLG),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  DesignSystem.primary.withOpacity(0.1),
                  DesignSystem.primary.withOpacity(0.05),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    margin: EdgeInsets.all(DesignSystem.spacingSM),
                    padding: EdgeInsets.symmetric(
                      horizontal: DesignSystem.spacingSM,
                      vertical: DesignSystem.spacingXXS,
                    ),
                    decoration: BoxDecoration(
                      color: DesignSystem.primary,
                      borderRadius: BorderRadius.circular(DesignSystem.radiusCircular),
                    ),
                    child: Text(
                      badge,
                      style: DesignSystem.caption.copyWith(
                        color: DesignSystem.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.all(DesignSystem.spacingMD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: DesignSystem.titleLarge.copyWith(
                          color: DesignSystem.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: DesignSystem.spacingSM),
                      Text(
                        description,
                        style: DesignSystem.bodyMedium.copyWith(
                          color: DesignSystem.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: DesignSystem.spacingLG),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DesignSystem.primary,
                          foregroundColor: DesignSystem.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
                          ),
                        ),
                        child: Text('Learn More'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
        .build();
  }

  // Helper method to format duration
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}

/// Extension for quick card factory access
extension CardFactoryExtension on CardFactory {
  /// Creates a CardFactory instance (singleton pattern)
  static CardFactory get instance => CardFactory();
}