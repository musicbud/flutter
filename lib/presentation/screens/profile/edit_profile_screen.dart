import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/design_system.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_event.dart';
import '../../../blocs/profile/profile_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  final _websiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load current profile data
    context.read<ProfileBloc>().add(ProfileRequested());
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: DesignSystem.headlineSmall,
        ),
        backgroundColor: DesignSystem.surface,
        elevation: 0,
        actions: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              return TextButton(
                onPressed: state is ProfileLoading ? null : _saveProfile,
                child: state is ProfileLoading 
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Save',
                      style: TextStyle(
                        color: DesignSystem.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
              );
            },
          ),
        ],
      ),
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoaded) {
            // Populate form fields with current profile data
            _displayNameController.text = state.profile.displayName ?? '';
            _bioController.text = state.profile.bio ?? '';
            _locationController.text = state.profile.location ?? '';
            // Note: website is not in the UserProfile model
          } else if (state is ProfileUpdateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop();
          } else if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(DesignSystem.spacingLG),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture Section
                _buildProfilePictureSection(),
                
                const SizedBox(height: DesignSystem.spacingXL),
                
                // Basic Information
                const Text(
                  'Basic Information',
                  style: DesignSystem.headlineSmall,
                ),
                const SizedBox(height: DesignSystem.spacingMD),
                
                _buildTextField(
                  controller: _displayNameController,
                  label: 'Display Name',
                  hint: 'How others will see you',
                  icon: Icons.person,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Display name is required';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: DesignSystem.spacingMD),
                
                _buildTextField(
                  controller: _bioController,
                  label: 'Bio',
                  hint: 'Tell others about your music taste',
                  icon: Icons.description,
                  maxLines: 3,
                  maxLength: 150,
                ),
                
                const SizedBox(height: DesignSystem.spacingMD),
                
                _buildTextField(
                  controller: _locationController,
                  label: 'Location',
                  hint: 'Where are you based?',
                  icon: Icons.location_on,
                ),
                
                const SizedBox(height: DesignSystem.spacingMD),
                
                _buildTextField(
                  controller: _websiteController,
                  label: 'Website',
                  hint: 'Your website or social media',
                  icon: Icons.link,
                  keyboardType: TextInputType.url,
                ),
                
                const SizedBox(height: DesignSystem.spacingXL),
                
                // Privacy Settings
                _buildPrivacySection(),
                
                const SizedBox(height: DesignSystem.spacingXL),
                
                // Music Preferences
                _buildMusicPreferencesSection(),
                
                const SizedBox(height: DesignSystem.spacingXXL),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: DesignSystem.primary.withValues(alpha: 0.1),
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: DesignSystem.primary,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: DesignSystem.primary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: DesignSystem.surface,
                      width: 2,
                    ),
                  ),
                  child: IconButton(
                    onPressed: _selectProfilePicture,
                    icon: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: DesignSystem.spacingMD),
          Text(
            'Tap to change profile picture',
            style: DesignSystem.bodyMedium.copyWith(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    int? maxLength,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignSystem.radiusMD),
          borderSide: const BorderSide(color: DesignSystem.primary),
        ),
        counterText: maxLength != null ? null : '',
      ),
      maxLines: maxLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildPrivacySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Privacy Settings',
          style: DesignSystem.headlineSmall,
        ),
        const SizedBox(height: DesignSystem.spacingMD),
        
        SwitchListTile(
          title: const Text('Profile Visibility'),
          subtitle: const Text('Make your profile visible to other users'),
          value: true,
          onChanged: (bool value) {
            // Handle privacy setting change
          },
          activeColor: DesignSystem.primary,
        ),
        
        SwitchListTile(
          title: const Text('Show Listening Activity'),
          subtitle: const Text('Let others see what you\'re currently playing'),
          value: true,
          onChanged: (bool value) {
            // Handle listening activity setting
          },
          activeColor: DesignSystem.primary,
        ),
      ],
    );
  }

  Widget _buildMusicPreferencesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Music Preferences',
          style: DesignSystem.headlineSmall,
        ),
        const SizedBox(height: DesignSystem.spacingMD),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(DesignSystem.spacingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.music_note, color: DesignSystem.primary),
                    const SizedBox(width: DesignSystem.spacingMD),
                    Text(
                      'Favorite Genres',
                      style: DesignSystem.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: DesignSystem.spacingMD),
                Wrap(
                  spacing: 8.0,
                  children: [
                    _buildGenreChip('Rock'),
                    _buildGenreChip('Pop'),
                    _buildGenreChip('Electronic'),
                    _buildGenreChip('Hip Hop'),
                    _buildGenreChip('Jazz'),
                  ],
                ),
                const SizedBox(height: DesignSystem.spacingMD),
                TextButton.icon(
                  onPressed: () {
                    // Navigate to genre selection
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add More Genres'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenreChip(String genre) {
    return Chip(
      label: Text(genre),
      deleteIcon: const Icon(Icons.close, size: 16),
      onDeleted: () {
        // Remove genre
      },
      backgroundColor: DesignSystem.primary.withValues(alpha: 0.1),
      deleteIconColor: DesignSystem.primary,
    );
  }

  void _selectProfilePicture() {
    // Implement profile picture selection
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                // Implement camera capture
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                // Implement gallery selection
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Create profile update event
      final updateData = {
        'display_name': _displayNameController.text.trim(),
        'bio': _bioController.text.trim(),
        'location': _locationController.text.trim(),
      };
      context.read<ProfileBloc>().add(
        ProfileUpdateRequested(updateData),
      );
    }
  }
}