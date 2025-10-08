import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Navigation components
import 'package:musicbud_flutter/navigation/navigation_constants.dart';

// Screens for verification
import 'package:musicbud_flutter/presentation/screens/home/home_screen.dart';
import 'package:musicbud_flutter/presentation/screens/discover/discover_screen.dart';
import 'package:musicbud_flutter/presentation/screens/library/library_screen.dart';
import 'package:musicbud_flutter/presentation/screens/chat/chat_screen.dart';
import 'package:musicbud_flutter/presentation/screens/profile/profile_screen.dart';
import 'package:musicbud_flutter/presentation/screens/search/search_screen.dart';
import 'package:musicbud_flutter/presentation/screens/buds/buds_screen.dart';
import 'package:musicbud_flutter/presentation/screens/settings/settings_screen.dart';



void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Navigation Integration Tests', () {
    late Widget testApp;

    setUp(() {
      testApp = MaterialApp(
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

    testWidgets('Bottom navigation switches between main screens',
        (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Start with Home screen (initial index 0)
      expect(find.byType(HomeScreen), findsOneWidget);

      // Navigate to Discover (index 1)
      await tester.tap(find.byIcon(Icons.explore));
      await tester.pumpAndSettle();
      expect(find.byType(DiscoverScreen), findsOneWidget);

      // Navigate to Library (index 2)
      await tester.tap(find.byIcon(Icons.library_music));
      await tester.pumpAndSettle();
      expect(find.byType(LibraryScreen), findsOneWidget);

      // Navigate to Chat (index 3)
      await tester.tap(find.byIcon(Icons.chat));
      await tester.pumpAndSettle();
      expect(find.byType(ChatScreen), findsOneWidget);

      // Navigate to Profile (index 4)
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);

      // Navigate back to Home (index 0)
      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Drawer navigation opens and navigates to secondary screens',
        (WidgetTester tester) async {
      // Create a test app with drawer
      final testAppWithDrawer = MaterialApp(
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
      Navigator.pop(tester.element(find.byType(MaterialApp)));
      await tester.pumpAndSettle();

      // Open drawer again
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Navigate to Buds via drawer
      await tester.tap(find.text('Buds'));
      await tester.pumpAndSettle();
      expect(find.byType(BudsScreen), findsOneWidget);

      // Go back to home
      Navigator.pop(tester.element(find.byType(MaterialApp)));
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
      final BuildContext context = tester.element(find.byType(MaterialApp));
      Navigator.pushNamed(context, NavigationConstants.discover);
      await tester.pumpAndSettle();
      expect(find.byType(DiscoverScreen), findsOneWidget);

      // Navigate to Library
      Navigator.pushNamed(context, NavigationConstants.library);
      await tester.pumpAndSettle();
      expect(find.byType(LibraryScreen), findsOneWidget);

      // Press back button (simulate Android back)
      await tester.pageBack();
      await tester.pumpAndSettle();
      // Should go back to Discover
      expect(find.byType(DiscoverScreen), findsOneWidget);

      // Press back again
      await tester.pageBack();
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
      final BuildContext context = tester.element(find.byType(MaterialApp));

      // Navigate to Discover
      Navigator.pushNamed(context, NavigationConstants.discover);
      await tester.pumpAndSettle();
      expect(find.byType(DiscoverScreen), findsOneWidget);

      // Navigate to Library
      Navigator.pushNamed(context, NavigationConstants.library);
      await tester.pumpAndSettle();
      expect(find.byType(LibraryScreen), findsOneWidget);

      // Navigate to Profile
      Navigator.pushNamed(context, NavigationConstants.profile);
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('Deep linking with initial routes',
        (WidgetTester tester) async {
      // Test app starting with different initial routes

      // Start with Discover as initial route
      final testAppDiscover = MaterialApp(
        initialRoute: NavigationConstants.discover,
        routes: {
          NavigationConstants.home: (context) => const HomeScreen(),
          NavigationConstants.discover: (context) => const DiscoverScreen(),
          NavigationConstants.library: (context) => const LibraryScreen(),
          NavigationConstants.chat: (context) => const ChatScreen(),
          NavigationConstants.profile: (context) => const ProfileScreen(),
        },
      );

      await tester.pumpWidget(testAppDiscover);
      await tester.pumpAndSettle();

      // Should start on Discover screen
      expect(find.byType(DiscoverScreen), findsOneWidget);

      // Test starting with Profile
      final testAppProfile = MaterialApp(
        initialRoute: NavigationConstants.profile,
        routes: {
          NavigationConstants.home: (context) => const HomeScreen(),
          NavigationConstants.discover: (context) => const DiscoverScreen(),
          NavigationConstants.library: (context) => const LibraryScreen(),
          NavigationConstants.chat: (context) => const ChatScreen(),
          NavigationConstants.profile: (context) => const ProfileScreen(),
        },
      );

      await tester.pumpWidget(testAppProfile);
      await tester.pumpAndSettle();

      // Should start on Profile screen
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('Error handling for invalid routes',
        (WidgetTester tester) async {
      final testAppWithError = MaterialApp(
        initialRoute: '/invalid-route',
        routes: {
          NavigationConstants.home: (context) => const HomeScreen(),
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

      // Should show error screen for unknown route
      expect(find.text('Unknown route: /invalid-route'), findsOneWidget);
    });

    testWidgets('Navigation state persistence during screen transitions',
        (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Navigate through multiple screens
      await tester.tap(find.byIcon(Icons.explore));
      await tester.pumpAndSettle();
      expect(find.byType(DiscoverScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.library_music));
      await tester.pumpAndSettle();
      expect(find.byType(LibraryScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chat));
      await tester.pumpAndSettle();
      expect(find.byType(ChatScreen), findsOneWidget);

      // Go back to Library
      await tester.tap(find.byIcon(Icons.library_music));
      await tester.pumpAndSettle();
      expect(find.byType(LibraryScreen), findsOneWidget);

      // Verify we can still navigate to other screens
      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);
    });

    testWidgets('Navigation maintains state during rapid transitions',
        (WidgetTester tester) async {
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Rapid navigation between screens
      await tester.tap(find.byIcon(Icons.explore));
      await tester.pumpAndSettle();
      expect(find.byType(DiscoverScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.library_music));
      await tester.pumpAndSettle();
      expect(find.byType(LibraryScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chat));
      await tester.pumpAndSettle();
      expect(find.byType(ChatScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.person));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);

      // Rapid back navigation
      await tester.tap(find.byIcon(Icons.library_music));
      await tester.pumpAndSettle();
      expect(find.byType(LibraryScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.home));
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}