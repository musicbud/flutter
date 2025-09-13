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
  bool _isSearching = false;
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Tracks',
    'Artists',
    'Albums',
    'Playlists',
    'Genres',
  ];

  final List<String> _trendingSearches = [
    'Midnight Dreams',
    'Luna Echo',
    'Electronic Music',
    'Chill Vibes',
    'Hip Hop 2024',
    'Summer Hits',
  ];

  final List<String> _popularGenres = [
    'Electronic',
    'Hip Hop',
    'Rock',
    'Jazz',
    'Classical',
    'Pop',
    'R&B',
    'Country',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      _isSearching = query.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colors.background,
      body: Container(
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
                      'Search',
                      style: appTheme.typography.headlineH5.copyWith(
                        color: appTheme.colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: appTheme.spacing.sm),
                    Text(
                      'Find your favorite music and artists',
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
                  hintText: 'Search for tracks, artists, albums...',
                  controller: _searchController,
                  onChanged: _performSearch,
                  size: ModernInputFieldSize.large,
                ),
              ),
            ),

            SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.lg)),

            // Categories Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Search Categories',
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

            SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),

            // Content based on search state
            if (_isSearching)
              SliverToBoxAdapter(child: _buildSearchResults(appTheme))
            else
              SliverToBoxAdapter(child: _buildDefaultContent(appTheme)),

            SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultContent(AppTheme appTheme) {
    return Column(
      children: [
        // Trending Searches Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trending Searches',
                style: appTheme.typography.headlineH7.copyWith(
                  color: appTheme.colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: appTheme.spacing.md),
              Wrap(
                spacing: appTheme.spacing.sm,
                runSpacing: appTheme.spacing.sm,
                children: _trendingSearches.map((search) {
                  return GestureDetector(
                    onTap: () {
                      _searchController.text = search;
                      _performSearch(search);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: appTheme.spacing.md,
                        vertical: appTheme.spacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: appTheme.colors.surfaceDark,
                        borderRadius: BorderRadius.circular(appTheme.radius.circular),
                        border: Border.all(
                          color: appTheme.colors.borderColor,
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        search,
                        style: appTheme.typography.bodySmall.copyWith(
                          color: appTheme.colors.textSecondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        SizedBox(height: appTheme.spacing.xl),
        // Popular Genres Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Popular Genres',
                style: appTheme.typography.headlineH7.copyWith(
                  color: appTheme.colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: appTheme.spacing.md),
              GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: appTheme.spacing.md,
                  mainAxisSpacing: appTheme.spacing.md,
                  childAspectRatio: 1.5,
                ),
                itemCount: _popularGenres.length,
                itemBuilder: (context, index) {
                  final genre = _popularGenres[index];
                  return _buildGenreCard(
                    genre,
                    _getGenreColor(genre, appTheme),
                    appTheme,
                  );
                },
              ),
            ],
          ),
        ),
        SizedBox(height: appTheme.spacing.xl),
        // Recent Searches Section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Searches',
                style: appTheme.typography.headlineH7.copyWith(
                  color: appTheme.colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: appTheme.spacing.md),
              Column(
                children: [
                  _buildRecentSearchItem('Electric Storm', '2 hours ago', appTheme),
                  SizedBox(height: appTheme.spacing.sm),
                  _buildRecentSearchItem('Coastal Vibes', '1 day ago', appTheme),
                  SizedBox(height: appTheme.spacing.sm),
                  _buildRecentSearchItem('Urban Flow', '3 days ago', appTheme),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(AppTheme appTheme) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search Results for "$_searchQuery"',
            style: appTheme.typography.headlineH7.copyWith(
              color: appTheme.colors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: appTheme.spacing.md),
          // Search Results
          Column(
            children: [
              _buildSearchResultCard(
                'Midnight Dreams',
                'Luna Echo',
                'Electronic',
                'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
                appTheme.colors.accentBlue,
                appTheme,
              ),
              SizedBox(height: appTheme.spacing.md),
              _buildSearchResultCard(
                'Ocean Waves',
                'Coastal Vibes',
                'Chill',
                'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
                appTheme.colors.accentPurple,
                appTheme,
              ),
              SizedBox(height: appTheme.spacing.md),
              _buildSearchResultCard(
                'Urban Nights',
                'City Pulse',
                'Hip Hop',
                'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
                appTheme.colors.accentGreen,
                appTheme,
              ),
              SizedBox(height: appTheme.spacing.md),
              _buildSearchResultCard(
                'Electric Storm',
                'Luna Echo',
                'Electronic',
                'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=100&h=100&fit=crop',
                appTheme.colors.primaryRed,
                appTheme,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenreCard(String genre, Color accentColor, AppTheme appTheme) {
    return ModernCard(
      variant: ModernCardVariant.accent,
      onTap: () {
        _searchController.text = genre;
        _performSearch(genre);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              accentColor.withValues(alpha: 0.1),
              accentColor.withValues(alpha: 0.05),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getGenreIcon(genre),
              color: accentColor,
              size: 32,
            ),
            SizedBox(height: appTheme.spacing.sm),
            Text(
              genre,
              style: appTheme.typography.titleSmall.copyWith(
                color: appTheme.colors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearchItem(String query, String timeAgo, AppTheme appTheme) {
    return ModernCard(
      variant: ModernCardVariant.secondary,
      onTap: () {
        _searchController.text = query;
        _performSearch(query);
      },
      child: Row(
        children: [
          Icon(
            Icons.history,
            color: appTheme.colors.textMuted,
            size: 20,
          ),
          SizedBox(width: appTheme.spacing.md),
          Expanded(
            child: Text(
              query,
              style: appTheme.typography.bodyMedium.copyWith(
                color: appTheme.colors.textPrimary,
              ),
            ),
          ),
          Text(
            timeAgo,
            style: appTheme.typography.caption.copyWith(
              color: appTheme.colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(
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
        // Navigate to track details
      },
      child: Row(
        children: [
          // Track Image
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

          // Track Info
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
                Icons.favorite_border,
                color: appTheme.colors.textMuted,
                size: 24,
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getGenreIcon(String genre) {
    switch (genre.toLowerCase()) {
      case 'electronic':
        return Icons.electric_bolt;
      case 'hip hop':
        return Icons.music_note;
      case 'rock':
        return Icons.rocket;
      case 'jazz':
        return Icons.music_note;
      case 'classical':
        return Icons.class_;
      case 'pop':
        return Icons.star;
      case 'r&b':
        return Icons.favorite;
      case 'country':
        return Icons.landscape;
      default:
        return Icons.music_note;
    }
  }

  Color _getGenreColor(String genre, AppTheme appTheme) {
    switch (genre.toLowerCase()) {
      case 'electronic':
        return appTheme.colors.accentBlue;
      case 'hip hop':
        return appTheme.colors.primaryRed;
      case 'rock':
        return appTheme.colors.accentOrange;
      case 'jazz':
        return appTheme.colors.accentPurple;
      case 'classical':
        return appTheme.colors.accentGreen;
      case 'pop':
        return appTheme.colors.primaryRed;
      case 'r&b':
        return appTheme.colors.accentPurple;
      case 'country':
        return appTheme.colors.accentGreen;
      default:
        return appTheme.colors.primaryRed;
    }
  }
}