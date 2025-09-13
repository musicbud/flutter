import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/common/index.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Pop',
    'Rock',
    'Hip Hop',
    'Electronic',
    'Jazz',
    'Classical',
    'Country',
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
                    'Discover Music',
                    style: appTheme.typography.headlineH5.copyWith(
                      color: appTheme.colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: appTheme.spacing.sm),
                  Text(
                    'Find your next favorite track',
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
                hintText: 'Search for artists, tracks, or genres...',
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

          // Categories Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: appTheme.typography.headlineH7.copyWith(
                      color: appTheme.colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: appTheme.spacing.md),

                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = category == _selectedCategory;

                        return Container(
                          margin: EdgeInsets.only(
                            right: index < _categories.length - 1 ? appTheme.spacing.md : 0,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = category;
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
                                  category,
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
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: appTheme.spacing.xl),
          ),

          // Featured Artists Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Featured Artists',
                        style: appTheme.typography.headlineH7.copyWith(
                          color: appTheme.colors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      ModernTextButton(
                        text: 'View All',
                        onPressed: () {
                          // Navigate to all artists
                        },
                        size: ModernButtonSize.small,
                      ),
                    ],
                  ),
                  SizedBox(height: appTheme.spacing.md),

                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildArtistCard(
                          'Luna Echo',
                          'Electronic',
                          null,
                          appTheme.colors.accentBlue,
                          appTheme,
                        ),
                        SizedBox(width: appTheme.spacing.md),
                        _buildArtistCard(
                          'Coastal Vibes',
                          'Chill',
                          null,
                          appTheme.colors.accentPurple,
                          appTheme,
                        ),
                        SizedBox(width: appTheme.spacing.md),
                        _buildArtistCard(
                          'City Pulse',
                          'Urban',
                          null,
                          appTheme.colors.accentGreen,
                          appTheme,
                        ),
                        SizedBox(width: appTheme.spacing.md),
                        _buildArtistCard(
                          'Midnight Dreams',
                          'Ambient',
                          null,
                          appTheme.colors.accentOrange,
                          appTheme,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: appTheme.spacing.xl),
          ),

          // Trending Tracks Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Trending Tracks',
                        style: appTheme.typography.headlineH7.copyWith(
                          color: appTheme.colors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      ModernTextButton(
                        text: 'View All',
                        onPressed: () {
                          // Navigate to all tracks
                        },
                        size: ModernButtonSize.small,
                      ),
                    ],
                  ),
                  SizedBox(height: appTheme.spacing.md),

                  // Trending Tracks Grid
                  Column(
                    children: [
                      _buildTrendingTrackCard(
                        'Midnight Dreams',
                        'Luna Echo',
                        'Electronic',
                        null,
                        Icons.music_note,
                        appTheme.colors.accentBlue,
                        appTheme,
                      ),
                      SizedBox(height: appTheme.spacing.md),
                      _buildTrendingTrackCard(
                        'Ocean Waves',
                        'Coastal Vibes',
                        'Chill',
                        null,
                        Icons.music_note,
                        appTheme.colors.accentPurple,
                        appTheme,
                      ),
                      SizedBox(height: appTheme.spacing.md),
                      _buildTrendingTrackCard(
                        'Urban Nights',
                        'City Pulse',
                        'Hip Hop',
                        null,
                        Icons.music_note,
                        appTheme.colors.accentGreen,
                        appTheme,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: appTheme.spacing.xl),
          ),

          // New Releases Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Releases',
                    style: appTheme.typography.headlineH7.copyWith(
                      color: appTheme.colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: appTheme.spacing.md),

                  // New Releases Grid
                  SizedBox(
                    height: 280,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildNewReleaseCard(
                          'Electric Storm',
                          'Luna Echo',
                          'New EP',
                          null,
                          Icons.music_note,
                          appTheme.colors.primaryRed,
                          appTheme,
                        ),
                        SizedBox(width: appTheme.spacing.md),
                        _buildNewReleaseCard(
                          'Chill Vibes',
                          'Coastal Vibes',
                          'Album',
                          null,
                          Icons.music_note,
                          appTheme.colors.accentBlue,
                          appTheme,
                        ),
                        SizedBox(width: appTheme.spacing.md),
                        _buildNewReleaseCard(
                          'Urban Flow',
                          'City Pulse',
                          'Single',
                          null,
                          Icons.music_note,
                          appTheme.colors.accentPurple,
                          appTheme,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: appTheme.spacing.xl),
          ),

          // Discover More Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discover More',
                    style: appTheme.typography.headlineH7.copyWith(
                      color: appTheme.colors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: appTheme.spacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: _buildDiscoverCard(
                          'Create Playlist',
                          'Build your perfect mix',
                          Icons.playlist_add,
                          appTheme.colors.accentGreen,
                          appTheme,
                        ),
                      ),
                      SizedBox(width: appTheme.spacing.md),
                      Expanded(
                        child: _buildDiscoverCard(
                          'Follow Artists',
                          'Stay updated with favorites',
                          Icons.person_add,
                          appTheme.colors.accentOrange,
                          appTheme,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: appTheme.spacing.xl),
          ),
        ],
      ),
    );
  }

  Widget _buildArtistCard(
    String name,
    String genre,
    String? imageUrl,
    Color accentColor,
    AppTheme appTheme,
  ) {
    return SizedBox(
      width: 100,
      child: ModernCard(
        variant: ModernCardVariant.primary,
        onTap: () {
          // Handle artist card tap
        },
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(appTheme.radius.circular),
                color: accentColor.withValues(alpha: 0.1),
              ),
              child: imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(appTheme.radius.circular),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      color: accentColor,
                      size: 40,
                    ),
            ),
            SizedBox(height: appTheme.spacing.sm),
            Text(
              name,
              style: appTheme.typography.bodySmall.copyWith(
                color: appTheme.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              genre,
              style: appTheme.typography.caption.copyWith(
                color: appTheme.colors.textMuted,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingTrackCard(
    String title,
    String artist,
    String genre,
    String? imageUrl,
    IconData icon,
    Color accentColor,
    AppTheme appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: () {
        // Handle track card tap
      },
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(appTheme.radius.md),
              color: accentColor.withValues(alpha: 0.1),
            ),
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(appTheme.radius.md),
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    icon,
                    color: accentColor,
                    size: 30,
                  ),
          ),
          SizedBox(width: appTheme.spacing.md),
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
                  genre,
                  style: appTheme.typography.caption.copyWith(
                    color: appTheme.colors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
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
        ],
      ),
    );
  }

  Widget _buildNewReleaseCard(
    String title,
    String artist,
    String type,
    String? imageUrl,
    IconData icon,
    Color accentColor,
    AppTheme appTheme,
  ) {
    return SizedBox(
      width: 200,
      child: ModernCard(
        variant: ModernCardVariant.primary,
        onTap: () {
          // Handle new release card tap
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(appTheme.radius.lg),
                color: accentColor.withValues(alpha: 0.1),
              ),
              child: imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(appTheme.radius.lg),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      icon,
                      color: accentColor,
                      size: 48,
                    ),
            ),
            SizedBox(height: appTheme.spacing.md),
            Text(
              title,
              style: appTheme.typography.titleMedium.copyWith(
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
              type,
              style: appTheme.typography.caption.copyWith(
                color: appTheme.colors.textMuted,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: appTheme.spacing.md),
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
                  Icons.favorite_border,
                  color: appTheme.colors.textMuted,
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoverCard(
    String title,
    String subtitle,
    IconData icon,
    Color accentColor,
    AppTheme appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.accent,
      onTap: () {
        // Handle discover card tap
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(appTheme.spacing.lg),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(appTheme.radius.md),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 32,
            ),
          ),
          SizedBox(height: appTheme.spacing.md),
          Text(
            title,
            style: appTheme.typography.titleSmall.copyWith(
              color: appTheme.colors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: appTheme.spacing.xs),
          Text(
            subtitle,
            style: appTheme.typography.caption.copyWith(
              color: appTheme.colors.textMuted,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}