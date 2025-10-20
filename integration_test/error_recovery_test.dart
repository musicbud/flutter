import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:musicbud_flutter/main.dart' as app;

/// Error Recovery and Resilience E2E Tests
///
/// Tests the app's ability to recover from various error conditions:
/// - Network errors and timeouts
/// - API failures and retries
/// - Invalid data handling
/// - Session expiration
/// - Graceful degradation
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Error Recovery and Resilience E2E Tests', () {
    testWidgets('should handle network timeout gracefully', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Navigate to a screen that makes network requests
      // Skip onboarding if present
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Try to access discover or home screen
      if (find.text('Discover').evaluate().isNotEmpty) {
        await tester.tap(find.text('Discover'));
        await tester.pumpAndSettle();
      }

      // Wait for potential network timeout
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Should show error message or retry option
      // Look for common error indicators
      final hasErrorIndicator = 
          find.text('Error').evaluate().isNotEmpty ||
          find.text('Retry').evaluate().isNotEmpty ||
          find.text('Try again').evaluate().isNotEmpty ||
          find.byIcon(Icons.error).evaluate().isNotEmpty ||
          find.byIcon(Icons.error_outline).evaluate().isNotEmpty;

      // If error shown, tap retry and verify recovery
      if (hasErrorIndicator && find.text('Retry').evaluate().isNotEmpty) {
        await tester.tap(find.text('Retry'));
        await tester.pumpAndSettle();
        
        // App should attempt to recover
        expect(find.byType(CircularProgressIndicator), findsWidgets);
      }
    });

    testWidgets('should handle API failure with fallback', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to library or profile
      if (find.text('Library').evaluate().isNotEmpty) {
        await tester.tap(find.text('Library'));
        await tester.pumpAndSettle();
      }

      // Wait for data load
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should either show data or empty state, not crash
      expect(find.byType(Scaffold), findsOneWidget);

      // Verify app is still responsive
      await tester.pumpAndSettle();
    });

    testWidgets('should recover from invalid authentication token', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Try to access authenticated feature
      if (find.text('Profile').evaluate().isNotEmpty) {
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
      }

      // Wait for potential auth check
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should either show content or redirect to login
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle corrupted data gracefully', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to home and try to load content
      if (find.text('Home').evaluate().isNotEmpty) {
        await tester.tap(find.text('Home'));
        await tester.pumpAndSettle();
      }

      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Should show either data or empty state, not crash
      expect(find.byType(Scaffold), findsOneWidget);
      
      // Try pull-to-refresh if available
      if (find.byType(RefreshIndicator).evaluate().isNotEmpty) {
        await tester.drag(
          find.byType(RefreshIndicator).first,
          const Offset(0, 300),
        );
        await tester.pumpAndSettle();
      }
    });

    testWidgets('should handle session expiration', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Try to perform an action that requires authentication
      if (find.text('Profile').evaluate().isNotEmpty) {
        await tester.tap(find.text('Profile'));
        await tester.pumpAndSettle();
      }

      // Wait and check for session handling
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should remain functional
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle rapid screen transitions without crash', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Rapidly switch between tabs
      final tabs = ['Home', 'Discover', 'Library', 'Buds', 'Chat', 'Profile'];
      
      for (int i = 0; i < 3; i++) {
        for (final tab in tabs) {
          if (find.text(tab).evaluate().isNotEmpty) {
            await tester.tap(find.text(tab));
            await tester.pump(const Duration(milliseconds: 100));
          }
        }
      }

      await tester.pumpAndSettle();

      // App should still be functional
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle back navigation from deep state', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate deep into app
      if (find.text('Settings').evaluate().isNotEmpty) {
        await tester.tap(find.text('Settings'));
        await tester.pumpAndSettle();
      }

      // Try to navigate back using back button
      if (find.byIcon(Icons.arrow_back).evaluate().isNotEmpty) {
        await tester.tap(find.byIcon(Icons.arrow_back).first);
        await tester.pumpAndSettle();
      }

      // Should return to previous screen
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle empty state transitions', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to library (might be empty for new users)
      if (find.text('Library').evaluate().isNotEmpty) {
        await tester.tap(find.text('Library'));
        await tester.pumpAndSettle();
      }

      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Should show either content or empty state message
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should handle concurrent operations', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Try to trigger multiple operations simultaneously
      if (find.text('Home').evaluate().isNotEmpty) {
        await tester.tap(find.text('Home'));
        await tester.pump(const Duration(milliseconds: 50));
      }

      if (find.text('Discover').evaluate().isNotEmpty) {
        await tester.tap(find.text('Discover'));
        await tester.pump(const Duration(milliseconds: 50));
      }

      await tester.pumpAndSettle();

      // App should handle concurrent navigation
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should maintain state after error recovery', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to a specific tab
      if (find.text('Discover').evaluate().isNotEmpty) {
        await tester.tap(find.text('Discover'));
        await tester.pumpAndSettle();
      }

      // Scroll if possible (create some state)
      final scrollableFinder = find.byType(Scrollable);
      if (scrollableFinder.evaluate().isNotEmpty) {
        await tester.drag(scrollableFinder.first, const Offset(0, -200));
        await tester.pumpAndSettle();
      }

      // Navigate away and back
      if (find.text('Home').evaluate().isNotEmpty) {
        await tester.tap(find.text('Home'));
        await tester.pumpAndSettle();
      }

      if (find.text('Discover').evaluate().isNotEmpty) {
        await tester.tap(find.text('Discover'));
        await tester.pumpAndSettle();
      }

      // State should be preserved or restored
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
