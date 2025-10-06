import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/user_profile/user_profile_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/common/app_button.dart';
import '../../../widgets/common/index.dart';
import 'profile_header_widget.dart';
import 'profile_music_widget.dart';
import 'profile_activity_widget.dart';
import 'profile_settings_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        } else if (state is UserProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile updated successfully'),
              backgroundColor: appTheme.colors.successGreen,
            ),
          );
          // Refresh profile after update
          context.read<UserProfileBloc>().add(FetchMyProfile());
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
                  child: ProfileHeaderWidget(
                    userProfile: state is UserProfileLoaded ? state.userProfile : null,
                    isLoading: state is UserProfileLoading,
                    hasError: state is UserProfileError,
                  ),
                ),

                // Profile Sections
                if (state is UserProfileLoaded) ...[
                  SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),

                  // My Music Section
                  SliverToBoxAdapter(
                    child: ProfileMusicWidget(),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),

                  // Recent Activity Section
                  SliverToBoxAdapter(
                    child: ProfileActivityWidget(),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),

                  // Settings Section
                  SliverToBoxAdapter(
                    child: ProfileSettingsWidget(),
                  ),

                  SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),

                  // Logout Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
                      child: AppButton.secondary(
                        text: 'Logout',
                        onPressed: () {
                          // Handle logout
                        },
                        icon: Icons.logout,
                        size: AppButtonSize.large,
                        width: double.infinity,
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
}