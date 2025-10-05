import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_event.dart';
import '../../../blocs/profile/profile_state.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../domain/models/user_profile.dart';
import '../../../domain/models/content_service.dart';
import '../../constants/app_constants.dart';
import '../../mixins/page_mixin.dart';
import '../../widgets/modern/app_text_field.dart';
import '../../widgets/common/modern_input_field.dart' as common_modern_input_field;

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with PageMixin, TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });

    // Load profile data
    _loadProfileData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _displayNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _loadProfileData() {
    context.read<ProfileBloc>().add(ProfileRequested());
    context.read<ProfileBloc>().add(ProfileConnectedServicesRequested());
    // TODO: Fix ProfileBloc events
    // context.read<ProfileBloc>().add(ProfileStatsRequested());
    // context.read<ProfileBloc>().add(ProfilePreferencesRequested());
  }

  void _loadTopItems(String category) {
    context.read<ProfileBloc>().add(ProfileTopItemsRequested(category));
  }

  void _loadLikedItems(String category) {
    context.read<ProfileBloc>().add(ProfileLikedItemsRequested(category));
  }

  void _loadBuds(String category) {
    context.read<ProfileBloc>().add(ProfileBudsRequested(category));
  }

  void _refreshProfile() {
    // TODO: Fix ProfileBloc events
    // context.read<ProfileBloc>().add(ProfileRefreshRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: AppConstants.backgroundColor,
        elevation: 0,
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileFailure) {
            _showErrorSnackBar(state.error);
                  } else if (state is ProfileUpdateSuccess) {
          _showSuccessSnackBar('Profile updated successfully');
          setState(() {
            _isEditing = false;
          });
        } else if (state is ProfileAvatarUpdateSuccess) {
          _showSuccessSnackBar('Avatar updated successfully');
        }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileLoaded) {
            return _buildProfileContent(state.profile, []);
          }

          return const Center(child: Text('Profile not found'));
        },
      ),
    );
  }

  Widget _buildProfileContent(UserProfile profile, List<dynamic> services) {
    return Column(
      children: [
        _buildProfileHeader(profile),
        _buildProfileStats(),
        _buildConnectedServices(services),
        Expanded(
          child: _buildProfileTabs(profile),
        ),
      ],
    );
  }

  Widget _buildProfileHeader(UserProfile profile) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primaryColor.withOpacity(0.3),
            AppConstants.primaryColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        children: [
          // Avatar Section
          _buildAvatarSection(profile),
          const SizedBox(height: 16),

          // Profile Info
          _buildProfileInfo(profile),
          const SizedBox(height: 16),

          // Profile Stats
          _buildProfileStats(),
          const SizedBox(height: 16),

          // Connected Services
          _buildConnectedServicesChips([]),
        ],
      ),
    );
  }

  Widget _buildAvatarSection(UserProfile profile) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: AppConstants.primaryColor.withOpacity(0.3),
          backgroundImage: profile.avatarUrl != null
              ? NetworkImage(profile.avatarUrl!)
              : null,
          child: profile.avatarUrl == null
              ? Text(
                  profile.username.isNotEmpty ? profile.username[0].toUpperCase() : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : null,
        ),
        if (_isEditing)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppConstants.primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _updateAvatar,
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProfileInfo(UserProfile profile) {
    return Column(
      children: [
        if (_isEditing) ...[
                      common_modern_input_field.ModernInputField(
                        controller: _firstNameController,
                        hintText: 'First Name',
                        variant: common_modern_input_field.ModernInputFieldVariant.filled,
                      ),
                      const SizedBox(height: 16),
                      common_modern_input_field.ModernInputField(
                        controller: _lastNameController,
                        hintText: 'Last Name',
                        variant: common_modern_input_field.ModernInputFieldVariant.filled,
                      ),
                      const SizedBox(height: 16),
                      common_modern_input_field.ModernInputField(
                        controller: _bioController,
                        hintText: 'Bio',
                        variant: common_modern_input_field.ModernInputFieldVariant.filled,
                        maxLines: 3,
                      ),
          const SizedBox(height: 12),
                      AppTextField(
              controller: _locationController,
              labelText: 'Location',
              hintText: 'Enter your location',
            ),
        ] else ...[
          Text(
            profile.displayName ?? profile.username,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (profile.bio != null && profile.bio!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              profile.bio!,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          if (profile.location != null && profile.location!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Text(
                  profile.location!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildProfileStats() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        // TODO: Fix ProfileBloc states
        // if (state is ProfileStatsLoaded) {
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Tracks', '0'), // TODO: Fix stats access
              _buildStatItem('Artists', '0'),
              _buildStatItem('Genres', '0'),
              _buildStatItem('Buds', '0'),
            ],
          ),
        );
        // }
        // return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectedServices(List<dynamic> services) {
    if (services.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          'No services connected',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Connected Services',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: services.map((service) {
              return Chip(
                label: Text(service.toString()),
                backgroundColor: Colors.blue.withOpacity(0.3),
                labelStyle: const TextStyle(color: Colors.white),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedServicesChips(List<ContentService> services) {
    if (services.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Connected Services',
          style: TextStyle(
            color: AppConstants.textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: services.map((service) => Chip(
            avatar: CircleAvatar(
              backgroundColor: _getServiceColor(service.name).withOpacity(0.2),
              child: Icon(
                _getServiceIcon(service.name),
                color: _getServiceColor(service.name),
                size: 16,
              ),
            ),
            label: Text(
              service.name,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: AppConstants.surfaceColor,
            side: BorderSide(
              color: _getServiceColor(service.name),
              width: 2,
            ),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppConstants.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppConstants.textSecondaryColor,
        tabs: const [
          Tab(text: 'Overview'),
          Tab(text: 'Library'),
          Tab(text: 'Playlists'),
          Tab(text: 'Following'),
          Tab(text: 'Followers'),
        ],
      ),
    );
  }

  Widget _buildProfileTabs(UserProfile profile) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'Top Items'),
            Tab(text: 'Liked Items'),
            Tab(text: 'Buds'),
            Tab(text: 'Preferences'),
            Tab(text: 'Settings'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTopItemsTab(),
              _buildLikedItemsTab(),
              _buildBudsTab(),
              _buildPreferencesTab(),
              _buildSettingsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopItemsTab() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileTopItemsLoaded) {
          return _buildItemsList(state.items, 'Top Items');
        }
        return _buildTabPlaceholder('Top Items', () {
          _loadTopItems('tracks');
        });
      },
    );
  }

  Widget _buildLikedItemsTab() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLikedItemsLoaded) {
          return _buildItemsList(state.items, 'Liked Items');
        }
        return _buildTabPlaceholder('Liked Items', () {
          _loadLikedItems('tracks');
        });
      },
    );
  }

  Widget _buildBudsTab() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileBudsLoaded) {
          return _buildBudsList(state.buds, state.category);
        }
        return _buildTabPlaceholder('Buds', () {
          _loadBuds('liked/artists');
        });
      },
    );
  }

  Widget _buildPreferencesTab() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        // TODO: Fix ProfileBloc states
        // if (state is ProfilePreferencesLoaded) {
        //   return _buildPreferencesList(state.preferences);
        // }
        return _buildTabPlaceholder('Preferences', () {
          // TODO: Fix ProfileBloc events
          // context.read<ProfileBloc>().add(ProfilePreferencesRequested());
        });
      },
    );
  }

  Widget _buildSettingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.notifications, color: Colors.white),
          title: const Text('Notifications', style: TextStyle(color: Colors.white)),
          trailing: Switch(
            value: true,
            onChanged: (value) {
              // Handle notification toggle
            },
          ),
        ),
        ListTile(
          leading: const Icon(Icons.privacy_tip, color: Colors.white),
          title: const Text('Privacy', style: TextStyle(color: Colors.white)),
          trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          onTap: () {
            // Navigate to privacy settings
          },
        ),
        ListTile(
          leading: const Icon(Icons.language, color: Colors.white),
          title: const Text('Language', style: TextStyle(color: Colors.white)),
          trailing: const Text('English', style: TextStyle(color: Colors.white70)),
          onTap: () {
            // Show language picker
          },
        ),
      ],
    );
  }

  Widget _buildTabPlaceholder(String title, VoidCallback onLoad) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'No $title loaded',
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onLoad,
            child: Text('Load $title'),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(List<dynamic> items, String title) {
    if (items.isEmpty) {
      return Center(
        child: Text(
          'No $title found',
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: Colors.white.withOpacity(0.1),
          child: ListTile(
            title: Text(
              item.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
            onTap: () {
              // Navigate to item details
            },
          ),
        );
      },
    );
  }

  Widget _buildBudsList(List<dynamic> buds, String category) {
    if (buds.isEmpty) {
      return Center(
        child: Text(
          'No buds found for $category',
          style: const TextStyle(color: Colors.white70),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: buds.length,
      itemBuilder: (context, index) {
        final bud = buds[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: Colors.white.withOpacity(0.1),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Text(
                bud.toString().substring(0, 1).toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              bud.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              'Category: $category',
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
            onTap: () {
              // Navigate to bud profile
            },
          ),
        );
      },
    );
  }

  Widget _buildPreferencesList(Map<String, dynamic> preferences) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: preferences.entries.map((entry) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          color: Colors.white.withOpacity(0.1),
          child: ListTile(
            title: Text(
              entry.key.replaceAll('_', ' ').toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              entry.value.toString(),
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: entry.value is bool
                ? Switch(
                    value: entry.value,
                    onChanged: (value) {
                      // Handle preference toggle
                    },
                  )
                : const Icon(Icons.arrow_forward_ios, color: Colors.white70),
            onTap: entry.value is bool ? null : () {
              // Navigate to preference details
            },
          ),
        );
      }).toList(),
    );
  }

  // Helper methods
  Color _getServiceColor(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'spotify':
        return Colors.green;
      case 'youtube music':
        return Colors.red;
      case 'lastfm':
        return Colors.purple;
      case 'myanimelist':
        return Colors.blue;
      default:
        return AppConstants.primaryColor;
    }
  }

  IconData _getServiceIcon(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'spotify':
        return Icons.music_note;
      case 'youtube music':
        return Icons.play_circle_filled;
      case 'lastfm':
        return Icons.radio;
      case 'myanimelist':
        return Icons.animation;
      default:
        return Icons.link;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    if (difference.inDays < 7) return '${difference.inDays} days ago';
    if (difference.inDays < 30) return '${(difference.inDays / 7).floor()} weeks ago';
    return '${(difference.inDays / 30).floor()} months ago';
  }

  // Action methods
  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });

    if (_isEditing) {
      // Load current values into controllers
      final profile = context.read<ProfileBloc>().state;
      if (profile is ProfileLoaded) {
        _displayNameController.text = profile.profile.displayName ?? '';
        _bioController.text = profile.profile.bio ?? '';
        _locationController.text = profile.profile.location ?? '';
      }
    }
  }

  void _saveProfile() {
    final profile = context.read<ProfileBloc>().state;
    if (profile is ProfileLoaded) {
      context.read<ProfileBloc>().add(ProfileUpdateRequested({
        // 'displayName': _displayNameController.text,
        'bio': _bioController.text,
        'location': _locationController.text,
      }));
    }
  }

  Future<void> _updateAvatar() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      context.read<ProfileBloc>().add(ProfileAvatarUpdateRequested(image));
    }
  }

  void _logout() {
    context.read<AuthBloc>().add(LogoutRequested());
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }
}









