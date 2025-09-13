import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/user_profile/user_profile_bloc.dart';
import '../constants/app_theme.dart';
import '../widgets/common/index.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
          return Container(
            decoration: BoxDecoration(
              gradient: appTheme.gradients.backgroundGradient,
            ),
            child: CustomScrollView(
              slivers: [
                // Profile Header Section
                SliverToBoxAdapter(
                  child: Container(
                    padding: EdgeInsets.all(appTheme.spacing.lg),
                    child: Column(
                      children: [
                        // Profile Avatar with enhanced styling
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(appTheme.radius.circular),
                            boxShadow: appTheme.shadows.shadowCardHover,
                            border: Border.all(
                              color: appTheme.colors.primaryRed.withValues(alpha: 0.3),
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: appTheme.colors.primaryRed,
                            backgroundImage: state is UserProfileLoaded && state.userProfile.avatarUrl != null
                                ? NetworkImage(state.userProfile.avatarUrl!)
                                : null,
                            child: state is UserProfileLoaded && state.userProfile.avatarUrl == null
                                ? Icon(
                                    Icons.person,
                                    color: appTheme.colors.white,
                                    size: 60,
                                  )
                                : null,
                          ),
                        ),

                        SizedBox(height: appTheme.spacing.lg),

                        // Profile Info
                        if (state is UserProfileLoaded) ...[
                          Text(
                            state.userProfile.displayName ?? state.userProfile.username,
                            style: appTheme.typography.headlineH5.copyWith(
                              color: appTheme.colors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          if (state.userProfile.displayName != null) ...[
                            SizedBox(height: appTheme.spacing.xs),
                            Text(
                              '@${state.userProfile.username}',
                              style: appTheme.typography.bodyMedium.copyWith(
                                color: appTheme.colors.textMuted,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],

                          SizedBox(height: appTheme.spacing.md),

                          // Profile Stats
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem('Followers', '1.2K', appTheme),
                              _buildStatItem('Following', '856', appTheme),
                              _buildStatItem('Tracks', '324', appTheme),
                            ],
                          ),

                          SizedBox(height: appTheme.spacing.lg),

                          // Edit Profile Button
                          PrimaryButton(
                            text: 'Edit Profile',
                            onPressed: () {
                              // Navigate to edit profile
                            },
                            icon: Icons.edit,
                            size: ModernButtonSize.large,
                            isFullWidth: true,
                          ),
                        ] else if (state is UserProfileLoading) ...[
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: appTheme.colors.primaryRed,
                              strokeWidth: 2,
                            ),
                          ),
                        ] else ...[
                          Text(
                            'Unable to load profile',
                            style: appTheme.typography.titleMedium.copyWith(
                              color: appTheme.colors.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: appTheme.spacing.md),
                          PrimaryButton(
                            onPressed: () {
                              context.read<UserProfileBloc>().add(FetchMyProfile());
                            },
                            text: 'Retry',
                            icon: Icons.refresh,
                            size: ModernButtonSize.medium,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Profile Sections
                if (state is UserProfileLoaded) ...[
                  // My Music Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Music',
                            style: appTheme.typography.headlineH7.copyWith(
                              color: appTheme.colors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: appTheme.spacing.md),

                          // Music Categories
                          Row(
                            children: [
                              Expanded(
                                child: _buildMusicCategoryCard(
                                  'Playlists',
                                  '12',
                                  Icons.playlist_play,
                                  appTheme.colors.accentBlue,
                                  appTheme,
                                ),
                              ),
                              SizedBox(width: appTheme.spacing.md),
                              Expanded(
                                child: _buildMusicCategoryCard(
                                  'Liked Songs',
                                  '89',
                                  Icons.favorite,
                                  appTheme.colors.primaryRed,
                                  appTheme,
                                ),
                              ),
                              SizedBox(width: appTheme.spacing.md),
                              Expanded(
                                child: _buildMusicCategoryCard(
                                  'Downloads',
                                  '23',
                                  Icons.download,
                                  appTheme.colors.accentGreen,
                                  appTheme,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),

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

                          // Activity Cards
                          _buildActivityCard(
                            'New Track Added',
                            'Added "Midnight Dreams" to your library',
                            '2 hours ago',
                            Icons.music_note,
                            appTheme.colors.primaryRed,
                            appTheme,
                          ),
                          SizedBox(height: appTheme.spacing.md),
                          _buildActivityCard(
                            'Playlist Created',
                            'Created "Chill Vibes" playlist',
                            '1 day ago',
                            Icons.playlist_add,
                            appTheme.colors.accentBlue,
                            appTheme,
                          ),
                          SizedBox(height: appTheme.spacing.md),
                          _buildActivityCard(
                            'Bud Connected',
                            'Sarah Johnson started following you',
                            '3 days ago',
                            Icons.person_add,
                            appTheme.colors.accentGreen,
                            appTheme,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),

                  // Settings Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Settings',
                            style: appTheme.typography.headlineH7.copyWith(
                              color: appTheme.colors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: appTheme.spacing.md),

                          // Settings Options
                          _buildSettingsOption(
                            'Account Settings',
                            'Manage your account preferences',
                            Icons.settings,
                            appTheme,
                          ),
                          SizedBox(height: appTheme.spacing.sm),
                          _buildSettingsOption(
                            'Privacy',
                            'Control your privacy settings',
                            Icons.privacy_tip,
                            appTheme,
                          ),
                          SizedBox(height: appTheme.spacing.sm),
                          _buildSettingsOption(
                            'Notifications',
                            'Customize notification preferences',
                            Icons.notifications,
                            appTheme,
                          ),
                          SizedBox(height: appTheme.spacing.sm),
                          _buildSettingsOption(
                            'Help & Support',
                            'Get help and contact support',
                            Icons.help,
                            appTheme,
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),

                  // Logout Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                      child: OutlineButton(
                        text: 'Logout',
                        onPressed: () {
                          // Handle logout
                        },
                        icon: Icons.logout,
                        size: ModernButtonSize.large,
                        isFullWidth: true,
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value, AppTheme appTheme) {
    return Column(
      children: [
        Text(
          value,
          style: appTheme.typography.headlineH7.copyWith(
            color: appTheme.colors.primaryRed,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: appTheme.spacing.xs),
        Text(
          label,
          style: appTheme.typography.caption.copyWith(
            color: appTheme.colors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildMusicCategoryCard(
    String title,
    String count,
    IconData icon,
    Color iconColor,
    AppTheme appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: () {
        // Handle category tap
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(appTheme.spacing.md),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(appTheme.radius.md),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 32,
            ),
          ),
          SizedBox(height: appTheme.spacing.sm),
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
            count,
            style: appTheme.typography.caption.copyWith(
              color: appTheme.colors.textMuted,
            ),
            textAlign: TextAlign.center,
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
    Color iconColor,
    AppTheme appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.primary,
      onTap: () {
        // Handle activity card tap
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(appTheme.spacing.sm),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
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
                    color: appTheme.colors.textMuted,
                  ),
                ),
                SizedBox(height: appTheme.spacing.xs),
                Text(
                  timeAgo,
                  style: appTheme.typography.caption.copyWith(
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
    );
  }

  Widget _buildSettingsOption(
    String title,
    String subtitle,
    IconData icon,
    AppTheme appTheme,
  ) {
    return ModernCard(
      variant: ModernCardVariant.secondary,
      onTap: () {
        // Handle settings option tap
      },
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(appTheme.spacing.sm),
            decoration: BoxDecoration(
              color: appTheme.colors.surfaceLight,
              borderRadius: BorderRadius.circular(appTheme.radius.md),
            ),
            child: Icon(
              icon,
              color: appTheme.colors.textSecondary,
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
                  subtitle,
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
    );
  }
}