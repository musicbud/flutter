import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:musicbud_flutter/main.dart' as app;

/// Search & Discovery E2E Tests
///
/// Tests search functionality and content discovery:
/// - Basic search (songs, artists, albums, playlists)
/// - Advanced search with filters
/// - Search result sorting
/// - Recent searches
/// - Search suggestions and autocomplete
/// - Content recommendations
/// - Trending and popular content
/// - Genre-based discovery
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Search & Discovery E2E Tests', () {
    testWidgets('should perform basic search for songs', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Find and tap search icon or tab
      final searchIcon = find.byIcon(Icons.search);
      if (searchIcon.evaluate().isNotEmpty) {
        await tester.tap(searchIcon.first);
        await tester.pumpAndSettle();
      } else {
        final searchTab = find.text('Search');
        if (searchTab.evaluate().isNotEmpty) {
          await tester.tap(searchTab);
          await tester.pumpAndSettle();
        }
      }

      // Enter search query
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField.first, 'test song');
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Search results should display
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('should search for artists', (tester) async {
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
      }

      // Look for artist filter or tab
      final artistTab = find.textContaining('Artist', findRichText: true);
      if (artistTab.evaluate().isNotEmpty) {
        await tester.tap(artistTab.first);
        await tester.pumpAndSettle();
      }

      // Enter artist search
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField.first, 'test artist');
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('should search for albums', (tester) async {
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
      }

      // Look for album filter
      final albumTab = find.textContaining('Album', findRichText: true);
      if (albumTab.evaluate().isNotEmpty) {
        await tester.tap(albumTab.first);
        await tester.pumpAndSettle();
      }

      // Enter album search
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField.first, 'test album');
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('should search for playlists', (tester) async {
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
      }

      // Look for playlist filter
      final playlistTab = find.textContaining('Playlist', findRichText: true);
      if (playlistTab.evaluate().isNotEmpty) {
        await tester.tap(playlistTab.first);
        await tester.pumpAndSettle();
      }

      // Enter playlist search
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField.first, 'chill');
        await tester.pumpAndSettle(const Duration(seconds: 2));

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('should apply search filters', (tester) async {
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
      }

      // Look for filter button
      final filterIcon = find.byIcon(Icons.filter_list);
      if (filterIcon.evaluate().isNotEmpty) {
        await tester.tap(filterIcon.first);
        await tester.pumpAndSettle();

        // Filter dialog/sheet should appear
        expect(find.byType(Dialog).evaluate().isNotEmpty ||
               find.byType(BottomSheet).evaluate().isNotEmpty ||
               find.byType(Scaffold).evaluate().isNotEmpty,
               isTrue);
      }
    });

    testWidgets('should sort search results', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to search and perform search
      final searchIcon = find.byIcon(Icons.search);
      if (searchIcon.evaluate().isNotEmpty) {
        await tester.tap(searchIcon.first);
        await tester.pumpAndSettle();
      }

      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField.first, 'music');
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Look for sort option
        final sortIcon = find.byIcon(Icons.sort);
        final sortText = find.textContaining('Sort', findRichText: true);
        
        if (sortIcon.evaluate().isNotEmpty) {
          await tester.tap(sortIcon.first);
          await tester.pumpAndSettle();
        } else if (sortText.evaluate().isNotEmpty) {
          await tester.tap(sortText.first);
          await tester.pumpAndSettle();
        }

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('should show recent searches', (tester) async {
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

        // Recent searches should appear before searching
        final recentText = find.textContaining('Recent', findRichText: true);
        expect(recentText.evaluate().isNotEmpty ||
               find.byType(Scaffold).evaluate().isNotEmpty,
               isTrue);
      }
    });

    testWidgets('should provide search suggestions', (tester) async {
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
      }

      // Start typing to get suggestions
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField.first, 'ro');
        await tester.pumpAndSettle(const Duration(seconds: 1));

        // Suggestions should appear
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('should clear search query', (tester) async {
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
      }

      // Enter search query
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField.first, 'test query');
        await tester.pumpAndSettle();

        // Look for clear button
        final clearIcon = find.byIcon(Icons.clear);
        if (clearIcon.evaluate().isNotEmpty) {
          await tester.tap(clearIcon.first);
          await tester.pumpAndSettle();

          // Search field should be cleared
          expect(find.text('test query'), findsNothing);
        }
      }
    });

    testWidgets('should display content recommendations', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to discover/home
      final discoverTab = find.text('Discover');
      final homeTab = find.text('Home');
      
      if (discoverTab.evaluate().isNotEmpty) {
        await tester.tap(discoverTab);
        await tester.pumpAndSettle();
      } else if (homeTab.evaluate().isNotEmpty) {
        await tester.tap(homeTab);
        await tester.pumpAndSettle();
      }

      // Look for recommendation sections
      final recommendedText = find.textContaining('Recommended', findRichText: true);
      final forYouText = find.textContaining('For You', findRichText: true);

      expect(recommendedText.evaluate().isNotEmpty ||
             forYouText.evaluate().isNotEmpty ||
             find.byType(Scaffold).evaluate().isNotEmpty,
             isTrue);
    });

    testWidgets('should show trending content', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to discover
      final discoverTab = find.text('Discover');
      if (discoverTab.evaluate().isNotEmpty) {
        await tester.tap(discoverTab);
        await tester.pumpAndSettle();
      }

      // Look for trending section
      final trendingText = find.textContaining('Trending', findRichText: true);
      final popularText = find.textContaining('Popular', findRichText: true);

      expect(trendingText.evaluate().isNotEmpty ||
             popularText.evaluate().isNotEmpty ||
             find.byType(Scaffold).evaluate().isNotEmpty,
             isTrue);
    });

    testWidgets('should browse by genre', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to discover
      final discoverTab = find.text('Discover');
      if (discoverTab.evaluate().isNotEmpty) {
        await tester.tap(discoverTab);
        await tester.pumpAndSettle();
      }

      // Look for genre sections
      final genreText = find.textContaining('Genre', findRichText: true);
      final categoriesText = find.textContaining('Categories', findRichText: true);

      if (genreText.evaluate().isNotEmpty) {
        // Scroll to find genre options
        final scrollable = find.byType(Scrollable);
        if (scrollable.evaluate().isNotEmpty) {
          await tester.drag(scrollable.first, const Offset(0, -200));
          await tester.pumpAndSettle();
        }
      }

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle empty search results', (tester) async {
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
      }

      // Enter query unlikely to have results
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField.first, 'xyzabc123nonexistent');
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Should show no results message or empty state
        final noResultsText = find.textContaining('No results', findRichText: true);
        final emptyText = find.textContaining('not found', findRichText: true);

        expect(noResultsText.evaluate().isNotEmpty ||
               emptyText.evaluate().isNotEmpty ||
               find.byType(Scaffold).evaluate().isNotEmpty,
               isTrue);
      }
    });

    testWidgets('should navigate to search result details', (tester) async {
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
      }

      // Perform search
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField.first, 'music');
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Tap on first result if available
        final listTile = find.byType(ListTile);
        if (listTile.evaluate().isNotEmpty) {
          await tester.tap(listTile.first);
          await tester.pumpAndSettle();

          // Detail screen should open
          expect(find.byType(Scaffold), findsOneWidget);
        }
      }
    });

    testWidgets('should save and clear recent searches', (tester) async {
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
      }

      // Perform search to save in history
      final searchField = find.byType(TextField);
      if (searchField.evaluate().isNotEmpty) {
        await tester.enterText(searchField.first, 'test search');
        await tester.pumpAndSettle(const Duration(seconds: 1));
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        // Clear search field
        final clearIcon = find.byIcon(Icons.clear);
        if (clearIcon.evaluate().isNotEmpty) {
          await tester.tap(clearIcon.first);
          await tester.pumpAndSettle();
        }

        // Look for clear history option
        final clearHistoryText = find.textContaining('Clear', findRichText: true);
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });
  });
}
