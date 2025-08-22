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
import '../../../blocs/likes/likes_event.dart';
import '../../../blocs/track/track_bloc.dart';
import '../../../blocs/bud/bud_bloc.dart';
import '../../../blocs/bud/bud_category_bloc.dart';
import '../../../blocs/chat/chat_bloc.dart';
import '../../../blocs/chat/chat_event.dart';
import '../../../blocs/spotify_control/spotify_control_bloc.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../../domain/repositories/content_repository.dart';
import '../../../domain/repositories/bud_repository.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/repositories/chat_repository.dart';
import '../../widgets/loading_indicator.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/unified_navigation_scaffold.dart';
import '../../widgets/common/app_bottom_navigation_bar.dart';
import '../../constants/app_constants.dart';
import '../../mixins/page_mixin.dart';
import '../../../injection_container.dart' as di;

// Import the new pages from the main pages directory
import '../home_page.dart';
import '../search_page.dart';
import '../chat_page.dart';
import '../library_page.dart';
import '../discover_page.dart';
import '../profile_page.dart' as MainProfilePage;
import '../event_page.dart' as MainEventPage;
import '../settings_page.dart' as MainSettingsPage;
import '../welcome_page.dart';

// Import auth pages
import '../auth/login_page.dart';
import '../auth/signup_page.dart';
import '../auth/forgot_password_page.dart';
import '../auth/otp_verification_page.dart';
import '../auth/change_password_page.dart';

// Import onboarding pages
import '../onboarding/onboarding_first_name_page.dart';
import '../onboarding/onboarding_birthday_page.dart';
import '../onboarding/onboarding_gender_page.dart';
import '../onboarding/onboarding_interests_page.dart';

// Import social pages
import '../social/match_recommendations_page.dart';
import '../social/watch_party_detail_page.dart';

// Import demo pages
import '../demo/user_profile_demo_page.dart';

// Import the stories page from new_pages directory
import 'stories_page.dart';

// Import new_pages versions with aliases
import 'profile_page.dart' as NewProfilePage;
import 'event_page.dart' as NewEventPage;
import 'settings_page.dart' as NewSettingsPage;

