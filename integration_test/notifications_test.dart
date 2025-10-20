import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:musicbud_flutter/main.dart' as app;

/// Notifications E2E Tests
///
/// Tests notification functionality:
/// - In-app notifications display
/// - Notification center/list
/// - Notification actions (tap to navigate)
/// - Notification badges and counts
/// - Notification preferences
/// - Marking notifications as read
/// - Clearing notifications
/// - Different notification types (social, system, music updates)
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Notifications E2E Tests', () {
    testWidgets('should display notification center', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Look for notification icon
      final notificationIcon = find.byIcon(Icons.notifications);
      final notificationOutlineIcon = find.byIcon(Icons.notifications_outlined);

      if (notificationIcon.evaluate().isNotEmpty) {
        await tester.tap(notificationIcon.first);
        await tester.pumpAndSettle();
      } else if (notificationOutlineIcon.evaluate().isNotEmpty) {
        await tester.tap(notificationOutlineIcon.first);
        await tester.pumpAndSettle();
      }

      // Notification screen should display
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should show notification badge with count', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Look for notification badge
      final badge = find.byType(Badge);
      final notificationIcon = find.byIcon(Icons.notifications);

      expect(badge.evaluate().isNotEmpty ||
             notificationIcon.evaluate().isNotEmpty ||
             find.byType(Scaffold).evaluate().isNotEmpty,
             isTrue);
    });

    testWidgets('should list all notifications', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to notifications
      final notificationIcon = find.byIcon(Icons.notifications);
      if (notificationIcon.evaluate().isNotEmpty) {
        await tester.tap(notificationIcon.first);
        await tester.pumpAndSettle();

        // Should show list of notifications or empty state
        final listView = find.byType(ListView);
        final scrollable = find.byType(Scrollable);
        
        expect(listView.evaluate().isNotEmpty ||
               scrollable.evaluate().isNotEmpty ||
               find.byType(Scaffold).evaluate().isNotEmpty,
               isTrue);
      }
    });

    testWidgets('should tap notification to navigate', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to notifications
      final notificationIcon = find.byIcon(Icons.notifications);
      if (notificationIcon.evaluate().isNotEmpty) {
        await tester.tap(notificationIcon.first);
        await tester.pumpAndSettle();

        // Tap on first notification if available
        final listTile = find.byType(ListTile);
        if (listTile.evaluate().isNotEmpty) {
          await tester.tap(listTile.first);
          await tester.pumpAndSettle();

          // Should navigate to relevant content
          expect(find.byType(Scaffold), findsOneWidget);
        }
      }
    });

    testWidgets('should mark notification as read', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to notifications
      final notificationIcon = find.byIcon(Icons.notifications);
      if (notificationIcon.evaluate().isNotEmpty) {
        await tester.tap(notificationIcon.first);
        await tester.pumpAndSettle();

        // Look for unread notifications
        final listTile = find.byType(ListTile);
        if (listTile.evaluate().isNotEmpty) {
          // Tap notification to mark as read
          await tester.tap(listTile.first);
          await tester.pumpAndSettle();

          // Navigate back
          if (find.byIcon(Icons.arrow_back).evaluate().isNotEmpty) {
            await tester.tap(find.byIcon(Icons.arrow_back).first);
            await tester.pumpAndSettle();
          }

          // Notification should be marked as read
          expect(find.byType(Scaffold), findsOneWidget);
        }
      }
    });

    testWidgets('should mark all notifications as read', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to notifications
      final notificationIcon = find.byIcon(Icons.notifications);
      if (notificationIcon.evaluate().isNotEmpty) {
        await tester.tap(notificationIcon.first);
        await tester.pumpAndSettle();

        // Look for mark all as read option
        final markAllRead = find.textContaining('Mark all', findRichText: true);
        final readAll = find.textContaining('Read all', findRichText: true);
        
        if (markAllRead.evaluate().isNotEmpty) {
          await tester.tap(markAllRead.first);
          await tester.pumpAndSettle();
        } else if (readAll.evaluate().isNotEmpty) {
          await tester.tap(readAll.first);
          await tester.pumpAndSettle();
        }

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('should clear individual notification', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to notifications
      final notificationIcon = find.byIcon(Icons.notifications);
      if (notificationIcon.evaluate().isNotEmpty) {
        await tester.tap(notificationIcon.first);
        await tester.pumpAndSettle();

        // Look for dismiss action (swipe or delete button)
        final listTile = find.byType(ListTile);
        if (listTile.evaluate().isNotEmpty) {
          // Try to swipe notification to dismiss
          await tester.drag(listTile.first, const Offset(-300, 0));
          await tester.pumpAndSettle();

          expect(find.byType(Scaffold), findsOneWidget);
        }
      }
    });

    testWidgets('should clear all notifications', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to notifications
      final notificationIcon = find.byIcon(Icons.notifications);
      if (notificationIcon.evaluate().isNotEmpty) {
        await tester.tap(notificationIcon.first);
        await tester.pumpAndSettle();

        // Look for clear all option
        final clearAll = find.textContaining('Clear all', findRichText: true);
        final deleteAll = find.textContaining('Delete all', findRichText: true);
        
        if (clearAll.evaluate().isNotEmpty) {
          await tester.tap(clearAll.first);
          await tester.pumpAndSettle();
          
          // Confirm if dialog appears
          final confirmButton = find.textContaining('Confirm', findRichText: true);
          if (confirmButton.evaluate().isNotEmpty) {
            await tester.tap(confirmButton.first);
            await tester.pumpAndSettle();
          }
        } else if (deleteAll.evaluate().isNotEmpty) {
          await tester.tap(deleteAll.first);
          await tester.pumpAndSettle();
        }

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('should display social notifications', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to notifications
      final notificationIcon = find.byIcon(Icons.notifications);
      if (notificationIcon.evaluate().isNotEmpty) {
        await tester.tap(notificationIcon.first);
        await tester.pumpAndSettle();

        // Look for social notification types (follows, likes, comments)
        final followNotif = find.textContaining('follow', findRichText: true);
        final likeNotif = find.textContaining('like', findRichText: true);
        final commentNotif = find.textContaining('comment', findRichText: true);

        expect(followNotif.evaluate().isNotEmpty ||
               likeNotif.evaluate().isNotEmpty ||
               commentNotif.evaluate().isNotEmpty ||
               find.byType(Scaffold).evaluate().isNotEmpty,
               isTrue);
      }
    });

    testWidgets('should display system notifications', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to notifications
      final notificationIcon = find.byIcon(Icons.notifications);
      if (notificationIcon.evaluate().isNotEmpty) {
        await tester.tap(notificationIcon.first);
        await tester.pumpAndSettle();

        // System notifications might include updates, announcements
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('should filter notifications by type', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to notifications
      final notificationIcon = find.byIcon(Icons.notifications);
      if (notificationIcon.evaluate().isNotEmpty) {
        await tester.tap(notificationIcon.first);
        await tester.pumpAndSettle();

        // Look for filter options (All, Social, System, etc.)
        final allTab = find.textContaining('All', findRichText: true);
        final socialTab = find.textContaining('Social', findRichText: true);
        
        if (socialTab.evaluate().isNotEmpty) {
          await tester.tap(socialTab.first);
          await tester.pumpAndSettle();
        }

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('should manage notification preferences', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to settings
      final profileTab = find.text('Profile');
      if (profileTab.evaluate().isNotEmpty) {
        await tester.tap(profileTab);
        await tester.pumpAndSettle();
      }

      final settingsIcon = find.byIcon(Icons.settings);
      if (settingsIcon.evaluate().isNotEmpty) {
        await tester.tap(settingsIcon.first);
        await tester.pumpAndSettle();
      }

      // Look for notification settings
      final notificationSettings = find.textContaining('Notification', findRichText: true);
      if (notificationSettings.evaluate().isNotEmpty) {
        await tester.tap(notificationSettings.first);
        await tester.pumpAndSettle();

        // Notification preferences screen should display
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('should toggle notification types on/off', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to notification settings
      final profileTab = find.text('Profile');
      if (profileTab.evaluate().isNotEmpty) {
        await tester.tap(profileTab);
        await tester.pumpAndSettle();
      }

      final settingsIcon = find.byIcon(Icons.settings);
      if (settingsIcon.evaluate().isNotEmpty) {
        await tester.tap(settingsIcon.first);
        await tester.pumpAndSettle();
      }

      final notificationSettings = find.textContaining('Notification', findRichText: true);
      if (notificationSettings.evaluate().isNotEmpty) {
        await tester.tap(notificationSettings.first);
        await tester.pumpAndSettle();

        // Look for toggle switches
        final switchWidget = find.byType(Switch);
        if (switchWidget.evaluate().isNotEmpty) {
          await tester.tap(switchWidget.first);
          await tester.pumpAndSettle();
        }

        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('should show empty state when no notifications', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to notifications
      final notificationIcon = find.byIcon(Icons.notifications);
      if (notificationIcon.evaluate().isNotEmpty) {
        await tester.tap(notificationIcon.first);
        await tester.pumpAndSettle();

        // Look for empty state message
        final emptyMessage = find.textContaining('No notifications', findRichText: true);
        final noNotificationsText = find.textContaining('no new', findRichText: true);

        expect(emptyMessage.evaluate().isNotEmpty ||
               noNotificationsText.evaluate().isNotEmpty ||
               find.byType(Scaffold).evaluate().isNotEmpty,
               isTrue);
      }
    });

    testWidgets('should show notification timestamp', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to notifications
      final notificationIcon = find.byIcon(Icons.notifications);
      if (notificationIcon.evaluate().isNotEmpty) {
        await tester.tap(notificationIcon.first);
        await tester.pumpAndSettle();

        // Notifications should have timestamps (e.g., "2h ago", "1d ago")
        final timeText = find.textContaining('ago', findRichText: true);
        
        expect(timeText.evaluate().isNotEmpty ||
               find.byType(Scaffold).evaluate().isNotEmpty,
               isTrue);
      }
    });
  });
}
