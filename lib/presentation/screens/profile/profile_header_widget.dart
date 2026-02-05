import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/user_profile/user_profile_bloc.dart';
import '../../../models/user_profile.dart';
import '../../../core/theme/design_system.dart';
// MIGRATED: import '../../../widgets/common/index.dart';
import '../../widgets/enhanced/enhanced_widgets.dart' hide UserProfile;

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
    return Container(
      padding: const EdgeInsets.all(DesignSystem.spacingLG),
      child: Column(
        children: [
          // Profile Avatar with enhanced styling
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(DesignSystem.radiusCircular),
              boxShadow: DesignSystem.shadowCard,
              border: Border.all(
                color: DesignSystem.primary.withAlpha(77),
                width: 3,
              ),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: DesignSystem.primary,
              backgroundImage: widget.userProfile?.avatarUrl != null
                  ? NetworkImage(widget.userProfile!.avatarUrl!)
                  : null,
              child: widget.userProfile?.avatarUrl == null
                  ? const Icon(
                      Icons.person,
                      color: DesignSystem.onPrimary,
                      size: 60,
                    )
                  : null,
            ),
          ),

          const SizedBox(height: DesignSystem.spacingLG),

          // Profile Info or Edit Form
          if (widget.isLoading) ...[
            const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: DesignSystem.primary,
                strokeWidth: 2,
              ),
            ),
          ] else if (widget.hasError) ...[
            Text(
              'Unable to load profile',
              style: DesignSystem.titleMedium.copyWith(
                color: DesignSystem.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: DesignSystem.spacingMD),
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ModernInputField(
                        controller: _displayNameController,
                        label: 'Display Name',
                        hintText: 'Enter your display name',
                      ),
                      const SizedBox(height: DesignSystem.spacingMD),
                      ModernInputField(
                        controller: _bioController,
                        label: 'Bio',
                        hintText: 'Tell us about yourself',
                        maxLines: 3,
                      ),
                      const SizedBox(height: DesignSystem.spacingMD),
                      ModernInputField(
                        controller: _locationController,
                        label: 'Location',
                        hintText: 'Enter your location',
                      ),
                      const SizedBox(height: DesignSystem.spacingMD),
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
              ),
            ] else ...[
              Text(
                widget.userProfile!.displayName ?? widget.userProfile!.username,
                style: DesignSystem.headlineSmall.copyWith(
                  color: DesignSystem.onSurface,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),

              if (widget.userProfile!.displayName != null) ...[
                const SizedBox(height: DesignSystem.spacingXS),
                Text(
                  '@${widget.userProfile!.username}',
                  style: DesignSystem.bodyMedium.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              if (widget.userProfile!.bio != null && widget.userProfile!.bio!.isNotEmpty) ...[
                const SizedBox(height: DesignSystem.spacingMD),
                Text(
                  widget.userProfile!.bio!,
                  style: DesignSystem.bodyMedium.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              if (widget.userProfile!.location != null && widget.userProfile!.location!.isNotEmpty) ...[
                const SizedBox(height: DesignSystem.spacingSM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: DesignSystem.onSurfaceVariant,
                    ),
                    const SizedBox(width: DesignSystem.spacingXS),
                    Text(
                      widget.userProfile!.location!,
                      style: DesignSystem.bodySmall.copyWith(
                        color: DesignSystem.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ],

            const SizedBox(height: DesignSystem.spacingMD),

            // Profile Stats - TODO: Implement ProfileStatsWidget
            // ProfileStatsWidget(userProfile: widget.userProfile!),

            const SizedBox(height: DesignSystem.spacingLG),

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
