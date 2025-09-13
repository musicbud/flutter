
import 'package:flutter/material.dart';
import '../constants/app_theme.dart';
import '../widgets/common/index.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _selectedFilter = 'Upcoming';

  final List<String> _categories = [
    'All',
    'Live Music',
    'Festivals',
    'Concerts',
    'DJ Sets',
    'Open Mic',
    'Workshops',
    'Networking',
  ];

  final List<String> _filters = [
    'Upcoming',
    'Today',
    'This Week',
    'This Month',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                      'Events',
                      style: appTheme.typography.headlineH5.copyWith(
                        color: appTheme.colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: appTheme.spacing.sm),
                    Text(
                      'Discover amazing music events near you',
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
                  hintText: 'Search for events, venues, or artists...',
                  controller: _searchController,
                  onChanged: (value) {
                    // Handle search
                  },
                  size: ModernInputFieldSize.large,
                ),
              ),
            ),

            SizedBox(height: appTheme.spacing.lg),

            // Filters Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Filters',
                      style: appTheme.typography.headlineH7.copyWith(
                        color: appTheme.colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: appTheme.spacing.md),

                    SizedBox(
                      height: 40,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filters.length,
                        itemBuilder: (context, index) {
                          final filter = _filters[index];
                          final isSelected = filter == _selectedFilter;

                          return Container(
                            margin: EdgeInsets.only(
                              right: index < _filters.length - 1 ? appTheme.spacing.md : 0,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedFilter = filter;
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
                                    filter,
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

            SizedBox(height: appTheme.spacing.xl),

            // Categories Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Event Categories',
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
                        childAspectRatio: 1.2,
                      ),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final isSelected = category == _selectedCategory;

                        return _buildCategoryCard(
                          category,
                          _getCategoryIcon(category),
                          _getCategoryColor(category, appTheme),
                          isSelected,
                          appTheme,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: appTheme.spacing.xl),

            // Featured Events Section
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
                          'Featured Events',
                          style: appTheme.typography.headlineH7.copyWith(
                            color: appTheme.colors.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        ModernTextButton(
                          text: 'View All',
                          onPressed: () {
                            // View all events
                          },
                          size: ModernButtonSize.small,
                        ),
                      ],
                    ),
                    SizedBox(height: appTheme.spacing.md),

                    // Featured Events List
                    Column(
                      children: [
                        _buildFeaturedEventCard(
                          'Summer Music Festival',
                          'Central Park, New York',
                          'June 15, 2024 • 6:00 PM',
                          'Live Music • Festival',
                          'https://images.unsplash.com/photo-1459749411175-04bf5292ceea?w=400&h=200&fit=crop',
                          appTheme.colors.accentBlue,
                          appTheme,
                        ),
                        SizedBox(height: appTheme.spacing.md),
                        _buildFeaturedEventCard(
                          'Jazz Night at Blue Note',
                          'Blue Note Jazz Club',
                          'June 20, 2024 • 8:00 PM',
                          'Jazz • Live Music',
                          'https://images.unsplash.com/photo-1511192336575-5a79af67a629?w=400&h=200&fit=crop',
                          appTheme.colors.accentPurple,
                          appTheme,
                        ),
                        SizedBox(height: appTheme.spacing.md),
                        _buildFeaturedEventCard(
                          'Electronic Music Workshop',
                          'Music Studio Downtown',
                          'June 25, 2024 • 2:00 PM',
                          'Workshop • Electronic',
                          'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=400&h=200&fit=crop',
                          appTheme.colors.accentGreen,
                          appTheme,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: appTheme.spacing.xl),

            // Upcoming Events Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Events',
                      style: appTheme.typography.headlineH7.copyWith(
                        color: appTheme.colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: appTheme.spacing.md),

                    // Upcoming Events Grid
                    SizedBox(
                      height: 280,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _buildUpcomingEventCard(
                            'Rock Concert',
                            'Madison Square Garden',
                            'July 1, 2024',
                            'Rock • Concert',
                            'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=200&fit=crop',
                            appTheme.colors.primaryRed,
                            appTheme,
                          ),
                          SizedBox(width: appTheme.spacing.md),
                          _buildUpcomingEventCard(
                            'Hip Hop Battle',
                            'Underground Club',
                            'July 5, 2024',
                            'Hip Hop • Battle',
                            'https://images.unsplash.com/photo-1516280440614-37939bbacd81?w=300&h=200&fit=crop',
                            appTheme.colors.accentOrange,
                            appTheme,
                          ),
                          SizedBox(width: appTheme.spacing.md),
                          _buildUpcomingEventCard(
                            'Classical Symphony',
                            'Carnegie Hall',
                            'July 10, 2024',
                            'Classical • Symphony',
                            'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=300&h=200&fit=crop',
                            appTheme.colors.accentBlue,
                            appTheme,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: appTheme.spacing.xl),

            // Create Event Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Host Your Own Event',
                      style: appTheme.typography.headlineH7.copyWith(
                        color: appTheme.colors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: appTheme.spacing.md),

                    ModernCard(
                      variant: ModernCardVariant.accent,
                      onTap: () {
                        // Navigate to create event
                      },
                      child: Padding(
                        padding: EdgeInsets.all(appTheme.spacing.lg),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(appTheme.spacing.lg),
                              decoration: BoxDecoration(
                                color: appTheme.colors.primaryRed.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(appTheme.radius.md),
                              ),
                              child: Icon(
                                Icons.add_circle_outline,
                                color: appTheme.colors.primaryRed,
                                size: 32,
                              ),
                            ),
                            SizedBox(width: appTheme.spacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Create Event',
                                    style: appTheme.typography.titleMedium.copyWith(
                                      color: appTheme.colors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: appTheme.spacing.xs),
                                  Text(
                                    'Share your music with the world',
                                    style: appTheme.typography.bodySmall.copyWith(
                                      color: appTheme.colors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: appTheme.colors.textSecondary,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: appTheme.spacing.xl),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    String title,
    IconData icon,
    Color accentColor,
    bool isSelected,
    AppTheme appTheme,
  ) {
    return ModernCard(
      variant: isSelected ? ModernCardVariant.accent : ModernCardVariant.primary,
      onTap: () {
        setState(() {
          _selectedCategory = title;
        });
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(appTheme.spacing.lg),
            decoration: BoxDecoration(
              color: isSelected
                  ? accentColor.withValues(alpha: 0.2)
                  : accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(appTheme.radius.md),
            ),
            child: Icon(
              icon,
              color: isSelected ? accentColor : accentColor.withValues(alpha: 0.7),
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedEventCard(
    String title,
    String location,
    String dateTime,
    String category,
    String imageUrl,
    Color accentColor,
    AppTheme appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: () {
        // Navigate to event details
      },
      child: Row(
        children: [
          // Event Image
          Container(
            width: 80,
            height: 80,
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
                    Icons.event,
                    color: accentColor,
                    size: 32,
                  );
                },
              ),
            ),
          ),

          SizedBox(width: appTheme.spacing.md),

          // Event Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: appTheme.colors.textMuted,
                      size: 16,
                    ),
                    SizedBox(width: appTheme.spacing.xs),
                    Expanded(
                      child: Text(
                        location,
                        style: appTheme.typography.bodySmall.copyWith(
                          color: appTheme.colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: appTheme.spacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: appTheme.colors.textMuted,
                      size: 16,
                    ),
                    SizedBox(width: appTheme.spacing.xs),
                    Expanded(
                      child: Text(
                        dateTime,
                        style: appTheme.typography.bodySmall.copyWith(
                          color: appTheme.colors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: appTheme.spacing.xs),
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
                    category,
                    style: appTheme.typography.caption.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Action Button
          Container(
            padding: EdgeInsets.all(appTheme.spacing.sm),
            decoration: BoxDecoration(
              color: appTheme.colors.primaryRed,
              borderRadius: BorderRadius.circular(appTheme.radius.circular),
              boxShadow: appTheme.shadows.shadowMedium,
            ),
            child: Icon(
              Icons.bookmark_border,
              color: appTheme.colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingEventCard(
    String title,
    String venue,
    String date,
    String category,
    String imageUrl,
    Color accentColor,
    AppTheme appTheme,
  ) {
    return SizedBox(
      width: 250,
      child: ModernCard(
        variant: ModernCardVariant.primary,
        onTap: () {
          // Navigate to event details
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
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
                      Icons.event,
                      color: accentColor,
                      size: 48,
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: appTheme.spacing.md),

            // Event Info
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
              venue,
              style: appTheme.typography.bodySmall.copyWith(
                color: appTheme.colors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              date,
              style: appTheme.typography.bodySmall.copyWith(
                color: appTheme.colors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: appTheme.spacing.sm),
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
                category,
                style: appTheme.typography.caption.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: appTheme.spacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlineButton(
                  text: 'Details',
                  onPressed: () {
                    // Navigate to event details
                  },
                  size: ModernButtonSize.small,
                ),
                Container(
                  padding: EdgeInsets.all(appTheme.spacing.sm),
                  decoration: BoxDecoration(
                    color: appTheme.colors.primaryRed,
                    borderRadius: BorderRadius.circular(appTheme.radius.circular),
                  ),
                  child: Icon(
                    Icons.bookmark_border,
                    color: appTheme.colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Live Music':
        return Icons.music_note;
      case 'Festivals':
        return Icons.festival;
      case 'Concerts':
        return Icons.music_note;
      case 'DJ Sets':
        return Icons.headphones;
      case 'Open Mic':
        return Icons.mic;
      case 'Workshops':
        return Icons.school;
      case 'Networking':
        return Icons.people;
      default:
        return Icons.event;
    }
  }

  Color _getCategoryColor(String category, AppTheme appTheme) {
    switch (category) {
      case 'Live Music':
        return appTheme.colors.primaryRed;
      case 'Festivals':
        return appTheme.colors.accentBlue;
      case 'Concerts':
        return appTheme.colors.accentPurple;
      case 'DJ Sets':
        return appTheme.colors.accentGreen;
      case 'Open Mic':
        return appTheme.colors.accentOrange;
      case 'Workshops':
        return appTheme.colors.infoBlue;
      case 'Networking':
        return appTheme.colors.successGreen;
      default:
        return appTheme.colors.primaryRed;
    }
  }
}