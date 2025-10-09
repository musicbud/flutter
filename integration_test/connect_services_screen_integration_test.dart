import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// App imports
import 'package:musicbud_flutter/presentation/screens/connect/connect_services_screen.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('ConnectServicesScreen Integration Tests', () {
    testWidgets('ConnectServicesScreen renders correctly',
        (WidgetTester tester) async {
      // Arrange
      final testApp = MaterialApp(
        theme: DesignSystem.darkTheme,
        home: const ConnectServicesScreen(),
      );

      // Act
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ConnectServicesScreen), findsOneWidget);
      expect(find.text('Connect Services'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('ConnectServicesScreen displays all service cards correctly',
        (WidgetTester tester) async {
      // Arrange
      final testApp = MaterialApp(
        theme: DesignSystem.darkTheme,
        home: const ConnectServicesScreen(),
      );

      // Act
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Assert - Check for all service cards
      expect(find.text('Spotify'), findsWidgets); // Appears in service card and connected services
      expect(find.text('Connect your Spotify account to control playback and access your music library.'), findsOneWidget);

      expect(find.text('YouTube Music'), findsOneWidget);
      expect(find.text('Link your YouTube Music account for seamless music streaming.'), findsOneWidget);

      expect(find.text('Last.fm'), findsOneWidget);
      expect(find.text('Connect Last.fm to track your listening habits and discover new music.'), findsOneWidget);

      expect(find.text('MyAnimeList'), findsOneWidget);
      expect(find.text('Link your MyAnimeList account to share your anime preferences.'), findsOneWidget);
    });

    testWidgets('ConnectServicesScreen displays service icons correctly',
        (WidgetTester tester) async {
      // Arrange
      final testApp = MaterialApp(
        theme: DesignSystem.darkTheme,
        home: const ConnectServicesScreen(),
      );

      // Act
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Assert - Check for service icons
      expect(find.byIcon(Icons.music_note), findsWidgets); // Spotify
      expect(find.byIcon(Icons.play_circle_filled), findsOneWidget); // YouTube Music
      expect(find.byIcon(Icons.radio), findsOneWidget); // Last.fm
      expect(find.byIcon(Icons.tv), findsOneWidget); // MyAnimeList
    });

    testWidgets('ConnectServicesScreen displays connect buttons correctly',
        (WidgetTester tester) async {
      // Arrange
      final testApp = MaterialApp(
        theme: DesignSystem.darkTheme,
        home: const ConnectServicesScreen(),
      );

      // Act
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Assert - Check for connect buttons
      expect(find.text('Connect'), findsNWidgets(4)); // One for each service
    });

    testWidgets('ConnectServicesScreen displays connected services section',
        (WidgetTester tester) async {
      // Arrange
      final testApp = MaterialApp(
        theme: DesignSystem.darkTheme,
        home: const ConnectServicesScreen(),
      );

      // Act
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Assert - Check for connected services section
      expect(find.text('Connected Services'), findsOneWidget);
      expect(find.text('Spotify'), findsNWidgets(2)); // One in service card, one in connected services
      expect(find.text('Connected'), findsOneWidget);
      expect(find.text('Manage'), findsOneWidget);
    });

    testWidgets('ConnectServicesScreen displays proper service card layout',
        (WidgetTester tester) async {
      // Arrange
      final testApp = MaterialApp(
        theme: DesignSystem.darkTheme,
        home: const ConnectServicesScreen(),
      );

      // Act
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Assert - Check card structure
      expect(find.byType(Card), findsNWidgets(5)); // 4 service cards + 1 connected service card
    });

    testWidgets('ConnectServicesScreen handles scrolling correctly',
        (WidgetTester tester) async {
      // Arrange
      final testApp = MaterialApp(
        theme: DesignSystem.darkTheme,
        home: const ConnectServicesScreen(),
      );

      // Act
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Scroll to bottom
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();

      // Assert - Should be able to scroll and find bottom content
      expect(find.text('Connected Services'), findsOneWidget);
      expect(find.text('Manage'), findsOneWidget);
    });

    testWidgets('ConnectServicesScreen displays all UI components correctly',
        (WidgetTester tester) async {
      // Arrange
      final testApp = MaterialApp(
        theme: DesignSystem.darkTheme,
        home: const ConnectServicesScreen(),
      );

      // Act
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Assert - Check for all major UI components
      expect(find.byType(ConnectServicesScreen), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(5));
      expect(find.byType(Container), findsWidgets); // For service icons
    });
  });
}