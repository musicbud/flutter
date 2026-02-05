import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';
import 'package:musicbud_flutter/presentation/components/music_card.dart';

void main() {
  group('MusicCard', () {
    const song = MusicCardData(
      id: '1',
      artistName: 'Test Artist',
      songTitle: 'Test Song',
    );

    testWidgets('renders correctly with given song data', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: DesignSystem.darkTheme,
          home: Scaffold(
            body: MusicCard(
              song: song,
              onTap: () {},
              onLikeToggle: (_) {},
            ),
          ),
        ),
      );

      // Verify that the song title and artist name are displayed
      expect(find.text('Test Song'), findsOneWidget);
      expect(find.text('Test Artist'), findsOneWidget);

      // Verify the default icon is present
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('like button toggles state and color', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: DesignSystem.darkTheme,
          home: Scaffold(
            body: MusicCard(
              song: song,
              onTap: () {},
              onLikeToggle: (_) {},
            ),
          ),
        ),
      );

      // Initial state: not liked
      Icon likeIcon = tester.widget(find.byIcon(Icons.favorite_border));
      expect(likeIcon.color, DesignSystem.onSurfaceVariant);

      // Tap the like button
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Verify the state has changed to liked
      likeIcon = tester.widget(find.byIcon(Icons.favorite));
      expect(likeIcon.color, DesignSystem.pinkAccent);
      expect(find.byIcon(Icons.favorite_border), findsNothing);

      // Tap again to unlike
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      // Verify the state is back to not liked
      likeIcon = tester.widget(find.byIcon(Icons.favorite_border));
      expect(likeIcon.color, DesignSystem.onSurfaceVariant);
      expect(find.byIcon(Icons.favorite), findsNothing);
    });

    testWidgets('uses colors from the design system', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: DesignSystem.darkTheme,
          home: Scaffold(
            body: MusicCard(
              song: song,
              onTap: () {},
              onLikeToggle: (_) {},
            ),
          ),
        ),
      );

      // Verify background color
      final container = tester.widget<Container>(find.descendant(
        of: find.byType(MusicCard),
        matching: find.byType(Container),
      ).first);
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, DesignSystem.surfaceContainer);

      // Verify text colors
      final title = tester.widget<Text>(find.text('Test Song'));
      expect(title.style?.color, DesignSystem.onSurface);

      final artist = tester.widget<Text>(find.text('Test Artist'));
      expect(artist.style?.color, DesignSystem.onSurfaceVariant);
    });
  });
}
