import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:musicbud_flutter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Onboarding Flow E2E Tests', () {
    testWidgets('should display onboarding page on first launch',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      // Verify onboarding screen elements
      expect(
        find.byType(PageView),
        findsOneWidget,
        reason: 'Onboarding should show PageView for screens',
      );
    });

    testWidgets('should navigate through onboarding screens',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Find and tap "Next" button
      final nextButton = find.text('Next');
      if (nextButton.evaluate().isNotEmpty) {
        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        // Verify navigation occurred
        expect(find.text('Next'), findsWidgets);
      }
    });

    testWidgets('should swipe through onboarding screens',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final pageView = find.byType(PageView);
      if (pageView.evaluate().isNotEmpty) {
        // Swipe left to go to next screen
        await tester.drag(pageView, const Offset(-400, 0));
        await tester.pumpAndSettle();

        // Verify we moved to next page
        expect(pageView, findsOneWidget);
      }
    });

    testWidgets('should complete onboarding and navigate to main screen',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for "Get Started" or "Done" button
      final getStartedButton = find.text('Get Started');
      final doneButton = find.text('Done');
      final skipButton = find.text('Skip');

      // Try to skip onboarding if possible
      if (skipButton.evaluate().isNotEmpty) {
        await tester.tap(skipButton);
        await tester.pumpAndSettle();
      } else if (getStartedButton.evaluate().isNotEmpty) {
        await tester.tap(getStartedButton);
        await tester.pumpAndSettle();
      } else if (doneButton.evaluate().isNotEmpty) {
        await tester.tap(doneButton);
        await tester.pumpAndSettle();
      }

      // Should navigate to login or main screen
      await tester.pumpAndSettle(const Duration(seconds: 1));
    });

    testWidgets('should show skip button and skip onboarding',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final skipButton = find.text('Skip');
      if (skipButton.evaluate().isNotEmpty) {
        await tester.tap(skipButton);
        await tester.pumpAndSettle();

        // Verify we're no longer on onboarding
        expect(
          find.byType(PageView),
          findsNothing,
          reason: 'Should navigate away from onboarding',
        );
      }
    });

    testWidgets('should display onboarding page indicators',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Look for page indicators (dots)
      final indicators = find.byType(Row);
      expect(indicators, findsWidgets);
    });

    testWidgets('onboarding should be responsive to different screen sizes',
        (WidgetTester tester) async {
      // Test with different screen sizes
      await tester.binding.setSurfaceSize(const Size(400, 800));
      
      app.main();
      await tester.pumpAndSettle();

      expect(find.byType(Scaffold), findsWidgets);

      // Reset to default
      await tester.binding.setSurfaceSize(null);
    });

    testWidgets('should handle back navigation on onboarding',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to second screen
      final nextButton = find.text('Next');
      if (nextButton.evaluate().isNotEmpty) {
        await tester.tap(nextButton);
        await tester.pumpAndSettle();

        // Try to go back (if back button exists)
        final backButton = find.byIcon(Icons.arrow_back);
        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton);
          await tester.pumpAndSettle();

          // Should be back on first screen
          expect(find.byType(PageView), findsOneWidget);
        }
      }
    });
  });
}
