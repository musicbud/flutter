import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/main/main_screen_bloc.dart';
import '../../blocs/main/main_screen_event.dart';
import '../../blocs/main/main_screen_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../core/design_system/design_system.dart';
// MIGRATED: import '../widgets/common/loading_widget.dart';
import '../components/bottom_navigation_bar.dart';
import '../screens/auth/login_screen.dart';
import 'home_page.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/buds/buds_screen.dart';
import '../screens/chat/chat_screen.dart';
import 'enhanced_search_page.dart';
import '../../screens/debug/api_test_screen.dart';
import '../widgets/enhanced/enhanced_widgets.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  final List<Widget> _pages = [
    const HomePage(),
    const EnhancedSearchPage(),
    const BudsScreen(),
    const ChatScreen(),
    const ProfileScreen(),
  ];

  final List<NavigationDestination> _destinations = const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(Icons.people_outlined),
      selectedIcon: Icon(Icons.people),
      label: 'Buds',
    ),
    NavigationDestination(
      icon: Icon(Icons.chat_outlined),
      selectedIcon: Icon(Icons.chat),
      label: 'Chat',
    ),
    NavigationDestination(
      icon: Icon(Icons.link_outlined),
      selectedIcon: Icon(Icons.link),
      label: 'Connect',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outlined),
      selectedIcon: Icon(Icons.person),
      label: 'Profile',
    ),
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
                duration: const Duration(seconds: 3),
                action: SnackBarAction(
                  label: 'Retry',
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
            return const Scaffold(
              body: Center(
                child: LoadingWidget(
                  message: 'Loading MusicBud...',
                ),
              ),
            );
          }

          return Scaffold(
            backgroundColor: MusicBudColors.backgroundPrimary,
            body: PageView(
              controller: _pageController,
              children: _pages,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            bottomNavigationBar: MusicBudBottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
            floatingActionButton: _buildFloatingActionButton(),
            floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          );
        },
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    // In debug mode, always show API test button on home page
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
        backgroundColor: Colors.deepPurple,
        tooltip: 'API Testing',
        child: const Icon(Icons.bug_report),
      );
    }
    
    switch (_currentIndex) {
      case 2: // Buds page
        return FloatingActionButton(
          heroTag: "buds_refresh_fab",
          onPressed: () {
            context.read<MainScreenBloc>().add(MainScreenRefreshRequested());
          },
          backgroundColor: MusicBudColors.primaryRed,
          tooltip: 'Refresh Buds',
          child: const Icon(Icons.refresh),
        );
      case 3: // Chat page
        return FloatingActionButton(
          heroTag: "chat_new_fab",
          onPressed: () {
            // Navigate to create new chat or channel
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Create new chat feature coming soon!')),
            );
          },
          backgroundColor: MusicBudColors.primaryRed,
          tooltip: 'New Chat',
          child: const Icon(Icons.add),
        );
      default:
        return null;
    }
  }
}