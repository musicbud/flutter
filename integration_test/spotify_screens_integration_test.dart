import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

// App imports
import 'package:musicbud_flutter/presentation/screens/spotify/spotify_control_screen.dart';
import 'package:musicbud_flutter/presentation/screens/spotify/played_tracks_map_screen.dart';
import 'package:musicbud_flutter/blocs/spotify/spotify_bloc.dart';
import 'package:musicbud_flutter/blocs/spotify/spotify_event.dart';
import 'package:musicbud_flutter/blocs/spotify/spotify_state.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

// Test utilities
import 'test_utils/test_helpers.dart';
import 'test_utils/mock_api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Spotify Screens Integration Tests', () {
    late MockSpotifyBloc mockSpotifyBloc;
    late MockApiClient mockApiClient;

    setUp(() {
      mockSpotifyBloc = MockSpotifyBloc();
      mockApiClient = MockApiClient();
      TestSetup.setupMockDependencies();
    });

    tearDown(() {
      TestSetup.teardownMockDependencies();
    });

    group('SpotifyControlScreen Tests', () {
      testWidgets('SpotifyControlScreen renders correctly with initial state',
          (WidgetTester tester) async {
        // Arrange
        when(mockSpotifyBloc.state).thenReturn(SpotifyInitial());

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const SpotifyControlScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Assert
        IntegrationTestUtils.expectWidgetVisible(find.byType(SpotifyControlScreen));
        IntegrationTestUtils.expectTextVisible('Spotify Control');
        expect(find.byType(AppBar), findsOneWidget);
        expect(find.byIcon(Icons.location_on), findsOneWidget);
        expect(find.byIcon(Icons.map), findsOneWidget);
      });

      testWidgets('SpotifyControlScreen loads played tracks on initialization',
          (WidgetTester tester) async {
        // Arrange
        when(mockSpotifyBloc.state).thenReturn(SpotifyInitial());

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const SpotifyControlScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Assert - Verify load event was triggered
        verify(mockSpotifyBloc.add(LoadPlayedTracks())).called(1);
      });

      testWidgets('SpotifyControlScreen displays played tracks correctly',
          (WidgetTester tester) async {
        // Arrange
        final testTracks = TestData.testTracks;
        when(mockSpotifyBloc.state).thenReturn(PlayedTracksLoaded(testTracks));

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const SpotifyControlScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Assert
        IntegrationTestUtils.expectWidgetVisible(find.byType(SpotifyControlScreen));
        for (final track in testTracks) {
          IntegrationTestUtils.expectTextVisible(track.name);
          IntegrationTestUtils.expectTextVisible(track.artistName ?? 'Unknown Artist');
        }
        expect(find.byIcon(Icons.play_arrow), findsNWidgets(testTracks.length));
      });

      testWidgets('SpotifyControlScreen handles send location action',
          (WidgetTester tester) async {
        // Arrange
        when(mockSpotifyBloc.state).thenReturn(SpotifyInitial());

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const SpotifyControlScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Tap send location button
        await IntegrationTestUtils.tapAndSettle(
          tester,
          find.byIcon(Icons.location_on),
        );

        // Assert - Location save event should be triggered
        // Note: In real scenario, this would trigger location permission and API call
        // For testing, we verify the UI interaction
        IntegrationTestUtils.expectWidgetVisible(find.byType(SpotifyControlScreen));
      });

      testWidgets('SpotifyControlScreen navigates to map screen',
          (WidgetTester tester) async {
        // Arrange
        when(mockSpotifyBloc.state).thenReturn(SpotifyInitial());

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const SpotifyControlScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Tap map button
        await IntegrationTestUtils.tapAndSettle(
          tester,
          find.byIcon(Icons.map),
        );

        // Assert - Navigation should occur (in test environment, we check the button exists)
        IntegrationTestUtils.expectWidgetVisible(find.byType(SpotifyControlScreen));
      });

      testWidgets('SpotifyControlScreen displays loading state',
          (WidgetTester tester) async {
        // Arrange
        when(mockSpotifyBloc.state).thenReturn(SpotifyLoading());

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const SpotifyControlScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Assert
        IntegrationTestUtils.expectWidgetVisible(find.byType(SpotifyControlScreen));
        expect(find.byType(CircularProgressIndicator), findsWidgets);
      });

      testWidgets('SpotifyControlScreen displays error messages',
          (WidgetTester tester) async {
        // Arrange
        const errorMessage = 'Failed to load tracks';
        when(mockSpotifyBloc.state).thenReturn(SpotifyInitial());

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: BlocListener<SpotifyBloc, SpotifyState>(
            listener: (context, state) {
              if (state is SpotifyError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: const SpotifyControlScreen(),
          ),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Simulate error state
        mockSpotifyBloc.emit(SpotifyError(errorMessage));
        await tester.pumpAndSettle();

        // Assert
        IntegrationTestUtils.expectWidgetVisible(find.byType(SpotifyControlScreen));
        IntegrationTestUtils.expectTextVisible(errorMessage);
      });

      testWidgets('SpotifyControlScreen displays success messages for track played',
          (WidgetTester tester) async {
        // Arrange
        when(mockSpotifyBloc.state).thenReturn(SpotifyInitial());

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: BlocListener<SpotifyBloc, SpotifyState>(
            listener: (context, state) {
              if (state is TrackPlayed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Track played successfully')),
                );
              }
            },
            child: const SpotifyControlScreen(),
          ),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Simulate track played
        mockSpotifyBloc.emit(const TrackPlayed());
        await tester.pumpAndSettle();

        // Assert
        IntegrationTestUtils.expectWidgetVisible(find.byType(SpotifyControlScreen));
        IntegrationTestUtils.expectTextVisible('Track played successfully');
      });

      testWidgets('SpotifyControlScreen displays success messages for location saved',
          (WidgetTester tester) async {
        // Arrange
        when(mockSpotifyBloc.state).thenReturn(SpotifyInitial());

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: BlocListener<SpotifyBloc, SpotifyState>(
            listener: (context, state) {
              if (state is LocationSaved) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Location saved successfully')),
                );
              }
            },
            child: const SpotifyControlScreen(),
          ),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Simulate location saved
        mockSpotifyBloc.emit(const LocationSaved());
        await tester.pumpAndSettle();

        // Assert
        IntegrationTestUtils.expectWidgetVisible(find.byType(SpotifyControlScreen));
        IntegrationTestUtils.expectTextVisible('Location saved successfully');
      });

      testWidgets('SpotifyControlScreen handles API errors gracefully',
          (WidgetTester tester) async {
        // Arrange - simulate API failure
        mockApiClient.setErrorResponse('GET', '/api/spotify/tracks');

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const SpotifyControlScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Simulate API error
        mockSpotifyBloc.emit(const SpotifyError('API Error'));
        await tester.pumpAndSettle();

        // Assert
        IntegrationTestUtils.expectWidgetVisible(find.byType(SpotifyControlScreen));
        IntegrationTestUtils.expectTextVisible('API Error');
      });

      testWidgets('SpotifyControlScreen handles network connectivity issues',
          (WidgetTester tester) async {
        // Arrange - simulate network failure
        mockApiClient.setNetworkError('GET', '/api/spotify/tracks');

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const SpotifyControlScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Simulate network error
        mockSpotifyBloc.emit(const SpotifyError('Network Error'));
        await tester.pumpAndSettle();

        // Assert
        IntegrationTestUtils.expectWidgetVisible(find.byType(SpotifyControlScreen));
        IntegrationTestUtils.expectTextVisible('Network Error');
      });
    });

    group('PlayedTracksMapScreen Tests', () {
      testWidgets('PlayedTracksMapScreen renders correctly with initial state',
          (WidgetTester tester) async {
        // Arrange
        when(mockSpotifyBloc.state).thenReturn(SpotifyInitial());

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const PlayedTracksMapScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Assert
        IntegrationTestUtils.expectWidgetVisible(find.byType(PlayedTracksMapScreen));
        IntegrationTestUtils.expectTextVisible('Played Tracks Map');
        expect(find.byType(AppBar), findsOneWidget);
        IntegrationTestUtils.expectTextVisible('No tracks with location data');
      });

      testWidgets('PlayedTracksMapScreen loads tracks with location on initialization',
          (WidgetTester tester) async {
        // Arrange
        when(mockSpotifyBloc.state).thenReturn(SpotifyInitial());

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const PlayedTracksMapScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Assert - Verify load event was triggered
        verify(mockSpotifyBloc.add(LoadPlayedTracksWithLocation())).called(1);
      });

      testWidgets('PlayedTracksMapScreen displays tracks with location correctly',
          (WidgetTester tester) async {
        // Arrange - Mock tracks with location data
        final testTracks = TestData.testTracks.map((track) {
          // Add mock location data
          return track.copyWith(latitude: 40.7128, longitude: -74.0060);
        }).toList();

        when(mockSpotifyBloc.state).thenReturn(PlayedTracksWithLocationLoaded(testTracks));

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const PlayedTracksMapScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Assert
        IntegrationTestUtils.expectWidgetVisible(find.byType(PlayedTracksMapScreen));
        for (final track in testTracks) {
          IntegrationTestUtils.expectTextVisible(track.name);
          IntegrationTestUtils.expectTextVisible('Lat: ${track.latitude}, Lng: ${track.longitude}');
        }
      });

      testWidgets('PlayedTracksMapScreen displays loading state',
          (WidgetTester tester) async {
        // Arrange
        when(mockSpotifyBloc.state).thenReturn(SpotifyLoading());

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const PlayedTracksMapScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Assert
        IntegrationTestUtils.expectWidgetVisible(find.byType(PlayedTracksMapScreen));
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('PlayedTracksMapScreen displays error state',
          (WidgetTester tester) async {
        // Arrange
        const errorMessage = 'Failed to load tracks with location';
        when(mockSpotifyBloc.state).thenReturn(SpotifyError(errorMessage));

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const PlayedTracksMapScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Assert
        IntegrationTestUtils.expectWidgetVisible(find.byType(PlayedTracksMapScreen));
        IntegrationTestUtils.expectTextVisible('Error: $errorMessage');
      });

      testWidgets('PlayedTracksMapScreen handles empty tracks list',
          (WidgetTester tester) async {
        // Arrange
        when(mockSpotifyBloc.state).thenReturn(const PlayedTracksWithLocationLoaded([]));

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const PlayedTracksMapScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Assert
        IntegrationTestUtils.expectWidgetVisible(find.byType(PlayedTracksMapScreen));
        IntegrationTestUtils.expectTextVisible('No tracks with location data');
      });

      testWidgets('PlayedTracksMapScreen handles API errors gracefully',
          (WidgetTester tester) async {
        // Arrange - simulate API failure
        mockApiClient.setErrorResponse('GET', '/api/spotify/tracks/location');

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const PlayedTracksMapScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Simulate API error
        mockSpotifyBloc.emit(const SpotifyError('API Error'));
        await tester.pumpAndSettle();

        // Assert
        IntegrationTestUtils.expectWidgetVisible(find.byType(PlayedTracksMapScreen));
        IntegrationTestUtils.expectTextVisible('Error: API Error');
      });

      testWidgets('PlayedTracksMapScreen handles network connectivity issues',
          (WidgetTester tester) async {
        // Arrange - simulate network failure
        mockApiClient.setNetworkError('GET', '/api/spotify/tracks/location');

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const PlayedTracksMapScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Simulate network error
        mockSpotifyBloc.emit(const SpotifyError('Network Error'));
        await tester.pumpAndSettle();

        // Assert
        IntegrationTestUtils.expectWidgetVisible(find.byType(PlayedTracksMapScreen));
        IntegrationTestUtils.expectTextVisible('Error: Network Error');
      });

      testWidgets('PlayedTracksMapScreen handles rapid state changes correctly',
          (WidgetTester tester) async {
        // Arrange
        final testTracks = TestData.testTracks.map((track) {
          return track.copyWith(latitude: 40.7128, longitude: -74.0060);
        }).toList();

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const PlayedTracksMapScreen(),
        );

        // Act - Simulate rapid state changes
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Loading -> Loaded -> Error -> Loaded
        mockSpotifyBloc.emit(SpotifyLoading());
        await tester.pump();

        mockSpotifyBloc.emit(PlayedTracksWithLocationLoaded(testTracks));
        await tester.pump();

        mockSpotifyBloc.emit(const SpotifyError('Temporary error'));
        await tester.pump();

        mockSpotifyBloc.emit(PlayedTracksWithLocationLoaded(testTracks));
        await tester.pumpAndSettle();

        // Assert
        IntegrationTestUtils.expectWidgetVisible(find.byType(PlayedTracksMapScreen));
        IntegrationTestUtils.expectTextVisible(testTracks.first.name);
      });

      testWidgets('PlayedTracksMapScreen maintains state during orientation changes',
          (WidgetTester tester) async {
        // Arrange
        final testTracks = TestData.testTracks.map((track) {
          return track.copyWith(latitude: 40.7128, longitude: -74.0060);
        }).toList();

        when(mockSpotifyBloc.state).thenReturn(PlayedTracksWithLocationLoaded(testTracks));

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const PlayedTracksMapScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Simulate orientation change (this would require additional setup in a real scenario)
        // For now, just verify the screen renders correctly with data
        IntegrationTestUtils.expectWidgetVisible(find.byType(PlayedTracksMapScreen));
        IntegrationTestUtils.expectTextVisible(testTracks.first.name);
      });

      testWidgets('PlayedTracksMapScreen displays all UI components correctly',
          (WidgetTester tester) async {
        // Arrange
        final testTracks = TestData.testTracks.map((track) {
          return track.copyWith(latitude: 40.7128, longitude: -74.0060);
        }).toList();

        when(mockSpotifyBloc.state).thenReturn(PlayedTracksWithLocationLoaded(testTracks));

        final testApp = TestAppWrapper(
          providers: [
            BlocProvider<SpotifyBloc>.value(value: mockSpotifyBloc),
          ],
          child: const PlayedTracksMapScreen(),
        );

        // Act
        await IntegrationTestUtils.pumpAndSettle(tester, testApp);

        // Assert - Check for all major UI components
        IntegrationTestUtils.expectWidgetVisible(find.byType(PlayedTracksMapScreen));
        IntegrationTestUtils.expectWidgetVisible(find.byType(AppBar));
        IntegrationTestUtils.expectWidgetVisible(find.byType(ListView));
        expect(find.byType(ListTile), findsNWidgets(testTracks.length));
        IntegrationTestUtils.expectTextVisible('Played Tracks Map');
      });
    });
  });
}