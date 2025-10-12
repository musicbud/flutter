import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musicbud_flutter/core/components/musicbud_components.dart';

void main() {
  group('MusicBud Components Tests', () {
    
    // ========================================================================
    // AVATAR TESTS
    // ========================================================================
    
    group('MusicBudAvatar', () {
      testWidgets('renders correctly with default size', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MusicBudAvatar(
                imageUrl: null,
              ),
            ),
          ),
        );

        expect(find.byType(MusicBudAvatar), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
      });

      testWidgets('renders with custom size', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MusicBudAvatar(
                imageUrl: null,
                size: 80,
              ),
            ),
          ),
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(MusicBudAvatar),
            matching: find.byType(Container),
          ).first,
        );
        
        expect(container.constraints?.minWidth, 80);
        expect(container.constraints?.minHeight, 80);
      });

      testWidgets('renders with border when hasBorder is true', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MusicBudAvatar(
                imageUrl: null,
                hasBorder: true,
              ),
            ),
          ),
        );

        expect(find.byType(MusicBudAvatar), findsOneWidget);
      });

      testWidgets('calls onTap when tapped', (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MusicBudAvatar(
                imageUrl: null,
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(MusicBudAvatar));
        await tester.pump();

        expect(tapped, true);
      });

      testWidgets('displays default icon when no image URL', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MusicBudAvatar(
                imageUrl: null,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.person), findsOneWidget);
      });
    });

    // ========================================================================
    // CONTENT CARD TESTS
    // ========================================================================

    group('ContentCard', () {
      testWidgets('renders with title and subtitle', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ContentCard(
                imageUrl: null,
                title: 'Test Track',
                subtitle: 'Test Artist',
              ),
            ),
          ),
        );

        expect(find.text('Test Track'), findsOneWidget);
        expect(find.text('Test Artist'), findsOneWidget);
      });

      testWidgets('renders with custom dimensions', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ContentCard(
                imageUrl: null,
                title: 'Test',
                subtitle: 'Test',
                width: 150,
                height: 200,
              ),
            ),
          ),
        );

        expect(find.byType(ContentCard), findsOneWidget);
      });

      testWidgets('calls onTap when tapped', (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ContentCard(
                imageUrl: null,
                title: 'Test',
                subtitle: 'Test',
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(ContentCard));
        await tester.pump();

        expect(tapped, true);
      });

      testWidgets('displays tag widget when provided', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ContentCard(
                imageUrl: null,
                title: 'Test',
                subtitle: 'Test',
                tag: Container(
                  child: const Text('NEW'),
                ),
              ),
            ),
          ),
        );

        expect(find.text('NEW'), findsOneWidget);
      });

      testWidgets('displays default icon when no image', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: ContentCard(
                imageUrl: null,
                title: 'Test',
                subtitle: 'Test',
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.music_note), findsOneWidget);
      });
    });

    // ========================================================================
    // HERO CARD TESTS
    // ========================================================================

    group('HeroCard', () {
      testWidgets('renders with title and subtitle', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: HeroCard(
                imageUrl: null,
                title: 'Discover New Music',
                subtitle: 'Trending this week',
              ),
            ),
          ),
        );

        expect(find.text('Discover New Music'), findsOneWidget);
        expect(find.text('Trending this week'), findsOneWidget);
      });

      testWidgets('displays play button', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: HeroCard(
                imageUrl: null,
                title: 'Test',
                subtitle: 'Test',
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.play_arrow), findsOneWidget);
      });

      testWidgets('displays save button', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: HeroCard(
                imageUrl: null,
                title: 'Test',
                subtitle: 'Test',
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.bookmark_outline), findsOneWidget);
      });

      testWidgets('calls onPlayTap when play button tapped', (WidgetTester tester) async {
        bool playTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: HeroCard(
                imageUrl: null,
                title: 'Test',
                subtitle: 'Test',
                onPlayTap: () {
                  playTapped = true;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.play_arrow));
        await tester.pump();

        expect(playTapped, true);
      });

      testWidgets('calls onSaveTap when save button tapped', (WidgetTester tester) async {
        bool saveTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: HeroCard(
                imageUrl: null,
                title: 'Test',
                subtitle: 'Test',
                onSaveTap: () {
                  saveTapped = true;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.bookmark_outline));
        await tester.pump();

        expect(saveTapped, true);
      });
    });

    // ========================================================================
    // BUTTON TESTS
    // ========================================================================

    group('MusicBudButton', () {
      testWidgets('renders with text', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MusicBudButton(
                text: 'Click Me',
              ),
            ),
          ),
        );

        expect(find.text('Click Me'), findsOneWidget);
      });

      testWidgets('renders as elevated button by default', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MusicBudButton(
                text: 'Test',
              ),
            ),
          ),
        );

        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('renders as outlined button when isOutlined is true', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MusicBudButton(
                text: 'Test',
                isOutlined: true,
              ),
            ),
          ),
        );

        expect(find.byType(OutlinedButton), findsOneWidget);
      });

      testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
        bool pressed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MusicBudButton(
                text: 'Test',
                onPressed: () {
                  pressed = true;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(MusicBudButton));
        await tester.pump();

        expect(pressed, true);
      });

      testWidgets('renders with icon when provided', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MusicBudButton(
                text: 'Test',
                icon: Icons.music_note,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.music_note), findsOneWidget);
      });

      testWidgets('is disabled when onPressed is null', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MusicBudButton(
                text: 'Test',
                onPressed: null,
              ),
            ),
          ),
        );

        final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
        expect(button.onPressed, isNull);
      });
    });

    // ========================================================================
    // CATEGORY TAB TESTS
    // ========================================================================

    group('CategoryTab', () {
      testWidgets('renders with label', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CategoryTab(
                label: 'Music',
                isSelected: false,
              ),
            ),
          ),
        );

        expect(find.text('Music'), findsOneWidget);
      });

      testWidgets('applies selected styling when isSelected is true', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: CategoryTab(
                label: 'Music',
                isSelected: true,
              ),
            ),
          ),
        );

        expect(find.byType(CategoryTab), findsOneWidget);
      });

      testWidgets('calls onTap when tapped', (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CategoryTab(
                label: 'Music',
                isSelected: false,
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(CategoryTab));
        await tester.pump();

        expect(tapped, true);
      });
    });

    // ========================================================================
    // BOTTOM NAVIGATION TESTS
    // ========================================================================

    group('MusicBudBottomNav', () {
      testWidgets('renders all navigation items', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MusicBudBottomNav(
                currentIndex: 0,
                onTap: (index) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.home_outlined), findsOneWidget);
        expect(find.byIcon(Icons.search_outlined), findsOneWidget);
        expect(find.byIcon(Icons.headphones_outlined), findsOneWidget);
        expect(find.byIcon(Icons.chat_bubble_outline), findsOneWidget);
      });

      testWidgets('calls onTap with correct index', (WidgetTester tester) async {
        int tappedIndex = -1;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MusicBudBottomNav(
                currentIndex: 0,
                onTap: (index) {
                  tappedIndex = index;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.search_outlined));
        await tester.pump();

        expect(tappedIndex, 1);
      });

      testWidgets('highlights selected item', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MusicBudBottomNav(
                currentIndex: 2,
                onTap: (index) {},
              ),
            ),
          ),
        );

        expect(find.byType(MusicBudBottomNav), findsOneWidget);
      });
    });

    // ========================================================================
    // MESSAGE LIST ITEM TESTS
    // ========================================================================

    group('MessageListItem', () {
      testWidgets('renders with name and message', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MessageListItem(
                name: 'John Doe',
                message: 'Hello there!',
              ),
            ),
          ),
        );

        expect(find.text('John Doe'), findsOneWidget);
        expect(find.text('Hello there!'), findsOneWidget);
      });

      testWidgets('displays avatar', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MessageListItem(
                name: 'John Doe',
                message: 'Hello!',
              ),
            ),
          ),
        );

        expect(find.byType(MusicBudAvatar), findsOneWidget);
      });

      testWidgets('shows notification badge when hasNewMessage is true', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: MessageListItem(
                name: 'John Doe',
                message: 'Hello!',
                hasNewMessage: true,
              ),
            ),
          ),
        );

        expect(find.byType(MessageListItem), findsOneWidget);
      });

      testWidgets('calls onTap when tapped', (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: MessageListItem(
                name: 'John Doe',
                message: 'Hello!',
                onTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(MessageListItem));
        await tester.pump();

        expect(tapped, true);
      });
    });

    // ========================================================================
    // SECTION HEADER TESTS
    // ========================================================================

    group('SectionHeader', () {
      testWidgets('renders with title', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SectionHeader(
                title: 'Trending Now',
              ),
            ),
          ),
        );

        expect(find.text('Trending Now'), findsOneWidget);
      });

      testWidgets('displays see all button when onSeeAllTap is provided', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SectionHeader(
                title: 'Trending Now',
                onSeeAllTap: () {},
              ),
            ),
          ),
        );

        expect(find.text('See all'), findsOneWidget);
      });

      testWidgets('calls onSeeAllTap when see all button tapped', (WidgetTester tester) async {
        bool tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SectionHeader(
                title: 'Trending Now',
                onSeeAllTap: () {
                  tapped = true;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text('See all'));
        await tester.pump();

        expect(tapped, true);
      });

      testWidgets('does not display see all button when onSeeAllTap is null', (WidgetTester tester) async {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: SectionHeader(
                title: 'Trending Now',
              ),
            ),
          ),
        );

        expect(find.text('See all'), findsNothing);
      });
    });
  });
}
