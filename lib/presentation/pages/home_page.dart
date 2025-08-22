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
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load user profile when page initializes
    context.read<UserProfileBloc>().add(FetchMyProfile());
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
            return Scaffold(
              backgroundColor: appTheme.colors.background,
              body: SafeArea(
                child: Column(
                  children: [
                    // Header Section
                    Container(
                      padding: EdgeInsets.all(appTheme.spacing.lg),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: appTheme.colors.primaryRed,
                            backgroundImage: state is UserProfileLoaded && state.userProfile.avatarUrl != null
                                ? NetworkImage(state.userProfile.avatarUrl!)
                                : null,
                            child: state is UserProfileLoaded && state.userProfile.avatarUrl == null
                                ? Icon(
                                    Icons.person,
                                    color: appTheme.colors.pureWhite,
                                    size: 24,
                                  )
                                : null,
                          ),
                          SizedBox(width: appTheme.spacing.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back!',
                                  style: appTheme.typography.bodyMedium.copyWith(
                                    color: appTheme.colors.textSecondary,
                                  ),
                                ),
                                Text(
                                  state is UserProfileLoaded
                                      ? (state.userProfile.displayName != null
                                          ? state.userProfile.displayName!
                                          : state.userProfile.username)
                                      : 'Loading...',
                                  style: appTheme.typography.headlineH6.copyWith(
                                    color: appTheme.colors.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Handle notifications
                            },
                            icon: Icon(
                              Icons.notifications_outlined,
                              color: appTheme.colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Search Section
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                      child: AppInputField(
                        labelText: 'Search',
                        hintText: 'Search for music, artists...',
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

                    SizedBox(height: appTheme.spacing.lg),

                    // Quick Actions
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                      child: Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              onPressed: () {
                                // Navigate to discover
                              },
                              text: 'Discover',
                              variant: AppButtonVariant.primary,
                              size: AppButtonSize.medium,
                              icon: Icons.explore,
                            ),
                          ),
                          SizedBox(width: appTheme.spacing.md),
                          Expanded(
                            child: AppButton(
                              onPressed: () {
                                // Navigate to library
                              },
                              text: 'My Library',
                              variant: AppButtonVariant.secondary,
                              size: AppButtonSize.medium,
                              icon: Icons.library_music,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: appTheme.spacing.lg),

                    // Recent Activity Section
                    if (state is UserProfileLoaded) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Activity',
                              style: appTheme.typography.titleMedium.copyWith(
                                color: appTheme.colors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // View all activity
                              },
                              child: Text(
                                'View All',
                                style: appTheme.typography.bodyMedium.copyWith(
                                  color: appTheme.colors.primaryRed,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: appTheme.spacing.md),

                      // Activity Cards
                      Expanded(
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                          children: [
                            _buildActivityCard(
                              context,
                              'New Track Added',
                              'Added "Midnight Dreams" to your library',
                              Icons.music_note,
                              appTheme.colors.primaryRed,
                              appTheme,
                            ),
                            SizedBox(height: appTheme.spacing.md),
                            _buildActivityCard(
                              context,
                              'Bud Connected',
                              'Sarah Johnson started following you',
                              Icons.person_add,
                              appTheme.colors.successGreen,
                              appTheme,
                            ),
                            SizedBox(height: appTheme.spacing.md),
                            _buildActivityCard(
                              context,
                              'Playlist Updated',
                              'Your "Chill Vibes" playlist was updated',
                              Icons.playlist_play,
                              appTheme.colors.infoBlue,
                              appTheme,
                            ),
                          ],
                        ),
                      ),
                    ] else if (state is UserProfileLoading) ...[
                      Expanded(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: appTheme.colors.primaryRed,
                          ),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.error_outline,
                                size: 64,
                                color: appTheme.colors.textSecondary,
                              ),
                              SizedBox(height: appTheme.spacing.md),
                              Text(
                                'Unable to load profile',
                                style: appTheme.typography.titleMedium.copyWith(
                                  color: appTheme.colors.textPrimary,
                                ),
                              ),
                              SizedBox(height: appTheme.spacing.sm),
                              AppButton(
                                onPressed: () {
                                  context.read<UserProfileBloc>().add(FetchMyProfile());
                                },
                                text: 'Retry',
                                variant: AppButtonVariant.primary,
                                size: AppButtonSize.medium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
      ),
    );
  }
}

  Widget _buildActivityCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color iconColor,
    AppTheme appTheme,
  ) {
    return AppCard(
      variant: AppCardVariant.primary,
      child: Padding(
        padding: EdgeInsets.all(appTheme.spacing.md),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(appTheme.spacing.sm),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(appTheme.radius.md),
              ),
              child: Icon(
                icon,
                color: iconColor,
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
                    style: appTheme.typography.titleSmall.copyWith(
                      color: appTheme.colors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: appTheme.spacing.xs),
                  Text(
                    description,
                    style: appTheme.typography.bodySmall.copyWith(
                      color: appTheme.colors.textSecondary,
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
    );
  }

