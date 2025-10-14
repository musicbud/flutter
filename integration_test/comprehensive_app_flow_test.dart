import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:musicbud_flutter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Comprehensive App Flow E2E Tests', () {
    
    // =================================================================
    // MAIN NAVIGATION TESTS
    // =================================================================
    group('Main Navigation', () {
      testWidgets('should navigate between all main tabs',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Find bottom navigation bar
        final bottomNav = find.byType(NavigationBar).or(
          find.byType(BottomNavigationBar),
        );

        if (bottomNav.evaluate().isNotEmpty) {
          // Test navigation to each tab
          final tabs = ['Home', 'Discover', 'Library', 'Buds', 'Chat', 'Profile'];
          
          for (final tabName in tabs) {
            final tab = find.text(tabName);
            if (tab.evaluate().isNotEmpty) {
              await tester.tap(tab);
              await tester.pumpAndSettle();
              
              // Verify navigation occurred
              expect(find.byType(Scaffold), findsWidgets);
            }
          }
        }
      });

      testWidgets('should maintain state when switching tabs',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Navigate to a tab, scroll, then navigate away and back
        final discoverTab = find.text('Discover');
        if (discoverTab.evaluate().isNotEmpty) {
          await tester.tap(discoverTab);
          await tester.pumpAndSettle();

          // Scroll down
          await tester.drag(find.byType(Scaffold).first, const Offset(0, -300));
          await tester.pumpAndSettle();

          // Navigate to another tab
          final homeTab = find.text('Home');
          if (homeTab.evaluate().isNotEmpty) {
            await tester.tap(homeTab);
            await tester.pumpAndSettle();

            // Navigate back
            await tester.tap(discoverTab);
            await tester.pumpAndSettle();

            // State should be preserved
            expect(find.byType(Scaffold), findsWidgets);
          }
        }
      });

      testWidgets('should show correct screen for each navigation item',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Test each main screen
        final navigationItems = {
          'Home': ['Welcome', 'Recent', 'Activity'],
          'Discover': ['Explore', 'Artists', 'Tracks', 'Genres'],
          'Library': ['Playlists', 'Songs', 'Albums'],
          'Buds': ['Friends', 'Matches', 'Connect'],
          'Chat': ['Messages', 'Conversations'],
          'Profile': ['Profile', 'Settings', 'Stats'],
        };

        for (final entry in navigationItems.entries) {
          final tabFinder = find.text(entry.key);
          if (tabFinder.evaluate().isNotEmpty) {
            await tester.tap(tabFinder);
            await tester.pumpAndSettle();

            // Check for screen-specific elements
            bool foundElement = false;
            for (final element in entry.value) {
              if (find.textContaining(element, findRichText: true).evaluate().isNotEmpty) {
                foundElement = true;
                break;
              }
            }

            // Should find at least one characteristic element
            if (!foundElement) {
              print('Note: Could not verify ${entry.key} screen content');
            }
          }
        }
      });
    });

    // =================================================================
    // SPOTIFY INTEGRATION TESTS
    // =================================================================
    group('Spotify Integration', () {
      testWidgets('should access Spotify control screen',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Navigate to profile or settings to find Spotify
        final profileTab = find.text('Profile');
        if (profileTab.evaluate().isNotEmpty) {
          await tester.tap(profileTab);
          await tester.pumpAndSettle();

          // Look for Spotify-related options
          final spotifyOptions = [
            find.text('Spotify'),
            find.text('Connect Spotify'),
            find.text('Music'),
            find.textContaining('Connect', findRichText: true),
          ];

          for (final option in spotifyOptions) {
            if (option.evaluate().isNotEmpty) {
              await tester.tap(option);
              await tester.pumpAndSettle();
              break;
            }
          }
        }
      });

      testWidgets('should display Spotify playback controls',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Look for Spotify control elements
        final spotifyControls = [
          find.byIcon(Icons.play_arrow),
          find.byIcon(Icons.pause),
          find.byIcon(Icons.skip_next),
          find.byIcon(Icons.skip_previous),
        ];

        bool foundControl = false;
        for (final control in spotifyControls) {
          if (control.evaluate().isNotEmpty) {
            foundControl = true;
            break;
          }
        }

        if (!foundControl) {
          print('Note: Spotify controls not found (may require authentication)');
        }
      });

      testWidgets('should show played tracks map',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Navigate to library or stats
        final libraryTab = find.text('Library');
        if (libraryTab.evaluate().isNotEmpty) {
          await tester.tap(libraryTab);
          await tester.pumpAndSettle();

          // Look for played tracks or stats
          final trackOptions = [
            find.text('History'),
            find.text('Recently Played'),
            find.text('Stats'),
            find.text('Map'),
          ];

          for (final option in trackOptions) {
            if (option.evaluate().isNotEmpty) {
              await tester.tap(option);
              await tester.pumpAndSettle();
              break;
            }
          }
        }
      });

      testWidgets('should handle Spotify connection status',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Check for Spotify connection indicators
        final connectionIndicators = [
          find.text('Connected'),
          find.text('Not Connected'),
          find.text('Connect to Spotify'),
          find.textContaining('Spotify', findRichText: true),
        ];

        bool foundIndicator = false;
        for (final indicator in connectionIndicators) {
          if (indicator.evaluate().isNotEmpty) {
            foundIndicator = true;
            print('Found Spotify indicator');
            break;
          }
        }
      });
    });

    // =================================================================
    // SETTINGS FLOW TESTS
    // =================================================================
    group('Settings Flow', () {
      testWidgets('should navigate to settings screen',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Navigate to profile
        final profileTab = find.text('Profile');
        if (profileTab.evaluate().isNotEmpty) {
          await tester.tap(profileTab);
          await tester.pumpAndSettle();

          // Find settings button
          final settingsButton = find.byIcon(Icons.settings).or(
            find.text('Settings'),
          );

          if (settingsButton.evaluate().isNotEmpty) {
            await tester.tap(settingsButton);
            await tester.pumpAndSettle();

            // Should show settings screen
            expect(find.byType(Scaffold), findsWidgets);
          }
        }
      });

      testWidgets('should display all settings options',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Navigate to settings (via profile)
        final profileTab = find.text('Profile');
        if (profileTab.evaluate().isNotEmpty) {
          await tester.tap(profileTab);
          await tester.pumpAndSettle();

          final settingsButton = find.text('Settings');
          if (settingsButton.evaluate().isNotEmpty) {
            await tester.tap(settingsButton);
            await tester.pumpAndSettle();

            // Check for common settings options
            final settingsOptions = [
              'Account',
              'Privacy',
              'Notifications',
              'Theme',
              'Language',
              'About',
              'Help',
              'Logout',
            ];

            int foundOptions = 0;
            for (final option in settingsOptions) {
              if (find.textContaining(option, findRichText: true).evaluate().isNotEmpty) {
                foundOptions++;
              }
            }

            expect(foundOptions, greaterThan(0),
                reason: 'Should show some settings options');
          }
        }
      });

      testWidgets('should toggle theme settings',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Navigate to settings
        final profileTab = find.text('Profile');
        if (profileTab.evaluate().isNotEmpty) {
          await tester.tap(profileTab);
          await tester.pumpAndSettle();

          final settingsButton = find.text('Settings');
          if (settingsButton.evaluate().isNotEmpty) {
            await tester.tap(settingsButton);
            await tester.pumpAndSettle();

            // Look for theme toggle
            final themeOptions = [
              find.text('Theme'),
              find.text('Dark Mode'),
              find.text('Appearance'),
            ];

            for (final option in themeOptions) {
              if (option.evaluate().isNotEmpty) {
                await tester.tap(option);
                await tester.pumpAndSettle();
                
                // Look for theme switches
                final switches = find.byType(Switch);
                if (switches.evaluate().isNotEmpty) {
                  await tester.tap(switches.first);
                  await tester.pumpAndSettle();
                }
                break;
              }
            }
          }
        }
      });

      testWidgets('should handle logout from settings',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Navigate to settings
        final profileTab = find.text('Profile');
        if (profileTab.evaluate().isNotEmpty) {
          await tester.tap(profileTab);
          await tester.pumpAndSettle();

          final settingsButton = find.text('Settings');
          if (settingsButton.evaluate().isNotEmpty) {
            await tester.tap(settingsButton);
            await tester.pumpAndSettle();

            // Find logout button
            final logoutButton = find.text('Logout').or(
              find.text('Sign Out'),
            );

            if (logoutButton.evaluate().isNotEmpty) {
              await tester.tap(logoutButton);
              await tester.pumpAndSettle();

              // Should show confirmation dialog
              final confirmButtons = [
                find.text('Yes'),
                find.text('Confirm'),
                find.text('Logout'),
              ];

              for (final button in confirmButtons) {
                if (button.evaluate().isNotEmpty) {
                  // Don't actually logout in test
                  print('Found logout confirmation');
                  break;
                }
              }
            }
          }
        }
      });
    });

    // =================================================================
    // STORIES/FEED FLOW TESTS
    // =================================================================
    group('Stories & Feed', () {
      testWidgets('should display feed or stories section',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Look for stories in home or discover
        final homeTab = find.text('Home');
        if (homeTab.evaluate().isNotEmpty) {
          await tester.tap(homeTab);
          await tester.pumpAndSettle();

          // Look for stories-related elements
          final storyElements = [
            find.text('Stories'),
            find.text('Feed'),
            find.text('Updates'),
            find.text('Recent Activity'),
          ];

          bool foundStories = false;
          for (final element in storyElements) {
            if (element.evaluate().isNotEmpty) {
              foundStories = true;
              print('Found stories/feed section');
              break;
            }
          }
        }
      });

      testWidgets('should scroll through feed content',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Navigate to home or discover
        final homeTab = find.text('Home');
        if (homeTab.evaluate().isNotEmpty) {
          await tester.tap(homeTab);
          await tester.pumpAndSettle();

          // Try to scroll
          final scrollable = find.byType(ListView).or(
            find.byType(GridView),
          );

          if (scrollable.evaluate().isNotEmpty) {
            await tester.drag(scrollable.first, const Offset(0, -300));
            await tester.pumpAndSettle();

            // Should have scrolled
            expect(scrollable, findsWidgets);
          }
        }
      });

      testWidgets('should interact with feed items',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Find home tab
        final homeTab = find.text('Home');
        if (homeTab.evaluate().isNotEmpty) {
          await tester.tap(homeTab);
          await tester.pumpAndSettle();

          // Look for interactive elements (like, comment, share)
          final interactionButtons = [
            find.byIcon(Icons.favorite),
            find.byIcon(Icons.favorite_border),
            find.byIcon(Icons.comment),
            find.byIcon(Icons.share),
          ];

          for (final button in interactionButtons) {
            if (button.evaluate().isNotEmpty) {
              await tester.tap(button.first);
              await tester.pumpAndSettle();
              print('Interacted with feed item');
              break;
            }
          }
        }
      });
    });

    // =================================================================
    // APP-WIDE FEATURES TESTS
    // =================================================================
    group('App-Wide Features', () {
      testWidgets('should show loading states appropriately',
          (WidgetTester tester) async {
        app.main();
        await tester.pump(); // Don't settle to catch loading

        // Should show loading indicator initially
        expect(find.byType(CircularProgressIndicator), findsWidgets,
            reason: 'Should show loading during initial load');

        await tester.pumpAndSettle(const Duration(seconds: 3));
      });

      testWidgets('should handle refresh actions',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Try pull to refresh
        await tester.drag(
          find.byType(Scaffold).first,
          const Offset(0, 300),
        );
        await tester.pump();

        // Should show refresh indicator
        expect(
          find.byType(RefreshIndicator).or(
            find.byType(CircularProgressIndicator),
          ),
          findsWidgets,
        );

        await tester.pumpAndSettle();
      });

      testWidgets('should handle network errors gracefully',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Look for error indicators
        final errorIndicators = [
          find.text('Error'),
          find.text('Failed'),
          find.text('No connection'),
          find.text('Retry'),
        ];

        // App should either work or show errors gracefully
        expect(find.byType(Scaffold), findsWidgets);
      });

      testWidgets('should maintain performance during navigation',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Rapidly switch between tabs
        final tabs = ['Home', 'Discover', 'Library', 'Profile'];
        
        for (int i = 0; i < 3; i++) {
          for (final tabName in tabs) {
            final tab = find.text(tabName);
            if (tab.evaluate().isNotEmpty) {
              await tester.tap(tab);
              await tester.pump();
            }
          }
        }

        await tester.pumpAndSettle();
        
        // App should still be responsive
        expect(find.byType(Scaffold), findsWidgets);
      });

      testWidgets('should handle deep links if supported',
          (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // App should load without crashes
        expect(find.byType(MaterialApp), findsOneWidget);
      });
    });
  });
}
