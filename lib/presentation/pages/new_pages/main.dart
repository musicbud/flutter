import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../blocs/main/main_screen_bloc.dart';
import '../../../blocs/main/main_screen_state.dart';
import '../../../blocs/main/main_screen_event.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_event.dart';
import '../../../blocs/profile/profile_state.dart';
import '../../../blocs/likes/likes_bloc.dart';
import '../../../blocs/likes/likes_state.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../../domain/repositories/content_repository.dart';
import '../../../domain/repositories/bud_repository.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/app_bottom_navigation_bar.dart';
import '../../constants/app_constants.dart';
import '../../mixins/page_mixin.dart';
import '../../../injection_container.dart' as di;

import 'chat_screen.dart';
import 'search.dart';
import 'sories.dart';
import 'profile_page.dart';
import 'service_connection_page.dart';
import 'user_management_page.dart';
import 'admin_dashboard_page.dart';
import 'channel_management_page.dart';
import 'settings_page.dart';
import 'event_page.dart';
import 'top_profile.dart';
import 'cards.dart';

class NewMainScreen extends StatefulWidget {
  const NewMainScreen({Key? key}) : super(key: key);

  @override
  State<NewMainScreen> createState() => _NewMainScreenState();
}

class _NewMainScreenState extends State<NewMainScreen> with PageMixin {
  int _selectedIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Don't initialize MainScreenBloc immediately - wait for authentication
  }

  // Enhanced navigation items configuration with all legacy functionality
  static const List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.laptop_mac_outlined,
      label: 'Home',
      page: HomeTab(),
    ),
    NavigationItem(
      icon: Icons.search,
      label: 'Search',
      page: SearchTab(),
    ),
    NavigationItem(
      icon: Icons.headphones,
      label: 'Stories',
      page: StoriesTab(),
    ),
    NavigationItem(
      icon: Icons.chat_rounded,
      label: 'Chat',
      page: ChatTab(),
    ),
    NavigationItem(
      icon: Icons.music_note,
      label: 'Music',
      page: MusicTab(),
    ),
    NavigationItem(
      icon: Icons.people,
      label: 'Buds',
      page: BudsTab(),
    ),
    NavigationItem(
      icon: Icons.analytics,
      label: 'Analytics',
      page: AnalyticsTab(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileBloc>(
          create: (context) => ProfileBloc(
            profileRepository: di.sl<ProfileRepository>(),
            contentRepository: di.sl<ContentRepository>(),
            budRepository: di.sl<BudRepository>(),
          ),
        ),
        BlocProvider<LikesBloc>(
          create: (context) => LikesBloc(
            contentRepository: di.sl<ContentRepository>(),
            authRepository: di.sl<AuthRepository>(),
          ),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: _handleAuthStateChange,
          ),
          BlocListener<MainScreenBloc, MainScreenState>(
            listener: _handleMainScreenStateChange,
          ),
        ],
        child: BlocConsumer<MainScreenBloc, MainScreenState>(
          listener: _handleMainScreenStateChange,
          builder: _buildMainScreen,
        ),
      ),
    );
  }

  void _handleAuthStateChange(BuildContext context, AuthState authState) {
    if (authState is Unauthenticated) {
      replaceRoute(AppConstants.loginRoute);
    } else if (authState is Authenticated) {
      // Initialize the main screen bloc after successful authentication
      addBlocEvent<MainScreenBloc, MainScreenInitialized>(MainScreenInitialized());
    }
  }

  void _handleMainScreenStateChange(BuildContext context, MainScreenState state) {
    if (state is MainScreenFailure) {
      showErrorSnackBar('Error: ${state.error}');
    } else if (state is MainScreenUnauthenticated) {
      addBlocEvent<AuthBloc, LogoutRequested>(LogoutRequested());
    } else if (state is MainScreenAuthenticated) {
      // Load additional data when authenticated
      _loadMainScreenData();
    }
  }

  void _loadMainScreenData() {
    // Load various data sources for the main screen
    // This integrates with the repository pattern from legacy code
    setState(() {
      _isLoading = true;
    });

    // Load top content, recent activity, etc.
    // These would be loaded through their respective blocs
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

    Widget _buildMainScreen(BuildContext context, MainScreenState state) {
    if (state is MainScreenLoading || _isLoading) {
      return const AppScaffold(
        body: Center(child: LoadingIndicator()),
      );
    }

    if (state is MainScreenAuthenticated) {
      return _buildAuthenticatedScreen();
    }

    if (state is MainScreenFailure) {
      return AppScaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: ${state.error}', style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => addBlocEvent<MainScreenBloc, MainScreenRefreshRequested>(MainScreenRefreshRequested()),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // Initial state - show loading
    return const AppScaffold(
      body: Center(child: LoadingIndicator()),
    );
  }

  Widget _buildAuthenticatedScreen() {
    return AppScaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Stack(
        children: [
          // Main content
          _navigationItems[_selectedIndex].page,

          // Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onNavigationItemTapped,
              items: _buildNavigationItems(),
              borderColor: AppConstants.primaryColor,
            ),
          ),

          // Profile Button
          Positioned(
            top: 20,
            right: 20,
            child: _buildProfileButton(),
          ),

          // Quick Actions Menu
          Positioned(
            top: 20,
            left: 20,
            child: _buildQuickActionsMenu(),
          ),
        ],
      ),
    );
  }

  List<BottomNavigationBarItem> _buildNavigationItems() {
    return _navigationItems.map((item) => BottomNavigationBarItem(
      icon: Icon(item.icon),
      label: item.label,
    )).toList();
  }

  Widget _buildProfileButton() {
    return IconButton(
      onPressed: () => navigateTo(AppConstants.profileRoute),
      icon: const Icon(
        Icons.person,
        color: AppConstants.textColor,
        size: 30,
      ),
      style: IconButton.styleFrom(
        backgroundColor: Colors.black54,
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  Widget _buildQuickActionsMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(
        Icons.menu,
        color: AppConstants.textColor,
        size: 30,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) => _handleQuickAction(value),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'services',
          child: Row(
            children: [
              Icon(Icons.connect_without_contact),
              SizedBox(width: 8),
              Text('Connect Services'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: Row(
            children: [
              Icon(Icons.settings),
              SizedBox(width: 8),
              Text('Settings'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'admin',
          child: Row(
            children: [
              Icon(Icons.admin_panel_settings),
              SizedBox(width: 8),
              Text('Admin Panel'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'events',
          child: Row(
            children: [
              Icon(Icons.event),
              SizedBox(width: 8),
              Text('Events'),
            ],
          ),
        ),
      ],
    );
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'services':
        navigateTo('/services');
        break;
      case 'settings':
        navigateTo('/settings');
        break;
      case 'admin':
        navigateTo('/admin');
        break;
      case 'events':
        navigateTo('/events');
        break;
    }
  }

  void _onNavigationItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

/// Data class for navigation items
class NavigationItem {
  final IconData icon;
  final String label;
  final Widget page;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.page,
  });
}

// Enhanced Tab implementations with legacy functionality
class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  void _loadHomeData() {
    // Load data for home tab
    // This integrates with the repository pattern from legacy code
    setState(() {
      _isLoading = true;
    });

    // Load various data sources for the main screen
    // These would be loaded through their respective blocs
    _loadTopContent();
    _loadRecentActivity();
    _loadRecommendations();

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _loadTopContent() {
    // Load top content from content repository
    // This would be implemented through content bloc
    // For now, we'll simulate the loading
  }

  void _loadRecentActivity() {
    // Load recent activity from user repository
    // This would be implemented through user bloc
    // For now, we'll simulate the loading
  }

  void _loadRecommendations() {
    // Load recommendations from content repository
    // This would be implemented through content bloc
    // For now, we'll simulate the loading
  }

  void navigateTo(String route) {
    // Simple navigation method for the HomeTab
    if (mounted) {
      // For now, just show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Navigating to: $route')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Profile error: ${state.error}')),
              );
            } else if (state is ProfileAvatarUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile picture updated successfully!')),
              );
            } else if (state is ProfileUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Profile updated successfully!')),
              );
            }
          },
        ),
        BlocListener<LikesBloc, LikesState>(
          listener: (context, state) {
            if (state is LikesUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is LikesUpdateFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.error}')),
              );
            }
          },
        ),
      ],
      child: _buildHomeContent(),
    );
  }

  Widget _buildHomeContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(),
          _buildProfileInfo(),
          _buildContentSections(),
          _buildQuickActions(),
          _buildRecentActivity(),
          _buildRecommendations(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppConstants.primaryColor,
                  AppConstants.primaryColor.withOpacity(0.7),
                ],
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: 20,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 90,
                  backgroundColor: AppConstants.primaryColor.withOpacity(0.3),
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: () => _updateProfilePicture(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Welcome to MusicBud',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => _editProfile(),
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white70,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Connect through music and discover new sounds',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          _buildProfileStats(),
        ],
      ),
    );
  }

  Widget _buildProfileStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatColumn('Followers', '1.2K', Icons.people),
        _buildStatColumn('Following', '856', Icons.person_add),
        _buildStatColumn('Tracks', '324', Icons.music_note),
        _buildStatColumn('Playlists', '12', Icons.playlist_play),
      ],
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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

  Widget _buildContentSections() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Recent Activity'),
          _buildActivityCards(),
          const SizedBox(height: 24),
          _buildSectionTitle('Top Recommendations'),
          _buildRecommendationCards(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          TextButton(
            onPressed: () => _viewAll(title.toLowerCase()),
            child: Text(
              'View All',
              style: TextStyle(
                color: AppConstants.primaryColor,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCards() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildActivityCard('Recent Tracks', Icons.music_note, Colors.blue, () => _navigateToMusic()),
          _buildActivityCard('New Buddies', Icons.people, Colors.green, () => _navigateToBuds()),
          _buildActivityCard('Events', Icons.event, Colors.orange, () => _navigateToEvents()),
          _buildActivityCard('Channels', Icons.chat, Colors.purple, () => _navigateToChannels()),
        ],
      ),
    );
  }

  Widget _buildActivityCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCards() {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildRecommendationCard('Top Artists', 'Discover trending artists', Icons.person, Colors.red, () => _navigateToMusic()),
          _buildRecommendationCard('New Releases', 'Latest music releases', Icons.new_releases, Colors.blue, () => _navigateToMusic()),
          _buildRecommendationCard('Genres', 'Explore music genres', Icons.category, Colors.green, () => _navigateToMusic()),
          _buildRecommendationCard('Playlists', 'Curated playlists', Icons.playlist_play, Colors.purple, () => _navigateToMusic()),
        ],
      ),
    );
  }

  Widget _buildRecommendationCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 32),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Quick Actions'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'Connect Services',
                  Icons.connect_without_contact,
                  Colors.blue,
                  () => _navigateToServices(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickActionButton(
                  'Find Buddies',
                  Icons.people,
                  Colors.green,
                  () => _navigateToBuds(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildQuickActionButton(
                  'Create Channel',
                  Icons.add_circle,
                  Colors.orange,
                  () => _navigateToChannels(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildQuickActionButton(
                  'Share Story',
                  Icons.camera_alt,
                  Colors.purple,
                  () => _navigateToStories(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Recent Activity'),
          const SizedBox(height: 16),
          _buildActivityItem('Liked "Bohemian Rhapsody" by Queen', Icons.favorite, Colors.red),
          _buildActivityItem('Followed @musiclover123', Icons.person_add, Colors.blue),
          _buildActivityItem('Joined "Rock Music" channel', Icons.chat, Colors.green),
          _buildActivityItem('Added "Summer Hits" to playlist', Icons.playlist_add, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildActivityItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            '2h ago',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('For You'),
          const SizedBox(height: 16),
          _buildRecommendationItem('Based on your love for Rock music', Icons.recommend, Colors.purple),
          _buildRecommendationItem('Similar to artists you follow', Icons.people, Colors.blue),
          _buildRecommendationItem('Trending in your area', Icons.trending_up, Colors.green),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Action methods
  Future<void> _updateProfilePicture() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null && mounted) {
      context.read<ProfileBloc>().add(ProfileAvatarUpdateRequested(image));
    }
  }

  void _editProfile() {
    _showProfileEditDialog();
  }

  void _showProfileEditDialog() {
    final TextEditingController bioController = TextEditingController();
    final TextEditingController locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: bioController,
              decoration: const InputDecoration(
                labelText: 'Bio',
                hintText: 'Tell us about yourself...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                hintText: 'Where are you located?',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final profileData = <String, dynamic>{};
              if (bioController.text.isNotEmpty) {
                profileData['bio'] = bioController.text;
              }
              if (locationController.text.isNotEmpty) {
                profileData['location'] = locationController.text;
              }

              if (profileData.isNotEmpty) {
                context.read<ProfileBloc>().add(ProfileUpdateRequested(profileData));
              }

              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _viewAll(String category) {
    // Navigate to category-specific page or tab
    switch (category.toLowerCase()) {
      case 'recent activity':
        _navigateToRecentActivity();
        break;
      case 'top recommendations':
        _navigateToTopRecommendations();
        break;
      case 'quick actions':
        _navigateToQuickActions();
        break;
      case 'recent activity':
        _navigateToRecentActivity();
        break;
      case 'for you':
        _navigateToRecommendations();
        break;
      default:
        // Navigate to music tab for music-related categories
        _navigateToMusic();
    }
  }

  void _navigateToRecentActivity() {
    // Navigate to recent activity page or show expanded view
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recent activity expanded view coming soon!')),
    );
  }

  void _navigateToTopRecommendations() {
    // Navigate to top recommendations page
    _navigateToMusic();
  }

  void _navigateToQuickActions() {
    // Navigate to quick actions page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Quick actions page coming soon!')),
    );
  }

  void _navigateToRecommendations() {
    // Navigate to recommendations page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recommendations page coming soon!')),
    );
  }

  void _navigateToMusic() {
    // Navigate to music tab
    if (mounted) {
      final mainScreenState = context.findAncestorStateOfType<_NewMainScreenState>();
      if (mainScreenState != null) {
        mainScreenState.setState(() {
          mainScreenState._selectedIndex = 4; // Music tab index
        });
      }
    }
  }

  void _navigateToBuds() {
    // Navigate to buds tab
    if (mounted) {
      final mainScreenState = context.findAncestorStateOfType<_NewMainScreenState>();
      if (mainScreenState != null) {
        mainScreenState.setState(() {
          mainScreenState._selectedIndex = 5; // Buds tab index
        });
      }
    }
  }

  void _navigateToEvents() {
    // Navigate to events page
    navigateTo('/events');
  }

  void _navigateToChannels() {
    // Navigate to channels page
    navigateTo('/channels');
  }

  void _navigateToStories() {
    // Navigate to stories tab
    if (mounted) {
      final mainScreenState = context.findAncestorStateOfType<_NewMainScreenState>();
      if (mainScreenState != null) {
        mainScreenState.setState(() {
          mainScreenState._selectedIndex = 2; // Stories tab index
        });
      }
    }
  }

  void _navigateToServices() {
    // Navigate to services page
    navigateTo('/services');
  }
}

class SearchTab extends StatelessWidget {
  const SearchTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SearchPage();
  }
}

class StoriesTab extends StatelessWidget {
  const StoriesTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const StoriesPage();
  }
}

class ChatTab extends StatelessWidget {
  const ChatTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Chat functionality coming soon'));
  }
}

class MusicTab extends StatelessWidget {
  const MusicTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Music functionality coming soon'));
  }
}

class BudsTab extends StatelessWidget {
  const BudsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Buds functionality coming soon'));
  }
}

class AnalyticsTab extends StatelessWidget {
  const AnalyticsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Analytics functionality coming soon'));
  }
}