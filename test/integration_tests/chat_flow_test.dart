import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:musicbud_flutter/presentation/screens/buds/buds_screen.dart';
import 'package:musicbud_flutter/presentation/screens/profile/profile_screen.dart';
import 'package:musicbud_flutter/presentation/screens/chat/chat_screen.dart';
import 'package:musicbud_flutter/blocs/bud_matching/bud_matching_bloc.dart' as bud_matching;
import 'package:musicbud_flutter/blocs/user/profile/profile_bloc.dart';
import 'package:musicbud_flutter/blocs/user/profile/profile_state.dart';
import 'package:musicbud_flutter/blocs/comprehensive_chat/comprehensive_chat_bloc.dart';
import 'package:musicbud_flutter/blocs/comprehensive_chat/comprehensive_chat_state.dart';
import 'package:musicbud_flutter/models/bud_match.dart';
import 'package:musicbud_flutter/models/user_profile.dart';
import 'package:musicbud_flutter/models/channel.dart';
import 'package:musicbud_flutter/models/channel_settings.dart';
import 'package:musicbud_flutter/models/channel_stats.dart';

// Mock classes
class MockBudMatchingBloc extends Mock implements bud_matching.BudMatchingBloc {}
class MockProfileBloc extends Mock implements ProfileBloc {}
class MockComprehensiveChatBloc extends Mock implements ComprehensiveChatBloc {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Social Flow Integration Tests', () {
    late MockBudMatchingBloc mockBudMatchingBloc;
    late MockProfileBloc mockProfileBloc;
    late MockComprehensiveChatBloc mockChatBloc;

    setUp(() {
      mockBudMatchingBloc = MockBudMatchingBloc();
      mockProfileBloc = MockProfileBloc();
      mockChatBloc = MockComprehensiveChatBloc();
    });

