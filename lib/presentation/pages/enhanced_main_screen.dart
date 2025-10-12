import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/main/main_screen_bloc.dart';
import '../../blocs/main/main_screen_event.dart';
import '../../blocs/main/main_screen_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../core/theme/design_system.dart';
import '../../core/components/musicbud_components.dart';
import '../screens/auth/login_screen.dart';
import '../screens/home/enhanced_home_screen.dart';
import '../screens/profile/enhanced_profile_screen.dart';
import '../screens/buds/dynamic_buds_screen.dart';
import '../screens/chat/enhanced_chat_screen.dart';
import 'enhanced_search_page.dart';
import '../../screens/debug/api_test_screen.dart';

/// Enhanced Main Screen using new MusicBud Components
/// Replaces old MainScreen with enhanced versions of all screens
class EnhancedMainScreen extends StatefulWidget {
  const EnhancedMainScreen({Key? key}) : super(key: key);

  @override
  State<EnhancedMainScreen> createState() => _EnhancedMainScreenState();
}

class _EnhancedMainScreenState extends State<EnhancedMainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<Widget> _pages = const [
    EnhancedHomeScreen(),      // Index 0: Home
    EnhancedSearchPage(),      // Index 1: Search
    DynamicBudsScreen(),       // Index 2: Buds
    EnhancedChatScreen(),      // Index 3: Chat
    EnhancedProfileScreen(),   // Index 4: Profile
  ];

  final List<String> _pageTitles = const [
    'Home',
    'Search',
    'Buds', 
    'Chat',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    // Initialize main screen
    context.read<MainScreenBloc>().add(MainScreenInitialized());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is Unauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: BlocConsumer<MainScreenBloc, MainScreenState>(
        listener: (context, state) {
          if (state is MainScreenFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: DesignSystem.errorRed,
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Retry',
                  textColor: DesignSystem.onPrimary,
                  onPressed: () {
                    context.read<MainScreenBloc>().add(MainScreenRefreshRequested());
                  },
                ),
              ),
            );
          } else if (state is MainScreenUnauthenticated) {
            context.read<AuthBloc>().add(LogoutRequested());
          }
        },
        builder: (context, state) {
          if (state is MainScreenLoading) {
            return Scaffold(
              backgroundColor: DesignSystem.background,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: DesignSystem.pinkAccent,
                    ),
                    const SizedBox(height: DesignSystem.spacingLG),
                    Text(
                      'Loading MusicBud...',
                      style: DesignSystem.bodyLarge.copyWith(
                        color: DesignSystem.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: DesignSystem.background,
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // Disable swipe for better UX
              children: _pages,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            bottomNavigationBar: MusicBudBottomNav(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _pageController.jumpToPage(index);
              },
            ),
            floatingActionButton: _buildFloatingActionButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        },
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    // In debug mode, show API test button on home page
    if (kDebugMode && _currentIndex == 0) {
      return FloatingActionButton(
        heroTag: "debug_api_fab",
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ApiTestScreen(),
            ),
          );
        },
        backgroundColor: DesignSystem.accentPurple,
        tooltip: 'API Testing',
        child: const Icon(Icons.bug_report, color: DesignSystem.onPrimary),
      );
    }

    // Contextual FABs based on current page
    switch (_currentIndex) {
      case 0: // Home page
        return FloatingActionButton(
          heroTag: "home_discover_fab",
          onPressed: () {
            // Quick action to discover new content
            _pageController.jumpToPage(1); // Navigate to search
          },
          backgroundColor: DesignSystem.pinkAccent,
          tooltip: 'Discover',
          child: const Icon(Icons.explore, color: DesignSystem.onPrimary),
        );
      
      case 1: // Search page
        return null; // Search page has its own search bar
      
      case 2: // Buds page
        return FloatingActionButton(
          heroTag: "buds_refresh_fab",
          onPressed: () {
            context.read<MainScreenBloc>().add(MainScreenRefreshRequested());
          },
          backgroundColor: DesignSystem.pinkAccent,
          tooltip: 'Refresh Matches',
          child: const Icon(Icons.refresh, color: DesignSystem.onPrimary),
        );
      
      case 3: // Chat page
        return FloatingActionButton(
          heroTag: "chat_new_fab",
          onPressed: () {
            // New chat feature
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Start new conversation'),
                backgroundColor: DesignSystem.surfaceContainer,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          backgroundColor: DesignSystem.pinkAccent,
          tooltip: 'New Chat',
          child: const Icon(Icons.edit, color: DesignSystem.onPrimary),
        );
      
      case 4: // Profile page
        return FloatingActionButton(
          heroTag: "profile_edit_fab",
          onPressed: () {
            // Navigate to edit profile
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Edit Profile'),
                backgroundColor: DesignSystem.surfaceContainer,
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          backgroundColor: DesignSystem.pinkAccent,
          tooltip: 'Edit Profile',
          child: const Icon(Icons.edit, color: DesignSystem.onPrimary),
        );
      
      default:
        return null;
    }
  }
}
