import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/user_profile/user_profile_bloc.dart';
import '../constants/app_theme.dart';
import '../widgets/common/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load user profile when page initializes
    context.read<UserProfileBloc>().add(FetchMyProfile());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: appTheme.colors.errorRed,
            ),
          );
        }
      },
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: appTheme.gradients.backgroundGradient,
            ),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                    // Header Section
                    SliverToBoxAdapter(
                      child: Container(
                        padding: EdgeInsets.all(appTheme.spacing.lg),
                        child: Row(
                          children: [
                            // Profile Avatar with enhanced styling
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(appTheme.radius.circular),
                                boxShadow: appTheme.shadows.shadowCard,
                                border: Border.all(
                                  color: appTheme.colors.primaryRed.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: appTheme.colors.primaryRed,
                                backgroundImage: state is UserProfileLoaded && state.userProfile.avatarUrl != null
                                    ? NetworkImage(state.userProfile.avatarUrl!)
                                    : null,
                                child: state is UserProfileLoaded && state.userProfile.avatarUrl == null
                                    ? Icon(
                                        Icons.person,
                                        color: appTheme.colors.white,
                                        size: 28,
                                      )
                                    : null,
                              ),
                            ),

                            SizedBox(width: appTheme.spacing.md),

                            // Welcome Text
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome back!',
                                    style: appTheme.typography.bodySmall.copyWith(
                                      color: appTheme.colors.textMuted,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: appTheme.spacing.xs),
                                  Text(
                                    state is UserProfileLoaded
                                        ? (state.userProfile.displayName != null
                                            ? state.userProfile.displayName!
                                            : state.userProfile.username)
                                        : 'Loading...',
                                    style: appTheme.typography.headlineH6.copyWith(
                                      color: appTheme.colors.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Notification Icon with enhanced styling
                            Container(
                              padding: EdgeInsets.all(appTheme.spacing.sm),
                              decoration: BoxDecoration(
                                color: appTheme.colors.surfaceDark,
                                borderRadius: BorderRadius.circular(appTheme.radius.md),
                                boxShadow: appTheme.shadows.shadowSmall,
                              ),
                              child: Icon(
                                Icons.notifications_outlined,
                                color: appTheme.colors.textSecondary,
                                size: 24,
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
                          hintText: 'Search for music, artists, or playlists...',
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

                    // Action Buttons Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                        child: Row(
                          children: [
                            Expanded(
                              child: PrimaryButton(
                                text: 'Discover',
                                onPressed: () {
                                  // Navigate to discover
                                },
                                icon: Icons.explore,
                                size: ModernButtonSize.large,
                                isFullWidth: true,
                              ),
                            ),
                            SizedBox(width: appTheme.spacing.md),
                            Expanded(
                              child: SecondaryButton(
                                text: 'My Library',
                                onPressed: () {
                                  // Navigate to library
                                },
                                icon: Icons.library_music,
                                size: ModernButtonSize.large,
                                isFullWidth: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: SizedBox(height: 120),
                    ),

                    // Featured Music Section
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
                                  'Featured Music',
                                  style: appTheme.typography.headlineH7.copyWith(
                                    color: appTheme.colors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                ModernTextButton(
                                  text: 'View All',
                                  onPressed: () {
                                    // Navigate to all music
                                  },
                                  size: ModernButtonSize.small,
                                ),
                              ],
                            ),
                            SizedBox(height: appTheme.spacing.md),

                            SizedBox(
                              height: 160, // Further reduced from 180 to prevent overflow
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                scrollDirection: Axis.horizontal,
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Container(
                                    width: 120, // Further reduced from 140 to ensure proper fit
                                    margin: EdgeInsets.only(
                                      right: index < 4 ? appTheme.spacing.md : 0,
                                    ),
                                    child: _buildFeaturedMusicCard(
                                      'Featured Track ${index + 1}',
                                      'Artist ${index + 1}',
                                      'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=120&h=160&fit=crop',
                                      appTheme.colors.accentBlue,
                                      appTheme,
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

                    // Recent Activity Section
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Recent Activity',
                              style: appTheme.typography.headlineH7.copyWith(
                                color: appTheme.colors.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: appTheme.spacing.md),

                            Column(
                              children: [
                                SizedBox(
                                  height: 120, // Example fixed height for activity cards
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    itemCount: 3,
                                    itemBuilder: (context, index) {
                                      // Existing activity card logic
                                      if (index == 0) {
                                        return _buildActivityCard(
                                          'Liked a track',
                                          'You liked "Midnight Dreams" by Luna Echo',
                                          '2 hours ago',
                                          Icons.favorite,
                                          appTheme.colors.primaryRed,
                                          appTheme,
                                        );
                                      } else if (index == 1) {
                                        return _buildActivityCard(
                                          'Added to playlist',
                                          'Added "Ocean Waves" to "Chill Vibes"',
                                          '1 day ago',
                                          Icons.playlist_add,
                                          appTheme.colors.accentBlue,
                                          appTheme,
                                        );
                                      } else {
                                        return _buildActivityCard(
                                          'Followed artist',
                                          'You started following Coastal Vibes',
                                          '3 days ago',
                                          Icons.person_add,
                                          appTheme.colors.accentGreen,
                                          appTheme,
                                        );
                                      }
                                    },
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
              ),
            );
        },
      ),
    );
  }

  Widget _buildFeaturedMusicCard(
    String title,
    String artist,
    String imageUrl,
    Color accentColor,
    AppTheme appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: () {
        // Navigate to track details
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Track Image
          Container(
            height: 80, // Further reduced from 100 to prevent overflow
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(appTheme.radius.lg),
              color: accentColor.withValues(alpha: 0.1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(appTheme.radius.lg),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: accentColor.withValues(alpha: 0.2),
                          child: Icon(
                            Icons.music_note,
                            color: accentColor,
                            size: 40,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: accentColor.withValues(alpha: 0.2),
                      child: Icon(
                        Icons.music_note,
                        color: accentColor,
                        size: 40,
                      ),
                    ),
            ),
          ),

          SizedBox(height: appTheme.spacing.xs), // Reduced from sm to xs

          // Track Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: appTheme.typography.titleMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: appTheme.colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: appTheme.spacing.xs / 2), // Reduced spacing
              Text(
                artist,
                style: appTheme.typography.bodyH10.copyWith(
                  color: appTheme.colors.textMuted,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    String title,
    String description,
    String timeAgo,
    IconData icon,
    Color accentColor,
    AppTheme appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.secondary,
      onTap: () {
        // Handle activity card tap
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(appTheme.spacing.sm),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(appTheme.radius.md),
            ),
            child: Icon(
              icon,
              color: accentColor,
              size: 18, // Reduced from 20
            ),
          ),

          SizedBox(width: appTheme.spacing.md),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: appTheme.typography.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: appTheme.colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: appTheme.spacing.xs),
                Text(
                  description,
                  style: appTheme.typography.bodyH10.copyWith(
                    color: appTheme.colors.textMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          SizedBox(width: appTheme.spacing.sm),

          Text(
            timeAgo,
            style: appTheme.typography.bodyH10.copyWith(
              color: appTheme.colors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
