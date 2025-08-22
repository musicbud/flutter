import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/user_profile/user_profile_bloc.dart';
import '../../domain/models/user_profile.dart';
import '../../injection_container.dart';
import '../constants/app_theme.dart';

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

    return BlocProvider(
      create: (context) => sl<UserProfileBloc>(),
      child: BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: appTheme.colors.error,
              ),
            );
          }
        },
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return Scaffold(
                backgroundColor: appTheme.colors.darkTone,
                body: Center(
                  child: CircularProgressIndicator(
                    color: appTheme.colors.primaryRed,
                  ),
                ),
              );
            }

            if (state is UserProfileLoaded) {
              return _buildProfileContent(context, state.userProfile);
            }

            if (state is UserProfileError) {
              return _buildErrorContent(context, state.message);
            }

            // Default state - show loading
            return Scaffold(
              backgroundColor: appTheme.colors.darkTone,
              body: Center(
                child: CircularProgressIndicator(
                  color: appTheme.colors.primaryRed,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserProfile profile) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colors.darkTone,
      body: CustomScrollView(
        slivers: [
          // App Bar with Profile Image
          SliverAppBar(
            expandedHeight: 300,
            backgroundColor: appTheme.colors.darkTone,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      appTheme.colors.primaryRed.withValues(alpha: 0.8),
                      appTheme.colors.darkTone,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Background Pattern
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: appTheme.colors.primaryRed.withValues(alpha: 0.1),
                        ),
                        child: CustomPaint(
                          painter: ProfileMusicNotePainter(),
                        ),
                      ),
                    ),
                    // Profile Info Overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(appTheme.spacing.lg),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              appTheme.colors.darkTone.withValues(alpha: 0.8),
                              appTheme.colors.darkTone,
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            // Profile Image
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(appTheme.radius.xl),
                                border: Border.all(
                                  color: appTheme.colors.pureWhite,
                                  width: 4,
                                ),
                                image: profile.avatarUrl != null
                                    ? DecorationImage(
                                        image: NetworkImage(profile.avatarUrl!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: profile.avatarUrl == null
                                  ? Icon(
                                      Icons.person,
                                      size: 50,
                                      color: appTheme.colors.pureWhite,
                                    )
                                  : null,
                            ),
                            SizedBox(height: appTheme.spacing.lg),
                            // Profile Name
                            Text(
                              profile.displayName ?? profile.username,
                              style: appTheme.typography.displayH1.copyWith(
                                color: appTheme.colors.pureWhite,
                                fontSize: 28,
                              ),
                            ),
                            SizedBox(height: appTheme.spacing.sm),
                            // Username
                            Text(
                              '@${profile.username}',
                              style: appTheme.typography.bodyH8.copyWith(
                                color: appTheme.colors.lightGray,
                              ),
                            ),
                            SizedBox(height: appTheme.spacing.md),
                            // Stats
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatItem('Followers', '2.4K', appTheme),
                                _buildStatItem('Following', '1.2K', appTheme),
                                _buildStatItem('Tracks', '89', appTheme),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: appTheme.colors.pureWhite,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: appTheme.colors.pureWhite,
                ),
                onPressed: () {
                  _showEditProfileDialog(context, profile);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: appTheme.colors.pureWhite,
                ),
                onPressed: () {
                  // Handle settings
                },
              ),
            ],
          ),

          // Profile Content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(appTheme.spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bio Section
                  Container(
                    padding: EdgeInsets.all(appTheme.spacing.lg),
                    decoration: BoxDecoration(
                      color: appTheme.colors.darkTone,
                      borderRadius: BorderRadius.circular(appTheme.radius.lg),
                      border: Border.all(
                        color: appTheme.colors.lightGray.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About Me',
                          style: appTheme.typography.headlineH6.copyWith(
                            color: appTheme.colors.pureWhite,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: appTheme.spacing.md),
                        Text(
                          profile.bio ?? 'No bio available. Click edit to add one!',
                          style: appTheme.typography.bodyH8.copyWith(
                            color: appTheme.colors.lightGray,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: appTheme.spacing.lg),

                  // Interests Section
                  Text(
                    'Music Interests',
                    style: appTheme.typography.headlineH6.copyWith(
                      color: appTheme.colors.pureWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: appTheme.spacing.md),
                  Wrap(
                    spacing: appTheme.spacing.sm,
                    runSpacing: appTheme.spacing.xs,
                    children: [
                      'Electronic', 'DJ', 'Music Production', 'Hip Hop',
                      'Jazz', 'Classical', 'Rock', 'Pop'
                    ].map<Widget>((interest) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: appTheme.spacing.sm,
                          vertical: appTheme.spacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: appTheme.colors.primaryRed.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(appTheme.radius.sm),
                          border: Border.all(
                            color: appTheme.colors.primaryRed.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          interest,
                          style: appTheme.typography.bodyH8.copyWith(
                            color: appTheme.colors.primaryRed,
                            fontSize: 12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  SizedBox(height: appTheme.spacing.lg),

                  // Recent Activity
                  Text(
                    'Recent Activity',
                    style: appTheme.typography.headlineH6.copyWith(
                      color: appTheme.colors.pureWhite,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: appTheme.spacing.md),

                  // Activity Items
                  _buildActivityItem(
                    'Liked "Midnight Dreams" by Luna Sky',
                    '2 hours ago',
                    Icons.favorite,
                    appTheme,
                  ),
                  _buildActivityItem(
                    'Added "Electric Storm" to playlist',
                    '4 hours ago',
                    Icons.playlist_add,
                    appTheme,
                  ),
                  _buildActivityItem(
                    'Followed DJ Pulse',
                    '1 day ago',
                    Icons.person_add,
                    appTheme,
                  ),

                  SizedBox(height: appTheme.spacing.xl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, String message) {
    final appTheme = AppTheme.of(context);
    return Scaffold(
      backgroundColor: appTheme.colors.darkTone,
      body: Center(
        child: Text(
          message,
          style: appTheme.typography.bodyH8.copyWith(
            color: appTheme.colors.lightGray,
          ),
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, UserProfile profile) {
    final appTheme = AppTheme.of(context);
    final displayNameController = TextEditingController(text: profile.displayName ?? '');
    final bioController = TextEditingController(text: profile.bio ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: appTheme.colors.darkTone,
          title: Text(
            'Edit Profile',
            style: appTheme.typography.headlineH6.copyWith(
              color: appTheme.colors.pureWhite,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: displayNameController,
                  style: appTheme.typography.bodyH8.copyWith(
                    color: appTheme.colors.pureWhite,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    labelStyle: appTheme.typography.bodyH8.copyWith(
                      color: appTheme.colors.lightGray,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: appTheme.colors.lightGray.withValues(alpha: 0.2)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: appTheme.colors.primaryRed),
                    ),
                    hintText: 'Enter your display name',
                    hintStyle: appTheme.typography.bodyH8.copyWith(
                      color: appTheme.colors.lightGray,
                    ),
                  ),
                ),
                SizedBox(height: appTheme.spacing.sm),
                TextField(
                  controller: bioController,
                  style: appTheme.typography.bodyH8.copyWith(
                    color: appTheme.colors.pureWhite,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    labelStyle: appTheme.typography.bodyH8.copyWith(
                      color: appTheme.colors.lightGray,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: appTheme.colors.lightGray.withValues(alpha: 0.2)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: appTheme.colors.primaryRed),
                    ),
                    hintText: 'Tell us about yourself',
                    hintStyle: appTheme.typography.bodyH8.copyWith(
                      color: appTheme.colors.lightGray,
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: appTheme.typography.bodyH8.copyWith(
                  color: appTheme.colors.primaryRed,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Save Changes',
                style: appTheme.typography.bodyH8.copyWith(
                  color: appTheme.colors.primaryRed,
                ),
              ),
              onPressed: () {
                final updateRequest = UserProfileUpdateRequest(
                  displayName: displayNameController.text.isNotEmpty ? displayNameController.text : null,
                  bio: bioController.text.isNotEmpty ? bioController.text : null,
                );

                context.read<UserProfileBloc>().add(UpdateUserProfile(updateRequest: updateRequest));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, AppTheme appTheme) {
    return Column(
      children: [
        Text(
          value,
          style: appTheme.typography.headlineH6.copyWith(
            color: appTheme.colors.pureWhite,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: appTheme.spacing.xs),
        Text(
          label,
          style: appTheme.typography.bodyH8.copyWith(
            color: appTheme.colors.lightGray,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(String text, String time, IconData icon, AppTheme appTheme) {
    return Container(
      margin: EdgeInsets.only(bottom: appTheme.spacing.md),
      padding: EdgeInsets.all(appTheme.spacing.md),
      decoration: BoxDecoration(
        color: appTheme.colors.darkTone,
        borderRadius: BorderRadius.circular(appTheme.radius.md),
        border: Border.all(
          color: appTheme.colors.lightGray.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: appTheme.colors.primaryRed.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(appTheme.radius.md),
            ),
            child: Icon(
              icon,
              color: appTheme.colors.primaryRed,
              size: 20,
            ),
          ),
          SizedBox(width: appTheme.spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: appTheme.typography.bodyH8.copyWith(
                    color: appTheme.colors.pureWhite,
                  ),
                ),
                SizedBox(height: appTheme.spacing.xs),
                Text(
                  time,
                  style: appTheme.typography.bodyH8.copyWith(
                    color: appTheme.colors.lightGray,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Music Notes Background
class ProfileMusicNotePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    // Draw some simple music note shapes
    for (int i = 0; i < 5; i++) {
      final x = (size.width / 5) * i + 20;
      final y = (size.height / 3) * (i % 3) + 50;

      // Draw note head
      canvas.drawCircle(Offset(x, y), 8, paint);
      // Draw stem
      canvas.drawRect(
        Rect.fromLTWH(x + 8, y - 20, 2, 20),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}