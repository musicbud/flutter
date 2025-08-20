import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_event.dart';
import '../../../blocs/profile/profile_state.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../domain/models/user_profile.dart';
import '../../../domain/models/common_track.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_genre.dart';
import '../../../domain/models/common_album.dart';
import '../../../domain/models/common_anime.dart';
import '../../../domain/models/common_manga.dart';
import '../../../domain/models/content_service.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/app_app_bar.dart';
import '../../widgets/common/app_button.dart';
import '../../widgets/common/app_text_field.dart';
import '../../mixins/page_mixin.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with PageMixin, TickerProviderStateMixin {
  late TabController _tabController;
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
    _bioController.dispose();
    _displayNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _loadProfileData() {
    context.read<ProfileBloc>().add(ProfileRequested());
    context.read<ProfileBloc>().add(ProfileConnectedServicesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        title: 'Profile',
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _isEditing ? _saveProfile : _toggleEdit,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => navigateTo('/settings'),
          ),
        ],
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
            return _buildProfileContent(state.profile, state.services ?? []);
          }

          return const Center(child: Text('Profile not found'));
        },
      ),
    );
  }

  Widget _buildProfileContent(UserProfile profile, List<ContentService> connectedServices) {
    return Column(
      children: [
        _buildProfileHeader(profile),
        _buildTabBar(),
        Expanded(
          child: _buildTabView(profile, connectedServices),
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
          _buildProfileStats(profile),
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
              decoration: BoxDecoration(
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
                      AppTextField(
              controller: _displayNameController,
              labelText: 'Display Name',
              hintText: 'Enter your display name',
            ),
          const SizedBox(height: 12),
                      AppTextField(
              controller: _bioController,
              labelText: 'Bio',
              hintText: 'Tell us about yourself',
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

  Widget _buildProfileStats(UserProfile profile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('Followers', '${profile.followersCount}'),
        _buildStatItem('Following', '${profile.followingCount}'),
        _buildStatItem('Stories', '0'),
        _buildStatItem('Buds', '0'),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectedServicesChips(List<ContentService> services) {
    if (services.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
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

  Widget _buildTabView(UserProfile profile, List<ContentService> connectedServices) {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildOverviewTab(profile, connectedServices),
        _buildLibraryTab(),
        _buildPlaylistsTab(),
        _buildFollowingTab(),
        _buildFollowersTab(),
      ],
    );
  }

  Widget _buildOverviewTab(UserProfile profile, List<ContentService> services) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Account Information'),
          _buildAccountInfoCard(profile),
          const SizedBox(height: 24),
          _buildSectionTitle('Recent Activity'),
          _buildRecentActivityCard(),
          const SizedBox(height: 24),
          _buildSectionTitle('Quick Actions'),
          _buildQuickActionsCard(),
        ],
      ),
    );
  }

  Widget _buildLibraryTab() {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileTopItemsLoaded) {
          return _buildLibraryContent([], [], []);
        }

        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.library_music, size: 64, color: Colors.white54),
              SizedBox(height: 16),
              Text(
                'Library',
                style: TextStyle(color: Colors.white54),
              ),
              Text(
                'Your music library will appear here',
                style: TextStyle(color: Colors.white38, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlaylistsTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.playlist_play, size: 64, color: Colors.white54),
          SizedBox(height: 16),
          Text(
            'Playlists',
            style: TextStyle(color: Colors.white54),
          ),
          Text(
            'Your playlists will appear here',
            style: TextStyle(color: Colors.white38, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFollowingTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 64, color: Colors.white54),
          SizedBox(height: 16),
          Text(
            'Following',
            style: TextStyle(color: Colors.white54),
          ),
          Text(
            'People you follow will appear here',
            style: TextStyle(color: Colors.white38, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFollowersTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.white54),
          SizedBox(height: 16),
          Text(
            'Followers',
            style: TextStyle(color: Colors.white54),
          ),
          Text(
            'Your followers will appear here',
            style: TextStyle(color: Colors.white38, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          color: AppConstants.textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAccountInfoCard(UserProfile profile) {
    return Card(
      color: AppConstants.surfaceColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoRow('Username', profile.username),
            _buildInfoRow('Email', profile.email ?? 'Not provided'),
            _buildInfoRow('Member Since', 'Recently'),
            _buildInfoRow('Status', profile.isActive ? 'Active' : 'Inactive'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: AppConstants.textColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard() {
    return Card(
      color: AppConstants.surfaceColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: TextStyle(
                color: AppConstants.textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildActivityItem('Listened to music', '2 hours ago', Icons.music_note),
            _buildActivityItem('Added new bud', '1 day ago', Icons.person_add),
            _buildActivityItem('Shared story', '2 days ago', Icons.share),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem(String activity, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppConstants.primaryColor,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              activity,
              style: TextStyle(
                color: AppConstants.textColor,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Card(
      color: AppConstants.surfaceColor,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                color: AppConstants.textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Edit Profile',
                    onPressed: _toggleEdit,
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    text: 'Connect Services',
                    onPressed: () => navigateTo('/services'),
                    isOutlined: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: 'Privacy Settings',
                    onPressed: () => navigateTo('/settings'),
                    isOutlined: true,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    text: 'Logout',
                    onPressed: _logout,
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLibraryContent(
    List<CommonTrack>? topTracks,
    List<CommonArtist>? topArtists,
    List<CommonGenre>? topGenres,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (topTracks != null && topTracks.isNotEmpty) ...[
            _buildSectionTitle('Top Tracks'),
            _buildTracksList(topTracks),
            const SizedBox(height: 24),
          ],
          if (topArtists != null && topArtists.isNotEmpty) ...[
            _buildSectionTitle('Top Artists'),
            _buildArtistsList(topArtists),
            const SizedBox(height: 24),
          ],
          if (topGenres != null && topGenres.isNotEmpty) ...[
            _buildSectionTitle('Top Genres'),
            _buildGenresList(topGenres),
          ],
        ],
      ),
    );
  }

  Widget _buildTracksList(List<CommonTrack> tracks) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        return ListTile(
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.music_note,
              color: Colors.white70,
            ),
          ),
          title: Text(
            track.name,
            style: const TextStyle(color: Colors.white),
          ),
                      subtitle: Text(
              track.artistName ?? 'Unknown Artist',
              style: const TextStyle(color: Colors.white70),
            ),
          trailing: Icon(
            track.isLiked ? Icons.favorite : Icons.favorite_border,
            color: track.isLiked ? Colors.red : Colors.white70,
          ),
        );
      },
    );
  }

  Widget _buildArtistsList(List<CommonArtist> artists) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        final artist = artists[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppConstants.primaryColor.withOpacity(0.3),
            child: Text(
              artist.name.isNotEmpty ? artist.name[0].toUpperCase() : 'A',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            artist.name,
            style: const TextStyle(color: Colors.white),
          ),
                      subtitle: Text(
              '${artist.followers ?? 0} followers',
              style: const TextStyle(color: Colors.white70),
            ),
          trailing: Icon(
            artist.isLiked ? Icons.favorite : Icons.favorite_border,
            color: artist.isLiked ? Colors.red : Colors.white70,
          ),
        );
      },
    );
  }

  Widget _buildGenresList(List<CommonGenre> genres) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: genres.map((genre) => Chip(
        label: Text(
          genre.name,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppConstants.primaryColor.withOpacity(0.2),
        side: BorderSide(color: AppConstants.primaryColor),
      )).toList(),
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
        'displayName': _displayNameController.text,
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








