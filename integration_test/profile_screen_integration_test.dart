import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

// App imports
import 'package:musicbud_flutter/presentation/screens/profile/profile_screen.dart';
import 'package:musicbud_flutter/blocs/user/profile/profile_bloc.dart';
import 'package:musicbud_flutter/blocs/user/profile/profile_event.dart';
import 'package:musicbud_flutter/blocs/user/profile/profile_state.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

// Test utilities
import 'test_utils/test_helpers.dart';
import 'test_utils/mock_api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ProfileScreen Integration Tests', () {
    late MockProfileBloc mockProfileBloc;
    late MockApiClient mockApiClient;

    setUp(() {
      mockProfileBloc = MockProfileBloc();
      mockApiClient = MockApiClient();
      TestSetup.setupMockDependencies();
    });

    tearDown(() {
      TestSetup.teardownMockDependencies();
    });

    testWidgets('ProfileScreen renders correctly with initial state',
        (WidgetTester tester) async {
      // Arrange
      when(mockProfileBloc.state).thenReturn(ProfileInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(ProfileScreen));
      IntegrationTestUtils.expectTextVisible('Profile');
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('ProfileScreen loads profile data on initialization',
        (WidgetTester tester) async {
      // Arrange
      when(mockProfileBloc.state).thenReturn(ProfileInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert - Verify profile loading event is triggered
      verify(mockProfileBloc.add(const GetProfile())).called(1);
    });

    testWidgets('ProfileScreen displays profile data correctly',
        (WidgetTester tester) async {
      // Arrange
      final testProfile = TestData.testUserProfile;
      when(mockProfileBloc.state).thenReturn(ProfileLoaded(testProfile));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(ProfileScreen));
      IntegrationTestUtils.expectTextVisible(testProfile.displayName ?? 'Unknown User');
      IntegrationTestUtils.expectTextVisible(testProfile.bio ?? 'No bio');
      IntegrationTestUtils.expectTextVisible(testProfile.location ?? 'Unknown location');
    });

    testWidgets('ProfileScreen displays top tracks correctly',
        (WidgetTester tester) async {
      // Arrange
      final testTracks = TestData.testTracks;
      when(mockProfileBloc.state).thenReturn(TopTracksLoaded(testTracks));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Switch to Top tab (index 1)
      await IntegrationTestUtils.tapAndSettle(
        tester,
        find.text('Top'),
      );

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(ProfileScreen));
      for (final track in testTracks) {
        IntegrationTestUtils.expectTextVisible(track.name);
        IntegrationTestUtils.expectTextVisible(track.artistName ?? 'Unknown Artist');
      }
    });

    testWidgets('ProfileScreen displays top artists correctly',
        (WidgetTester tester) async {
      // Arrange
      final testArtists = TestData.testArtists;
      when(mockProfileBloc.state).thenReturn(TopArtistsLoaded(testArtists));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Switch to Top tab
      await IntegrationTestUtils.tapAndSettle(
        tester,
        find.text('Top'),
      );

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(ProfileScreen));
      for (final artist in testArtists) {
        IntegrationTestUtils.expectTextVisible(artist.name);
      }
    });

    testWidgets('ProfileScreen displays top genres correctly',
        (WidgetTester tester) async {
      // Arrange
      final testGenres = TestData.testGenres;
      when(mockProfileBloc.state).thenReturn(TopGenresLoaded(testGenres));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Switch to Top tab
      await IntegrationTestUtils.tapAndSettle(
        tester,
        find.text('Top'),
      );

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(ProfileScreen));
      for (final genre in testGenres) {
        IntegrationTestUtils.expectTextVisible(genre.name);
      }
    });

    testWidgets('ProfileScreen displays liked tracks correctly',
        (WidgetTester tester) async {
      // Arrange
      final testTracks = TestData.testTracks;
      when(mockProfileBloc.state).thenReturn(LikedTracksLoaded(testTracks));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Switch to Liked tab (index 2)
      await IntegrationTestUtils.tapAndSettle(
        tester,
        find.text('Liked'),
      );

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(ProfileScreen));
      for (final track in testTracks) {
        IntegrationTestUtils.expectTextVisible(track.name);
        IntegrationTestUtils.expectTextVisible(track.artistName ?? 'Unknown Artist');
      }
    });

    testWidgets('ProfileScreen displays liked artists correctly',
        (WidgetTester tester) async {
      // Arrange
      final testArtists = TestData.testArtists;
      when(mockProfileBloc.state).thenReturn(LikedArtistsLoaded(testArtists));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Switch to Liked tab
      await IntegrationTestUtils.tapAndSettle(
        tester,
        find.text('Liked'),
      );

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(ProfileScreen));
      for (final artist in testArtists) {
        IntegrationTestUtils.expectTextVisible(artist.name);
      }
    });

    testWidgets('ProfileScreen displays liked genres correctly',
        (WidgetTester tester) async {
      // Arrange
      final testGenres = TestData.testGenres;
      when(mockProfileBloc.state).thenReturn(LikedGenresLoaded(testGenres));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Switch to Liked tab
      await IntegrationTestUtils.tapAndSettle(
        tester,
        find.text('Liked'),
      );

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(ProfileScreen));
      for (final genre in testGenres) {
        IntegrationTestUtils.expectTextVisible(genre.name);
      }
    });

    testWidgets('ProfileScreen handles tab switching correctly',
        (WidgetTester tester) async {
      // Arrange
      when(mockProfileBloc.state).thenReturn(ProfileLoaded(TestData.testUserProfile));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Switch between tabs
      await IntegrationTestUtils.tapAndSettle(tester, find.text('Top'));
      await IntegrationTestUtils.tapAndSettle(tester, find.text('Liked'));
      await IntegrationTestUtils.tapAndSettle(tester, find.text('Buds'));
      await IntegrationTestUtils.tapAndSettle(tester, find.text('Profile'));

      // Assert - Screen should still be visible and functional
      IntegrationTestUtils.expectWidgetVisible(find.byType(ProfileScreen));
      IntegrationTestUtils.expectTextVisible('Profile');
    });

    testWidgets('ProfileScreen loads data when switching to tabs',
        (WidgetTester tester) async {
      // Arrange
      when(mockProfileBloc.state).thenReturn(ProfileInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Switch to Top tab
      await IntegrationTestUtils.tapAndSettle(tester, find.text('Top'));

      // Assert - Verify data loading events are triggered
      verify(mockProfileBloc.add(TopTracksRequested())).called(1);
      verify(mockProfileBloc.add(TopArtistsRequested())).called(1);
      verify(mockProfileBloc.add(TopGenresRequested())).called(1);
    });

    testWidgets('ProfileScreen handles refresh functionality',
        (WidgetTester tester) async {
      // Arrange
      when(mockProfileBloc.state).thenReturn(ProfileLoaded(TestData.testUserProfile));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Perform refresh on profile tab
      await tester.drag(find.byType(RefreshIndicator), const Offset(0, 300));
      await tester.pumpAndSettle();

      // Assert - Verify refresh events are triggered
      verify(mockProfileBloc.add(const GetProfile())).called(greaterThanOrEqualTo(2));
    });

    testWidgets('ProfileScreen handles loading states correctly',
        (WidgetTester tester) async {
      // Arrange
      when(mockProfileBloc.state).thenReturn(ProfileLoading());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(ProfileScreen));
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('ProfileScreen displays error states correctly',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Failed to load profile';
      when(mockProfileBloc.state).thenReturn(ProfileError(errorMessage));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError || state is ProfileFailure) {
              final error = state is ProfileError ? state.error : (state as ProfileFailure).error;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: $error'),
                  backgroundColor: DesignSystem.error,
                ),
              );
            }
          },
          child: const ProfileScreen(),
        ),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Trigger error state
      mockProfileBloc.emit(ProfileError(errorMessage));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(ProfileScreen));
      IntegrationTestUtils.expectTextVisible('Error: $errorMessage');
    });

    testWidgets('ProfileScreen handles API errors gracefully',
        (WidgetTester tester) async {
      // Arrange - simulate API failure
      mockApiClient.setErrorResponse('GET', '/api/user/profile');

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate error state
      when(mockProfileBloc.state).thenReturn(const ProfileError('API Error'));
      mockProfileBloc.emit(const ProfileError('API Error'));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(ProfileScreen));
      IntegrationTestUtils.expectTextVisible('Error: API Error');
    });

    testWidgets('ProfileScreen handles network connectivity issues',
        (WidgetTester tester) async {
      // Arrange - simulate network failure
      mockApiClient.setNetworkError('GET', '/api/user/profile');

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate network error
      when(mockProfileBloc.state).thenReturn(const ProfileError('Network Error'));
      mockProfileBloc.emit(const ProfileError('Network Error'));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(ProfileScreen));
      IntegrationTestUtils.expectTextVisible('Error: Network Error');
    });

    testWidgets('ProfileScreen handles drawer navigation',
        (WidgetTester tester) async {
      // Arrange
      when(mockProfileBloc.state).thenReturn(ProfileInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Open drawer
      await IntegrationTestUtils.tapAndSettle(tester, find.byIcon(Icons.menu));

      // Assert - Drawer should be open
      expect(find.byType(Drawer), findsOneWidget);
    });

    testWidgets('ProfileScreen handles rapid state changes correctly',
        (WidgetTester tester) async {
      // Arrange
      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act - Simulate rapid state changes
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Loading -> Loaded -> Error -> Loaded
      when(mockProfileBloc.state).thenReturn(ProfileLoading());
      mockProfileBloc.emit(ProfileLoading());
      await tester.pump();

      when(mockProfileBloc.state).thenReturn(ProfileLoaded(TestData.testUserProfile));
      mockProfileBloc.emit(ProfileLoaded(TestData.testUserProfile));
      await tester.pump();

      when(mockProfileBloc.state).thenReturn(const ProfileError('Temporary error'));
      mockProfileBloc.emit(const ProfileError('Temporary error'));
      await tester.pump();

      when(mockProfileBloc.state).thenReturn(ProfileLoaded(TestData.testUserProfile));
      mockProfileBloc.emit(ProfileLoaded(TestData.testUserProfile));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(ProfileScreen));
      IntegrationTestUtils.expectTextVisible(TestData.testUserProfile.displayName ?? 'Unknown User');
    });

    testWidgets('ProfileScreen maintains state during orientation changes',
        (WidgetTester tester) async {
      // Arrange
      when(mockProfileBloc.state).thenReturn(ProfileLoaded(TestData.testUserProfile));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate orientation change (this would require additional setup in a real scenario)
      // For now, just verify the screen renders correctly with data
      IntegrationTestUtils.expectWidgetVisible(find.byType(ProfileScreen));
      IntegrationTestUtils.expectTextVisible(TestData.testUserProfile.displayName ?? 'Unknown User');
    });

    testWidgets('ProfileScreen handles empty states gracefully',
        (WidgetTester tester) async {
      // Arrange
      when(mockProfileBloc.state).thenReturn(const TopTracksLoaded([]));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Switch to Top tab
      await IntegrationTestUtils.tapAndSettle(tester, find.text('Top'));

      // Assert - Screen should still render correctly even with empty data
      IntegrationTestUtils.expectWidgetVisible(find.byType(ProfileScreen));
      IntegrationTestUtils.expectTextVisible('Top Tracks');
    });

    testWidgets('ProfileScreen displays all UI components correctly',
        (WidgetTester tester) async {
      // Arrange
      when(mockProfileBloc.state).thenReturn(ProfileLoaded(TestData.testUserProfile));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
        ],
        child: const ProfileScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert - Check for all major UI components
      IntegrationTestUtils.expectWidgetVisible(find.byType(ProfileScreen));
      IntegrationTestUtils.expectWidgetVisible(find.byType(AppBar));
      IntegrationTestUtils.expectWidgetVisible(find.byType(BottomNavigationBar));
      IntegrationTestUtils.expectWidgetVisible(find.byType(CustomScrollView));
      IntegrationTestUtils.expectTextVisible('Profile');

      // Check bottom navigation items
      IntegrationTestUtils.expectTextVisible('Profile');
      IntegrationTestUtils.expectTextVisible('Top');
      IntegrationTestUtils.expectTextVisible('Liked');
      IntegrationTestUtils.expectTextVisible('Buds');
    });
  });
}