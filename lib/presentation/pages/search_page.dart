import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/common/index.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Songs',
    'Artists',
    'Albums',
    'Playlists',
    'Users',
  ];

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(appTheme.spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search',
                    style: appTheme.typography.displayH1.copyWith(
                      color: appTheme.colors.textPrimary,
                      fontSize: 32,
                    ),
                  ),
                  SizedBox(height: appTheme.spacing.sm),
                  Text(
                    'Find your favorite music and artists',
                    style: appTheme.typography.bodyMedium.copyWith(
                      color: appTheme.colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
              child: AppInputField(
                controller: _searchController,
                label: 'Search',
                hint: 'Search for songs, artists, albums...',
                variant: AppInputVariant.search,
                onChanged: (value) {
                  // Handle search
                },
                suffixIcon: Icon(
                  Icons.search,
                  color: appTheme.colors.textSecondary,
                ),
              ),
            ),

            SizedBox(height: appTheme.spacing.md),

            // Category Filter
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final isSelected = _selectedCategory == category;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: appTheme.spacing.sm),
                      padding: EdgeInsets.symmetric(
                        horizontal: appTheme.spacing.md,
                        vertical: appTheme.spacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? appTheme.colors.primaryRed
                            : appTheme.colors.neutralGray.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(appTheme.radius.lg),
                        border: Border.all(
                          color: isSelected
                              ? appTheme.colors.primaryRed
                              : appTheme.colors.neutralGray.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          category,
                          style: appTheme.typography.bodyMedium.copyWith(
                            color: isSelected
                                ? appTheme.colors.pureWhite
                                : appTheme.colors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: appTheme.spacing.lg),

            // Search Results
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                children: [
                  // Recent Searches
                  if (_searchController.text.isEmpty) ...[
                    Text(
                      'Recent Searches',
                      style: appTheme.typography.titleMedium.copyWith(
                        color: appTheme.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: appTheme.spacing.md),
                    _buildRecentSearchItem('Midnight Dreams', 'Luna Sky', appTheme),
                    SizedBox(height: appTheme.spacing.sm),
                    _buildRecentSearchItem('Electric Storm', 'DJ Pulse', appTheme),
                    SizedBox(height: appTheme.spacing.sm),
                    _buildRecentSearchItem('Desert Wind', 'The Midnight Echo', appTheme),
                  ] else ...[
                    // Search Results
                    Text(
                      'Search Results',
                      style: appTheme.typography.titleMedium.copyWith(
                        color: appTheme.colors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: appTheme.spacing.md),
                    _buildSearchResultItem('Midnight Dreams', 'Luna Sky', 'Starlight', '3:45', appTheme),
                    SizedBox(height: appTheme.spacing.sm),
                    _buildSearchResultItem('Electric Storm', 'DJ Pulse', 'Digital Revolution', '4:12', appTheme),
                    SizedBox(height: appTheme.spacing.sm),
                    _buildSearchResultItem('Desert Wind', 'The Midnight Echo', 'Echoes', '5:23', appTheme),
                  ],

                  SizedBox(height: appTheme.spacing.lg),

                  // Trending
                  Text(
                    'Trending Now',
                    style: appTheme.typography.titleMedium.copyWith(
                      color: appTheme.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: appTheme.spacing.md),
                  _buildTrendingItem('Chill Vibes', 'MusicBud', 45, appTheme),
                  SizedBox(height: appTheme.spacing.sm),
                  _buildTrendingItem('Workout Beats', 'Fitness Music', 32, appTheme),
                  SizedBox(height: appTheme.spacing.sm),
                  _buildTrendingItem('Study Focus', 'Academic Tunes', 28, appTheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearchItem(String title, String subtitle, AppTheme appTheme) {
    return Container(
      padding: EdgeInsets.all(appTheme.spacing.md),
      decoration: BoxDecoration(
        color: appTheme.colors.neutralGray.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(appTheme.radius.md),
      ),
      child: Row(
        children: [
          Icon(
            Icons.history,
            color: appTheme.colors.textSecondary,
            size: 20,
          ),
          SizedBox(width: appTheme.spacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: appTheme.typography.bodyMedium.copyWith(
                    color: appTheme.colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  subtitle,
                  style: appTheme.typography.bodySmall.copyWith(
                    color: appTheme.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: appTheme.colors.textSecondary,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultItem(String title, String artist, String album, String duration, AppTheme appTheme) {
    return Container(
      padding: EdgeInsets.all(appTheme.spacing.md),
      decoration: BoxDecoration(
        color: appTheme.colors.neutralGray.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(appTheme.radius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: appTheme.colors.primaryRed,
              borderRadius: BorderRadius.circular(appTheme.radius.md),
            ),
            child: Icon(
              Icons.music_note,
              color: appTheme.colors.pureWhite,
              size: 24,
            ),
          ),
          SizedBox(width: appTheme.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: appTheme.typography.bodyMedium.copyWith(
                    color: appTheme.colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '$artist • $album',
                  style: appTheme.typography.bodySmall.copyWith(
                    color: appTheme.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            duration,
            style: appTheme.typography.bodySmall.copyWith(
              color: appTheme.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingItem(String name, String curator, int trackCount, AppTheme appTheme) {
    return Container(
      padding: EdgeInsets.all(appTheme.spacing.md),
      decoration: BoxDecoration(
        color: appTheme.colors.neutralGray.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(appTheme.radius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: appTheme.colors.infoBlue,
              borderRadius: BorderRadius.circular(appTheme.radius.md),
            ),
            child: Icon(
              Icons.playlist_play,
              color: appTheme.colors.pureWhite,
              size: 24,
            ),
          ),
          SizedBox(width: appTheme.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: appTheme.typography.bodyMedium.copyWith(
                    color: appTheme.colors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'by $curator • $trackCount tracks',
                  style: appTheme.typography.bodySmall.copyWith(
                    color: appTheme.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: appTheme.colors.textSecondary,
            size: 16,
          ),
        ],
      ),
    );
  }
}