import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musicbud_flutter/blocs/user_profile/user_profile_bloc.dart';
import 'package:musicbud_flutter/models/user_profile.dart';
import 'package:musicbud_flutter/presentation/screens/home/home_header_widget.dart';
import 'package:musicbud_flutter/presentation/screens/home/home_quick_actions.dart';
import 'package:musicbud_flutter/presentation/screens/home/home_recommendations.dart';
import 'package:musicbud_flutter/presentation/screens/home/home_recent_activity.dart';
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

  group('HomeHeaderWidget', () {
    testWidgets('displays loading state', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(HomeHeaderWidget()));

      // Check that loading text is shown
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('displays user profile when loaded', (WidgetTester tester) async {
      final userProfile = UserProfile(
        id: '1',
        username: 'testuser',
        displayName: 'Test User',
        email: 'test@example.com',
        avatarUrl: 'https://example.com/avatar.jpg',
        isActive: true,
      );

      userProfileBloc.emit(UserProfileLoaded(userProfile: userProfile));

      await tester.pumpWidget(createTestWidget(HomeHeaderWidget()));

      // Check that user name is displayed
      expect(find.text('Test User'), findsOneWidget);
      expect(find.text('Welcome back!'), findsOneWidget);
    });
  });

  group('HomeQuickActions', () {
    testWidgets('renders all quick action buttons', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(HomeQuickActions()));

      // Check for all quick action buttons
      expect(find.text('Discover'), findsOneWidget);
      expect(find.text('My Library'), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
      expect(find.text('Find Buds'), findsOneWidget);
      expect(find.text('Connect Services'), findsOneWidget);
    });

    testWidgets('navigates on quick action tap', (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        WidgetTestHelper.createTestableWidget(
          child: HomeQuickActions(),
          blocProviders: [BlocProvider<UserProfileBloc>.value(value: userProfileBloc)],
          navigatorObserver: mockObserver,
          onGenerateRoute: (settings) {
            return MaterialPageRoute(
              builder: (_) => Scaffold(body: Text('${settings.name} Page')),
              settings: settings,
            );
          },
        ),
      );

      // Test Discover action
      await WidgetTestHelper.tapByText(tester, 'Discover');
      expect(mockObserver.pushedRoutes.any((route) => route?.settings.name == '/discover'), true);
    });
  });

  group('HomeRecommendations', () {
    testWidgets('displays recommendations when tracks are loaded', (WidgetTester tester) async {
      userProfileBloc.emit(MyContentLoaded(
        contentType: 'tracks',
        content: MockTracks.allTracks,
      ));

      await tester.pumpWidget(createTestWidget(HomeRecommendations()));

      // Check that recommendations section is shown
      expect(find.text('Your Liked Songs'), findsOneWidget);
      expect(find.text('Bohemian Rhapsody'), findsOneWidget);
    });

    testWidgets('displays top artists when artists are loaded', (WidgetTester tester) async {
      userProfileBloc.emit(MyContentLoaded(
        contentType: 'artists',
        content: MockArtists.allArtists,
      ));

      await tester.pumpWidget(createTestWidget(HomeRecommendations()));

      // Check that top artists section is shown
      expect(find.text('Your Top Artists'), findsOneWidget);
      expect(find.text('Queen'), findsOneWidget);
    });

    testWidgets('handles empty content', (WidgetTester tester) async {
      userProfileBloc.emit(MyContentLoaded(
        contentType: 'tracks',
        content: [],
      ));

      await tester.pumpWidget(createTestWidget(HomeRecommendations()));

      // Check that no recommendations are shown
      expect(find.text('Your Liked Songs'), findsNothing);
    });
  });

  group('HomeRecentActivity', () {
    testWidgets('displays recent activity when played tracks are loaded', (WidgetTester tester) async {
      userProfileBloc.emit(MyContentLoaded(
        contentType: 'played_tracks',
        content: MockTracks.allTracks,
      ));

      await tester.pumpWidget(createTestWidget(HomeRecentActivity()));

      // Check that recent activity section is shown
      expect(find.text('Recently Played'), findsOneWidget);
      expect(find.text('Bohemian Rhapsody'), findsOneWidget);
    });
  });

  group('HomeScreen Integration', () {
    testWidgets('renders complete home screen layout', (WidgetTester tester) async {
      // Mock the MainNavigationScaffold by testing the content directly
      final homeContent = Container(
        child: BlocListener<UserProfileBloc, UserProfileState>(
          listener: (context, state) {
            if (state is UserProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error: ${state.message}')),
              );
            }
          },
          child: Container(
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: HomeHeaderWidget()),
                  SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search for music, artists, or playlists...',
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 16)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: HomeQuickActions(),
                    ),
                  ),
                  SliverToBoxAdapter(child: SizedBox(height: 32)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [HomeRecommendations(), HomeRecentActivity()],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpWidget(createTestWidget(homeContent));

      // Check basic layout elements
      expect(find.text('Welcome back!'), findsOneWidget);
      expect(find.text('Search for music, artists, or playlists...'), findsOneWidget);
      expect(find.text('Discover'), findsOneWidget);
    });

    testWidgets('handles error state with snackbar', (WidgetTester tester) async {
      final homeContent = BlocListener<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Container(),
      );

      userProfileBloc.emit(UserProfileError('Test error'));

      await tester.pumpWidget(createTestWidget(Scaffold(body: homeContent)));
      await tester.pump(); // Allow snackbar to show

      expect(find.text('Error: Test error'), findsOneWidget);
    });
  });
}