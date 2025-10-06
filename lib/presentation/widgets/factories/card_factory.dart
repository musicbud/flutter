import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
import '../builders/card_builder.dart';
import '../utils/theme_helper.dart';

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
///   context: context,
///   title: 'My Playlist',
///   trackCount: '25 tracks',
///   imageUrl: 'https://example.com/playlist.jpg',
///   accentColor: ThemeHelper.getDesignSystemColors(context).primary,
///   onTap: () => navigateToPlaylist(),
/// );
///
/// final artistCard = factory.createArtistCard(
///   context: context,
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
    required BuildContext context,
    required String title,
    required String trackCount,
    required String imageUrl,
    required Color accentColor,
    VoidCallback? onTap,
    double? elevation,
    EdgeInsetsGeometry? margin,
  }) {
    final colors = ThemeHelper.getDesignSystemColors(context);
    final spacing = ThemeHelper.getDesignSystemSpacing(context);
    final radius = ThemeHelper.getDesignSystemRadius(context);

    return CardBuilder()
        .withVariant(CardVariant.primary)
        .withElevation(elevation ?? 2)
        .withMargin(margin ?? EdgeInsets.all(spacing.xs))
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
                  borderRadius: BorderRadius.circular(radius.lg),
                  color: accentColor.withValues(alpha: 0.1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius.lg),
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

              SizedBox(height: spacing.md),

              // Playlist Info
              Text(
                title,
                style: TextStyle(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  fontFamily: 'Cairo',
                  height: 1.40,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: spacing.xs),
              Text(
                trackCount,
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 12,
                  fontFamily: 'Josefin Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),

              SizedBox(height: spacing.md),

              // Action Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(spacing.sm),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Icon(
                      Icons.play_arrow,
                      color: colors.onPrimary,
                      size: 20,
                    ),
                  ),
                  Icon(
                    Icons.more_vert,
                    color: colors.onSurfaceVariant,
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
    required BuildContext context,
    required String name,
    required String genre,
    required String followerCount,
    required String imageUrl,
    VoidCallback? onTap,
    double? elevation,
    EdgeInsetsGeometry? margin,
  }) {
    final colors = ThemeHelper.getDesignSystemColors(context);
    final spacing = ThemeHelper.getDesignSystemSpacing(context);
    final radius = ThemeHelper.getDesignSystemRadius(context);

    return CardBuilder()
        .withVariant(CardVariant.primary)
        .withElevation(elevation ?? 2)
        .withMargin(margin ?? EdgeInsets.all(spacing.xs))
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
                  borderRadius: BorderRadius.circular(radius.lg),
                  color: colors.surfaceContainerHigh,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius.lg),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.person,
                        color: colors.onSurfaceVariant,
                        size: 48,
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: spacing.md),

              // Artist Info
              Text(
                name,
                style: TextStyle(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  fontFamily: 'Cairo',
                  height: 1.35,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: spacing.xs),
              Text(
                genre,
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 14,
                  fontFamily: 'Josefin Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
              SizedBox(height: spacing.xs),
              Text(
                followerCount,
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 12,
                  fontFamily: 'Josefin Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),

              SizedBox(height: spacing.md),

              // Follow Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius.md),
                    ),
                    padding: EdgeInsets.symmetric(vertical: spacing.sm),
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
    required BuildContext context,
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
    final colors = ThemeHelper.getDesignSystemColors(context);
    final spacing = ThemeHelper.getDesignSystemSpacing(context);
    final radius = ThemeHelper.getDesignSystemRadius(context);

    return CardBuilder()
        .withVariant(CardVariant.primary)
        .withElevation(elevation ?? 1)
        .withMargin(margin ?? EdgeInsets.symmetric(vertical: spacing.xxs))
        .withOnTap(onTap ?? () {})
        .withContent(
          child: Row(
            children: [
              // Track Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius.md),
                  color: colors.surfaceContainerHigh,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius.md),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.music_note,
                        color: colors.onSurfaceVariant,
                        size: 24,
                      );
                    },
                  ),
                ),
              ),

              SizedBox(width: spacing.md),

              // Track Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        fontFamily: 'Cairo',
                        height: 1.40,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: spacing.xxs),
                    Text(
                      artist,
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 14,
                        fontFamily: 'Josefin Sans',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: spacing.xxs),
                    Text(
                      album,
                      style: TextStyle(
                        color: colors.onSurfaceVariant,
                        fontSize: 12,
                        fontFamily: 'Josefin Sans',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
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
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 14,
                  fontFamily: 'Josefin Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),

              SizedBox(width: spacing.md),

              // Actions
              Row(
                children: [
                  IconButton(
                    onPressed: onPlay,
                    icon: Icon(
                      Icons.play_circle_fill,
                      color: colors.primary,
                      size: 32,
                    ),
                  ),
                  IconButton(
                    onPressed: onAddToPlaylist,
                    icon: Icon(
                      Icons.more_vert,
                      color: colors.onSurfaceVariant,
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
    required BuildContext context,
    required String title,
    required String artist,
    required String year,
    required String imageUrl,
    required int trackCount,
    VoidCallback? onTap,
    double? elevation,
    EdgeInsetsGeometry? margin,
  }) {
    final colors = ThemeHelper.getDesignSystemColors(context);
    final spacing = ThemeHelper.getDesignSystemSpacing(context);
    final radius = ThemeHelper.getDesignSystemRadius(context);

    return CardBuilder()
        .withVariant(CardVariant.primary)
        .withElevation(elevation ?? 2)
        .withMargin(margin ?? EdgeInsets.all(spacing.xs))
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
                  borderRadius: BorderRadius.circular(radius.lg),
                  color: colors.surfaceContainerHigh,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius.lg),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.album,
                        color: colors.onSurfaceVariant,
                        size: 48,
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: spacing.md),

              // Album Info
              Text(
                title,
                style: TextStyle(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  fontFamily: 'Cairo',
                  height: 1.35,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: spacing.xs),
              Text(
                artist,
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 16,
                  fontFamily: 'Josefin Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.40,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: spacing.xs),
              Text(
                '$year • $trackCount tracks',
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 12,
                  fontFamily: 'Josefin Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),

              SizedBox(height: spacing.md),

              // Play Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.play_arrow, size: 20),
                  label: Text('Play'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(radius.md),
                    ),
                    padding: EdgeInsets.symmetric(vertical: spacing.sm),
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
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    Color? iconColor,
    VoidCallback? onTap,
    double? elevation,
    EdgeInsetsGeometry? margin,
  }) {
    final colors = ThemeHelper.getDesignSystemColors(context);
    final spacing = ThemeHelper.getDesignSystemSpacing(context);

    return CardBuilder()
        .withVariant(CardVariant.secondary)
        .withElevation(elevation ?? 1)
        .withMargin(margin ?? EdgeInsets.all(spacing.xs))
        .withOnTap(onTap)
        .withContent(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: iconColor ?? colors.primary,
              ),
              SizedBox(height: spacing.sm),
              Text(
                value,
                style: TextStyle(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 22,
                  fontFamily: 'Cairo',
                  height: 1.30,
                ),
              ),
              SizedBox(height: spacing.xs),
              Text(
                title,
                style: TextStyle(
                  color: colors.onSurfaceVariant,
                  fontSize: 14,
                  fontFamily: 'Josefin Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
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
    required BuildContext context,
    required String title,
    required String description,
    required String imageUrl,
    required String badge,
    VoidCallback? onTap,
    double? elevation,
    EdgeInsetsGeometry? margin,
  }) {
    final colors = ThemeHelper.getDesignSystemColors(context);
    final spacing = ThemeHelper.getDesignSystemSpacing(context);
    final radius = ThemeHelper.getDesignSystemRadius(context);

    return CardBuilder()
        .withVariant(CardVariant.accent)
        .withElevation(elevation ?? 3)
        .withMargin(margin ?? EdgeInsets.all(spacing.xs))
        .withOnTap(onTap ?? () {})
        .withContent(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius.lg),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.primary.withValues(alpha: 0.1),
                  colors.primary.withValues(alpha: 0.05),
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
                    margin: EdgeInsets.all(spacing.sm),
                    padding: EdgeInsets.symmetric(
                      horizontal: spacing.sm,
                      vertical: spacing.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: colors.primary,
                      borderRadius: BorderRadius.circular(radius.circular),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        color: colors.onPrimary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        fontFamily: 'Josefin Sans',
                        fontWeight: FontWeight.w400,
                        height: 1.50,
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: EdgeInsets.all(spacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          fontFamily: 'Cairo',
                          height: 1.30,
                        ),
                      ),
                      SizedBox(height: spacing.sm),
                      Text(
                        description,
                        style: TextStyle(
                          color: colors.onSurfaceVariant,
                          fontSize: 16,
                          fontFamily: 'Josefin Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.40,
                        ),
                      ),
                      SizedBox(height: spacing.lg),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(radius.md),
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