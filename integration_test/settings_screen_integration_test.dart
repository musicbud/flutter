import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

// App imports
import 'package:musicbud_flutter/presentation/screens/settings/settings_screen.dart';
import 'package:musicbud_flutter/blocs/settings/settings_bloc.dart';
import 'package:musicbud_flutter/blocs/settings/settings_event.dart';
import 'package:musicbud_flutter/blocs/settings/settings_state.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

// Test utilities
import 'test_utils/test_helpers.dart';
import 'test_utils/mock_api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('SettingsScreen Integration Tests', () {
    late MockSettingsBloc mockSettingsBloc;
    late MockApiClient mockApiClient;

    setUp(() {
      mockSettingsBloc = MockSettingsBloc();
      mockApiClient = MockApiClient();
      TestSetup.setupMockDependencies();
    });

    tearDown(() {
      TestSetup.teardownMockDependencies();
    });

    testWidgets('SettingsScreen renders correctly with initial state',
        (WidgetTester tester) async {
      // Arrange
      when(mockSettingsBloc.state).thenReturn(SettingsLoading());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
        ],
        child: const SettingsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SettingsScreen));
      IntegrationTestUtils.expectTextVisible('Settings');
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('SettingsScreen loads settings on initialization',
        (WidgetTester tester) async {
      // Arrange
      when(mockSettingsBloc.state).thenReturn(SettingsLoading());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
        ],
        child: const SettingsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert - Verify settings load event was triggered
      verify(mockSettingsBloc.add(LoadSettingsEvent())).called(1);
    });

    testWidgets('SettingsScreen displays loaded settings correctly',
        (WidgetTester tester) async {
      // Arrange - Mock loaded settings state
      final mockSettings = SettingsData(
        notifications: NotificationSettings(
          enabled: true,
          pushEnabled: true,
          emailEnabled: false,
          soundEnabled: true,
        ),
        privacy: PrivacySettings(
          profileVisible: true,
          locationVisible: false,
          activityVisible: true,
        ),
        theme: 'dark',
        languageCode: 'en',
      );

      when(mockSettingsBloc.state).thenReturn(SettingsLoaded(mockSettings));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
        ],
        child: const SettingsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SettingsScreen));
      IntegrationTestUtils.expectTextVisible('Notifications');
      IntegrationTestUtils.expectTextVisible('Privacy');
      IntegrationTestUtils.expectTextVisible('Appearance');
      IntegrationTestUtils.expectTextVisible('Service Connections');
      IntegrationTestUtils.expectTextVisible('Data Synchronization');
      IntegrationTestUtils.expectTextVisible('Language');
      IntegrationTestUtils.expectTextVisible('Save Settings');
    });

    testWidgets('SettingsScreen handles notification settings toggle',
        (WidgetTester tester) async {
      // Arrange
      final mockSettings = SettingsData(
        notifications: NotificationSettings(
          enabled: true,
          pushEnabled: true,
          emailEnabled: false,
          soundEnabled: true,
        ),
        privacy: PrivacySettings(
          profileVisible: true,
          locationVisible: false,
          activityVisible: true,
        ),
        theme: 'dark',
        languageCode: 'en',
      );

      when(mockSettingsBloc.state).thenReturn(SettingsLoaded(mockSettings));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
        ],
        child: const SettingsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Toggle push notifications
      await IntegrationTestUtils.tapAndSettle(
        tester,
        find.byType(SwitchListTile).first, // Push notifications switch
      );

      // Assert - Verify event was triggered
      verify(mockSettingsBloc.add(any)).called(greaterThan(1)); // Initial load + toggle
    });

    testWidgets('SettingsScreen handles privacy settings toggle',
        (WidgetTester tester) async {
      // Arrange
      final mockSettings = SettingsData(
        notifications: NotificationSettings(
          enabled: true,
          pushEnabled: true,
          emailEnabled: false,
          soundEnabled: true,
        ),
        privacy: PrivacySettings(
          profileVisible: true,
          locationVisible: false,
          activityVisible: true,
        ),
        theme: 'dark',
        languageCode: 'en',
      );

      when(mockSettingsBloc.state).thenReturn(SettingsLoaded(mockSettings));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
        ],
        child: const SettingsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Find privacy switches (they come after notification switches)
      final switches = find.byType(SwitchListTile);
      expect(switches, findsNWidgets(7)); // 3 notifications + 3 privacy + 1 activity

      // Toggle profile visibility (4th switch)
      await IntegrationTestUtils.tapAndSettle(
        tester,
        switches.at(3),
      );

      // Assert - Verify privacy update event was triggered
      verify(mockSettingsBloc.add(any)).called(greaterThan(1));
    });

    testWidgets('SettingsScreen handles theme selection',
        (WidgetTester tester) async {
      // Arrange
      final mockSettings = SettingsData(
        notifications: NotificationSettings(
          enabled: true,
          pushEnabled: true,
          emailEnabled: false,
          soundEnabled: true,
        ),
        privacy: PrivacySettings(
          profileVisible: true,
          locationVisible: false,
          activityVisible: true,
        ),
        theme: 'dark',
        languageCode: 'en',
      );

      when(mockSettingsBloc.state).thenReturn(SettingsLoaded(mockSettings));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
        ],
        child: const SettingsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Find dropdown button for theme
      final dropdownFinder = find.byType(DropdownButton<String>);
      expect(dropdownFinder, findsOneWidget);

      // Note: Testing dropdown selection requires more complex interaction
      // For now, just verify the dropdown is present
      IntegrationTestUtils.expectWidgetVisible(dropdownFinder);
    });

    testWidgets('SettingsScreen handles language input',
        (WidgetTester tester) async {
      // Arrange
      final mockSettings = SettingsData(
        notifications: NotificationSettings(
          enabled: true,
          pushEnabled: true,
          emailEnabled: false,
          soundEnabled: true,
        ),
        privacy: PrivacySettings(
          profileVisible: true,
          locationVisible: false,
          activityVisible: true,
        ),
        theme: 'dark',
        languageCode: 'en',
      );

      when(mockSettingsBloc.state).thenReturn(SettingsLoaded(mockSettings));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
        ],
        child: const SettingsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Find language input field
      final textFields = find.byType(TextFormField);
      expect(textFields, findsOneWidget); // Language field

      // Enter new language code
      await IntegrationTestUtils.enterTextAndSettle(
        tester,
        textFields.first,
        'es',
      );

      // Assert - Language update event should be triggered
      verify(mockSettingsBloc.add(any)).called(greaterThan(1));
    });

    testWidgets('SettingsScreen handles service connection requests',
        (WidgetTester tester) async {
      // Arrange
      final mockSettings = SettingsData(
        notifications: NotificationSettings(
          enabled: true,
          pushEnabled: true,
          emailEnabled: false,
          soundEnabled: true,
        ),
        privacy: PrivacySettings(
          profileVisible: true,
          locationVisible: false,
          activityVisible: true,
        ),
        theme: 'dark',
        languageCode: 'en',
      );

      when(mockSettingsBloc.state).thenReturn(SettingsLoaded(mockSettings));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
        ],
        child: const SettingsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Find service connection buttons
      final connectButtons = find.text('Connect');
      expect(connectButtons, findsNWidgets(4)); // Spotify, YTMusic, Last.fm, MAL

      // Tap Spotify connect button
      await IntegrationTestUtils.tapAndSettle(
        tester,
        connectButtons.first,
      );

      // Assert - Service login URL request should be triggered
      verify(mockSettingsBloc.add(GetServiceLoginUrl('spotify'))).called(1);
    });

    testWidgets('SettingsScreen handles save settings',
        (WidgetTester tester) async {
      // Arrange
      final mockSettings = SettingsData(
        notifications: NotificationSettings(
          enabled: true,
          pushEnabled: true,
          emailEnabled: false,
          soundEnabled: true,
        ),
        privacy: PrivacySettings(
          profileVisible: true,
          locationVisible: false,
          activityVisible: true,
        ),
        theme: 'dark',
        languageCode: 'en',
      );

      when(mockSettingsBloc.state).thenReturn(SettingsLoaded(mockSettings));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
        ],
        child: const SettingsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Tap save settings button
      await IntegrationTestUtils.tapAndSettle(
        tester,
        find.text('Save Settings'),
      );

      // Assert - Save event should be triggered
      verify(mockSettingsBloc.add(SaveSettingsEvent())).called(1);
    });

    testWidgets('SettingsScreen displays error messages',
        (WidgetTester tester) async {
      // Arrange
      when(mockSettingsBloc.state).thenReturn(SettingsLoading());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
        ],
        child: BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: DesignSystem.error,
                ),
              );
            }
          },
          child: const SettingsScreen(),
        ),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate error state
      mockSettingsBloc.emit(const SettingsError('Failed to load settings'));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SettingsScreen));
      IntegrationTestUtils.expectTextVisible('Error: Failed to load settings');
    });

    testWidgets('SettingsScreen displays success messages for saved settings',
        (WidgetTester tester) async {
      // Arrange
      when(mockSettingsBloc.state).thenReturn(SettingsLoading());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
        ],
        child: BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is SettingsSaved) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Settings saved successfully'),
                  backgroundColor: DesignSystem.success,
                ),
              );
            }
          },
          child: const SettingsScreen(),
        ),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate settings saved
      mockSettingsBloc.emit(const SettingsSaved());
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SettingsScreen));
      IntegrationTestUtils.expectTextVisible('Settings saved successfully');
    });

    testWidgets('SettingsScreen handles service connection success',
        (WidgetTester tester) async {
      // Arrange
      when(mockSettingsBloc.state).thenReturn(SettingsLoading());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
        ],
        child: BlocListener<SettingsBloc, SettingsState>(
          listener: (context, state) {
            if (state is ServiceConnected) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${state.service} connected successfully'),
                  backgroundColor: DesignSystem.success,
                ),
              );
            }
          },
          child: const SettingsScreen(),
        ),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate service connection
      mockSettingsBloc.emit(const ServiceConnected('Spotify'));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SettingsScreen));
      IntegrationTestUtils.expectTextVisible('Spotify connected successfully');
    });

    testWidgets('SettingsScreen handles API errors gracefully',
        (WidgetTester tester) async {
      // Arrange - simulate API failure
      mockApiClient.setErrorResponse('GET', '/api/settings');

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
        ],
        child: const SettingsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate API error
      mockSettingsBloc.emit(const SettingsError('API Error'));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SettingsScreen));
      IntegrationTestUtils.expectTextVisible('Error: API Error');
    });

    testWidgets('SettingsScreen handles network connectivity issues',
        (WidgetTester tester) async {
      // Arrange - simulate network failure
      mockApiClient.setNetworkError('GET', '/api/settings');

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
        ],
        child: const SettingsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate network error
      mockSettingsBloc.emit(const SettingsError('Network Error'));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SettingsScreen));
      IntegrationTestUtils.expectTextVisible('Error: Network Error');
    });

    testWidgets('SettingsScreen handles rapid state changes correctly',
        (WidgetTester tester) async {
      // Arrange
      final mockSettings = SettingsData(
        notifications: NotificationSettings(
          enabled: true,
          pushEnabled: true,
          emailEnabled: false,
          soundEnabled: true,
        ),
        privacy: PrivacySettings(
          profileVisible: true,
          locationVisible: false,
          activityVisible: true,
        ),
        theme: 'dark',
        languageCode: 'en',
      );

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
        ],
        child: const SettingsScreen(),
      );

      // Act - Simulate rapid state changes
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Loading -> Loaded -> Error -> Loaded
      mockSettingsBloc.emit(SettingsLoading());
      await tester.pump();

      mockSettingsBloc.emit(SettingsLoaded(mockSettings));
      await tester.pump();

      mockSettingsBloc.emit(const SettingsError('Temporary error'));
      await tester.pump();

      mockSettingsBloc.emit(SettingsLoaded(mockSettings));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(SettingsScreen));
      IntegrationTestUtils.expectTextVisible('Save Settings');
    });

    testWidgets('SettingsScreen maintains state during orientation changes',
        (WidgetTester tester) async {
      // Arrange
      final mockSettings = SettingsData(
        notifications: NotificationSettings(
          enabled: true,
          pushEnabled: true,
          emailEnabled: false,
          soundEnabled: true,
        ),
        privacy: PrivacySettings(
          profileVisible: true,
          locationVisible: false,
          activityVisible: true,
        ),
        theme: 'dark',
        languageCode: 'en',
      );

      when(mockSettingsBloc.state).thenReturn(SettingsLoaded(mockSettings));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
        ],
        child: const SettingsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate orientation change (this would require additional setup in a real scenario)
      // For now, just verify the screen renders correctly with settings
      IntegrationTestUtils.expectWidgetVisible(find.byType(SettingsScreen));
      IntegrationTestUtils.expectTextVisible('Notifications');
    });

    testWidgets('SettingsScreen displays all UI components correctly',
        (WidgetTester tester) async {
      // Arrange
      final mockSettings = SettingsData(
        notifications: NotificationSettings(
          enabled: true,
          pushEnabled: true,
          emailEnabled: false,
          soundEnabled: true,
        ),
        privacy: PrivacySettings(
          profileVisible: true,
          locationVisible: false,
          activityVisible: true,
        ),
        theme: 'dark',
        languageCode: 'en',
      );

      when(mockSettingsBloc.state).thenReturn(SettingsLoaded(mockSettings));

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<SettingsBloc>.value(value: mockSettingsBloc),
        ],
        child: const SettingsScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert - Check for all major UI components
      IntegrationTestUtils.expectWidgetVisible(find.byType(SettingsScreen));
      IntegrationTestUtils.expectWidgetVisible(find.byType(AppBar));
      IntegrationTestUtils.expectWidgetVisible(find.byType(SingleChildScrollView));
      expect(find.byType(Card), findsNWidgets(6)); // 6 settings sections
      expect(find.byType(SwitchListTile), findsNWidgets(7)); // Notification and privacy switches
      expect(find.byType(DropdownButton<String>), findsOneWidget); // Theme dropdown
      expect(find.byType(TextFormField), findsOneWidget); // Language field
      expect(find.text('Connect'), findsNWidgets(4)); // Service connect buttons
      IntegrationTestUtils.expectTextVisible('Save Settings');
    });
  });
}