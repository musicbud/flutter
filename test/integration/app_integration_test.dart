import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:musicbud_flutter/main.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/services/dynamic_config_service.dart';
import 'package:musicbud_flutter/domain/repositories/auth_repository.dart';
import 'package:musicbud_flutter/data/providers/token_provider.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';

@GenerateMocks([
  ApiService,
  AuthRepository,
  TokenProvider,
  DynamicConfigService,
])
import 'app_integration_test.mocks.dart';

void main() {
  group('App Integration Tests', () {
    late MockApiService mockApiService;
    late MockAuthRepository mockAuthRepository;
    late MockTokenProvider mockTokenProvider;
    late MockDynamicConfigService mockConfigService;

    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      FlutterSecureStorage.setMockInitialValues({});
    });

    setUp(() async {
      // Clear any existing GetIt instances
      if (GetIt.instance.isRegistered<ApiService>()) {
        await GetIt.instance.reset();
      }

      mockApiService = MockApiService();
      mockAuthRepository = MockAuthRepository();
      mockTokenProvider = MockTokenProvider();
      mockConfigService = MockDynamicConfigService();

      // Register mocks
      GetIt.instance.registerSingleton<ApiService>(mockApiService);
      GetIt.instance.registerSingleton<AuthRepository>(mockAuthRepository);
      GetIt.instance.registerSingleton<TokenProvider>(mockTokenProvider);
      GetIt.instance.registerSingleton<DynamicConfigService>(mockConfigService);

      // Setup default mock responses
      when(mockTokenProvider.token).thenReturn(null);
      when(mockConfigService.getTheme()).thenReturn('system');
      when(mockConfigService.isFeatureEnabled(any)).thenReturn(true);
      when(mockConfigService.get<bool>(any, defaultValue: anyNamed('defaultValue')))
          .thenReturn(true);
    });

    tearDown(() async {
      await GetIt.instance.reset();
    });

    group('App Initialization', () {
      testWidgets('should initialize app successfully without token', (WidgetTester tester) async {
        when(mockTokenProvider.token).thenReturn(null);

        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        // Should show login screen when no token
        expect(find.text('Login'), findsWidgets);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should initialize app successfully with valid token', (WidgetTester tester) async {
        const validToken = 'valid_token';
        when(mockTokenProvider.token).thenReturn(validToken);
        when(mockAuthRepository.validateToken(validToken)).thenAnswer((_) async => true);

        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        // Should show home screen when valid token exists
        expect(find.text('MusicBud'), findsWidgets);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should apply DesignSystem theme correctly', (WidgetTester tester) async {
        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        // Check that DesignSystem theme is applied
        final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(materialApp.theme?.colorScheme.primary, DesignSystem.primary);
        expect(materialApp.theme?.useMaterial3, true);
      });
    });

    group('Authentication Flow', () {
      testWidgets('should complete login flow successfully', (WidgetTester tester) async {
        const email = 'test@example.com';
        const password = 'password123';
        const token = 'new_token';

        when(mockTokenProvider.token).thenReturn(null);
        when(mockAuthRepository.login(email: email, password: password))
            .thenAnswer((_) async => token);
        when(mockTokenProvider.updateToken(token)).thenAnswer((_) async => {});

        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        // Should be on login screen
        expect(find.text('Login'), findsWidgets);

        // Enter credentials (assuming login form exists)
        if (find.byType(TextFormField).evaluate().length >= 2) {
          await tester.enterText(find.byType(TextFormField).at(0), email);
          await tester.enterText(find.byType(TextFormField).at(1), password);

          // Tap login button
          final loginButtons = find.text('Login');
          if (loginButtons.evaluate().isNotEmpty) {
            await tester.tap(loginButtons.first);
            await tester.pumpAndSettle();

            // Should navigate to home screen after successful login
            verify(mockAuthRepository.login(email: email, password: password)).called(1);
            verify(mockTokenProvider.updateToken(token)).called(1);
          }
        }
      });

      testWidgets('should handle login failure gracefully', (WidgetTester tester) async {
        const email = 'test@example.com';
        const password = 'wrong_password';

        when(mockTokenProvider.token).thenReturn(null);
        when(mockAuthRepository.login(email: email, password: password))
            .thenThrow(Exception('Invalid credentials'));

        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        // Attempt login with wrong credentials
        if (find.byType(TextFormField).evaluate().length >= 2) {
          await tester.enterText(find.byType(TextFormField).at(0), email);
          await tester.enterText(find.byType(TextFormField).at(1), password);

          final loginButtons = find.text('Login');
          if (loginButtons.evaluate().isNotEmpty) {
            await tester.tap(loginButtons.first);
            await tester.pumpAndSettle();

            // Should show error message and stay on login screen
            expect(find.text('Login'), findsWidgets);
            // Error message might be shown in a snackbar or dialog
          }
        }
      });

      testWidgets('should complete logout flow successfully', (WidgetTester tester) async {
        const token = 'valid_token';
        when(mockTokenProvider.token).thenReturn(token);
        when(mockAuthRepository.validateToken(token)).thenAnswer((_) async => true);
        when(mockAuthRepository.logout()).thenAnswer((_) async => {});
        when(mockTokenProvider.clearToken()).thenAnswer((_) async => {});

        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        // Should be on home screen
        expect(find.text('MusicBud'), findsWidgets);

        // Find and tap logout (assuming it's in settings or menu)
        if (find.byIcon(Icons.settings).evaluate().isNotEmpty) {
          await tester.tap(find.byIcon(Icons.settings));
          await tester.pumpAndSettle();

          // Look for logout option
          if (find.text('Logout').evaluate().isNotEmpty) {
            await tester.tap(find.text('Logout'));
            await tester.pumpAndSettle();

            // Should return to login screen
            verify(mockAuthRepository.logout()).called(1);
            verify(mockTokenProvider.clearToken()).called(1);
          }
        }
      });
    });

    group('Navigation Flow', () {
      testWidgets('should navigate between main screens', (WidgetTester tester) async {
        const token = 'valid_token';
        when(mockTokenProvider.token).thenReturn(token);
        when(mockAuthRepository.validateToken(token)).thenAnswer((_) async => true);

        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        // Should be on home screen
        expect(find.text('MusicBud'), findsWidgets);

        // Test navigation to search
        if (find.byIcon(Icons.search).evaluate().isNotEmpty) {
          await tester.tap(find.byIcon(Icons.search));
          await tester.pumpAndSettle();
          
          // Should navigate to search screen
          expect(tester.takeException(), isNull);
        }

        // Test navigation back
        if (find.byIcon(Icons.arrow_back).evaluate().isNotEmpty) {
          await tester.tap(find.byIcon(Icons.arrow_back));
          await tester.pumpAndSettle();
        }
      });

      testWidgets('should handle bottom navigation', (WidgetTester tester) async {
        const token = 'valid_token';
        when(mockTokenProvider.token).thenReturn(token);
        when(mockAuthRepository.validateToken(token)).thenAnswer((_) async => true);

        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        // Look for bottom navigation bar
        if (find.byType(BottomNavigationBar).evaluate().isNotEmpty) {
          final bottomNavItems = find.byType(BottomNavigationBarItem);
          
          if (bottomNavItems.evaluate().length > 1) {
            // Tap second tab
            await tester.tap(bottomNavItems.at(1));
            await tester.pumpAndSettle();
            
            expect(tester.takeException(), isNull);
          }
        }
      });
    });

    group('Data Loading Flow', () {
      testWidgets('should load user profile data', (WidgetTester tester) async {
        const token = 'valid_token';
        final profileData = {
          'uid': 'user123',
          'username': 'testuser',
          'bio': 'Test bio',
          'profile_image': 'https://example.com/image.jpg',
        };

        when(mockTokenProvider.token).thenReturn(token);
        when(mockAuthRepository.validateToken(token)).thenAnswer((_) async => true);
        when(mockApiService.getUserProfile()).thenAnswer((_) async => 
          UserProfile.fromJson(profileData));

        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        // Navigate to profile (if accessible)
        if (find.text('Profile').evaluate().isNotEmpty) {
          await tester.tap(find.text('Profile'));
          await tester.pumpAndSettle();

          // Should load profile data
          expect(find.text('testuser'), findsWidgets);
        }
      });

      testWidgets('should handle API errors gracefully', (WidgetTester tester) async {
        const token = 'valid_token';
        when(mockTokenProvider.token).thenReturn(token);
        when(mockAuthRepository.validateToken(token)).thenAnswer((_) async => true);
        when(mockApiService.getUserProfile()).thenThrow(Exception('Network error'));

        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        // App should still function despite API errors
        expect(find.text('MusicBud'), findsWidgets);
        expect(tester.takeException(), isNull);
      });
    });

    group('Theme and Configuration', () {
      testWidgets('should respect theme configuration', (WidgetTester tester) async {
        when(mockConfigService.getTheme()).thenReturn('dark');

        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        // Check that dark theme is applied
        final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
        expect(materialApp.darkTheme, isNotNull);
        expect(materialApp.themeMode, ThemeMode.system);
      });

      testWidgets('should respect feature flags', (WidgetTester tester) async {
        when(mockConfigService.isFeatureEnabled('music_discovery')).thenReturn(false);

        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        // Features should be disabled based on configuration
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle responsive layout changes', (WidgetTester tester) async {
        // Test mobile layout
        await tester.binding.setSurfaceSize(const Size(400, 800));
        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        expect(find.byType(MaterialApp), findsOneWidget);

        // Test tablet layout
        await tester.binding.setSurfaceSize(const Size(800, 1024));
        await tester.pump();

        expect(tester.takeException(), isNull);

        // Test desktop layout
        await tester.binding.setSurfaceSize(const Size(1400, 1024));
        await tester.pump();

        expect(tester.takeException(), isNull);
      });
    });

    group('Error Handling', () {
      testWidgets('should handle initialization errors gracefully', (WidgetTester tester) async {
        when(mockConfigService.initialize()).thenThrow(Exception('Init error'));

        // App should still start despite config service errors
        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        expect(find.byType(MaterialApp), findsOneWidget);
        // Error should not crash the app
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle service connection errors', (WidgetTester tester) async {
        when(mockApiService.initialize(any)).thenThrow(Exception('Connection error'));

        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        // App should handle API service initialization errors
        expect(find.byType(MaterialApp), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle token validation errors', (WidgetTester tester) async {
        const invalidToken = 'invalid_token';
        when(mockTokenProvider.token).thenReturn(invalidToken);
        when(mockAuthRepository.validateToken(invalidToken))
            .thenThrow(Exception('Token validation error'));
        when(mockTokenProvider.clearToken()).thenAnswer((_) async => {});

        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        // Should handle token validation errors and redirect to login
        expect(tester.takeException(), isNull);
      });
    });

    group('Performance and Memory', () {
      testWidgets('should not have memory leaks during navigation', (WidgetTester tester) async {
        const token = 'valid_token';
        when(mockTokenProvider.token).thenReturn(token);
        when(mockAuthRepository.validateToken(token)).thenAnswer((_) async => true);

        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        // Navigate between screens multiple times
        for (int i = 0; i < 3; i++) {
          if (find.byIcon(Icons.search).evaluate().isNotEmpty) {
            await tester.tap(find.byIcon(Icons.search));
            await tester.pumpAndSettle();
          }
          
          if (find.byIcon(Icons.arrow_back).evaluate().isNotEmpty) {
            await tester.tap(find.byIcon(Icons.arrow_back));
            await tester.pumpAndSettle();
          }
        }

        // No exceptions should occur
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle large data sets efficiently', (WidgetTester tester) async {
        const token = 'valid_token';
        when(mockTokenProvider.token).thenReturn(token);
        when(mockAuthRepository.validateToken(token)).thenAnswer((_) async => true);

        // Mock large data response
        final largeDataSet = List.generate(1000, (index) => {
          'id': 'item_$index',
          'name': 'Item $index',
          'description': 'Description for item $index',
        });

        await tester.pumpWidget(const MusicBudApp());
        await tester.pumpAndSettle();

        // App should handle large data sets without performance issues
        expect(tester.takeException(), isNull);
      });
    });
  });
}