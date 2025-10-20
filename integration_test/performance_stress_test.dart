import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:musicbud_flutter/main.dart' as app;

/// Performance & Stress Testing E2E Tests
///
/// Tests app performance and stability:
/// - Rapid navigation between screens
/// - Multiple simultaneous operations
/// - Large data set handling
/// - Memory management
/// - Long session behavior
/// - Rapid user interactions
/// - Animation performance
/// - Background task handling
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Performance & Stress Testing E2E Tests', () {
    testWidgets('should handle rapid navigation between tabs', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Rapidly switch between tabs
      final tabNames = ['Discover', 'Library', 'Buddies', 'Profile'];
      
      for (int i = 0; i < 10; i++) {
        for (final tabName in tabNames) {
          final tab = find.text(tabName);
          if (tab.evaluate().isNotEmpty) {
            await tester.tap(tab);
            await tester.pump(const Duration(milliseconds: 100));
          }
        }
      }

      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle rapid scrolling', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to a scrollable list
      final discoverTab = find.text('Discover');
      if (discoverTab.evaluate().isNotEmpty) {
        await tester.tap(discoverTab);
        await tester.pumpAndSettle();
      }

      // Perform rapid scrolling
      final scrollable = find.byType(Scrollable);
      if (scrollable.evaluate().isNotEmpty) {
        for (int i = 0; i < 20; i++) {
          await tester.drag(scrollable.first, const Offset(0, -500));
          await tester.pump(const Duration(milliseconds: 50));
        }

        // Scroll back up
        for (int i = 0; i < 20; i++) {
          await tester.drag(scrollable.first, const Offset(0, 500));
          await tester.pump(const Duration(milliseconds: 50));
        }
      }

      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle multiple quick taps', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Find a tappable element
      final discoverTab = find.text('Discover');
      if (discoverTab.evaluate().isNotEmpty) {
        // Rapidly tap the same element
        for (int i = 0; i < 10; i++) {
          await tester.tap(discoverTab);
          await tester.pump(const Duration(milliseconds: 50));
        }
      }

      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle opening and closing multiple dialogs', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to settings
      final profileTab = find.text('Profile');
      if (profileTab.evaluate().isNotEmpty) {
        await tester.tap(profileTab);
        await tester.pumpAndSettle();
      }

      final settingsIcon = find.byIcon(Icons.settings);
      if (settingsIcon.evaluate().isNotEmpty) {
        // Open and close settings multiple times
        for (int i = 0; i < 5; i++) {
          await tester.tap(settingsIcon.first);
          await tester.pumpAndSettle();

          // Try to go back
          final backButton = find.byIcon(Icons.arrow_back);
          if (backButton.evaluate().isNotEmpty) {
            await tester.tap(backButton.first);
            await tester.pumpAndSettle();
          }
        }
      }

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle rapid search queries', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to search
      final searchIcon = find.byIcon(Icons.search);
      if (searchIcon.evaluate().isNotEmpty) {
        await tester.tap(searchIcon.first);
        await tester.pumpAndSettle();

        // Enter multiple search queries rapidly
        final searchField = find.byType(TextField);
        if (searchField.evaluate().isNotEmpty) {
          final queries = ['rock', 'pop', 'jazz', 'classical', 'electronic'];
          
          for (final query in queries) {
            await tester.enterText(searchField.first, query);
            await tester.pump(const Duration(milliseconds: 200));
          }
        }
      }

      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle loading large playlists', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to library
      final libraryTab = find.text('Library');
      if (libraryTab.evaluate().isNotEmpty) {
        await tester.tap(libraryTab);
        await tester.pumpAndSettle();

        // Look for playlists
        final playlistText = find.textContaining('Playlist', findRichText: true);
        if (playlistText.evaluate().isNotEmpty) {
          await tester.tap(playlistText.first);
          await tester.pumpAndSettle();

          // Scroll through large list
          final scrollable = find.byType(Scrollable);
          if (scrollable.evaluate().isNotEmpty) {
            for (int i = 0; i < 10; i++) {
              await tester.drag(scrollable.first, const Offset(0, -300));
              await tester.pump(const Duration(milliseconds: 100));
            }
          }
        }
      }

      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle long session simulation', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Simulate various user actions over time
      final tabNames = ['Discover', 'Library', 'Buddies', 'Profile'];
      
      for (int session = 0; session < 3; session++) {
        // Navigate through tabs
        for (final tabName in tabNames) {
          final tab = find.text(tabName);
          if (tab.evaluate().isNotEmpty) {
            await tester.tap(tab);
            await tester.pumpAndSettle();

            // Perform some scrolling
            final scrollable = find.byType(Scrollable);
            if (scrollable.evaluate().isNotEmpty) {
              await tester.drag(scrollable.first, const Offset(0, -200));
              await tester.pumpAndSettle();
            }
          }
        }
      }

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle rapid playlist operations', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to library
      final libraryTab = find.text('Library');
      if (libraryTab.evaluate().isNotEmpty) {
        await tester.tap(libraryTab);
        await tester.pumpAndSettle();

        // Rapidly tap favorite/like buttons if available
        final favoriteButton = find.byIcon(Icons.favorite_border);
        if (favoriteButton.evaluate().isNotEmpty) {
          for (int i = 0; i < 5; i++) {
            await tester.tap(favoriteButton.first);
            await tester.pump(const Duration(milliseconds: 100));
          }
        }
      }

      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle animation stress', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Trigger animations by rapid navigation
      final tabNames = ['Discover', 'Library', 'Buddies', 'Profile'];
      
      for (int i = 0; i < 15; i++) {
        final randomTab = tabNames[i % tabNames.length];
        final tab = find.text(randomTab);
        if (tab.evaluate().isNotEmpty) {
          await tester.tap(tab);
          await tester.pump(const Duration(milliseconds: 50));
        }
      }

      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle multiple back navigation', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate deep into the app
      final profileTab = find.text('Profile');
      if (profileTab.evaluate().isNotEmpty) {
        await tester.tap(profileTab);
        await tester.pumpAndSettle();
      }

      final settingsIcon = find.byIcon(Icons.settings);
      if (settingsIcon.evaluate().isNotEmpty) {
        await tester.tap(settingsIcon.first);
        await tester.pumpAndSettle();

        // Rapidly navigate back
        for (int i = 0; i < 5; i++) {
          final backButton = find.byIcon(Icons.arrow_back);
          if (backButton.evaluate().isNotEmpty) {
            await tester.tap(backButton.first);
            await tester.pump(const Duration(milliseconds: 100));
          }
        }
      }

      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle concurrent data loading', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to different sections that load data
      final tabNames = ['Discover', 'Library', 'Buddies'];
      
      for (final tabName in tabNames) {
        final tab = find.text(tabName);
        if (tab.evaluate().isNotEmpty) {
          await tester.tap(tab);
          await tester.pump(const Duration(milliseconds: 200));
          // Don't wait for settle, move to next tab quickly
        }
      }

      await tester.pumpAndSettle();
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should maintain performance during continuous use', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Simulate continuous app usage
      for (int cycle = 0; cycle < 5; cycle++) {
        // Navigate to search
        final searchIcon = find.byIcon(Icons.search);
        if (searchIcon.evaluate().isNotEmpty) {
          await tester.tap(searchIcon.first);
          await tester.pumpAndSettle();

          // Perform search
          final searchField = find.byType(TextField);
          if (searchField.evaluate().isNotEmpty) {
            await tester.enterText(searchField.first, 'test $cycle');
            await tester.pumpAndSettle();
          }

          // Go back
          final backButton = find.byIcon(Icons.arrow_back);
          if (backButton.evaluate().isNotEmpty) {
            await tester.tap(backButton.first);
            await tester.pumpAndSettle();
          }
        }
      }

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
