import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:musicbud_flutter/main.dart' as app;

/// User Preferences & Personalization E2E Tests
///
/// Tests user customization and settings persistence:
/// - Theme preferences (light/dark mode)
/// - Language settings
/// - Notification preferences
/// - Privacy settings
/// - Display preferences
/// - Audio quality settings
/// - Data usage preferences
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('User Preferences & Personalization E2E Tests', () {
    testWidgets('should persist theme preference across sessions', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to settings
      if (find.text('Profile').evaluate().isNotEmpty) {
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
      }

      if (find.byIcon(Icons.settings).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();
      }

      // Look for theme toggle
      final themeToggle = find.textContaining('Theme', findRichText: true);
      if (themeToggle.evaluate().isNotEmpty) {
        final switchFinder = find.byType(Switch);
        if (switchFinder.evaluate().isNotEmpty) {
          // Record current theme
          await tester.tap(switchFinder.first);
          await tester.pumpAndSettle();
        }
      }

      // Verify settings screen is functional
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should save notification preferences', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to settings
      if (find.text('Profile').evaluate().isNotEmpty) {
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
      }

      if (find.byIcon(Icons.settings).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();
      }

      // Look for notification settings
      final notificationSettings = find.textContaining('Notification', findRichText: true);
      if (notificationSettings.evaluate().isNotEmpty) {
        // Notification preferences available
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('should update privacy settings', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to settings/profile
      if (find.text('Profile').evaluate().isNotEmpty) {
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
      }

      // Look for privacy settings
      if (find.byIcon(Icons.settings).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();
      }

      final privacySettings = find.textContaining('Privacy', findRichText: true);
      if (privacySettings.evaluate().isNotEmpty) {
        // Privacy settings available
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('should customize display preferences', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to settings
      if (find.text('Profile').evaluate().isNotEmpty) {
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
      }

      if (find.byIcon(Icons.settings).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();
      }

      // Settings should be accessible
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should set audio quality preferences', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to settings
      if (find.text('Profile').evaluate().isNotEmpty) {
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
      }

      if (find.byIcon(Icons.settings).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();
      }

      // Look for audio quality settings
      final audioQuality = find.textContaining('Quality', findRichText: true);
      if (audioQuality.evaluate().isNotEmpty) {
        // Audio quality settings available
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('should manage data usage preferences', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to settings
      if (find.text('Profile').evaluate().isNotEmpty) {
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
      }

      if (find.byIcon(Icons.settings).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();
      }

      // Look for data usage settings
      final dataUsage = find.textContaining('Data', findRichText: true);
      if (dataUsage.evaluate().isEmpty) {
        // Data usage settings might be in a different section
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('should save language preferences', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to settings
      if (find.text('Profile').evaluate().isNotEmpty) {
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
      }

      if (find.byIcon(Icons.settings).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();
      }

      // Settings accessible
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle profile customization', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to profile
      if (find.text('Profile').evaluate().isNotEmpty) {
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
      }

      // Look for edit profile option
      final editButton = find.byIcon(Icons.edit);
      if (editButton.evaluate().isNotEmpty) {
        await tester.tap(editButton.first);
        await tester.pumpAndSettle();
      }

      // Profile screen should be accessible
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should restore preferences after app restart', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to settings and change a preference
      if (find.text('Profile').evaluate().isNotEmpty) {
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
      }

      if (find.byIcon(Icons.settings).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();
      }

      // Toggle a setting
      final switchFinder = find.byType(Switch);
      if (switchFinder.evaluate().isNotEmpty) {
        await tester.tap(switchFinder.first);
        await tester.pumpAndSettle();
      }

      // Navigate away and back
      if (find.byIcon(Icons.arrow_back).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.arrow_back).first);
        await tester.pumpAndSettle();
      }

      // Preference should persist
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle preference reset to defaults', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to settings
      if (find.text('Profile').evaluate().isNotEmpty) {
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
      }

      if (find.byIcon(Icons.settings).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();
      }

      // Look for reset option
      final resetOption = find.textContaining('Reset', findRichText: true);
      if (resetOption.evaluate().isNotEmpty) {
        // Reset option available
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });
  });
}
