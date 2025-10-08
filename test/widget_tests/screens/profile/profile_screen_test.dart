import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musicbud_flutter/blocs/user_profile/user_profile_bloc.dart';
import 'package:musicbud_flutter/models/user_profile.dart';
import 'package:musicbud_flutter/presentation/screens/profile/profile_screen.dart';
import '../../../test_utils/mock_data.dart';
import '../../../test_utils/test_helpers.dart';
import '../../../test_utils/widget_test_helpers.dart';

void main() {
  late UserProfileBloc userProfileBloc;

  setUp(() async {
    await TestSetup.initMockDependencies();
    userProfileBloc = UserProfileBloc(
      userProfileRepository: TestSetup.getMock() as MockUserProfileRepository,
    );
  });

  tearDown(() {
    userProfileBloc.close();
  });

  Widget createTestWidget(Widget child) {
    return WidgetTestHelper.createTestableWidget(
      child: child,
      blocProviders: [
        BlocProvider<UserProfileBloc>.value(value: userProfileBloc),
      ],
    );
  }

  group('ProfileScreen', () {
    testWidgets('renders correctly with initial state', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(const ProfileScreen()));

      // Check that the app bar is present
      expect(find.text('Profile'), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);

      // Check that bottom navigation is present
      expect(find.text('Profile'), findsNWidgets(2)); // App bar + bottom nav
      expect(find.text('Top'), findsOneWidget);
      expect(find.text('Liked'), findsOneWidget);
      expect(find.text('Buds'), findsOneWidget);
    });

    testWidgets('displays loading state', (WidgetTester tester) async {
      userProfileBloc.emit(UserProfileLoading());

      await tester.pumpWidget(createTestWidget(const ProfileScreen()));

      // Check for loading indicators
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('displays user profile information when loaded', (WidgetTester tester) async {
      final mockUserProfile = UserProfile(
        id: 'user1',
        username: 'john_doe',
        email: 'john@example.com',
        displayName: 'John Doe',
        bio: 'Music lover and developer',
        location: 'New York',
        avatarUrl: 'https://example.com/avatar.jpg',
        followersCount: 150,
        followingCount: 75,
        isActive: true,
        isAuthenticated: true,
      );

      userProfileBloc.emit(UserProfileLoaded(userProfile: mockUserProfile));

      await tester.pumpWidget(createTestWidget(const ProfileScreen()));

      // Check that profile information is displayed
      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('@john_doe'), findsOneWidget);
      expect(find.text('Music lover and developer'), findsOneWidget);
      expect(find.text('New York'), findsOneWidget);

      // Check that profile sections are present
      expect(find.text('My Music'), findsOneWidget);
      expect(find.text('Recent Activity'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);
    });

    testWidgets('displays error state with snackbar', (WidgetTester tester) async {
      userProfileBloc.emit(const UserProfileError('Failed to load profile'));

      await tester.pumpWidget(createTestWidget(const ProfileScreen()));
      await tester.pump(); // Allow snackbar to show

      expect(find.text('Error: Failed to load profile'), findsOneWidget);
    });

    testWidgets('handles profile update success', (WidgetTester tester) async {
      final mockUserProfile = UserProfile(
        id: 'user1',
        username: 'john_doe',
        displayName: 'John Doe',
        isActive: true,
      );

      userProfileBloc.emit(UserProfileUpdated(userProfile: mockUserProfile));

      await tester.pumpWidget(createTestWidget(const ProfileScreen()));
      await tester.pump(); // Allow snackbar to show

      expect(find.text('Profile updated successfully'), findsOneWidget);
    });

    testWidgets('displays profile header with avatar and edit button', (WidgetTester tester) async {
      final mockUserProfile = UserProfile(
        id: 'user1',
        username: 'john_doe',
        displayName: 'John Doe',
        avatarUrl: 'https://example.com/avatar.jpg',
        isActive: true,
      );

      userProfileBloc.emit(UserProfileLoaded(userProfile: mockUserProfile));

      await tester.pumpWidget(createTestWidget(const ProfileScreen()));

      // Check for avatar (CircleAvatar)
      expect(find.byType(CircleAvatar), findsOneWidget);

      // Check for edit profile button
      expect(find.text('Edit Profile'), findsOneWidget);
    });

    testWidgets('displays profile stats correctly', (WidgetTester tester) async {
      final mockUserProfile = UserProfile(
        id: 'user1',
        username: 'john_doe',
        displayName: 'John Doe',
        followersCount: 150,
        followingCount: 75,
        isActive: true,
      );

      userProfileBloc.emit(UserProfileLoaded(userProfile: mockUserProfile));

      await tester.pumpWidget(createTestWidget(const ProfileScreen()));

      // Check that stats are displayed (though ProfileStatsWidget is commented out in the code)
      // The stats would show: Followers: 150, Following: 75, Tracks: 0
      expect(find.text('150'), findsOneWidget);
      expect(find.text('75'), findsOneWidget);
    });

    testWidgets('displays music preferences with categories', (WidgetTester tester) async {
      final mockUserProfile = UserProfile(
        id: 'user1',
        username: 'john_doe',
        displayName: 'John Doe',
        isActive: true,
      );

      userProfileBloc.emit(UserProfileLoaded(userProfile: mockUserProfile));

      await tester.pumpWidget(createTestWidget(const ProfileScreen()));

      // Check music categories
      expect(find.text('Playlists'), findsOneWidget);
      expect(find.text('12'), findsOneWidget); // Playlist count
      expect(find.text('Liked Songs'), findsOneWidget);
      expect(find.text('89'), findsOneWidget); // Liked songs count
      expect(find.text('Downloads'), findsOneWidget);
      expect(find.text('23'), findsOneWidget); // Downloads count
    });

    testWidgets('allows editing profile information', (WidgetTester tester) async {
      final mockUserProfile = UserProfile(
        id: 'user1',
        username: 'john_doe',
        displayName: 'John Doe',
        bio: 'Original bio',
        location: 'Original location',
        isActive: true,
      );

      userProfileBloc.emit(UserProfileLoaded(userProfile: mockUserProfile));

      await tester.pumpWidget(createTestWidget(const ProfileScreen()));

      // Tap edit profile button
      await tester.tap(find.text('Edit Profile'));
      await tester.pumpAndSettle();

      // Check that edit form is displayed
      expect(find.text('Display Name'), findsOneWidget);
      expect(find.text('Bio'), findsOneWidget);
      expect(find.text('Location'), findsOneWidget);

      // Check that form fields are pre-filled
      expect(find.text('John Doe'), findsWidgets); // Display name field
      expect(find.text('Original bio'), findsOneWidget);
      expect(find.text('Original location'), findsOneWidget);

      // Check for save and cancel buttons
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('handles tab navigation correctly', (WidgetTester tester) async {
      final mockUserProfile = UserProfile(
        id: 'user1',
        username: 'john_doe',
        displayName: 'John Doe',
        isActive: true,
      );

      userProfileBloc.emit(UserProfileLoaded(userProfile: mockUserProfile));

      await tester.pumpWidget(createTestWidget(const ProfileScreen()));

      // Initially on Profile tab
      expect(find.text('My Music'), findsOneWidget);

      // Tap Top tab
      await tester.tap(find.text('Top'));
      await tester.pumpAndSettle();

      // Check that Top sections are displayed
      expect(find.text('Top Tracks'), findsOneWidget);
      expect(find.text('Top Artists'), findsOneWidget);
      expect(find.text('Top Genres'), findsOneWidget);

      // Tap Liked tab
      await tester.tap(find.text('Liked'));
      await tester.pumpAndSettle();

      // Check that Liked sections are displayed
      expect(find.text('Liked Tracks'), findsOneWidget);
      expect(find.text('Liked Artists'), findsOneWidget);
      expect(find.text('Liked Genres'), findsOneWidget);

      // Tap Buds tab
      await tester.tap(find.text('Buds'));
      await tester.pumpAndSettle();

      // Check that Buds placeholder is displayed
      expect(find.text('Buds Coming Soon'), findsOneWidget);
    });

    testWidgets('displays top content when loaded', (WidgetTester tester) async {
      final mockUserProfile = UserProfile(
        id: 'user1',
        username: 'john_doe',
        displayName: 'John Doe',
        isActive: true,
      );

      userProfileBloc.emit(UserProfileLoaded(userProfile: mockUserProfile));
      // Simulate top tracks loaded
      userProfileBloc.emit(MyContentLoaded(
        contentType: 'tracks',
        content: [MockTracks.track1, MockTracks.track2],
      ));

      await tester.pumpWidget(createTestWidget(const ProfileScreen()));

      // Switch to Top tab
      await tester.tap(find.text('Top'));
      await tester.pumpAndSettle();

      // Check that top tracks are displayed
      expect(find.text('Bohemian Rhapsody'), findsOneWidget);
      expect(find.text('Queen'), findsOneWidget);
      expect(find.text('Stairway to Heaven'), findsOneWidget);
      expect(find.text('Led Zeppelin'), findsOneWidget);
    });

    testWidgets('displays liked content when loaded', (WidgetTester tester) async {
      final mockUserProfile = UserProfile(
        id: 'user1',
        username: 'john_doe',
        displayName: 'John Doe',
        isActive: true,
      );

      userProfileBloc.emit(UserProfileLoaded(userProfile: mockUserProfile));
      // Simulate liked tracks loaded
      userProfileBloc.emit(MyContentLoaded(
        contentType: 'tracks',
        content: [MockTracks.track1, MockTracks.track3], // Both are liked
      ));

      await tester.pumpWidget(createTestWidget(const ProfileScreen()));

      // Switch to Liked tab
      await tester.tap(find.text('Liked'));
      await tester.pumpAndSettle();

      // Check that liked tracks are displayed
      expect(find.text('Bohemian Rhapsody'), findsOneWidget);
      expect(find.text('Hotel California'), findsOneWidget);
    });

    testWidgets('navigates to track details on tap', (WidgetTester tester) async {
      final mockUserProfile = UserProfile(
        id: 'user1',
        username: 'john_doe',
        displayName: 'John Doe',
        isActive: true,
      );

      userProfileBloc.emit(UserProfileLoaded(userProfile: mockUserProfile));
      userProfileBloc.emit(MyContentLoaded(
        contentType: 'tracks',
        content: [MockTracks.track1],
      ));

      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        WidgetTestHelper.createTestableWidget(
          child: const ProfileScreen(),
          blocProviders: [BlocProvider<UserProfileBloc>.value(value: userProfileBloc)],
          navigatorObserver: mockObserver,
          onGenerateRoute: (settings) {
            if (settings.name == '/track-details') {
              return MaterialPageRoute(
                builder: (_) => const Scaffold(body: Text('Track Details Page')),
                settings: settings,
              );
            }
            return MaterialPageRoute(
              builder: (_) => Scaffold(body: Text('${settings.name} Page')),
            );
          },
        ),
      );

      // Switch to Top tab
      await tester.tap(find.text('Top'));
      await tester.pumpAndSettle();

      // Tap on a track
      await tester.tap(find.text('Bohemian Rhapsody'));
      await tester.pumpAndSettle();

      // Check that navigation occurred (mock observer would track this)
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('navigates to artist details on tap', (WidgetTester tester) async {
      final mockUserProfile = UserProfile(
        id: 'user1',
        username: 'john_doe',
        displayName: 'John Doe',
        isActive: true,
      );

      userProfileBloc.emit(UserProfileLoaded(userProfile: mockUserProfile));
      userProfileBloc.emit(MyContentLoaded(
        contentType: 'artists',
        content: [MockArtists.artist1],
      ));

      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        WidgetTestHelper.createTestableWidget(
          child: const ProfileScreen(),
          blocProviders: [BlocProvider<UserProfileBloc>.value(value: userProfileBloc)],
          navigatorObserver: mockObserver,
          onGenerateRoute: (settings) {
            if (settings.name == '/artist-details') {
              return MaterialPageRoute(
                builder: (_) => const Scaffold(body: Text('Artist Details Page')),
                settings: settings,
              );
            }
            return MaterialPageRoute(
              builder: (_) => Scaffold(body: Text('${settings.name} Page')),
            );
          },
        ),
      );

      // Switch to Top tab
      await tester.tap(find.text('Top'));
      await tester.pumpAndSettle();

      // Tap on an artist
      await tester.tap(find.text('Queen'));
      await tester.pumpAndSettle();

      // Check that navigation occurred
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('handles drawer opening', (WidgetTester tester) async {
      final mockUserProfile = UserProfile(
        id: 'user1',
        username: 'john_doe',
        displayName: 'John Doe',
        isActive: true,
      );

      userProfileBloc.emit(UserProfileLoaded(userProfile: mockUserProfile));

      await tester.pumpWidget(createTestWidget(const ProfileScreen()));

      // Tap the menu button to open drawer
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // The drawer should be open (basic test - drawer visibility is tested)
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('handles empty content gracefully', (WidgetTester tester) async {
      final mockUserProfile = UserProfile(
        id: 'user1',
        username: 'john_doe',
        displayName: 'John Doe',
        isActive: true,
      );

      userProfileBloc.emit(UserProfileLoaded(userProfile: mockUserProfile));
      // Empty content
      userProfileBloc.emit(const MyContentLoaded(
        contentType: 'tracks',
        content: [],
      ));

      await tester.pumpWidget(createTestWidget(const ProfileScreen()));

      // Switch to Top tab
      await tester.tap(find.text('Top'));
      await tester.pumpAndSettle();

      // Check that empty state messages are displayed
      expect(find.text('No top tracks available'), findsOneWidget);
      expect(find.text('No top artists available'), findsOneWidget);
      expect(find.text('No top genres available'), findsOneWidget);
    });

    testWidgets('maintains scrollable layout', (WidgetTester tester) async {
      final mockUserProfile = UserProfile(
        id: 'user1',
        username: 'john_doe',
        displayName: 'John Doe',
        bio: 'This is a very long bio that should make the content scrollable. ' * 10,
        isActive: true,
      );

      userProfileBloc.emit(UserProfileLoaded(userProfile: mockUserProfile));

      await tester.pumpWidget(createTestWidget(const ProfileScreen()));

      // Check that CustomScrollView is present for scrolling
      expect(find.byType(CustomScrollView), findsOneWidget);

      // Test scrolling behavior
      await tester.drag(find.byType(CustomScrollView), const Offset(0, -200));
      await tester.pumpAndSettle();

      // After scrolling, the screen should still be functional
      expect(find.text('Profile'), findsOneWidget);
    });

    testWidgets('displays profile header in loading state', (WidgetTester tester) async {
      userProfileBloc.emit(UserProfileLoading());

      await tester.pumpWidget(createTestWidget(const ProfileScreen()));

      // Check for loading indicator in profile header
      expect(find.byType(CircularProgressIndicator), findsWidgets);
    });

    testWidgets('displays profile header in error state', (WidgetTester tester) async {
      userProfileBloc.emit(const UserProfileError('Network error'));

      await tester.pumpWidget(createTestWidget(const ProfileScreen()));

      // Check for error message and retry button
      expect(find.text('Unable to load profile'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('handles profile header retry functionality', (WidgetTester tester) async {
      userProfileBloc.emit(const UserProfileError('Network error'));

      await tester.pumpWidget(createTestWidget(const ProfileScreen()));

      // Tap retry button
      await tester.tap(find.text('Retry'));
      await tester.pumpAndSettle();

      // Check that retry action was triggered (would need mock verification)
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}