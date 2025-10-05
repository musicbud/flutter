import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/user_profile/user_profile_bloc.dart';
import '../../../domain/models/user_profile.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_card.dart';
import '../../widgets/common/app_input_field.dart';
import '../../constants/app_theme.dart';

class UserProfileDemoPage extends StatefulWidget {
  const UserProfileDemoPage({super.key});

  @override
  State<UserProfileDemoPage> createState() => _UserProfileDemoPageState();
}

class _UserProfileDemoPageState extends State<UserProfileDemoPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load user profile when page initializes
    context.read<UserProfileBloc>().add(FetchMyProfile());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile Demo'),
        backgroundColor: appTheme.colors.primaryRed,
        foregroundColor: appTheme.colors.pureWhite,
      ),
      body: BlocListener<UserProfileBloc, UserProfileState>(
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
                content: const Text('Profile updated successfully!'),
                backgroundColor: appTheme.colors.successGreen,
              ),
            );
          }
        },
        child: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is UserProfileLoaded) {
              return _buildProfileContent(context, state.userProfile);
            }

            if (state is UserProfileError) {
              return _buildErrorContent(context, state.message);
            }

            return const Center(
              child: Text('No profile data available'),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserProfile profile) {
    final appTheme = AppTheme.of(context);

    return SingleChildScrollView(
      padding: EdgeInsets.all(appTheme.spacing.paddingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Header
          AppCard(
            variant: AppCardVariant.profile,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: appTheme.colors.primaryRed,
                  child: profile.avatarUrl != null
                      ? ClipOval(
                          child: Image.network(
                            profile.avatarUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                size: 50,
                                color: appTheme.colors.pureWhite,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 50,
                          color: appTheme.colors.pureWhite,
                        ),
                ),
                const SizedBox(height: 16),
                Text(
                  profile.username,
                  style: appTheme.typography.titleLarge.copyWith(
                    color: appTheme.colors.primaryRed,
                  ),
                ),
                if (profile.displayName != null)
                  Text(
                    profile.displayName!,
                    style: appTheme.typography.bodyMedium,
                  ),
                if (profile.bio != null && profile.bio!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      profile.bio!,
                      style: appTheme.typography.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Profile Form
          AppCard(
            variant: AppCardVariant.primary,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Edit Profile',
                    style: appTheme.typography.titleMedium.copyWith(
                      color: appTheme.colors.primaryRed,
                    ),
                  ),
                  const SizedBox(height: 16),

                  AppInputField(
                    controller: _firstNameController..text = profile.displayName?.split(' ').first ?? '',
                    labelText: 'First Name',
                    hintText: 'Enter your first name',
                    variant: AppInputVariant.primary,
                  ),

                  const SizedBox(height: 16),

                  AppInputField(
                    controller: _lastNameController..text = profile.displayName?.split(' ').last ?? '',
                    labelText: 'Last Name',
                    hintText: 'Enter your last name',
                    variant: AppInputVariant.primary,
                  ),

                  const SizedBox(height: 16),

                  AppInputField(
                    controller: _bioController..text = profile.bio ?? '',
                    labelText: 'Bio',
                    hintText: 'Tell us about yourself',
                    variant: AppInputVariant.primary,
                    maxLines: 3,
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      onPressed: _updateProfile,
                      text: 'Update Profile',
                      variant: AppButtonVariant.primary,
                      size: AppButtonSize.large,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Connected Services
          AppCard(
            variant: AppCardVariant.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Connected Services',
                  style: appTheme.typography.titleMedium.copyWith(
                    color: appTheme.colors.primaryRed,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'No connected services available',
                  style: appTheme.typography.bodySmall.copyWith(
                    color: appTheme.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: AppButton(
                  onPressed: () => _loadLikedContent('artists'),
                  text: 'My Artists',
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.medium,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AppButton(
                  onPressed: () => _loadLikedContent('tracks'),
                  text: 'My Tracks',
                  variant: AppButtonVariant.secondary,
                  size: AppButtonSize.medium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorContent(BuildContext context, String message) {
    final appTheme = AppTheme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: appTheme.colors.errorRed,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading profile',
            style: appTheme.typography.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: appTheme.typography.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          AppButton(
            onPressed: () {
              context.read<UserProfileBloc>().add(FetchMyProfile());
            },
            text: 'Retry',
            variant: AppButtonVariant.primary,
          ),
        ],
      ),
    );
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      final updateRequest = UserProfileUpdateRequest(
        firstName: _firstNameController.text.isNotEmpty
            ? _firstNameController.text
            : null,
        lastName: _lastNameController.text.isNotEmpty
            ? _lastNameController.text
            : null,
        bio: _bioController.text.isNotEmpty
            ? _bioController.text
            : null,
      );

      context.read<UserProfileBloc>().add(UpdateUserProfile(updateRequest: updateRequest));
    }
  }

  void _loadLikedContent(String contentType) {
    context.read<UserProfileBloc>().add(FetchMyLikedContent(contentType: contentType));
    // You could navigate to a content page or show a dialog here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loading $contentType...'),
        backgroundColor: AppTheme.of(context).colors.infoBlue,
      ),
    );
  }
}