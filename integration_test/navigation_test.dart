import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Navigation components
import 'package:musicbud_flutter/navigation/navigation_constants.dart';

// Design System
import 'package:musicbud_flutter/core/theme/design_system.dart';

// BLoCs
import 'package:musicbud_flutter/blocs/user_profile/user_profile_bloc.dart';
import 'package:musicbud_flutter/presentation/blocs/search/search_bloc.dart';

// Repositories
import 'package:musicbud_flutter/domain/repositories/user_profile_repository.dart';
import 'package:musicbud_flutter/domain/repositories/search_repository.dart';

// Core
import 'package:dartz/dartz.dart';
import 'package:musicbud_flutter/core/error/failures.dart';
import 'package:musicbud_flutter/models/user_profile.dart';
import 'package:musicbud_flutter/models/search.dart';

// Placeholder screens for navigation testing
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Home Screen')));
  }
}

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Discover Screen')));
  }
}

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Library Screen')));
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Chat Screen')));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Profile Screen')));
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Search Screen')));
  }
}

class BudsScreen extends StatelessWidget {
  const BudsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Buds Screen')));
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Settings Screen')));
  }
}

// Dummy implementations
class DummyUserProfileRepository implements UserProfileRepository {
  @override
  Future<UserProfile> getUserProfile(String userId) async => _dummyUserProfile();

  @override
  Future<UserProfile> getMyProfile({String? service, String? token}) async => _dummyUserProfile();

  @override
  Future<UserProfile> updateProfile(UserProfileUpdateRequest updateRequest) async => _dummyUserProfile();

  @override
  Future<void> updateLikes(Map<String, dynamic> likesData) async {}

  @override
  Future<List<dynamic>> getUserLikedContent(String contentType, String userId) async => [];

  @override
  Future<List<dynamic>> getMyLikedContent(String contentType) async => [];

  @override
  Future<List<dynamic>> getUserTopContent(String contentType, String userId) async => [];

  @override
  Future<List<dynamic>> getMyTopContent(String contentType) async => [];

  @override
  Future<List<dynamic>> getUserPlayedTracks(String userId) async => [];

  @override
  Future<List<dynamic>> getMyPlayedTracks() async => [];

  UserProfile _dummyUserProfile() => const UserProfile(
    id: 'dummy_id',
    username: 'dummy_user',
    email: 'dummy@example.com',
    avatarUrl: null,
    bio: 'Dummy bio',
    displayName: 'Dummy User',
    location: 'Dummy Location',
    followersCount: 0,
    followingCount: 0,
    isActive: true,
    isAuthenticated: true,
    isAdmin: false,
  );
}

class DummySearchRepository implements SearchRepository {
  @override
  Future<Either<Failure, SearchResults>> search({required String query, List<String>? types, Map<String, dynamic>? filters, int? page, int? pageSize}) async => Right(_dummySearchResults());

  @override
  Future<Either<Failure, List<String>>> getSuggestions({required String query, int? limit}) async => const Right([]);

  @override
  Future<Either<Failure, List<String>>> getRecentSearches({int? limit}) async => const Right([]);

  @override
  Future<Either<Failure, void>> saveRecentSearch(String query) async => const Right(null);

  @override
  Future<Either<Failure, void>> clearRecentSearches() async => const Right(null);

  @override
  Future<Either<Failure, List<String>>> getTrendingSearches({int? limit}) async => const Right([]);

  SearchResults _dummySearchResults() => SearchResults.empty();
}



