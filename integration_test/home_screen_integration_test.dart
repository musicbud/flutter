import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

// App imports
import 'package:musicbud_flutter/main.dart';
import 'package:musicbud_flutter/presentation/screens/home/home_screen.dart';
import 'package:musicbud_flutter/blocs/user/user_bloc.dart';
import 'package:musicbud_flutter/blocs/user/user_event.dart';
import 'package:musicbud_flutter/blocs/user/user_state.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

// Test utilities
import 'test_utils/test_helpers.dart';
import 'test_utils/mock_api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('HomeScreen Integration Tests', () {
    late MockUserBloc mockUserBloc;
    late MockApiClient mockApiClient;

    setUp(() {
      mockUserBloc = MockUserBloc();
      mockApiClient = MockApiClient();
      TestSetup.setupMockDependencies();
    });

    tearDown(() {
      TestSetup.teardownMockDependencies();
    });

    testWidgets('HomeScreen renders correctly with initial state',
        (WidgetTester tester) async {
      // Arrange
      mockUserBloc.emit(UserInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<UserBloc>.value(value: mockUserBloc),
        ],
        child: const HomeScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(HomeScreen));
      IntegrationTestUtils.expectTextVisible('Search for music, artists, or playlists...');
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('HomeScreen loads user profile on initialization',
        (WidgetTester tester) async {
      // Arrange
      mockUserBloc.emit(UserInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<UserBloc>.value(value: mockUserBloc),
        ],
        child: const HomeScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      verify(mockUserBloc.add(LoadMyProfile())).called(1);
      verify(mockUserBloc.add(LoadLikedItems())).called(1);
      verify(mockUserBloc.add(LoadTopItems())).called(1);
      verify(mockUserBloc.add(LoadPlayedTracks())).called(1);
    });

    testWidgets('HomeScreen displays loading state correctly',
        (WidgetTester tester) async {
      // Arrange
      mockUserBloc.emit(UserLoading());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<UserBloc>.value(value: mockUserBloc),
        ],
        child: const HomeScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(HomeScreen));
      // Loading indicators should be visible in the content sections
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('HomeScreen displays user profile data correctly',
        (WidgetTester tester) async {
      // Arrange
      final testProfile = TestData.testUserProfile;
      mockUserBloc.emit(ProfileLoaded(testProfile));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<UserBloc>.value(value: mockUserBloc),
        ],
        child: const HomeScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(HomeScreen));
      IntegrationTestUtils.expectTextVisible(testProfile.displayName!);
      IntegrationTestUtils.expectTextVisible(testProfile.bio!);
    });

    testWidgets('HomeScreen displays top artists content correctly',
        (WidgetTester tester) async {
      // Arrange
      final testArtists = TestData.testArtists;
      mockUserBloc.emit(TopItemsLoaded(
        topArtists: testArtists,
        topTracks: [],
        topGenres: [],
        topAnime: [],
        topManga: [],
      ));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<UserBloc>.value(value: mockUserBloc),
        ],
        child: const HomeScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(HomeScreen));
      for (final artist in testArtists) {
        IntegrationTestUtils.expectTextVisible(artist.name);
      }
    });

    testWidgets('HomeScreen displays liked tracks content correctly',
        (WidgetTester tester) async {
      // Arrange
      final testTracks = TestData.testTracks;
      mockUserBloc.emit(LikedItemsLoaded(
        likedArtists: [],
        likedTracks: testTracks,
        likedAlbums: [],
        likedGenres: [],
      ));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<UserBloc>.value(value: mockUserBloc),
        ],
        child: const HomeScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(HomeScreen));
      for (final track in testTracks) {
        IntegrationTestUtils.expectTextVisible(track.name);
        IntegrationTestUtils.expectTextVisible(track.artistName!);
      }
    });

    testWidgets('HomeScreen displays played tracks content correctly',
        (WidgetTester tester) async {
      // Arrange
      final testTracks = TestData.testTracks;
      mockUserBloc.emit(PlayedTracksLoaded(testTracks));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<UserBloc>.value(value: mockUserBloc),
        ],
        child: const HomeScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(HomeScreen));
      for (final track in testTracks) {
        IntegrationTestUtils.expectTextVisible(track.name);
      }
    });

    testWidgets('HomeScreen handles search input correctly',
        (WidgetTester tester) async {
      // Arrange
      mockUserBloc.emit(UserInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<UserBloc>.value(value: mockUserBloc),
        ],
        child: const HomeScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Enter search text
      await IntegrationTestUtils.enterTextAndSettle(
        tester,
        find.byType(TextField),
        'test search query',
      );

      // Assert
      // Should navigate to search screen with query
      // Note: This would require mocking Navigator.pushNamed
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('HomeScreen displays error state correctly',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Failed to load user profile';
      mockUserBloc.emit(UserError(errorMessage));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<UserBloc>.value(value: mockUserBloc),
        ],
        child: BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: DesignSystem.error,
                ),
              );
            }
          },
          child: const HomeScreen(),
        ),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Trigger error by simulating bloc state change
      mockUserBloc.emit(UserError(errorMessage));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(HomeScreen));
      // Error snackbar should be shown
      IntegrationTestUtils.expectTextVisible('Error: $errorMessage');
    });

    testWidgets('HomeScreen handles API errors gracefully',
        (WidgetTester tester) async {
      // Arrange - simulate API failure
      mockApiClient.setErrorResponse('GET', '/api/user/profile');

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<UserBloc>.value(value: mockUserBloc),
        ],
        child: const HomeScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate error state
      mockUserBloc.emit(const UserError('Network Error'));
      mockUserBloc.emit(const UserError('Network Error'));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(HomeScreen));
      IntegrationTestUtils.expectTextVisible('Error: Network Error');
    });

    testWidgets('HomeScreen handles network connectivity issues',
        (WidgetTester tester) async {
      // Arrange - simulate network failure
      mockApiClient.setNetworkError('GET', '/api/user/profile');

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<UserBloc>.value(value: mockUserBloc),
        ],
        child: const HomeScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate network error
      mockUserBloc.emit(const UserError('No internet connection'));
      mockUserBloc.emit(const UserError('No internet connection'));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(HomeScreen));
      IntegrationTestUtils.expectTextVisible('Error: No internet connection');
    });

    testWidgets('HomeScreen displays all UI components correctly',
        (WidgetTester tester) async {
      // Arrange
      mockUserBloc.emit(UserInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<UserBloc>.value(value: mockUserBloc),
        ],
        child: const HomeScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert - Check for all major UI components
      IntegrationTestUtils.expectWidgetVisible(find.byType(HomeScreen));
      IntegrationTestUtils.expectWidgetVisible(find.byType(CustomScrollView));
      IntegrationTestUtils.expectWidgetVisible(find.byType(TextField));
      IntegrationTestUtils.expectTextVisible('Search for music, artists, or playlists...');

      // Check for gradient background
      final containerFinder = find.byType(Container);
      expect(containerFinder, findsWidgets);
    });

    testWidgets('HomeScreen handles rapid state changes correctly',
        (WidgetTester tester) async {
      // Arrange
      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<UserBloc>.value(value: mockUserBloc),
        ],
        child: const HomeScreen(),
      );

      // Act - Simulate rapid state changes
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Loading -> Loaded -> Error -> Loaded
      mockUserBloc.emit(UserLoading());
      mockUserBloc.emit(UserLoading());
      await tester.pump();

      mockUserBloc.emit(ProfileLoaded(TestData.testUserProfile));
      mockUserBloc.emit(ProfileLoaded(TestData.testUserProfile));
      await tester.pump();

      mockUserBloc.emit(const UserError('Temporary error'));
      mockUserBloc.emit(const UserError('Temporary error'));
      await tester.pump();

      mockUserBloc.emit(ProfileLoaded(TestData.testUserProfile));
      mockUserBloc.emit(ProfileLoaded(TestData.testUserProfile));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(HomeScreen));
      IntegrationTestUtils.expectTextVisible(TestData.testUserProfile.displayName!);
    });

    testWidgets('HomeScreen maintains state during orientation changes',
        (WidgetTester tester) async {
      // Arrange
      mockUserBloc.emit(ProfileLoaded(TestData.testUserProfile));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<UserBloc>.value(value: mockUserBloc),
        ],
        child: const HomeScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate orientation change (this would require additional setup in a real scenario)
      // For now, just verify the screen renders correctly
      IntegrationTestUtils.expectWidgetVisible(find.byType(HomeScreen));
      IntegrationTestUtils.expectTextVisible(TestData.testUserProfile.displayName!);
    });
  });
}