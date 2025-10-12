import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:musicbud_flutter/presentation/screens/discover/dynamic_discover_screen.dart';
import 'package:musicbud_flutter/presentation/screens/search/dynamic_search_screen.dart';
import 'package:musicbud_flutter/presentation/screens/profile/track_details_screen.dart';
import 'package:musicbud_flutter/blocs/content/content_bloc.dart';
import 'package:musicbud_flutter/blocs/content/content_event.dart';
import 'package:musicbud_flutter/presentation/blocs/search/search_bloc.dart';
import 'package:musicbud_flutter/presentation/blocs/search/search_event.dart';
import '../test_utils/test_helpers.dart';
import 'package:musicbud_flutter/models/track.dart';
import 'package:musicbud_flutter/models/artist.dart';
import 'package:musicbud_flutter/models/search.dart';
import 'package:dartz/dartz.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Music Discovery Flow Integration Tests', () {
    late MockSearchRepository mockSearchRepo;
    late MockContentRepository mockContentRepo;
    late SearchBloc searchBloc;
    late ContentBloc contentBloc;

    setUp(() {
      mockSearchRepo = MockSearchRepository();
      mockContentRepo = MockContentRepository();
      searchBloc = SearchBloc(repository: mockSearchRepo);
      contentBloc = ContentBloc(contentRepository: mockContentRepo);
    });

    testWidgets('Complete discovery flow: discover → search → track details',
        (WidgetTester tester) async {
      // Setup mock data
      final mockTracks = [
        const Track(
          uid: '1',
          title: 'Test Track 1',
          artistName: 'Test Artist 1',
          albumName: 'Test Album 1',
        ),
        const Track(
          uid: '2',
          title: 'Test Track 2',
          artistName: 'Test Artist 2',
          albumName: 'Test Album 2',
        ),
      ];

      final mockArtists = [
        Artist(
          id: '1',
          name: 'Test Artist 1',
        ),
      ];

      // Setup mock repository responses (repositories already initialized in setUp)

      // Stub all ContentRepository methods
      when(mockContentRepo.getTopTracks()).thenReturn(Future.value(mockTracks));
      when(mockContentRepo.getTopArtists()).thenReturn(Future.value(mockArtists));
      when(mockContentRepo.getTopGenres()).thenReturn(Future.value([]));
      when(mockContentRepo.getTopAnime()).thenReturn(Future.value([]));
      when(mockContentRepo.getTopManga()).thenReturn(Future.value([]));
      when(mockContentRepo.getLikedTracks()).thenReturn(Future.value([]));
      when(mockContentRepo.getLikedArtists()).thenReturn(Future.value([]));
      when(mockContentRepo.getLikedGenres()).thenReturn(Future.value([]));
      when(mockContentRepo.getLikedAlbums()).thenReturn(Future.value([]));
      when(mockContentRepo.getPlayedTracks()).thenReturn(Future.value([]));
      when(mockContentRepo.toggleLike('test_id', 'track')).thenReturn(Future.value());

      // Stub all SearchRepository methods
      when(mockSearchRepo.search(query: 'test song')).thenAnswer((_) async => Right(SearchResults(
        items: mockTracks.map((track) => SearchItem(
          id: track.id!,
          type: 'track',
          title: track.title,
          subtitle: track.artistName,
          data: const {},
          relevanceScore: 1.0,
        )).toList(),
        suggestions: const [],
        metadata: const SearchMetadata(
          totalResults: 2,
          pageSize: 20,
          currentPage: 1,
          hasMore: false,
          typeCounts: {},
          searchTime: Duration.zero,
        ),
      )));
      when(mockSearchRepo.getRecentSearches()).thenAnswer((_) async => const Right(<String>[]));
      when(mockSearchRepo.getTrendingSearches()).thenAnswer((_) async => const Right(<String>[]));
      when(mockSearchRepo.saveRecentSearch('test')).thenAnswer((_) async => const Right(null));
      when(mockSearchRepo.clearRecentSearches()).thenAnswer((_) async => const Right(null));

      // Create blocs with mocked repositories
      final contentBloc = ContentBloc(contentRepository: mockContentRepo);
      final searchBloc = SearchBloc(repository: mockSearchRepo);

      // Trigger content loading
      contentBloc.add(LoadTopContent());

      // Create test app
      final testApp = MultiBlocProvider(
        providers: [
          BlocProvider<ContentBloc>.value(value: contentBloc),
          BlocProvider<SearchBloc>.value(value: searchBloc),
        ],
        child: MaterialApp(
          routes: {
            '/discover': (context) => const DynamicDiscoverScreen(),
            '/search': (context) => const DynamicSearchScreen(),
            '/track-details': (context) => TrackDetailsScreen(track: mockTracks[0]),
          },
          initialRoute: '/discover',
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Verify we're on discover screen
      expect(find.byType(DynamicDiscoverScreen), findsOneWidget);
      expect(find.text('Discover'), findsOneWidget);

      // Verify content is loaded
      expect(find.text('Test Track 1'), findsOneWidget);
      expect(find.text('Test Artist 1'), findsOneWidget);

      // Tap on search section to navigate to search
      await tester.tap(find.byType(TextField).first); // Search input field
      await tester.pumpAndSettle();

      // Enter search query
      await tester.enterText(find.byType(TextField).first, 'test song');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      // Verify navigation to search screen
      expect(find.byType(DynamicSearchScreen), findsOneWidget);

      // Setup mock search repository (reuse existing one)
      when(mockSearchRepo.search(query: 'test song')).thenAnswer((_) async => Right(SearchResults(
        items: mockTracks.map((track) => SearchItem(
          id: track.id!,
          type: 'track',
          title: track.title,
          subtitle: track.artistName,
          data: const {},
          relevanceScore: 1.0,
        )).toList(),
        suggestions: const [],
        metadata: const SearchMetadata(
          totalResults: 2,
          pageSize: 20,
          currentPage: 1,
          hasMore: false,
          typeCounts: {},
          searchTime: Duration.zero,
        ),
      )));

      // Trigger search
      searchBloc.add(const PerformSearch(query: 'test song'));
      await tester.pumpAndSettle();

      // Verify search results are displayed
      expect(find.text('Test Track 1'), findsOneWidget);
      expect(find.text('Test Artist 1'), findsOneWidget);

      // Tap on a track to view details
      await tester.tap(find.text('Test Track 1'));
      await tester.pumpAndSettle();

      // Verify navigation to track details
      expect(find.byType(TrackDetailsScreen), findsOneWidget);
      expect(find.text('Test Track 1'), findsOneWidget);
      expect(find.text('Test Artist 1'), findsOneWidget);
    });

    testWidgets('Search with no results shows empty state',
        (WidgetTester tester) async {
      // Setup empty search results BEFORE creating the app
      final mockSearchRepo = TestSetup.getMock<MockSearchRepository>();
      when(mockSearchRepo.search(query: 'nonexistent song')).thenAnswer((_) async => Right(SearchResults.empty()));

      final testApp = BlocProvider<SearchBloc>.value(
        value: searchBloc,
        child: MaterialApp(
          routes: {
            '/search': (context) => const DynamicSearchScreen(),
          },
          initialRoute: '/search',
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Enter search query with no results
      await tester.enterText(find.byType(TextField).first, 'nonexistent song');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pumpAndSettle();

      // Verify empty state is shown
      expect(find.text('No results found'), findsOneWidget);
      expect(find.text('Try a different search term'), findsOneWidget);
    });

    testWidgets('Content loading states during discovery',
        (WidgetTester tester) async {
      // Setup mock repository to delay response (simulate loading) BEFORE creating bloc
      final mockContentRepo = TestSetup.getMock<MockContentRepository>();
      when(mockContentRepo.getTopTracks()).thenReturn(Future.delayed(const Duration(milliseconds: 100), () => [const Track(uid: '1', title: 'Loaded Track', artistName: 'Loaded Artist')]));
      when(mockContentRepo.getTopArtists()).thenReturn(Future.value([]));
      when(mockContentRepo.getTopGenres()).thenReturn(Future.value([]));
      when(mockContentRepo.getTopAnime()).thenReturn(Future.value([]));
      when(mockContentRepo.getTopManga()).thenReturn(Future.value([]));

      final testApp = BlocProvider<ContentBloc>.value(
        value: contentBloc,
        child: MaterialApp(
          routes: {
            '/discover': (context) => const DiscoverScreen(),
          },
          initialRoute: '/discover',
        ),
      );

      await tester.pumpWidget(testApp);

      // Trigger loading
      contentBloc.add(LoadTopContent());
      await tester.pump();

      // Verify loading indicators are shown
      expect(find.byType(CircularProgressIndicator), findsWidgets);

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Verify content is now displayed
      expect(find.text('Loaded Track'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('Error handling during content loading',
        (WidgetTester tester) async {
      // Setup mock repository to throw error BEFORE creating bloc
      final mockContentRepo = TestSetup.getMock<MockContentRepository>();
      when(mockContentRepo.getTopTracks()).thenThrow(Exception('Network error'));
      when(mockContentRepo.getTopArtists()).thenReturn(Future.value([]));
      when(mockContentRepo.getTopGenres()).thenReturn(Future.value([]));
      when(mockContentRepo.getTopAnime()).thenReturn(Future.value([]));
      when(mockContentRepo.getTopManga()).thenReturn(Future.value([]));

      final testApp = BlocProvider<ContentBloc>.value(
        value: contentBloc,
        child: MaterialApp(
          routes: {
            '/discover': (context) => const DiscoverScreen(),
          },
          initialRoute: '/discover',
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Verify error message is displayed
      expect(find.text('Failed to load content'), findsOneWidget);

      // Verify retry functionality
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('Search filters and categories work correctly',
        (WidgetTester tester) async {
      final testApp = BlocProvider<SearchBloc>.value(
        value: searchBloc,
        child: MaterialApp(
          routes: {
            '/search': (context) => const SearchScreen(),
          },
          initialRoute: '/search',
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Verify filter toggle button exists
      expect(find.byIcon(Icons.filter_list), findsOneWidget);

      // Tap filter button to show filters
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();

      // Verify filter options are visible
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Tracks'), findsOneWidget);
      expect(find.text('Artists'), findsOneWidget);

      // Select tracks filter
      await tester.tap(find.text('Tracks'));
      await tester.pumpAndSettle();

      // Verify filter is applied (would trigger search with filter)
      // verify(mockSearchBloc.add(any)).called(greaterThan(0));
    });

    testWidgets('Track details interaction and playback',
        (WidgetTester tester) async {
      const mockTrack = Track(
        uid: '1',
        title: 'Test Track',
        artistName: 'Test Artist',
        albumName: 'Test Album',
      );

      final testApp = MaterialApp(
        routes: {
          '/track-details': (context) => const TrackDetailsScreen(track: mockTrack),
        },
        initialRoute: '/track-details',
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Verify track information is displayed
      expect(find.text('Test Track'), findsOneWidget);
      expect(find.text('Test Artist'), findsOneWidget);
      expect(find.text('Album: Test Album'), findsOneWidget);

      // Verify playback buttons are present
      expect(find.text('Play on Spotify'), findsOneWidget);
      expect(find.text('Play on YouTube Music'), findsOneWidget);
      expect(find.text('Play on Last.fm'), findsOneWidget);

      // Tap play button (would normally trigger playback)
      await tester.tap(find.text('Play on Spotify'));
      await tester.pumpAndSettle();

      // Verify some response (in real app, would show success/error message)
      // This is a placeholder for actual playback verification
    });

    testWidgets('Navigation persistence during flow',
        (WidgetTester tester) async {
      final mockTracks = [const Track(uid: '1', title: 'Test Track', artistName: 'Test Artist')];

      // Setup mock repository BEFORE creating bloc
      final mockContentRepo = TestSetup.getMock<MockContentRepository>();
      when(mockContentRepo.getTopTracks()).thenReturn(Future.value(mockTracks));
      when(mockContentRepo.getTopArtists()).thenReturn(Future.value([]));
      when(mockContentRepo.getTopGenres()).thenReturn(Future.value([]));
      when(mockContentRepo.getTopAnime()).thenReturn(Future.value([]));
      when(mockContentRepo.getTopManga()).thenReturn(Future.value([]));

      final testApp = BlocProvider<ContentBloc>.value(
        value: contentBloc,
        child: MaterialApp(
          routes: {
            '/discover': (context) => const DiscoverScreen(),
            '/search': (context) => const SearchScreen(),
          },
          initialRoute: '/discover',
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Navigate to search
      await tester.tap(find.byType(TextField).first);
      await tester.pumpAndSettle();

      expect(find.byType(SearchScreen), findsOneWidget);

      // Use back navigation
      await tester.pageBack();
      await tester.pumpAndSettle();

      // Verify we're back on discover screen
      expect(find.byType(DiscoverScreen), findsOneWidget);
      expect(find.byType(SearchScreen), findsNothing);
    });
  });
}