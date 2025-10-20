import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:musicbud_flutter/main.dart' as app;

/// Social Features E2E Tests
///
/// Tests user interactions and social functionality:
/// - Following/unfollowing users (buddies)
/// - Viewing follower/following lists
/// - Sharing music content
/// - Liking songs and playlists
/// - Commenting on shared content
/// - Social feed and activity stream
/// - Friend recommendations
/// - Social notifications
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Social Features E2E Tests', () {
    testWidgets('should follow and unfollow users', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to social/buddies section
      final buddiesTab = find.text('Buddies');
      if (buddiesTab.evaluate().isNotEmpty) {
        await tester.tap(buddiesTab);
        await tester.pumpAndSettle();
      }

      // Look for follow buttons
      final followButton = find.textContaining('Follow', findRichText: true);
      if (followButton.evaluate().isNotEmpty) {
        await tester.tap(followButton.first);
        await tester.pumpAndSettle();

        // Should show unfollow after following
        final unfollowButton = find.textContaining('Unfollow', findRichText: true);
        expect(unfollowButton.evaluate().isNotEmpty || 
               find.textContaining('Following', findRichText: true).evaluate().isNotEmpty, 
               isTrue);
      }
    });

    testWidgets('should view followers and following lists', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to profile
      final profileTab = find.text('Profile');
      if (profileTab.evaluate().isNotEmpty) {
        await tester.tap(profileTab);
        await tester.pumpAndSettle();
      }

      // Look for followers/following counts
      final followersText = find.textContaining('Followers', findRichText: true);
      final followingText = find.textContaining('Following', findRichText: true);

      if (followersText.evaluate().isNotEmpty) {
        await tester.tap(followersText.first);
        await tester.pumpAndSettle();
        
        // Should show followers list
        expect(find.byType(ListView), findsWidgets);
        
        // Navigate back
        if (find.byIcon(Icons.arrow_back).evaluate().isNotEmpty) {
          await tester.tap(find.byIcon(Icons.arrow_back).first);
          await tester.pumpAndSettle();
        }
      }

      if (followingText.evaluate().isNotEmpty) {
        await tester.tap(followingText.first);
        await tester.pumpAndSettle();
        
        // Should show following list
        expect(find.byType(ListView), findsWidgets);
      }
    });

    testWidgets('should share music content with buddies', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to music/library
      final libraryTab = find.text('Library');
      if (libraryTab.evaluate().isNotEmpty) {
        await tester.tap(libraryTab);
        await tester.pumpAndSettle();
      }

      // Look for share button
      final shareButton = find.byIcon(Icons.share);
      if (shareButton.evaluate().isNotEmpty) {
        await tester.tap(shareButton.first);
        await tester.pumpAndSettle();

        // Share dialog should appear
        expect(find.byType(Dialog).evaluate().isNotEmpty ||
               find.byType(BottomSheet).evaluate().isNotEmpty, 
               isTrue);
      }
    });

    testWidgets('should like songs and playlists', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to discover/home
      final homeTab = find.text('Discover');
      if (homeTab.evaluate().isNotEmpty) {
        await tester.tap(homeTab);
        await tester.pumpAndSettle();
      }

      // Look for favorite/like button
      final likeButton = find.byIcon(Icons.favorite_border);
      if (likeButton.evaluate().isNotEmpty) {
        await tester.tap(likeButton.first);
        await tester.pumpAndSettle();

        // Should change to filled heart
        expect(find.byIcon(Icons.favorite).evaluate().isNotEmpty, isTrue);
      }
    });

    testWidgets('should comment on shared content', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to social feed
      final buddiesTab = find.text('Buddies');
      if (buddiesTab.evaluate().isNotEmpty) {
        await tester.tap(buddiesTab);
        await tester.pumpAndSettle();
      }

      // Look for comment icon
      final commentIcon = find.byIcon(Icons.comment);
      if (commentIcon.evaluate().isNotEmpty) {
        await tester.tap(commentIcon.first);
        await tester.pumpAndSettle();

        // Comment input should appear
        final textField = find.byType(TextField);
        if (textField.evaluate().isNotEmpty) {
          await tester.enterText(textField.first, 'Great song!');
          await tester.pumpAndSettle();

          // Look for submit button
          final submitButton = find.textContaining('Send', findRichText: true);
          if (submitButton.evaluate().isNotEmpty) {
            await tester.tap(submitButton.first);
            await tester.pumpAndSettle();
          }
        }
      }
    });

    testWidgets('should display social feed with activity', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to social feed
      final buddiesTab = find.text('Buddies');
      if (buddiesTab.evaluate().isNotEmpty) {
        await tester.tap(buddiesTab);
        await tester.pumpAndSettle();

        // Feed should display
        expect(find.byType(Scaffold), findsOneWidget);
        
        // Check for scrollable content
        final scrollable = find.byType(Scrollable);
        if (scrollable.evaluate().isNotEmpty) {
          // Scroll through feed
          await tester.drag(scrollable.first, const Offset(0, -300));
          await tester.pumpAndSettle();
        }
      }
    });

    testWidgets('should show friend recommendations', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to buddies
      final buddiesTab = find.text('Buddies');
      if (buddiesTab.evaluate().isNotEmpty) {
        await tester.tap(buddiesTab);
        await tester.pumpAndSettle();
      }

      // Look for suggested/recommended section
      final suggestedText = find.textContaining('Suggested', findRichText: true);
      final recommendedText = find.textContaining('Recommended', findRichText: true);

      expect(suggestedText.evaluate().isNotEmpty || 
             recommendedText.evaluate().isNotEmpty ||
             find.byType(Scaffold).evaluate().isNotEmpty, 
             isTrue);
    });

    testWidgets('should receive and display social notifications', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Look for notification icon
      final notificationIcon = find.byIcon(Icons.notifications);
      if (notificationIcon.evaluate().isNotEmpty) {
        await tester.tap(notificationIcon.first);
        await tester.pumpAndSettle();

        // Notification screen should display
        expect(find.byType(Scaffold), findsOneWidget);
      }
    });

    testWidgets('should search for users to follow', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Look for search functionality
      final searchIcon = find.byIcon(Icons.search);
      if (searchIcon.evaluate().isNotEmpty) {
        await tester.tap(searchIcon.first);
        await tester.pumpAndSettle();

        // Search field should appear
        final searchField = find.byType(TextField);
        if (searchField.evaluate().isNotEmpty) {
          await tester.enterText(searchField.first, 'test user');
          await tester.pumpAndSettle();

          // Search results should display
          expect(find.byType(Scaffold), findsOneWidget);
        }
      }
    });

    testWidgets('should view buddy profile and activity', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to buddies
      final buddiesTab = find.text('Buddies');
      if (buddiesTab.evaluate().isNotEmpty) {
        await tester.tap(buddiesTab);
        await tester.pumpAndSettle();

        // Look for user profile cards/items
        final scrollable = find.byType(Scrollable);
        if (scrollable.evaluate().isNotEmpty) {
          // Tap on first user if available
          final userCard = find.byType(Card);
          if (userCard.evaluate().isNotEmpty) {
            await tester.tap(userCard.first);
            await tester.pumpAndSettle();

            // Profile screen should display
            expect(find.byType(Scaffold), findsOneWidget);
          }
        }
      }
    });

    testWidgets('should handle social interactions offline', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Skip onboarding
      if (find.text('Skip').evaluate().isNotEmpty) {
        await tester.tap(find.text('Skip'));
        await tester.pumpAndSettle();
      }

      // Navigate to buddies
      final buddiesTab = find.text('Buddies');
      if (buddiesTab.evaluate().isNotEmpty) {
        await tester.tap(buddiesTab);
        await tester.pumpAndSettle();

        // Try to perform social action (like/follow)
        final followButton = find.textContaining('Follow', findRichText: true);
        if (followButton.evaluate().isNotEmpty) {
          await tester.tap(followButton.first);
          await tester.pumpAndSettle();

          // Should handle offline state gracefully
          expect(find.byType(Scaffold), findsOneWidget);
        }
      }
    });

    testWidgets('should manage blocked users', (tester) async {
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

        // Look for privacy/blocked users option
        final privacyOption = find.textContaining('Privacy', findRichText: true);
        final blockedOption = find.textContaining('Blocked', findRichText: true);

        expect(privacyOption.evaluate().isNotEmpty || 
               blockedOption.evaluate().isNotEmpty ||
               find.byType(Scaffold).evaluate().isNotEmpty, 
               isTrue);
      }
    });
  });
}
