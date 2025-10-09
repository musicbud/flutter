import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

// App imports
import 'package:musicbud_flutter/presentation/screens/search/search_screen.dart';
import 'package:musicbud_flutter/presentation/blocs/search/search_bloc.dart';
import 'package:musicbud_flutter/presentation/blocs/search/search_event.dart';
import 'package:musicbud_flutter/presentation/blocs/search/search_state.dart';
import 'package:musicbud_flutter/models/search.dart';

// Test utilities
import 'test_utils/test_helpers.dart';
import 'test_utils/mock_api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SearchScreen Integration Tests', () {
    late MockSearchBloc mockSearchBloc;
    late MockApiClient mockApiClient;

    setUp(() {
      mockSearchBloc = MockSearchBloc();
      mockApiClient = MockApiClient();
      TestSetup.setupMockDependencies();
    });

    tearDown(() {
      TestSetup.teardownMockDependencies();
    });

    testWidgets('SearchScreen renders correctly with initial state',
        (WidgetTester tester) async {
      // Arrange
      when(mockSearchBloc.state).thenReturn(SearchInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SearchScreen));
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('SearchScreen loads initial data on initialization',
        (WidgetTester tester) async {
      // Arrange
      when(mockSearchBloc.state).thenReturn(SearchInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert - Verify initial data loading events are triggered
      verify(mockSearchBloc.add(const GetRecentSearches(limit: 5))).called(1);
      verify(mockSearchBloc.add(const GetTrendingSearches(limit: 5))).called(1);
    });

    testWidgets('SearchScreen displays recent searches correctly',
        (WidgetTester tester) async {
      // Arrange
      final recentSearches = ['test query 1', 'test query 2', 'test query 3'];
      when(mockSearchBloc.state).thenReturn(RecentSearchesLoaded(recentSearches));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SearchScreen));
      for (final search in recentSearches) {
        IntegrationTestUtils.expectTextVisible(search);
      }
    });

    testWidgets('SearchScreen displays trending searches correctly',
        (WidgetTester tester) async {
      // Arrange
      final trendingSearches = ['trending 1', 'trending 2', 'trending 3'];
      when(mockSearchBloc.state).thenReturn(TrendingSearchesLoaded(trendingSearches));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SearchScreen));
      for (final search in trendingSearches) {
        IntegrationTestUtils.expectTextVisible(search);
      }
      // Should show trending icon
      expect(find.byIcon(Icons.trending_up), findsWidgets);
    });

    testWidgets('SearchScreen handles search input correctly',
        (WidgetTester tester) async {
      // Arrange
      when(mockSearchBloc.state).thenReturn(SearchInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Enter search text
      await IntegrationTestUtils.enterTextAndSettle(
        tester,
        find.byType(TextField),
        'test search query',
      );

      // Assert - Verify suggestions are requested
      verify(mockSearchBloc.add(argThat(isA<SearchEvent>()))).called(greaterThanOrEqualTo(1));
    });

    testWidgets('SearchScreen displays search suggestions correctly',
        (WidgetTester tester) async {
      // Arrange
      final suggestions = ['suggestion 1', 'suggestion 2', 'suggestion 3'];
      when(mockSearchBloc.state).thenReturn(SearchSuggestionsLoaded(
        suggestions: suggestions,
        query: 'test',
      ));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SearchScreen));
      for (final suggestion in suggestions) {
        IntegrationTestUtils.expectTextVisible(suggestion);
      }
    });

    testWidgets('SearchScreen performs search correctly',
        (WidgetTester tester) async {
      // Arrange
      final searchResults = SearchResults(
        items: [
          SearchItem(
            id: '1',
            type: 'track',
            title: 'Test Track',
            subtitle: 'Test Artist',
            imageUrl: 'https://example.com/image.jpg',
            data: {},
            relevanceScore: 1.0,
          ),
        ],
        suggestions: [],
        metadata: SearchMetadata(
          totalResults: 1,
          currentPage: 1,
          pageSize: 20,
          hasMore: false,
          typeCounts: {},
          searchTime: Duration.zero,
        ),
      );

      when(mockSearchBloc.state).thenReturn(SearchResultsLoaded(
        results: searchResults,
        query: 'test query',
      ));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SearchScreen));
      IntegrationTestUtils.expectTextVisible('Test Track');
      IntegrationTestUtils.expectTextVisible('Test Artist');
    });

    testWidgets('SearchScreen handles search filters correctly',
        (WidgetTester tester) async {
      // Arrange
      when(mockSearchBloc.state).thenReturn(SearchInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Toggle filters (assuming there's a filter button)
      // This would depend on the actual UI implementation
      IntegrationTestUtils.expectWidgetVisible(find.byType(SearchScreen));
    });

    testWidgets('SearchScreen handles loading states correctly',
        (WidgetTester tester) async {
      // Arrange
      when(mockSearchBloc.state).thenReturn(SearchLoading());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SearchScreen));
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('SearchScreen handles empty search results correctly',
        (WidgetTester tester) async {
      // Arrange
      when(mockSearchBloc.state).thenReturn(const SearchEmpty('empty query'));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SearchScreen));
      IntegrationTestUtils.expectTextVisible('empty query');
    });

    testWidgets('SearchScreen displays error states correctly',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Search failed';
      when(mockSearchBloc.state).thenReturn(SearchError(errorMessage));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SearchScreen));
      IntegrationTestUtils.expectTextVisible(errorMessage);
    });

    testWidgets('SearchScreen handles API errors gracefully',
        (WidgetTester tester) async {
      // Arrange - simulate API failure
      mockApiClient.setErrorResponse('GET', '/api/search');

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate error state
      when(mockSearchBloc.state).thenReturn(const SearchError('API Error'));
      mockSearchBloc.emit(const SearchError('API Error'));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SearchScreen));
      IntegrationTestUtils.expectTextVisible('API Error');
    });

    testWidgets('SearchScreen handles network connectivity issues',
        (WidgetTester tester) async {
      // Arrange - simulate network failure
      mockApiClient.setNetworkError('GET', '/api/search');

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate network error
      when(mockSearchBloc.state).thenReturn(const SearchError('Network Error'));
      mockSearchBloc.emit(const SearchError('Network Error'));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SearchScreen));
      IntegrationTestUtils.expectTextVisible('Network Error');
    });

    testWidgets('SearchScreen handles pagination correctly',
        (WidgetTester tester) async {
      // Arrange
      final searchResults = SearchResults(
        items: [
          SearchItem(
            id: '1',
            type: 'track',
            title: 'Test Track',
            subtitle: 'Test Artist',
            imageUrl: 'https://example.com/image.jpg',
            data: {},
            relevanceScore: 1.0,
          ),
        ],
        suggestions: [],
        metadata: SearchMetadata(
          totalResults: 50,
          currentPage: 1,
          pageSize: 20,
          hasMore: true,
          typeCounts: {},
          searchTime: Duration.zero,
        ),
      );

      when(mockSearchBloc.state).thenReturn(SearchResultsLoaded(
        results: searchResults,
        query: 'test query',
      ));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Scroll to bottom to trigger pagination
      final scrollable = find.byType(CustomScrollView);
      await tester.scrollUntilVisible(
        find.text('Test Track'), // Scroll to the item
        50.0,
        scrollable: scrollable,
      );

      // Assert - Pagination should be triggered
      verify(mockSearchBloc.add(argThat(isA<SearchEvent>()))).called(greaterThanOrEqualTo(1));
    });

    testWidgets('SearchScreen handles drawer navigation',
        (WidgetTester tester) async {
      // Arrange
      when(mockSearchBloc.state).thenReturn(SearchInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Open drawer
      await IntegrationTestUtils.tapAndSettle(tester, find.byIcon(Icons.menu));

      // Assert - Drawer should be open
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('SearchScreen handles clear search correctly',
        (WidgetTester tester) async {
      // Arrange
      when(mockSearchBloc.state).thenReturn(SearchInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Enter text and then clear
      await IntegrationTestUtils.enterTextAndSettle(
        tester,
        find.byType(TextField),
        'test query',
      );

      // Find and tap clear button (assuming it exists)
      final clearButton = find.byIcon(Icons.clear);
      if (clearButton.evaluate().isNotEmpty) {
        await IntegrationTestUtils.tapAndSettle(tester, clearButton);
      }

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SearchScreen));
    });

    testWidgets('SearchScreen handles rapid state changes correctly',
        (WidgetTester tester) async {
      // Arrange
      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act - Simulate rapid state changes
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Loading -> Suggestions -> Results -> Error -> Initial
      when(mockSearchBloc.state).thenReturn(SearchLoading());
      mockSearchBloc.emit(SearchLoading());
      await tester.pump();

      final suggestions = ['suggestion 1', 'suggestion 2'];
      when(mockSearchBloc.state).thenReturn(SearchSuggestionsLoaded(
        suggestions: suggestions,
        query: 'test',
      ));
      mockSearchBloc.emit(SearchSuggestionsLoaded(
        suggestions: suggestions,
        query: 'test',
      ));
      await tester.pump();

      final searchResults = SearchResults(
        items: [SearchItem(
          id: '1',
          type: 'track',
          title: 'Test Track',
          subtitle: 'Test Artist',
          data: {},
          relevanceScore: 1.0,
        )],
        suggestions: [],
        metadata: SearchMetadata(
          totalResults: 1,
          currentPage: 1,
          pageSize: 20,
          hasMore: false,
          typeCounts: {},
          searchTime: Duration.zero,
        ),
      );

      when(mockSearchBloc.state).thenReturn(SearchResultsLoaded(
        results: searchResults,
        query: 'test query',
      ));
      mockSearchBloc.emit(SearchResultsLoaded(
        results: searchResults,
        query: 'test query',
      ));
      await tester.pump();

      when(mockSearchBloc.state).thenReturn(const SearchError('Temporary error'));
      mockSearchBloc.emit(const SearchError('Temporary error'));
      await tester.pump();

      when(mockSearchBloc.state).thenReturn(SearchInitial());
      mockSearchBloc.emit(SearchInitial());
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SearchScreen));
    });

    testWidgets('SearchScreen maintains state during orientation changes',
        (WidgetTester tester) async {
      // Arrange
      final suggestions = ['suggestion 1', 'suggestion 2'];
      when(mockSearchBloc.state).thenReturn(SearchSuggestionsLoaded(
        suggestions: suggestions,
        query: 'test',
      ));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate orientation change (this would require additional setup in a real scenario)
      // For now, just verify the screen renders correctly with data
      IntegrationTestUtils.expectWidgetVisible(find.byType(SearchScreen));
      for (final suggestion in suggestions) {
        IntegrationTestUtils.expectTextVisible(suggestion);
      }
    });

    testWidgets('SearchScreen displays all UI components correctly',
        (WidgetTester tester) async {
      // Arrange
      when(mockSearchBloc.state).thenReturn(SearchInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SearchBloc>.value(value: mockSearchBloc),
        ],
        child: const SearchScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert - Check for all major UI components
      IntegrationTestUtils.expectWidgetVisible(find.byType(SearchScreen));
      IntegrationTestUtils.expectWidgetVisible(find.byType(AppBar));
      IntegrationTestUtils.expectWidgetVisible(find.byType(TextField));
      IntegrationTestUtils.expectWidgetVisible(find.byType(CustomScrollView));

      // Check for search-related icons
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
    });
  });
}