import 'chat_screen.dart';
import 'profile_page.dart';
import 'service_connection_page.dart';
import 'user_management_page.dart';
import 'admin_dashboard_page.dart';
import 'channel_management_page.dart';
import 'settings_page.dart';
import 'event_page.dart';
import 'top_profile.dart';
import 'cards.dart';
import 'dynamic_music_page.dart';
import 'dynamic_buds_page.dart';

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

  // Enhanced navigation items configuration with all newly created pages
  static const List<NavigationItem> _navigationItems = [
    // Main Navigation Pages
    NavigationItem(
      icon: Icons.home_outlined,
      label: 'Home',
      page: HomePage(),
    ),
    NavigationItem(
      icon: Icons.search,
      label: 'Search',
      page: SearchPage(),
    ),
    NavigationItem(
      icon: Icons.people,
      label: 'Discover',
      page: DiscoverPage(),
    ),
    NavigationItem(
      icon: Icons.chat_bubble_outline,
      label: 'Chat',
      page: ChatPage(),
    ),
    NavigationItem(
      icon: Icons.music_note,
      label: 'Library',
      page: LibraryPage(),
    ),
    NavigationItem(
      icon: Icons.person,
      label: 'Profile',
      page: MainProfilePage.ProfilePage(),
    ),
  ];

  // Additional pages for testing - accessible via navigation drawer or buttons
  static const List<NavigationItem> _additionalPages = [
    // Auth Pages
    NavigationItem(
      icon: Icons.login,
      label: 'Login',
      page: LoginPage(),
    ),
    NavigationItem(
      icon: Icons.person_add,
      label: 'Sign Up',
      page: SignupPage(),
    ),
    NavigationItem(
      icon: Icons.lock_reset,
      label: 'Forgot Password',
      page: ForgotPasswordPage(),
    ),
    NavigationItem(
      icon: Icons.verified,
      label: 'OTP Verification',
      page: OtpVerificationPage(),
    ),
    NavigationItem(
      icon: Icons.password,
      label: 'Change Password',
      page: ChangePasswordPage(),
    ),

    // Onboarding Pages
    NavigationItem(
      icon: Icons.badge,
      label: 'First Name',
      page: OnboardingFirstNamePage(),
    ),
    NavigationItem(
      icon: Icons.cake,
      label: 'Birthday',
      page: OnboardingBirthdayPage(),
    ),
    NavigationItem(
      icon: Icons.wc,
      label: 'Gender',
      page: OnboardingGenderPage(),
    ),
    NavigationItem(
      icon: Icons.interests,
      label: 'Interests',
      page: OnboardingInterestsPage(),
    ),

    // Social Pages
    NavigationItem(
      icon: Icons.favorite,
      label: 'Match Recommendations',
      page: MatchRecommendationsPage(),
    ),
    NavigationItem(
      icon: Icons.tv,
      label: 'Watch Party Detail',
      page: WatchPartyDetailPage(),
    ),

    // Demo Pages
    NavigationItem(
      icon: Icons.account_circle,
      label: 'User Profile Demo',
      page: UserProfileDemoPage(),
    ),

    // Other Pages
    NavigationItem(
      icon: Icons.event,
      label: 'Events',
      page: MainEventPage.EventPage(),
    ),
    NavigationItem(
      icon: Icons.settings,
      label: 'Settings',
      page: MainSettingsPage.SettingsPage(),
    ),
    NavigationItem(
      icon: Icons.waving_hand,
      label: 'Welcome',
      page: WelcomePage(),
    ),
    NavigationItem(
      icon: Icons.headphones,
      label: 'Stories',
      page: StoriesPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      },
      builder: (context, authState) {
        if (authState is AuthLoading) {
          return const AppScaffold(
            body: Center(child: LoadingIndicator()),
          );
        }

        if (authState is Authenticated) {
          return _buildAuthenticatedScreen();
        }

        // Initial state - show loading
        return const AppScaffold(
          body: Center(child: LoadingIndicator()),
        );
      },
    );
  }

  Widget _buildAuthenticatedScreen() {
    return Scaffold(
      drawer: _buildNavigationDrawer(),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFE2C54), // Primary red color
        foregroundColor: Colors.white,
        title: const Text(
          'MusicBud',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: MainNavigationScaffold(
        body: _navigationItems[_selectedIndex].page,
        currentIndex: _selectedIndex,
        onNavigationTap: _onNavigationItemTapped,
        navigationItems: _navigationItems,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        backgroundColor: const Color(0xFFFE2C54),
        child: const Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

  Widget _buildNavigationDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFFE2C54), // Primary red color
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 32,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'MusicBud',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  '🍔 HAMBURGER MENU OPENED! 🍔',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'All Test Pages Available Below ↓',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Main Navigation Section
          Container(
            margin: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFE2C54).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFFE2C54),
                width: 2,
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🍔 MAIN NAVIGATION 🍔',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFE2C54),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Tap any item below to navigate',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          ..._navigationItems.map((item) => ListTile(
            leading: Icon(item.icon),
            title: Text(item.label),
            onTap: () {
              Navigator.pop(context);
              int index = _navigationItems.indexOf(item);
              _onNavigationItemTapped(index);
            },
          )),

          const Divider(),

          // Auth Pages Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Auth Pages',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ..._additionalPages.take(5).map((item) => ListTile(
            leading: Icon(item.icon, size: 20),
            title: Text(item.label, style: const TextStyle(fontSize: 14)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => item.page),
              );
            },
          )),

          const Divider(),

          // Onboarding Pages Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Onboarding Pages',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ..._additionalPages.skip(5).take(4).map((item) => ListTile(
            leading: Icon(item.icon, size: 20),
            title: Text(item.label, style: const TextStyle(fontSize: 14)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => item.page),
              );
            },
          )),

          const Divider(),

          // Other Pages Section
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Other Pages',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          ..._additionalPages.skip(9).map((item) => ListTile(
            leading: Icon(item.icon, size: 20),
            title: Text(item.label, style: const TextStyle(fontSize: 14)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => item.page),
              );
            },
          )),
        ],
      ),
    );
  }

  void _onNavigationItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });

      // Load data for the selected tab
      _loadTabData(index);
    }
  }

  void _loadTabData(int index) {
    switch (index) {
      case 0: // Home
        _loadHomeData();
        break;
      case 1: // Search
        // Search data loaded on demand
        break;
      case 2: // Discover
        // Discover/Buds data loaded by the discover page
        break;
      case 3: // Chat
        context.read<ChatBloc>().add(ChatUserListRequested());
        break;
      case 4: // Library/Music
        // Music data loaded by the library page
        break;
      case 5: // Profile
        // Profile data loaded by the profile page
        break;
    }
  }

  void _loadHomeData() {
    // Load home data
    context.read<ProfileBloc>().add(ProfileRequested());
    context.read<LikesBloc>().add(LikesUpdateRequested('general'));
  }
}