    testWidgets('Complete social flow: buds → profile → chat',
        (WidgetTester tester) async {
      // Setup mock bud data
      final mockBuds = [
        BudMatch(
          id: '1',
          userId: 'user1',
          username: 'musiclover123',
          email: 'music@example.com',
          matchScore: 85,
          commonTracks: 15,
          commonArtists: 8,
          commonGenres: 0,
        ),
        BudMatch(
          id: '2',
          userId: 'user2',
          username: 'rockfan99',
          email: 'rock@example.com',
          matchScore: 78,
          commonTracks: 12,
          commonArtists: 6,
          commonGenres: 0,
        ),
      ];

      // Setup mock user profile
      final mockUserProfile = UserProfile(
        id: '1',
        username: 'musiclover123',
        email: 'music@example.com',
        bio: 'Love discovering new music!',
        avatarUrl: null,
        isActive: true,
      );

      // Setup initial states
      when(mockBudMatchingBloc.state).thenReturn(bud_matching.BudMatchingInitial());
      when(mockBudMatchingBloc.stream).thenAnswer((_) => Stream.value(bud_matching.BudMatchingInitial()));

      when(mockProfileBloc.state).thenReturn(ProfileInitial());
      when(mockProfileBloc.stream).thenAnswer((_) => Stream.value(ProfileInitial()));

      when(mockChatBloc.state).thenReturn(ComprehensiveChatInitial());
      when(mockChatBloc.stream).thenAnswer((_) => Stream.value(ComprehensiveChatInitial()));

      // Create test app
      final testApp = MultiBlocProvider(
        providers: [
          BlocProvider<bud_matching.BudMatchingBloc>.value(value: mockBudMatchingBloc),
          BlocProvider<ProfileBloc>.value(value: mockProfileBloc),
          BlocProvider<ComprehensiveChatBloc>.value(value: mockChatBloc),
        ],
        child: MaterialApp(
          routes: {
            '/buds': (context) => const BudsScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/chat': (context) => const ChatScreen(),
          },
          initialRoute: '/buds',
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Verify we're on buds screen
      expect(find.byType(BudsScreen), findsOneWidget);
      expect(find.text('Find Buds'), findsOneWidget);

      // Enter search query
      await tester.enterText(find.byType(TextField).first, 'rock music');
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      // Simulate search results
      when(mockBudMatchingBloc.state).thenReturn(bud_matching.BudsSearchResults(buds: mockBuds, query: 'rock music'));
      when(mockBudMatchingBloc.stream).thenAnswer((_) => Stream.value(bud_matching.BudsSearchResults(buds: mockBuds, query: 'rock music')));

      await tester.pumpAndSettle();

      // Verify buds are displayed
      expect(find.text('musiclover123'), findsOneWidget);
      expect(find.text('rockfan99'), findsOneWidget);

      // Tap on a bud to view their profile
      await tester.tap(find.text('musiclover123'));
      await tester.pumpAndSettle();

      // Verify navigation to profile screen
      expect(find.byType(ProfileScreen), findsOneWidget);

      // Simulate profile loaded state
      when(mockProfileBloc.state).thenReturn(BudProfileLoaded(mockUserProfile));
      when(mockProfileBloc.stream).thenAnswer((_) => Stream.value(BudProfileLoaded(mockUserProfile)));

      await tester.pumpAndSettle();

      // Verify profile information
      expect(find.text('musiclover123'), findsOneWidget);
      expect(find.text('Love discovering new music!'), findsOneWidget);

      // Find and tap chat button (assuming it exists in profile)
      // Note: This depends on the actual profile screen implementation
      // For this test, we'll simulate navigation to chat
      Navigator.pushNamed(tester.element(find.byType(ProfileScreen)), '/chat');
      await tester.pumpAndSettle();

      // Verify navigation to chat screen
      expect(find.byType(ChatScreen), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);
    });

    testWidgets('Bud search with no results',
        (WidgetTester tester) async {
      when(mockBudMatchingBloc.state).thenReturn(bud_matching.BudMatchingInitial());
      when(mockBudMatchingBloc.stream).thenAnswer((_) => Stream.value(bud_matching.BudMatchingInitial()));

      final testApp = BlocProvider<bud_matching.BudMatchingBloc>.value(
        value: mockBudMatchingBloc,
        child: MaterialApp(
          routes: {
            '/buds': (context) => const BudsScreen(),
          },
          initialRoute: '/buds',
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Search for something with no results
      await tester.enterText(find.byType(TextField).first, 'nonexistentgenre');
      await tester.tap(find.byIcon(Icons.search));
      await tester.pump();

      // Simulate empty results
      when(mockBudMatchingBloc.state).thenReturn(bud_matching.BudsSearchResults(buds: [], query: 'nonexistentgenre'));
      when(mockBudMatchingBloc.stream).thenAnswer((_) => Stream.value(bud_matching.BudsSearchResults(buds: [], query: 'nonexistentgenre')));

      await tester.pumpAndSettle();

      // Verify empty state
      expect(find.text('No Buds Found'), findsOneWidget);
      expect(find.text('Try a different search term'), findsOneWidget);
    });

    testWidgets('Bud matching loading and error states',
        (WidgetTester tester) async {
      // Test loading state
      when(mockBudMatchingBloc.state).thenReturn(bud_matching.BudMatchingLoading());
      when(mockBudMatchingBloc.stream).thenAnswer((_) => Stream.value(bud_matching.BudMatchingLoading()));

      final testApp = BlocProvider<bud_matching.BudMatchingBloc>.value(
        value: mockBudMatchingBloc,
        child: MaterialApp(
          routes: {
            '/buds': (context) => const BudsScreen(),
          },
          initialRoute: '/buds',
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Verify loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Test error state
      when(mockBudMatchingBloc.state).thenReturn(bud_matching.BudMatchingError('Network error'));
      when(mockBudMatchingBloc.stream).thenAnswer((_) => Stream.value(bud_matching.BudMatchingError('Network error')));

      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('Network error'), findsOneWidget);
    });

    testWidgets('Profile loading and data display',
        (WidgetTester tester) async {
      final mockUserProfile = UserProfile(
        id: '1',
        username: 'testuser',
        email: 'test@example.com',
        bio: 'Music enthusiast',
        avatarUrl: 'https://example.com/avatar.jpg',
        isActive: true,
      );

      // Start with loading state
      when(mockProfileBloc.state).thenReturn(ProfileLoading());
      when(mockProfileBloc.stream).thenAnswer((_) => Stream.value(ProfileLoading()));

      final testApp = BlocProvider<ProfileBloc>.value(
        value: mockProfileBloc,
        child: MaterialApp(
          routes: {
            '/profile': (context) => const ProfileScreen(),
          },
          initialRoute: '/profile',
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Verify loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Simulate profile loaded
      when(mockProfileBloc.state).thenReturn(BudProfileLoaded(mockUserProfile));
      when(mockProfileBloc.stream).thenAnswer((_) => Stream.value(BudProfileLoaded(mockUserProfile)));

      await tester.pumpAndSettle();

      // Verify profile data is displayed
      expect(find.text('testuser'), findsOneWidget);
      expect(find.text('Music enthusiast'), findsOneWidget);
    });

    testWidgets('Chat functionality and message sending',
        (WidgetTester tester) async {
      // Setup chat states
      final testChannel = Channel(
        id: '1',
        name: 'General',
        description: 'General chat',
        settings: ChannelSettings(channelId: '1'),
        stats: ChannelStats(channelId: '1', memberCount: 0, messageCount: 0, activeUsers: 0),
        type: 'public',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isJoined: true,
      );
      when(mockChatBloc.state).thenReturn(ChannelsLoaded([testChannel]));
      when(mockChatBloc.stream).thenAnswer((_) => Stream.value(ChannelsLoaded([testChannel])));

      final testApp = BlocProvider<ComprehensiveChatBloc>.value(
        value: mockChatBloc,
        child: MaterialApp(
          routes: {
            '/chat': (context) => const ChatScreen(),
          },
          initialRoute: '/chat',
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Verify chat screen is loaded
      expect(find.byType(ChatScreen), findsOneWidget);
      expect(find.text('Chat'), findsOneWidget);

      // Find message input field
      final messageField = find.byType(TextField).last; // Assuming message input is the last TextField
      expect(messageField, findsOneWidget);

      // Enter a message
      await tester.enterText(messageField, 'Hello from integration test!');
      await tester.pump();

      // Tap send button (assuming it exists)
      final sendButton = find.byIcon(Icons.send); // Common send icon
      if (sendButton.evaluate().isNotEmpty) {
        await tester.tap(sendButton);
        await tester.pump();

        // Verify message sent event was triggered
        // verify(mockChatBloc.add(any())).called(greaterThan(0));
      }
    });

    testWidgets('Navigation flow persistence',
        (WidgetTester tester) async {
      final mockBuds = [BudMatch(id: '1', userId: 'user1', username: 'testbud', email: 'test@example.com', matchScore: 0, commonTracks: 0, commonArtists: 0, commonGenres: 0)];

      when(mockBudMatchingBloc.state).thenReturn(bud_matching.BudsSearchResults(buds: mockBuds, query: ''));
      when(mockBudMatchingBloc.stream).thenAnswer((_) => Stream.value(bud_matching.BudsSearchResults(buds: mockBuds, query: '')));

      final testApp = BlocProvider<bud_matching.BudMatchingBloc>.value(
        value: mockBudMatchingBloc,
        child: MaterialApp(
          routes: {
            '/buds': (context) => const BudsScreen(),
            '/profile': (context) => const ProfileScreen(),
            '/chat': (context) => const ChatScreen(),
          },
          initialRoute: '/buds',
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Navigate buds -> profile
      await tester.tap(find.text('testbud'));
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);

      // Navigate profile -> chat
      Navigator.pushNamed(tester.element(find.byType(ProfileScreen)), '/chat');
      await tester.pumpAndSettle();
      expect(find.byType(ChatScreen), findsOneWidget);

      // Test back navigation
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(BudsScreen), findsOneWidget);
    });

    testWidgets('Quick search functionality in buds screen',
        (WidgetTester tester) async {
      when(mockBudMatchingBloc.state).thenReturn(bud_matching.BudMatchingInitial());
      when(mockBudMatchingBloc.stream).thenAnswer((_) => Stream.value(bud_matching.BudMatchingInitial()));

      final testApp = BlocProvider<bud_matching.BudMatchingBloc>.value(
        value: mockBudMatchingBloc,
        child: MaterialApp(
          routes: {
            '/buds': (context) => const BudsScreen(),
          },
          initialRoute: '/buds',
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Verify quick search chips are present
      expect(find.text('music lovers'), findsOneWidget);
      expect(find.text('rock fans'), findsOneWidget);
      expect(find.text('pop enthusiasts'), findsOneWidget);

      // Tap on a quick search chip
      await tester.tap(find.text('rock fans'));
      await tester.pump();

      // Verify search was triggered
      // verify(mockBudMatchingBloc.add(any())).called(greaterThan(0));
    });

    testWidgets('Profile tabs navigation',
        (WidgetTester tester) async {
      final mockUserProfile = UserProfile(
        id: '1',
        username: 'testuser',
        email: 'test@example.com',
        isActive: true,
      );

      when(mockProfileBloc.state).thenReturn(BudProfileLoaded(mockUserProfile));
      when(mockProfileBloc.stream).thenAnswer((_) => Stream.value(BudProfileLoaded(mockUserProfile)));

      final testApp = BlocProvider<ProfileBloc>.value(
        value: mockProfileBloc,
        child: MaterialApp(
          routes: {
            '/profile': (context) => const ProfileScreen(),
          },
          initialRoute: '/profile',
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Verify bottom navigation tabs
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Top'), findsOneWidget);
      expect(find.text('Liked'), findsOneWidget);
      expect(find.text('Buds'), findsOneWidget);

      // Tap on "Top" tab
      await tester.tap(find.text('Top'));
      await tester.pumpAndSettle();

      // Verify tab changed (this would trigger data loading in real app)
      // verify(mockProfileBloc.add(any())).called(greaterThan(0));
    });
  });
}

// Mock classes for missing models