void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigation Integration Tests', () {
    late Widget testApp;

    setUp(() {
      testApp = MaterialApp(
        theme: DesignSystem.darkTheme,
        initialRoute: NavigationConstants.home,
        routes: {
          NavigationConstants.home: (context) => const HomeScreen(),
          NavigationConstants.discover: (context) => const DiscoverScreen(),
          NavigationConstants.library: (context) => const LibraryScreen(),
          NavigationConstants.chat: (context) => const ChatScreen(),
          NavigationConstants.profile: (context) => const ProfileScreen(),
          NavigationConstants.search: (context) => const SearchScreen(),
          NavigationConstants.buds: (context) => const BudsScreen(),
          NavigationConstants.settings: (context) => const SettingsScreen(),
        },
      );
    });

    testWidgets('Named navigation switches between main screens',
        (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Start with Home screen
      expect(find.byType(HomeScreen), findsOneWidget);

      // Navigate to Discover
      final context = tester.element(find.byType(HomeScreen));
      Navigator.pushNamed(context, NavigationConstants.discover);
      await tester.pumpAndSettle();
      expect(find.byType(DiscoverScreen), findsOneWidget);

      // Navigate to Library
      Navigator.pushNamed(context, NavigationConstants.library);
      await tester.pumpAndSettle();
      expect(find.byType(LibraryScreen), findsOneWidget);

      // Navigate to Chat
      final chatContext = tester.element(find.byType(LibraryScreen));
      Navigator.pushNamed(chatContext, NavigationConstants.chat);
      await tester.pumpAndSettle();
      expect(find.byType(ChatScreen), findsOneWidget);

      // Navigate to Profile
      final profileContext = tester.element(find.byType(ChatScreen));
      Navigator.pushNamed(profileContext, NavigationConstants.profile);
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);

      // Navigate back to Home
      Navigator.popUntil(profileContext, ModalRoute.withName(NavigationConstants.home));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Drawer navigation opens and navigates to secondary screens',
        (WidgetTester tester) async {
      // Create a test app with drawer
      final testAppWithDrawer = MaterialApp(
        theme: DesignSystem.darkTheme,
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Test App'),
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(color: Colors.blue),
                  child: Text('Test Drawer'),
                ),
                ListTile(
                  leading: const Icon(Icons.search),
                  title: const Text('Search'),
                  onTap: () {
                    Navigator.pop(tester.element(find.byType(Scaffold)));
                    Navigator.pushNamed(
                      tester.element(find.byType(Scaffold)),
                      NavigationConstants.search,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.people),
                  title: const Text('Buds'),
                  onTap: () {
                    Navigator.pop(tester.element(find.byType(Scaffold)));
                    Navigator.pushNamed(
                      tester.element(find.byType(Scaffold)),
                      NavigationConstants.buds,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(tester.element(find.byType(Scaffold)));
                    Navigator.pushNamed(
                      tester.element(find.byType(Scaffold)),
                      NavigationConstants.settings,
                    );
                  },
                ),
              ],
            ),
          ),
          body: const Center(child: Text('Home Screen')),
        ),
        routes: {
          NavigationConstants.search: (context) => const SearchScreen(),
          NavigationConstants.buds: (context) => const BudsScreen(),
          NavigationConstants.settings: (context) => const SettingsScreen(),
        },
      );

      await tester.pumpWidget(testAppWithDrawer);
      await tester.pumpAndSettle();

      // Open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Verify drawer is open
      expect(find.text('Test Drawer'), findsOneWidget);

      // Navigate to Search via drawer
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      expect(find.byType(SearchScreen), findsOneWidget);

      // Go back to home
      Navigator.pop(tester.element(find.byType(Scaffold)));
      await tester.pumpAndSettle();

      // Open drawer again
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Navigate to Buds via drawer
      await tester.tap(find.text('Buds'));
      await tester.pumpAndSettle();
      expect(find.byType(BudsScreen), findsOneWidget);

      // Go back to home
      Navigator.pop(tester.element(find.byType(Scaffold)));
      await tester.pumpAndSettle();

      // Open drawer again
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Navigate to Settings via drawer
      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();
      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('Back navigation works correctly',
        (WidgetTester tester) async {
      // For this test, use named routes instead of bottom navigation
      // since MainNavigationScaffold uses IndexedStack which doesn't maintain history
      final testAppWithRoutes = MaterialApp(
        theme: DesignSystem.darkTheme,
        initialRoute: NavigationConstants.home,
        routes: {
          NavigationConstants.home: (context) => const HomeScreen(),
          NavigationConstants.discover: (context) => const DiscoverScreen(),
          NavigationConstants.library: (context) => const LibraryScreen(),
        },
      );

      await tester.pumpWidget(testAppWithRoutes);
      await tester.pumpAndSettle();

      // Start at Home
      expect(find.byType(HomeScreen), findsOneWidget);

      // Navigate to Discover
      final BuildContext context = tester.element(find.byType(HomeScreen));
      Navigator.pushNamed(context, NavigationConstants.discover);
      await tester.pumpAndSettle();
      expect(find.byType(DiscoverScreen), findsOneWidget);

      // Navigate to Library
      final libraryContext = tester.element(find.byType(DiscoverScreen));
      Navigator.pushNamed(libraryContext, NavigationConstants.library);
      await tester.pumpAndSettle();
      expect(find.byType(LibraryScreen), findsOneWidget);

      // Press back button (simulate Android back using Navigator.pop)
      final currentContext = tester.element(find.byType(LibraryScreen));
      Navigator.pop(currentContext);
      await tester.pumpAndSettle();
      // Should go back to Discover
      expect(find.byType(DiscoverScreen), findsOneWidget);

      // Press back again
      final discoverContext = tester.element(find.byType(DiscoverScreen));
      Navigator.pop(discoverContext);
      await tester.pumpAndSettle();
      // Should go back to Home
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Route handling with named navigation',
        (WidgetTester tester) async {
      // Use a MaterialApp with routes for this test
      final testAppWithRoutes = MaterialApp(
        initialRoute: NavigationConstants.home,
        routes: {
          NavigationConstants.home: (context) => const HomeScreen(),
          NavigationConstants.discover: (context) => const DiscoverScreen(),
          NavigationConstants.library: (context) => const LibraryScreen(),
          NavigationConstants.chat: (context) => const ChatScreen(),
          NavigationConstants.profile: (context) => const ProfileScreen(),
        },
      );

      await tester.pumpWidget(testAppWithRoutes);
      await tester.pumpAndSettle();

      // Navigate using named routes
      final BuildContext context = tester.element(find.byType(HomeScreen));

      // Navigate to Discover
      Navigator.pushNamed(context, NavigationConstants.discover);
      await tester.pumpAndSettle();
      expect(find.byType(DiscoverScreen), findsOneWidget);

      // Navigate to Library
      final libraryContext = tester.element(find.byType(DiscoverScreen));
      Navigator.pushNamed(libraryContext, NavigationConstants.library);
      await tester.pumpAndSettle();
      expect(find.byType(LibraryScreen), findsOneWidget);

      // Navigate to Profile
      final profileContext = tester.element(find.byType(LibraryScreen));
      Navigator.pushNamed(profileContext, NavigationConstants.profile);
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('Deep linking with initial routes',
        (WidgetTester tester) async {
      // Test app starting with different initial routes

      // Start with Discover as initial route
      final testAppDiscover = MaterialApp(
        theme: DesignSystem.darkTheme,
        home: const DiscoverScreen(),
      );

      await tester.pumpWidget(testAppDiscover);
      await tester.pumpAndSettle();

      // Should start on Discover screen
      expect(find.byType(DiscoverScreen), findsOneWidget);

      // Test starting with Profile
      final testAppProfile = MaterialApp(
        theme: DesignSystem.darkTheme,
        home: const ProfileScreen(),
      );

      await tester.pumpWidget(testAppProfile);
      await tester.pumpAndSettle();

      // Should start on Profile screen
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('Error handling for invalid routes',
        (WidgetTester tester) async {
      final testAppWithError = MaterialApp(
        theme: DesignSystem.darkTheme,
        home: const HomeScreen(),
        routes: {
          NavigationConstants.discover: (context) => const DiscoverScreen(),
          // Intentionally missing some routes to test error handling
        },
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text('Unknown route: ${settings.name}'),
            ),
          ),
        ),
      );

      await tester.pumpWidget(testAppWithError);
      await tester.pumpAndSettle();

      // Start with home screen
      expect(find.byType(HomeScreen), findsOneWidget);

      // Try to navigate to invalid route
      final context = tester.element(find.byType(HomeScreen));
      Navigator.pushNamed(context, '/invalid-route');
      await tester.pumpAndSettle();

      // Should show error screen for unknown route
      expect(find.text('Unknown route: /invalid-route'), findsOneWidget);
    });

    testWidgets('Navigation state persistence during screen transitions',
        (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(HomeScreen));

      // Navigate through multiple screens
      Navigator.pushNamed(context, NavigationConstants.discover);
      await tester.pumpAndSettle();
      expect(find.byType(DiscoverScreen), findsOneWidget);

      final discoverContext = tester.element(find.byType(DiscoverScreen));
      Navigator.pushNamed(discoverContext, NavigationConstants.library);
      await tester.pumpAndSettle();
      expect(find.byType(LibraryScreen), findsOneWidget);

      final libraryContext = tester.element(find.byType(LibraryScreen));
      Navigator.pushNamed(libraryContext, NavigationConstants.chat);
      await tester.pumpAndSettle();
      expect(find.byType(ChatScreen), findsOneWidget);

      // Go back to Library
      Navigator.pop(libraryContext);
      await tester.pumpAndSettle();
      expect(find.byType(LibraryScreen), findsOneWidget);

      // Verify we can still navigate to other screens
      Navigator.pushNamed(tester.element(find.byType(LibraryScreen)), NavigationConstants.profile);
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('Navigation maintains state during rapid transitions',
        (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      final context = tester.element(find.byType(HomeScreen));

      // Rapid navigation between screens
      Navigator.pushNamed(context, NavigationConstants.discover);
      await tester.pumpAndSettle();
      expect(find.byType(DiscoverScreen), findsOneWidget);

      var currentContext = tester.element(find.byType(DiscoverScreen));
      Navigator.pushNamed(currentContext, NavigationConstants.library);
      await tester.pumpAndSettle();
      expect(find.byType(LibraryScreen), findsOneWidget);

      currentContext = tester.element(find.byType(LibraryScreen));
      Navigator.pushNamed(currentContext, NavigationConstants.chat);
      await tester.pumpAndSettle();
      expect(find.byType(ChatScreen), findsOneWidget);

      currentContext = tester.element(find.byType(ChatScreen));
      Navigator.pushNamed(currentContext, NavigationConstants.profile);
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);

      // Rapid back navigation
      Navigator.pop(currentContext);
      await tester.pumpAndSettle();
      expect(find.byType(ChatScreen), findsOneWidget);

      currentContext = tester.element(find.byType(ChatScreen));
      Navigator.pop(currentContext);
      await tester.pumpAndSettle();
      expect(find.byType(LibraryScreen), findsOneWidget);

      currentContext = tester.element(find.byType(LibraryScreen));
      Navigator.pop(currentContext);
      await tester.pumpAndSettle();
      expect(find.byType(DiscoverScreen), findsOneWidget);

      currentContext = tester.element(find.byType(DiscoverScreen));
      Navigator.pop(currentContext);
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}