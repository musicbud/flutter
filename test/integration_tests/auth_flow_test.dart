import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:musicbud_flutter/main.dart';
import 'package:musicbud_flutter/blocs/auth/login/login_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/login/login_event.dart';
import 'package:musicbud_flutter/blocs/auth/login/login_state.dart';
import 'package:musicbud_flutter/blocs/auth/auth_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/auth_event.dart';
import 'package:musicbud_flutter/blocs/auth/auth_state.dart';
import 'package:musicbud_flutter/domain/repositories/auth_repository.dart';
import 'package:musicbud_flutter/data/providers/token_provider.dart';
import 'package:musicbud_flutter/presentation/screens/home/home_screen.dart';
import 'package:musicbud_flutter/presentation/screens/auth/login_screen.dart';
import '../test_utils/test_helpers.dart';


void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow Integration Tests', () {
    setUp(() async {
      await TestSetup.initMockDependencies();
    });

    tearDown(() {
      TestSetup.resetDependencies();
    });

    testWidgets('Successful login flow: login screen → home screen',
        (WidgetTester tester) async {
      // Get mock instances
      final mockTokenProvider = TestSetup.getMock<MockTokenProvider>();
      final mockAuthRepository = TestSetup.getMock<MockAuthRepository>();

      // Setup mocks for successful authentication
      when(mockTokenProvider.token).thenReturn(null); // No existing token
      when(mockTokenProvider.updateToken('mock_token')).thenReturn(Future.value());
      when(mockAuthRepository.login('testuser', 'password123')).thenAnswer((_) async => {'token': 'mock_token', 'user': {'id': '1', 'username': 'testuser'}});

      // Create test app with mocked dependencies
      final testApp = MultiBlocProvider(
        providers: [
          RepositoryProvider<AuthRepository>.value(value: mockAuthRepository),
          Provider<TokenProvider>.value(value: mockTokenProvider),
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(authRepository: mockAuthRepository),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: mockAuthRepository),
          ),
        ],
        child: MaterialApp(
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/': (context) => const HomeScreen(),
          },
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Verify we're on the login screen
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('MusicBud'), findsOneWidget);
      expect(find.text('Connect through music'), findsOneWidget);

      // Enter valid credentials
      await tester.enterText(find.byType(TextField).first, 'testuser');
      await tester.enterText(find.byType(TextField).last, 'password123');

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verify loading state
      expect(find.text('Logging in...'), findsOneWidget);

      // Wait for authentication to complete
      await tester.pumpAndSettle();

      // Verify navigation to home screen
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);

      // Verify token was saved
      verify(mockTokenProvider.updateToken('mock_token')).called(1);
    });

    testWidgets('Login failure with invalid credentials',
        (WidgetTester tester) async {
      // Get mock instances
      final mockTokenProvider = TestSetup.getMock<MockTokenProvider>();
      final mockAuthRepository = TestSetup.getMock<MockAuthRepository>();

      // Setup mocks for failed authentication
      when(mockTokenProvider.token).thenReturn(null);
      when(mockAuthRepository.login('invaliduser', 'wrongpassword')).thenThrow(Exception('Invalid credentials'));

      final testApp = MultiBlocProvider(
        providers: [
          RepositoryProvider<AuthRepository>.value(value: mockAuthRepository),
          Provider<TokenProvider>.value(value: mockTokenProvider),
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(authRepository: mockAuthRepository),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: mockAuthRepository),
          ),
        ],
        child: MaterialApp(
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/': (context) => const HomeScreen(),
          },
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Enter invalid credentials
      await tester.enterText(find.byType(TextField).first, 'invaliduser');
      await tester.enterText(find.byType(TextField).last, 'wrongpassword');

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Wait for error to appear
      await tester.pumpAndSettle();

      // Verify error message is shown
      expect(find.text('Invalid credentials'), findsOneWidget);

      // Verify we're still on login screen
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('Auto-login when token exists',
        (WidgetTester tester) async {
      // Get mock instances
      final mockTokenProvider = TestSetup.getMock<MockTokenProvider>();
      final mockAuthRepository = TestSetup.getMock<MockAuthRepository>();

      // Setup mocks for existing token
      when(mockTokenProvider.token).thenReturn('existing_token');
      when(mockTokenProvider.updateToken('new_token')).thenReturn(Future.value());
      when(mockAuthRepository.login('testuser', 'password123')).thenAnswer((_) async => {'token': 'new_token', 'user': {'id': '1', 'username': 'testuser'}});

      final testApp = MultiBlocProvider(
        providers: [
          RepositoryProvider<AuthRepository>.value(value: mockAuthRepository),
          Provider<TokenProvider>.value(value: mockTokenProvider),
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(authRepository: mockAuthRepository),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: mockAuthRepository),
          ),
        ],
        child: MaterialApp(
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/': (context) => const HomeScreen(),
          },
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Should automatically navigate to home screen due to existing token
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    });

    testWidgets('Network error during login',
        (WidgetTester tester) async {
      // Get mock instances
      final mockTokenProvider = TestSetup.getMock<MockTokenProvider>();
      final mockAuthRepository = TestSetup.getMock<MockAuthRepository>();

      // Setup mocks for network error
      when(mockTokenProvider.token).thenReturn(null);
      when(mockAuthRepository.login('testuser', 'password123')).thenThrow(Exception('Network error'));

      final testApp = MultiBlocProvider(
        providers: [
          RepositoryProvider<AuthRepository>.value(value: mockAuthRepository),
          Provider<TokenProvider>.value(value: mockTokenProvider),
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(authRepository: mockAuthRepository),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: mockAuthRepository),
          ),
        ],
        child: MaterialApp(
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/': (context) => const HomeScreen(),
          },
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Enter credentials
      await tester.enterText(find.byType(TextField).first, 'testuser');
      await tester.enterText(find.byType(TextField).last, 'password123');

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Wait for error
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('Network error'), findsOneWidget);

      // Verify still on login screen
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('Form validation prevents empty submissions',
        (WidgetTester tester) async {
      // Get mock instances
      final mockTokenProvider = TestSetup.getMock<MockTokenProvider>();
      final mockAuthRepository = TestSetup.getMock<MockAuthRepository>();

      when(mockTokenProvider.token).thenReturn(null);

      final testApp = MultiBlocProvider(
        providers: [
          RepositoryProvider<AuthRepository>.value(value: mockAuthRepository),
          Provider<TokenProvider>.value(value: mockTokenProvider),
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(authRepository: mockAuthRepository),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: mockAuthRepository),
          ),
        ],
        child: MaterialApp(
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/': (context) => const HomeScreen(),
          },
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Try to submit empty form
      await tester.tap(find.text('Login'));
      await tester.pump();

      // Verify login was not attempted (no loading state)
      expect(find.text('Logging in...'), findsNothing);

      // Verify still on login screen
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('State persistence after successful login',
        (WidgetTester tester) async {
      // Get mock instances
      final mockTokenProvider = TestSetup.getMock<MockTokenProvider>();
      final mockAuthRepository = TestSetup.getMock<MockAuthRepository>();

      // Setup mocks
      when(mockTokenProvider.token).thenReturn(null);
      when(mockTokenProvider.updateToken('mock_token')).thenReturn(Future.value());
      when(mockAuthRepository.login('testuser', 'password123')).thenAnswer((_) async => {'token': 'mock_token', 'user': {'id': '1', 'username': 'testuser'}});

      final testApp = MultiBlocProvider(
        providers: [
          RepositoryProvider<AuthRepository>.value(value: mockAuthRepository),
          Provider<TokenProvider>.value(value: mockTokenProvider),
          BlocProvider<LoginBloc>(
            create: (context) => LoginBloc(authRepository: mockAuthRepository),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(authRepository: mockAuthRepository),
          ),
        ],
        child: MaterialApp(
          initialRoute: '/login',
          routes: {
            '/login': (context) => const LoginScreen(),
            '/': (context) => const HomeScreen(),
          },
        ),
      );

      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Perform login
      await tester.enterText(find.byType(TextField).first, 'testuser');
      await tester.enterText(find.byType(TextField).last, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify navigation to home
      expect(find.byType(HomeScreen), findsOneWidget);

      // Simulate app restart by recreating the widget tree
      await tester.pumpWidget(testApp);
      await tester.pumpAndSettle();

      // Should still be on home screen (token persisted)
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    });
  });
}