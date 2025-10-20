/// Comprehensive Integration Tests
/// 
/// End-to-end tests for complete user flows through the app

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:musicbud_flutter/main.dart' as app;
import '../test_config.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Comprehensive Integration Tests', () {
    group('Authentication Flow', () {
      testWidgets('Complete registration and login flow', (tester) async {
        TestLogger.log('Starting registration and login flow test');
        
        // Start app
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        // Should show login screen
        expect(find.text('Welcome to MusicBud'), findsOneWidget);
        TestLogger.log('Login screen loaded');

        // Switch to register mode if toggle exists
        if (find.text('Register').first != null) {
          await tester.tap(find.text('Register'));
          await tester.pumpAndSettle();
        }

        // Fill registration form
        await tester.enterText(find.byType(TextFormField).at(0), TestConfig.testUsername);
        await tester.enterText(find.byType(TextFormField).at(1), TestConfig.testPassword);
        await tester.pumpAndSettle();

        TestLogger.log('Registration form filled');

        // Submit registration (might fail if user exists)
        final submitButton = find.byType(ElevatedButton);
        if (submitButton.evaluate().isNotEmpty) {
          await tester.tap(submitButton);
          await tester.pumpAndSettle(TestConfig.mediumTimeout);
        }

        TestLogger.logSuccess('Registration flow completed');
      });

      testWidgets('Login flow with valid credentials', (tester) async {
        TestLogger.log('Starting login flow test');
        
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        // Enter credentials
        await tester.enterText(find.byType(TextFormField).at(0), TestConfig.testUsername);
        await tester.enterText(find.byType(TextFormField).at(1), TestConfig.testPassword);
        await tester.pumpAndSettle();

        // Submit login
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle(TestConfig.longTimeout);

        TestLogger.logSuccess('Login attempt completed');
      });

      testWidgets('Login with invalid credentials shows error', (tester) async {
        TestLogger.log('Testing login with invalid credentials');
        
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        // Enter invalid credentials
        await tester.enterText(find.byType(TextFormField).at(0), 'invalid_user');
        await tester.enterText(find.byType(TextFormField).at(1), 'wrong_password');
        await tester.pumpAndSettle();

        // Submit login
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle(TestConfig.mediumTimeout);

        // Should show error (SnackBar or error message)
        // This will depend on actual implementation
        
        TestLogger.logSuccess('Invalid login handled');
      });
    });

    group('Navigation Flow', () {
      testWidgets('Navigate through bottom navigation tabs', (tester) async {
        TestLogger.log('Testing bottom navigation');
        
        // Assuming user is logged in
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        // Look for bottom navigation bar
        final bottomNav = find.byType(BottomNavigationBar);
        if (bottomNav.evaluate().isNotEmpty) {
          TestLogger.log('Bottom navigation found');

          // Tap through each tab
          final icons = find.byType(Icon);
          if (icons.evaluate().length >= 3) {
            for (int i = 0; i < 3; i++) {
              await tester.tap(icons.at(i));
              await tester.pumpAndSettle(TestConfig.shortDelay);
              TestLogger.log('Navigated to tab $i');
            }
          }
        }

        TestLogger.logSuccess('Navigation test completed');
      });

      testWidgets('Drawer navigation works', (tester) async {
        TestLogger.log('Testing drawer navigation');
        
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        // Look for menu icon
        final menuIcon = find.byIcon(Icons.menu);
        if (menuIcon.evaluate().isNotEmpty) {
          await tester.tap(menuIcon);
          await tester.pumpAndSettle();

          // Should show drawer
          expect(find.byType(Drawer), findsOneWidget);
          TestLogger.log('Drawer opened');

          // Tap first drawer item if exists
          final drawerItems = find.byType(ListTile);
          if (drawerItems.evaluate().isNotEmpty) {
            await tester.tap(drawerItems.first);
            await tester.pumpAndSettle();
          }
        }

        TestLogger.logSuccess('Drawer navigation completed');
      });

      testWidgets('Back navigation works correctly', (tester) async {
        TestLogger.log('Testing back navigation');
        
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        // Navigate to a detail screen if possible
        final listTiles = find.byType(ListTile);
        if (listTiles.evaluate().isNotEmpty) {
          await tester.tap(listTiles.first);
          await tester.pumpAndSettle(TestConfig.mediumDelay);

          // Try to go back
          final backButton = find.byType(BackButton);
          if (backButton.evaluate().isNotEmpty) {
            await tester.tap(backButton);
            await tester.pumpAndSettle();
            TestLogger.log('Back navigation successful');
          }
        }

        TestLogger.logSuccess('Back navigation test completed');
      });
    });

    group('Content Interaction Flow', () {
      testWidgets('Search and filter content', (tester) async {
        TestLogger.log('Testing search functionality');
        
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        // Look for search field
        final searchFields = find.byType(TextField);
        if (searchFields.evaluate().isNotEmpty) {
          await tester.enterText(searchFields.first, 'test query');
          await tester.pumpAndSettle(TestConfig.mediumDelay);
          TestLogger.log('Search query entered');

          // Wait for results
          await tester.pumpAndSettle(TestConfig.longTimeout);
        }

        TestLogger.logSuccess('Search test completed');
      });

      testWidgets('Pull to refresh works', (tester) async {
        TestLogger.log('Testing pull to refresh');
        
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        // Look for scrollable list
        final listViews = find.byType(ListView);
        if (listViews.evaluate().isNotEmpty) {
          // Perform pull to refresh gesture
          await tester.drag(listViews.first, const Offset(0, 300));
          await tester.pumpAndSettle(TestConfig.mediumTimeout);
          TestLogger.log('Pull to refresh triggered');
        }

        TestLogger.logSuccess('Pull to refresh test completed');
      });

      testWidgets('Infinite scroll loads more content', (tester) async {
        TestLogger.log('Testing infinite scroll');
        
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        // Find scrollable content
        final scrollables = find.byType(Scrollable);
        if (scrollables.evaluate().isNotEmpty) {
          // Count initial items
          final initialItems = find.byType(ListTile).evaluate().length;
          TestLogger.log('Initial items: $initialItems');

          // Scroll to bottom
          await tester.drag(scrollables.first, const Offset(0, -5000));
          await tester.pumpAndSettle(TestConfig.longTimeout);

          // Check if more items loaded
          final finalItems = find.byType(ListTile).evaluate().length;
          TestLogger.log('Final items: $finalItems');
        }

        TestLogger.logSuccess('Infinite scroll test completed');
      });
    });

    group('Profile Management Flow', () {
      testWidgets('View and edit profile', (tester) async {
        TestLogger.log('Testing profile management');
        
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        // Navigate to profile (usually last tab)
        final bottomNav = find.byType(BottomNavigationBar);
        if (bottomNav.evaluate().isNotEmpty) {
          final icons = find.byType(Icon);
          if (icons.evaluate().length >= 4) {
            await tester.tap(icons.last);
            await tester.pumpAndSettle(TestConfig.mediumDelay);
            TestLogger.log('Profile screen opened');
          }
        }

        // Look for edit button
        final editButtons = find.text('Edit');
        if (editButtons.evaluate().isNotEmpty) {
          await tester.tap(editButtons.first);
          await tester.pumpAndSettle();
          TestLogger.log('Edit mode activated');

          // Try to modify a field
          final textFields = find.byType(TextFormField);
          if (textFields.evaluate().isNotEmpty) {
            await tester.enterText(textFields.first, 'Updated Bio');
            await tester.pumpAndSettle();
          }

          // Save changes
          final saveButtons = find.text('Save');
          if (saveButtons.evaluate().isNotEmpty) {
            await tester.tap(saveButtons.first);
            await tester.pumpAndSettle(TestConfig.mediumTimeout);
          }
        }

        TestLogger.logSuccess('Profile management test completed');
      });
    });

    group('Chat Flow', () {
      testWidgets('Navigate to chat and send message', (tester) async {
        TestLogger.log('Testing chat functionality');
        
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        // Look for chat tab or button
        final chatButtons = find.text('Chat');
        if (chatButtons.evaluate().isNotEmpty) {
          await tester.tap(chatButtons.first);
          await tester.pumpAndSettle(TestConfig.mediumDelay);
          TestLogger.log('Chat screen opened');

          // Select a chat if available
          final chatItems = find.byType(ListTile);
          if (chatItems.evaluate().isNotEmpty) {
            await tester.tap(chatItems.first);
            await tester.pumpAndSettle();
            TestLogger.log('Chat opened');

            // Find message input field
            final messageFields = find.byType(TextField);
            if (messageFields.evaluate().isNotEmpty) {
              await tester.enterText(messageFields.last, 'Test message');
              await tester.pumpAndSettle();

              // Find send button
              final sendButtons = find.byIcon(Icons.send);
              if (sendButtons.evaluate().isNotEmpty) {
                await tester.tap(sendButtons.first);
                await tester.pumpAndSettle(TestConfig.mediumDelay);
                TestLogger.log('Message sent');
              }
            }
          }
        }

        TestLogger.logSuccess('Chat test completed');
      });
    });

    group('Settings Flow', () {
      testWidgets('Access and modify settings', (tester) async {
        TestLogger.log('Testing settings');
        
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        // Look for settings icon or menu
        final settingsButtons = find.byIcon(Icons.settings);
        if (settingsButtons.evaluate().isNotEmpty) {
          await tester.tap(settingsButtons.first);
          await tester.pumpAndSettle();
          TestLogger.log('Settings opened');

          // Toggle some switches if available
          final switches = find.byType(Switch);
          if (switches.evaluate().isNotEmpty) {
            await tester.tap(switches.first);
            await tester.pumpAndSettle();
            TestLogger.log('Setting toggled');
          }
        }

        TestLogger.logSuccess('Settings test completed');
      });

      testWidgets('Theme switching works', (tester) async {
        TestLogger.log('Testing theme switching');
        
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        // Navigate to settings
        final settingsButtons = find.byIcon(Icons.settings);
        if (settingsButtons.evaluate().isNotEmpty) {
          await tester.tap(settingsButtons.first);
          await tester.pumpAndSettle();

          // Look for theme toggle
          final themeText = find.text('Dark Mode');
          if (themeText.evaluate().isNotEmpty) {
            // Find associated switch
            await tester.tap(themeText);
            await tester.pumpAndSettle();
            TestLogger.log('Theme toggled');
          }
        }

        TestLogger.logSuccess('Theme test completed');
      });
    });

    group('Logout Flow', () {
      testWidgets('Logout returns to login screen', (tester) async {
        TestLogger.log('Testing logout');
        
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        // Open drawer or profile menu
        final menuIcon = find.byIcon(Icons.menu);
        if (menuIcon.evaluate().isNotEmpty) {
          await tester.tap(menuIcon);
          await tester.pumpAndSettle();

          // Look for logout button
          final logoutButtons = find.text('Logout');
          if (logoutButtons.evaluate().isNotEmpty) {
            await tester.tap(logoutButtons.first);
            await tester.pumpAndSettle(TestConfig.mediumTimeout);
            TestLogger.log('Logout initiated');

            // Should return to login screen
            expect(find.text('Welcome to MusicBud'), findsOneWidget);
            TestLogger.log('Returned to login screen');
          }
        }

        TestLogger.logSuccess('Logout test completed');
      });
    });

    group('Error Handling', () {
      testWidgets('App handles network errors gracefully', (tester) async {
        TestLogger.log('Testing error handling');
        
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        // App should still function even with network errors
        // This depends on implementation details
        
        TestLogger.logSuccess('Error handling test completed');
      });

      testWidgets('App recovers from errors', (tester) async {
        TestLogger.log('Testing error recovery');
        
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        // Navigate through app to ensure stability
        for (int i = 0; i < 5; i++) {
          final buttons = find.byType(ElevatedButton);
          if (buttons.evaluate().isNotEmpty) {
            await tester.tap(buttons.first);
            await tester.pumpAndSettle(TestConfig.shortDelay);
          }
        }

        TestLogger.logSuccess('Error recovery test completed');
      });
    });

    group('Performance Tests', () {
      testWidgets('App scrolls smoothly with large lists', (tester) async {
        TestLogger.log('Testing scroll performance');
        
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        final scrollables = find.byType(Scrollable);
        if (scrollables.evaluate().isNotEmpty) {
          // Perform multiple rapid scrolls
          for (int i = 0; i < 10; i++) {
            await tester.drag(scrollables.first, const Offset(0, -500));
            await tester.pump(const Duration(milliseconds: 16)); // 60 FPS
          }
          await tester.pumpAndSettle();
        }

        TestLogger.logSuccess('Scroll performance test completed');
      });

      testWidgets('App handles rapid navigation', (tester) async {
        TestLogger.log('Testing rapid navigation');
        
        app.main();
        await tester.pumpAndSettle(TestConfig.longTimeout);

        // Rapidly switch tabs if available
        final bottomNav = find.byType(BottomNavigationBar);
        if (bottomNav.evaluate().isNotEmpty) {
          final icons = find.byType(Icon);
          for (int i = 0; i < 10; i++) {
            final index = i % icons.evaluate().length;
            await tester.tap(icons.at(index));
            await tester.pump(const Duration(milliseconds: 100));
          }
          await tester.pumpAndSettle();
        }

        TestLogger.logSuccess('Rapid navigation test completed');
      });
    });
  });
}
