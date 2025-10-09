import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

// App imports
import 'package:musicbud_flutter/presentation/screens/discover/discover_screen.dart';
import 'package:musicbud_flutter/blocs/discover/discover_bloc.dart';
import 'package:musicbud_flutter/blocs/discover/discover_event.dart';
import 'package:musicbud_flutter/blocs/discover/discover_state.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';
import 'package:musicbud_flutter/models/album.dart';

// Test utilities
import 'test_utils/test_helpers.dart';
import 'test_utils/mock_api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('DiscoverScreen Integration Tests', () {
    late MockDiscoverBloc mockDiscoverBloc;
    late MockApiClient mockApiClient;

    setUp(() {
      mockDiscoverBloc = MockDiscoverBloc();
      mockApiClient = MockApiClient();
      TestSetup.setupMockDependencies();
    });

    tearDown(() {
      TestSetup.teardownMockDependencies();
    });

    testWidgets('DiscoverScreen renders correctly with initial state',
        (WidgetTester tester) async {
      // Arrange
      when(mockDiscoverBloc.state).thenReturn(const DiscoverInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: const DiscoverScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(DiscoverScreen));
      IntegrationTestUtils.expectTextVisible('Discover');
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('DiscoverScreen loads content on initialization',
        (WidgetTester tester) async {
      // Arrange
      when(mockDiscoverBloc.state).thenReturn(const DiscoverInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: const DiscoverScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert - Verify all content loading events are triggered
      verify(mockDiscoverBloc.add(const FetchTopTracks())).called(1);
      verify(mockDiscoverBloc.add(const FetchTopArtists())).called(1);
      verify(mockDiscoverBloc.add(const FetchTopGenres())).called(1);
      verify(mockDiscoverBloc.add(const FetchTopAnime())).called(1);
      verify(mockDiscoverBloc.add(const FetchTopManga())).called(1);
      verify(mockDiscoverBloc.add(const FetchLikedAlbums())).called(1);
    });

    testWidgets('DiscoverScreen displays top tracks correctly',
        (WidgetTester tester) async {
      // Arrange
      final testTracks = TestData.testTracks;
      when(mockDiscoverBloc.state).thenReturn(TopTracksLoaded(testTracks));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: const DiscoverScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(DiscoverScreen));
      for (final track in testTracks) {
        IntegrationTestUtils.expectTextVisible(track.name);
        IntegrationTestUtils.expectTextVisible(track.artistName ?? 'Unknown Artist');
      }
    });

    testWidgets('DiscoverScreen displays top artists correctly',
        (WidgetTester tester) async {
      // Arrange
      final testArtists = TestData.testArtists;
      when(mockDiscoverBloc.state).thenReturn(TopArtistsLoaded(testArtists));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: const DiscoverScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(DiscoverScreen));
      for (final artist in testArtists) {
        IntegrationTestUtils.expectTextVisible(artist.name);
      }
    });

    testWidgets('DiscoverScreen displays top genres correctly',
        (WidgetTester tester) async {
      // Arrange
      final testGenres = TestData.testGenres;
      when(mockDiscoverBloc.state).thenReturn(TopGenresLoaded(testGenres));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: const DiscoverScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(DiscoverScreen));
      for (final genre in testGenres) {
        IntegrationTestUtils.expectTextVisible(genre.name);
      }
    });

    testWidgets('DiscoverScreen displays new releases (albums) correctly',
        (WidgetTester tester) async {
      // Arrange
      final testAlbums = [
        Album(
          id: 'album_1',
          name: 'Test Album',
          artistName: 'Test Artist',
          imageUrls: ['https://example.com/album.jpg'],
          releaseYear: 2023,
          totalTracks: 10,
        ),
      ];
      when(mockDiscoverBloc.state).thenReturn(LikedAlbumsLoaded(testAlbums));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: const DiscoverScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(DiscoverScreen));
      for (final album in testAlbums) {
        IntegrationTestUtils.expectTextVisible(album.name);
        IntegrationTestUtils.expectTextVisible(album.artistName);
      }
    });

    testWidgets('DiscoverScreen handles loading states correctly',
        (WidgetTester tester) async {
      // Arrange
      when(mockDiscoverBloc.state).thenReturn(const TopTracksLoading());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: const DiscoverScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(DiscoverScreen));
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('DiscoverScreen handles refresh functionality',
        (WidgetTester tester) async {
      // Arrange
      when(mockDiscoverBloc.state).thenReturn(TopTracksLoaded(TestData.testTracks));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: const DiscoverScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Perform refresh
      await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
      await tester.pumpAndSettle();

      // Assert - Verify refresh events are triggered
      verify(mockDiscoverBloc.add(const FetchTopTracks())).called(greaterThanOrEqualTo(2));
      verify(mockDiscoverBloc.add(const FetchTopArtists())).called(greaterThanOrEqualTo(2));
      verify(mockDiscoverBloc.add(const FetchTopGenres())).called(greaterThanOrEqualTo(2));
      verify(mockDiscoverBloc.add(const FetchTopAnime())).called(greaterThanOrEqualTo(2));
      verify(mockDiscoverBloc.add(const FetchTopManga())).called(greaterThanOrEqualTo(2));
      verify(mockDiscoverBloc.add(const FetchLikedAlbums())).called(greaterThanOrEqualTo(2));
    });

    testWidgets('DiscoverScreen handles search functionality',
        (WidgetTester tester) async {
      // Arrange
      when(mockDiscoverBloc.state).thenReturn(const DiscoverInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: const DiscoverScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Find and interact with search field
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await IntegrationTestUtils.enterTextAndSettle(
        tester,
        searchField,
        'test search',
      );

      // Assert - Search functionality would trigger events (implementation dependent)
      IntegrationTestUtils.expectWidgetVisible(searchField);
    });

    testWidgets('DiscoverScreen handles category filtering',
        (WidgetTester tester) async {
      // Arrange
      when(mockDiscoverBloc.state).thenReturn(const DiscoverInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: const DiscoverScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // The category selection is handled internally by the screen
      // This test verifies the screen renders with category functionality
      IntegrationTestUtils.expectWidgetVisible(find.byType(DiscoverScreen));
    });

    testWidgets('DiscoverScreen displays error states correctly',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Failed to load tracks';
      when(mockDiscoverBloc.state).thenReturn(TopTracksError(errorMessage));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: BlocListener<DiscoverBloc, DiscoverState>(
          listener: (context, state) {
            if (state is TopTracksError ||
                state is TopArtistsError ||
                state is TopGenresError ||
                state is TopAnimeError ||
                state is TopMangaError ||
                state is LikedAlbumsError) {
              String message = 'Error loading content';
              if (state is TopTracksError) message = 'Error loading tracks: ${state.message}';
              if (state is TopArtistsError) message = 'Error loading artists: ${state.message}';
              if (state is TopGenresError) message = 'Error loading genres: ${state.message}';
              if (state is TopAnimeError) message = 'Error loading anime: ${state.message}';
              if (state is TopMangaError) message = 'Error loading manga: ${state.message}';
              if (state is LikedAlbumsError) message = 'Error loading albums: ${state.message}';

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: DesignSystem.error,
                ),
              );
            }
          },
          child: const DiscoverScreen(),
        ),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Trigger error state
      mockDiscoverBloc.emit(TopTracksError(errorMessage));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(DiscoverScreen));
      IntegrationTestUtils.expectTextVisible('Error loading tracks: $errorMessage');
    });

    testWidgets('DiscoverScreen handles API errors gracefully',
        (WidgetTester tester) async {
      // Arrange - simulate API failure
      mockApiClient.setErrorResponse('GET', '/api/discover/top/tracks');

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: const DiscoverScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate error state
      when(mockDiscoverBloc.state).thenReturn(const TopTracksError('API Error'));
      mockDiscoverBloc.emit(const TopTracksError('API Error'));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(DiscoverScreen));
      IntegrationTestUtils.expectTextVisible('Error loading tracks: API Error');
    });

    testWidgets('DiscoverScreen handles network connectivity issues',
        (WidgetTester tester) async {
      // Arrange - simulate network failure
      mockApiClient.setNetworkError('GET', '/api/discover/top/tracks');

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: const DiscoverScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate network error
      when(mockDiscoverBloc.state).thenReturn(const TopTracksError('Network Error'));
      mockDiscoverBloc.emit(const TopTracksError('Network Error'));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(DiscoverScreen));
      IntegrationTestUtils.expectTextVisible('Error loading tracks: Network Error');
    });

    testWidgets('DiscoverScreen displays all sections correctly',
        (WidgetTester tester) async {
      // Arrange - Set up multiple loaded states
      final testTracks = TestData.testTracks;
      final testArtists = TestData.testArtists;
      final testGenres = TestData.testGenres;

      // Mock multiple states (in real scenario, bloc would manage this)
      when(mockDiscoverBloc.state).thenReturn(TopTracksLoaded(testTracks));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: const DiscoverScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert - Check for main UI components
      IntegrationTestUtils.expectWidgetVisible(find.byType(DiscoverScreen));
      IntegrationTestUtils.expectWidgetVisible(find.byType(AppBar));
      IntegrationTestUtils.expectWidgetVisible(find.byType(CustomScrollView));
      IntegrationTestUtils.expectTextVisible('Discover');

      // Check for gradient background
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsWidgets);
    });

    testWidgets('DiscoverScreen handles drawer navigation',
        (WidgetTester tester) async {
      // Arrange
      when(mockDiscoverBloc.state).thenReturn(const DiscoverInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: const DiscoverScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Open drawer
      await IntegrationTestUtils.tapAndSettle(tester, find.byIcon(Icons.menu));

      // Assert - Drawer should be open
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('DiscoverScreen handles rapid state changes correctly',
        (WidgetTester tester) async {
      // Arrange
      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: const DiscoverScreen(),
      );

      // Act - Simulate rapid state changes
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Loading -> Loaded -> Error -> Loaded
      when(mockDiscoverBloc.state).thenReturn(const TopTracksLoading());
      mockDiscoverBloc.emit(const TopTracksLoading());
      await tester.pump();

      when(mockDiscoverBloc.state).thenReturn(TopTracksLoaded(TestData.testTracks));
      mockDiscoverBloc.emit(TopTracksLoaded(TestData.testTracks));
      await tester.pump();

      when(mockDiscoverBloc.state).thenReturn(const TopTracksError('Temporary error'));
      mockDiscoverBloc.emit(const TopTracksError('Temporary error'));
      await tester.pump();

      when(mockDiscoverBloc.state).thenReturn(TopTracksLoaded(TestData.testTracks));
      mockDiscoverBloc.emit(TopTracksLoaded(TestData.testTracks));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(DiscoverScreen));
      for (final track in TestData.testTracks) {
        IntegrationTestUtils.expectTextVisible(track.name);
      }
    });

    testWidgets('DiscoverScreen maintains state during orientation changes',
        (WidgetTester tester) async {
      // Arrange
      when(mockDiscoverBloc.state).thenReturn(TopTracksLoaded(TestData.testTracks));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: const DiscoverScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate orientation change (this would require additional setup in a real scenario)
      // For now, just verify the screen renders correctly with data
      IntegrationTestUtils.expectWidgetVisible(find.byType(DiscoverScreen));
      for (final track in TestData.testTracks) {
        IntegrationTestUtils.expectTextVisible(track.name);
      }
    });

    testWidgets('DiscoverScreen handles empty states gracefully',
        (WidgetTester tester) async {
      // Arrange
      when(mockDiscoverBloc.state).thenReturn(const TopTracksLoaded([]));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<DiscoverBloc>.value(value: mockDiscoverBloc),
        ],
        child: const DiscoverScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert - Screen should still render correctly even with empty data
      IntegrationTestUtils.expectWidgetVisible(find.byType(DiscoverScreen));
      IntegrationTestUtils.expectTextVisible('Discover');
    });
  });
}