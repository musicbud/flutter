import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../core/theme/design_system.dart';
import 'home/dynamic_home_screen.dart';
import 'discover/dynamic_discover_screen.dart';
import 'discover/guest_discover_screen.dart';
import 'buds/dynamic_buds_screen.dart';
import 'search/dynamic_search_screen.dart';
import 'auth/login_screen.dart';
import 'profile/dynamic_profile_screen.dart';

/// Main screen with bottom navigation that supports both guest and authenticated users
class MainScreenWithGuest extends StatefulWidget {
  const MainScreenWithGuest({super.key});

  @override
  State<MainScreenWithGuest> createState() => _MainScreenWithGuestState();
}

class _MainScreenWithGuestState extends State<MainScreenWithGuest> {
  int _currentIndex = 0;
  bool _isAuthenticated = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await _authService.initialize();
    final isAuth = await _authService.isAuthenticated();
    if (mounted) {
      setState(() {
        _isAuthenticated = isAuth;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          const DynamicHomeScreen(), // Public home (works for guests)
          _isAuthenticated 
            ? const DynamicDiscoverScreen() 
            : const GuestDiscoverScreen(), // Guest-friendly discover
          const DynamicBudsScreen(), // Public buds preview (works for guests)
          const DynamicSearchScreen(), // Public search (works for guests)
          _isAuthenticated 
            ? const DynamicProfileScreen() 
            : const GuestProfileScreen(), // Profile or login prompt
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      selectedItemColor: DesignSystem.primary,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.explore),
          label: 'Discover',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Buds',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}

/// Guest profile screen that prompts login or shows limited features
class GuestProfileScreen extends StatelessWidget {
  const GuestProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: DesignSystem.surface,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.person_outline,
                size: 80,
                color: DesignSystem.primary.withOpacity(0.6),
              ),
              const SizedBox(height: 24),
              Text(
                'Join MusicBud!',
                style: DesignSystem.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Sign in to access your profile, save favorites, chat with buds, and unlock all features.',
                textAlign: TextAlign.center,
                style: DesignSystem.bodyLarge.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: DesignSystem.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Sign In',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: DesignSystem.primary,
                  side: const BorderSide(color: DesignSystem.primary),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildGuestFeatures(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestFeatures(BuildContext context) {
    return Column(
      children: [
        Text(
          'As a guest, you can:',
          style: DesignSystem.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 16),
        _buildFeatureItem(Icons.explore, 'Browse music and discover new content'),
        _buildFeatureItem(Icons.search, 'Search for artists, tracks, and albums'),
        _buildFeatureItem(Icons.people_outline, 'Preview bud matching (limited)'),
        const SizedBox(height: 16),
        Text(
          'Sign in to unlock:',
          style: DesignSystem.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: DesignSystem.primary,
          ),
        ),
        const SizedBox(height: 8),
        _buildFeatureItem(Icons.favorite, 'Save favorites and create playlists'),
        _buildFeatureItem(Icons.chat, 'Chat with music buds'),
        _buildFeatureItem(Icons.library_music, 'Access your music library'),
        _buildFeatureItem(Icons.settings, 'Personalized settings'),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: DesignSystem.bodySmall.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}