// Enhanced Tab implementations with legacy functionality
class HomeTab extends StatefulWidget {
  const HomeTab({Key? key}) : super(key: key);

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with PageMixin {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  void _loadHomeData() {
    setState(() {
      _isLoading = true;
    });

    // Load various data sources for the main screen
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
  }

  void _loadRecentActivity() {
    // Load recent activity from user repository
  }

  void _loadRecommendations() {
    // Load recommendations from content repository
  }

  @override
  Widget build(BuildContext context) {
    return UnifiedNavigationScaffold(
      showAppBar: false, // Custom header
      body: Column(
        children: [
          _buildCustomHeader(),
          Expanded(
            child: _isLoading
                ? const Center(child: LoadingIndicator())
                : _buildHomeContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back!',
                style: AppConstants.headingStyle,
              ),
              const SizedBox(height: 4),
              Text(
                'Discover new music and connect with friends',
                style: AppConstants.captionStyle,
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: () => navigateTo('/notifications'),
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: AppConstants.textColor,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: () => navigateTo(AppConstants.profileRoute),
                icon: const Icon(
                  Icons.person_outline,
                  color: AppConstants.textColor,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildQuickActions(),
          const SizedBox(height: 24),
          _buildRecentActivity(),
          const SizedBox(height: 24),
          _buildRecommendations(),
          const SizedBox(height: 100), // Space for bottom navigation
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppConstants.subheadingStyle,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildQuickActionButton(
                icon: Icons.music_note,
                label: 'Music',
                onTap: () => navigateTo('/music'),
              ),
              _buildQuickActionButton(
                icon: Icons.people,
                label: 'Find Buds',
                onTap: () => navigateTo('/buds'),
              ),
              _buildQuickActionButton(
                icon: Icons.chat_bubble,
                label: 'Chat',
                onTap: () => navigateTo('/chat'),
              ),
              _buildQuickActionButton(
                icon: Icons.settings,
                label: 'Settings',
                onTap: () => navigateTo('/settings'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppConstants.primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppConstants.captionStyle.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: AppConstants.subheadingStyle,
        ),
        const SizedBox(height: 16),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) => Container(
              width: 100,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: AppConstants.surfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.music_note,
                    color: AppConstants.primaryColor,
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track ${index + 1}',
                    style: AppConstants.captionStyle.copyWith(fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended for You',
          style: AppConstants.subheadingStyle,
        ),
        const SizedBox(height: 16),
        Container(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) => Container(
              width: 120,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: AppConstants.surfaceColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor.withOpacity(0.2),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.album,
                          color: AppConstants.primaryColor,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Album ${index + 1}',
                          style: AppConstants.bodyStyle.copyWith(fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Artist Name',
                          style: AppConstants.captionStyle.copyWith(fontSize: 10),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
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
    return const ChatListScreen();
  }
}

class MusicTab extends StatelessWidget {
  const MusicTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DynamicMusicPage();
  }
}

class BudsTab extends StatelessWidget {
  const BudsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const DynamicBudsPage();
  }
}