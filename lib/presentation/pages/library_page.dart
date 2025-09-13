import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/common/index.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedTab = 'Playlists';
  int _selectedIndex = 0;

  final List<String> _tabs = [
    'Playlists',
    'Liked Songs',
    'Downloads',
    'Recently Played',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: appTheme.gradients.backgroundGradient,
      ),
      child: CustomScrollView(
        slivers: [
          // Header Section
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(appTheme.spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Library',
                    style: appTheme.typography.headlineH5.copyWith(
                      color: appTheme.colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: appTheme.spacing.sm),
                  Text(
                    'Your personal music collection',
                    style: appTheme.typography.bodyMedium.copyWith(
                      color: appTheme.colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
              child: ModernInputField(
                hintText: 'Search your library...',
                controller: _searchController,
                onChanged: (value) {
                  // Handle search
                },
                size: ModernInputFieldSize.large,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: appTheme.spacing.lg),
          ),

          // Tabs Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
              child: Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _tabs.length,
                  itemBuilder: (context, index) {
                    final tab = _tabs[index];
                    final isSelected = index == _selectedIndex;

                    return Container(
                      margin: EdgeInsets.only(
                        right: index < _tabs.length - 1 ? appTheme.spacing.md : 0,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                            _selectedTab = tab;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: appTheme.spacing.lg,
                            vertical: appTheme.spacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? appTheme.colors.primaryRed
                                : appTheme.colors.surfaceDark,
                            borderRadius: BorderRadius.circular(appTheme.radius.circular),
                            border: Border.all(
                              color: isSelected
                                  ? appTheme.colors.primaryRed
                                  : appTheme.colors.borderColor,
                              width: 1.5,
                            ),
                            boxShadow: isSelected
                                ? appTheme.shadows.shadowMedium
                                : appTheme.shadows.shadowSmall,
                          ),
                          child: Center(
                            child: Text(
                              tab,
                              style: appTheme.typography.bodySmall.copyWith(
                                color: isSelected
                                    ? appTheme.colors.white
                                    : appTheme.colors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: appTheme.spacing.xl),
          ),

          // Content based on selected tab
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
              child: _buildTabContent(appTheme),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: appTheme.spacing.xl),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(AppTheme appTheme) {
    switch (_selectedTab) {
      case 'Playlists':
        return _buildPlaylistsContent(appTheme);
      case 'Liked Songs':
        return _buildLikedSongsContent(appTheme);
      case 'Downloads':
        return _buildDownloadsContent(appTheme);
      case 'Recently Played':
        return _buildRecentlyPlayedContent(appTheme);
      default:
        return _buildPlaylistsContent(appTheme);
    }
  }

  Widget _buildPlaylistsContent(AppTheme appTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Playlists',
              style: appTheme.typography.headlineH7.copyWith(
                color: appTheme.colors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
            PrimaryButton(
              text: 'Create New',
              onPressed: () {
                // Navigate to create playlist
              },
              icon: Icons.add,
              size: ModernButtonSize.small,
            ),
          ],
        ),
        SizedBox(height: appTheme.spacing.md),

        // Playlists Grid
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: appTheme.spacing.md,
            mainAxisSpacing: appTheme.spacing.md,
            childAspectRatio: 0.8,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return _buildPlaylistCard(
              'Chill Vibes ${index + 1}',
              '${(index + 1) * 12} tracks',
              'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop',
              appTheme.colors.accentBlue,
              appTheme,
            );
          },
        ),
      ],
    );
  }

  Widget _buildLikedSongsContent(AppTheme appTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Liked Songs',
          style: appTheme.typography.headlineH7.copyWith(
            color: appTheme.colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: appTheme.spacing.md),

        // Liked Songs List
        Column(
          children: [
            _buildLikedSongCard(
              'Midnight Dreams',
              'Luna Echo',
              'Electronic',
              'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
              appTheme.colors.accentBlue,
              appTheme,
            ),
            SizedBox(height: appTheme.spacing.md),
            _buildLikedSongCard(
              'Ocean Waves',
              'Coastal Vibes',
              'Chill',
              'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
              appTheme.colors.accentPurple,
              appTheme,
            ),
            SizedBox(height: appTheme.spacing.md),
            _buildLikedSongCard(
              'Urban Nights',
              'City Pulse',
              'Hip Hop',
              'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
              appTheme.colors.accentGreen,
              appTheme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDownloadsContent(AppTheme appTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Downloaded Music',
          style: appTheme.typography.headlineH7.copyWith(
            color: appTheme.colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: appTheme.spacing.md),

        // Downloads Grid
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: appTheme.spacing.md,
            mainAxisSpacing: appTheme.spacing.md,
            childAspectRatio: 0.8,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return _buildDownloadCard(
              'Album ${index + 1}',
              'Artist ${index + 1}',
              '${(index + 1) * 8} tracks',
              'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=300&fit=crop',
              appTheme.colors.accentOrange,
              appTheme,
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentlyPlayedContent(AppTheme appTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recently Played',
          style: appTheme.typography.headlineH7.copyWith(
            color: appTheme.colors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: appTheme.spacing.md),

        // Recently Played List
        Column(
          children: [
            _buildRecentlyPlayedCard(
              'Electric Storm',
              'Luna Echo',
              '2 hours ago',
              'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
              appTheme.colors.primaryRed,
              appTheme,
            ),
            SizedBox(height: appTheme.spacing.md),
            _buildRecentlyPlayedCard(
              'Chill Vibes',
              'Coastal Vibes',
              '1 day ago',
              'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
              appTheme.colors.accentBlue,
              appTheme,
            ),
            SizedBox(height: appTheme.spacing.md),
            _buildRecentlyPlayedCard(
              'Urban Flow',
              'City Pulse',
              '3 days ago',
              'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
              appTheme.colors.accentPurple,
              appTheme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaylistCard(
    String title,
    String trackCount,
    String imageUrl,
    Color accentColor,
    AppTheme appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: () {
        // Navigate to playlist
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Playlist Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(appTheme.radius.lg),
              color: accentColor.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(appTheme.radius.lg),
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

          SizedBox(height: appTheme.spacing.md),

          // Playlist Info
          Text(
            title,
            style: appTheme.typography.titleSmall.copyWith(
              color: appTheme.colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: appTheme.spacing.xs),
          Text(
            trackCount,
            style: appTheme.typography.caption.copyWith(
              color: appTheme.colors.textMuted,
            ),
          ),
          SizedBox(height: appTheme.spacing.md),

          // Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(appTheme.spacing.sm),
                decoration: BoxDecoration(
                  color: appTheme.colors.primaryRed,
                  borderRadius: BorderRadius.circular(appTheme.radius.circular),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: appTheme.colors.white,
                  size: 20,
                ),
              ),
              Icon(
                Icons.more_vert,
                color: appTheme.colors.textMuted,
                size: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLikedSongCard(
    String title,
    String artist,
    String genre,
    String imageUrl,
    Color accentColor,
    AppTheme appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: () {
        // Navigate to song
      },
      child: Row(
        children: [
          // Song Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(appTheme.radius.md),
              color: accentColor.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(appTheme.radius.md),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.music_note,
                    color: accentColor,
                    size: 30,
                  );
                },
              ),
            ),
          ),

          SizedBox(width: appTheme.spacing.md),

          // Song Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: appTheme.typography.titleSmall.copyWith(
                    color: appTheme.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: appTheme.spacing.xs),
                Text(
                  artist,
                  style: appTheme.typography.bodySmall.copyWith(
                    color: appTheme.colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: appTheme.spacing.sm,
                    vertical: appTheme.spacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(appTheme.radius.sm),
                  ),
                  child: Text(
                    genre,
                    style: appTheme.typography.caption.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(appTheme.spacing.sm),
                decoration: BoxDecoration(
                  color: appTheme.colors.primaryRed,
                  borderRadius: BorderRadius.circular(appTheme.radius.circular),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: appTheme.colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: appTheme.spacing.sm),
              Icon(
                Icons.favorite,
                color: appTheme.colors.primaryRed,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadCard(
    String title,
    String artist,
    String trackCount,
    String imageUrl,
    Color accentColor,
    AppTheme appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: () {
        // Navigate to album
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Album Image
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(appTheme.radius.lg),
              color: accentColor.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(appTheme.radius.lg),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.album,
                    color: accentColor,
                    size: 48,
                  );
                },
              ),
            ),
          ),

          SizedBox(height: appTheme.spacing.md),

          // Album Info
          Text(
            title,
            style: appTheme.typography.titleSmall.copyWith(
              color: appTheme.colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: appTheme.spacing.xs),
          Text(
            artist,
            style: appTheme.typography.bodySmall.copyWith(
              color: appTheme.colors.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            trackCount,
            style: appTheme.typography.caption.copyWith(
              color: appTheme.colors.textMuted,
            ),
          ),
          SizedBox(height: appTheme.spacing.md),

          // Action Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(appTheme.spacing.sm),
                decoration: BoxDecoration(
                  color: appTheme.colors.primaryRed,
                  borderRadius: BorderRadius.circular(appTheme.radius.circular),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: appTheme.colors.white,
                  size: 20,
                ),
              ),
              Icon(
                Icons.download_done,
                color: appTheme.colors.accentGreen,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyPlayedCard(
    String title,
    String artist,
    String timeAgo,
    String imageUrl,
    Color accentColor,
    AppTheme appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: () {
        // Navigate to song
      },
      child: Row(
        children: [
          // Song Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(appTheme.radius.md),
              color: accentColor.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(appTheme.radius.md),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.music_note,
                    color: accentColor,
                    size: 30,
                  );
                },
              ),
            ),
          ),

          SizedBox(width: appTheme.spacing.md),

          // Song Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: appTheme.typography.titleSmall.copyWith(
                    color: appTheme.colors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: appTheme.spacing.xs),
                Text(
                  artist,
                  style: appTheme.typography.bodySmall.copyWith(
                    color: appTheme.colors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  timeAgo,
                  style: appTheme.typography.caption.copyWith(
                    color: appTheme.colors.textMuted,
                  ),
                ),
              ],
            ),
          ),

          // Action Buttons
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(appTheme.spacing.sm),
                decoration: BoxDecoration(
                  color: appTheme.colors.primaryRed,
                  borderRadius: BorderRadius.circular(appTheme.radius.circular),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: appTheme.colors.white,
                  size: 20,
                ),
              ),
              SizedBox(width: appTheme.spacing.sm),
              Icon(
                Icons.history,
                color: appTheme.colors.textMuted,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }
}