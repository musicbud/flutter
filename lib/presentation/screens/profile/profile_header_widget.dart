import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/user_profile/user_profile_bloc.dart';
import '../../../domain/models/user_profile.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/index.dart';

class ProfileHeaderWidget extends StatefulWidget {
  final UserProfile? userProfile;
  final bool isLoading;
  final bool hasError;

  const ProfileHeaderWidget({
    super.key,
    this.userProfile,
    this.isLoading = false,
    this.hasError = false,
  });

  @override
  State<ProfileHeaderWidget> createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProfileHeaderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset editing state when profile changes
    if (oldWidget.userProfile != widget.userProfile && !_isEditing) {
      _isEditing = false;
    }
  }

  void _startEditing() {
    if (widget.userProfile == null) return;

    _displayNameController.text = widget.userProfile!.displayName ?? '';
    _bioController.text = widget.userProfile!.bio ?? '';
    _locationController.text = widget.userProfile!.location ?? '';
    setState(() {
      _isEditing = true;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<UserProfileBloc>().add(UpdateUserProfile(
        updateRequest: UserProfileUpdateRequest(
          displayName: _displayNameController.text,
          bio: _bioController.text,
          location: _locationController.text,
        ),
      ));
      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return Container(
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
              backgroundImage: widget.userProfile?.avatarUrl != null
                  ? NetworkImage(widget.userProfile!.avatarUrl!)
                  : null,
              child: widget.userProfile?.avatarUrl == null
                  ? Icon(
                      Icons.person,
                      color: appTheme.colors.white,
                      size: 60,
                    )
                  : null,
            ),
          ),

          SizedBox(height: appTheme.spacing.lg),

          // Profile Info or Edit Form
          if (widget.isLoading) ...[
            SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: appTheme.colors.primaryRed,
                strokeWidth: 2,
              ),
            ),
          ] else if (widget.hasError) ...[
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
          ] else if (widget.userProfile != null) ...[
            if (_isEditing) ...[
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    ModernInputField(
                      controller: _displayNameController,
                      label: 'Display Name',
                      hintText: 'Enter your display name',
                    ),
                    SizedBox(height: appTheme.spacing.md),
                    ModernInputField(
                      controller: _bioController,
                      label: 'Bio',
                      hintText: 'Tell us about yourself',
                      maxLines: 3,
                    ),
                    SizedBox(height: appTheme.spacing.md),
                    ModernInputField(
                      controller: _locationController,
                      label: 'Location',
                      hintText: 'Enter your location',
                    ),
                    SizedBox(height: appTheme.spacing.md),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SecondaryButton(
                          text: 'Cancel',
                          onPressed: _cancelEditing,
                        ),
                        PrimaryButton(
                          text: 'Save',
                          onPressed: _saveChanges,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ] else ...[
              Text(
                widget.userProfile!.displayName ?? widget.userProfile!.username,
                style: appTheme.typography.headlineH5.copyWith(
                  color: appTheme.colors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              if (widget.userProfile!.displayName != null) ...[
                SizedBox(height: appTheme.spacing.xs),
                Text(
                  '@${widget.userProfile!.username}',
                  style: appTheme.typography.bodyMedium.copyWith(
                    color: appTheme.colors.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              if (widget.userProfile!.bio != null && widget.userProfile!.bio!.isNotEmpty) ...[
                SizedBox(height: appTheme.spacing.md),
                Text(
                  widget.userProfile!.bio!,
                  style: appTheme.typography.bodyMedium.copyWith(
                    color: appTheme.colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              if (widget.userProfile!.location != null && widget.userProfile!.location!.isNotEmpty) ...[
                SizedBox(height: appTheme.spacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 16,
                      color: appTheme.colors.textMuted,
                    ),
                    SizedBox(width: appTheme.spacing.xs),
                    Text(
                      widget.userProfile!.location!,
                      style: appTheme.typography.bodySmall.copyWith(
                        color: appTheme.colors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ],

            SizedBox(height: appTheme.spacing.md),

            // Profile Stats - TODO: Implement ProfileStatsWidget
            // ProfileStatsWidget(userProfile: widget.userProfile!),

            SizedBox(height: appTheme.spacing.lg),

            // Edit Profile Button
            PrimaryButton(
              text: _isEditing ? 'Cancel' : 'Edit Profile',
              onPressed: () {
                if (_isEditing) {
                  _cancelEditing();
                } else {
                  _startEditing();
                }
              },
              icon: _isEditing ? Icons.close : Icons.edit,
              size: ModernButtonSize.large,
              isFullWidth: true,
            ),
          ],
        ],
      ),
    );
  }
}