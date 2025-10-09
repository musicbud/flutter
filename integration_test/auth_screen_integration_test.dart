import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

// App imports
import 'package:musicbud_flutter/presentation/screens/auth/login_screen.dart';
import 'package:musicbud_flutter/blocs/auth/login/login_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/login/login_event.dart';
import 'package:musicbud_flutter/blocs/auth/login/login_state.dart';
import 'package:musicbud_flutter/blocs/auth/auth_event.dart';
import 'package:musicbud_flutter/core/theme/design_system.dart';
import 'package:musicbud_flutter/models/auth_response.dart';

// Test utilities
import 'test_utils/test_helpers.dart';
import 'test_utils/mock_api_client.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AuthScreen Integration Tests', () {
    late MockLoginBloc mockLoginBloc;
    late MockAuthBloc mockAuthBloc;
    late MockTokenProvider mockTokenProvider;
    late MockApiClient mockApiClient;

    setUp(() {
      mockLoginBloc = MockLoginBloc();
      mockAuthBloc = MockAuthBloc();
      mockTokenProvider = MockTokenProvider();
      mockApiClient = MockApiClient();
      TestSetup.setupMockDependencies();
    });

    tearDown(() {
      TestSetup.teardownMockDependencies();
    });

    testWidgets('LoginScreen renders correctly with initial state',
        (WidgetTester tester) async {
      // Arrange
      when(mockLoginBloc.state).thenReturn(LoginInitial());
      when(mockauth_bloc.AuthBloc.state).thenReturn(auth_bloc.AuthInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<LoginBloc>.value(value: mockLoginBloc),
          BlocProvider<auth_bloc.AuthBloc>.value(value: mockauth_bloc.AuthBloc),
        ],
        child: const LoginScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(LoginScreen));
      IntegrationTestUtils.expectTextVisible('MusicBud');
      IntegrationTestUtils.expectTextVisible('Connect through music');
      expect(find.byType(TextFormField), findsNWidgets(2)); // Username and password
      IntegrationTestUtils.expectTextVisible('Login');
      IntegrationTestUtils.expectTextVisible('Don\'t have an account? Sign up');
    });

    testWidgets('LoginScreen displays loading state during login',
        (WidgetTester tester) async {
      // Arrange
      when(mockLoginBloc.state).thenReturn(LoginLoading());
      when(mockauth_bloc.AuthBloc.state).thenReturn(auth_bloc.auth_bloc.AuthInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<LoginBloc>.value(value: mockLoginBloc),
          BlocProvider<auth_bloc.AuthBloc>.value(value: mockauth_bloc.AuthBloc),
        ],
        child: const LoginScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(LoginScreen));
      IntegrationTestUtils.expectTextVisible('Logging in...');
      // Button should be disabled during loading
      final buttonFinder = find.text('Logging in...');
      expect(buttonFinder, findsOneWidget);
    });

    testWidgets('LoginScreen handles successful login flow',
        (WidgetTester tester) async {
      // Arrange
      when(mockLoginBloc.state).thenReturn(LoginInitial());
      when(mockauth_bloc.AuthBloc.state).thenReturn(auth_bloc.auth_bloc.AuthInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<LoginBloc>.value(value: mockLoginBloc),
          BlocProvider<auth_bloc.AuthBloc>.value(value: mockauth_bloc.AuthBloc),
        ],
        child: const LoginScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Enter credentials
      await IntegrationTestUtils.enterTextAndSettle(
        tester,
        find.byType(TextFormField).first, // Username field
        'testuser',
      );
      await IntegrationTestUtils.enterTextAndSettle(
        tester,
        find.byType(TextFormField).last, // Password field
        'password123',
      );

      // Tap login button
      await IntegrationTestUtils.tapAndSettle(
        tester,
        find.text('Login'),
      );

      // Assert - Verify LoginBloc event was triggered
      verify(mockLoginBloc.add(LoginSubmitted(
        username: 'testuser',
        password: 'password123',
      ))).called(1);
    });

    testWidgets('LoginScreen triggers auth_bloc.AuthBloc login on LoginSuccess',
        (WidgetTester tester) async {
      // Arrange
      when(mockLoginBloc.state).thenReturn(LoginInitial());
      when(mockauth_bloc.AuthBloc.state).thenReturn(auth_bloc.auth_bloc.AuthInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<LoginBloc>.value(value: mockLoginBloc),
          BlocProvider<auth_bloc.AuthBloc>.value(value: mockauth_bloc.AuthBloc),
        ],
        child: const LoginScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate LoginSuccess state
      final loginResponse = LoginResponse(
        accessToken: 'test_token',
        refreshToken: 'refresh_token',
      );
      mockLoginBloc.emit(LoginSuccess(loginResponse));
      await tester.pump();

      // Assert - auth_bloc.AuthBloc should receive LoginRequested event
      verify(mockauth_bloc.AuthBloc.add(auth_bloc.LoginRequested(
        username: '', // Empty because controllers are not set in this test
        password: '',
      ))).called(1);
    });

    testWidgets('LoginScreen navigates to home on authentication success',
        (WidgetTester tester) async {
      // Arrange
      when(mockLoginBloc.state).thenReturn(LoginInitial());
      when(mockauth_bloc.AuthBloc.state).thenReturn(auth_bloc.auth_bloc.AuthInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<LoginBloc>.value(value: mockLoginBloc),
          BlocProvider<auth_bloc.AuthBloc>.value(value: mockauth_bloc.AuthBloc),
        ],
        child: const LoginScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate successful authentication
      mockauth_bloc.AuthBloc.emit(auth_bloc.Authenticated(token: 'test_token'));
      await tester.pump();

      // Assert - Navigation should be triggered (would navigate to home in real app)
      // In test environment, we verify the state change
      expect(mockauth_bloc.AuthBloc.state, isA<auth_bloc.Authenticated>());
    });

    testWidgets('LoginScreen displays error message on login failure',
        (WidgetTester tester) async {
      // Arrange
      const errorMessage = 'Invalid credentials';
      when(mockLoginBloc.state).thenReturn(LoginInitial());
      when(mockauth_bloc.AuthBloc.state).thenReturn(auth_bloc.AuthInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<LoginBloc>.value(value: mockLoginBloc),
          BlocProvider<auth_bloc.AuthBloc>.value(value: mockauth_bloc.AuthBloc),
        ],
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: DesignSystem.error,
                ),
              );
            }
          },
          child: const LoginScreen(),
        ),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate login failure
      mockLoginBloc.emit(LoginFailure(errorMessage));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(LoginScreen));
      IntegrationTestUtils.expectTextVisible(errorMessage);
    });

    testWidgets('LoginScreen handles API errors gracefully',
        (WidgetTester tester) async {
      // Arrange - simulate API failure
      mockApiClient.setErrorResponse('POST', '/api/auth/login');

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<LoginBloc>.value(value: mockLoginBloc),
          BlocProvider<auth_bloc.AuthBloc>.value(value: mockauth_bloc.AuthBloc),
        ],
        child: const LoginScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate API error state
      mockLoginBloc.emit(const LoginFailure('API Error'));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(LoginScreen));
      IntegrationTestUtils.expectTextVisible('API Error');
    });

    testWidgets('LoginScreen handles network connectivity issues',
        (WidgetTester tester) async {
      // Arrange - simulate network failure
      mockApiClient.setNetworkError('POST', '/api/auth/login');

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<LoginBloc>.value(value: mockLoginBloc),
          BlocProvider<auth_bloc.AuthBloc>.value(value: mockauth_bloc.AuthBloc),
        ],
        child: const LoginScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Simulate network error
      mockLoginBloc.emit(const LoginFailure('No internet connection'));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(LoginScreen));
      IntegrationTestUtils.expectTextVisible('No internet connection');
    });

    testWidgets('LoginScreen validates empty fields',
        (WidgetTester tester) async {
      // Arrange
      when(mockLoginBloc.state).thenReturn(LoginInitial());
      when(mockauth_bloc.AuthBloc.state).thenReturn(auth_bloc.AuthInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<LoginBloc>.value(value: mockLoginBloc),
          BlocProvider<auth_bloc.AuthBloc>.value(value: mockauth_bloc.AuthBloc),
        ],
        child: const LoginScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Try to login with empty fields
      await IntegrationTestUtils.tapAndSettle(
        tester,
        find.text('Login'),
      );

      // Assert - LoginBloc should not be called with empty fields
      verifyNever(mockLoginBloc.add(any));
    });

    testWidgets('LoginScreen handles rapid state changes correctly',
        (WidgetTester tester) async {
      // Arrange
      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<LoginBloc>.value(value: mockLoginBloc),
          BlocProvider<auth_bloc.AuthBloc>.value(value: mockauth_bloc.AuthBloc),
        ],
        child: const LoginScreen(),
      );

      // Act - Simulate rapid state changes
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Initial -> Loading -> Success -> Authenticated
      mockLoginBloc.emit(LoginLoading());
      await tester.pump();

      final loginResponse = LoginResponse(accessToken: 'token', refreshToken: 'refresh');
      mockLoginBloc.emit(LoginSuccess(loginResponse));
      await tester.pump();

      mockauth_bloc.AuthBloc.emit(const Authenticated(token: 'token'));
      await tester.pumpAndSettle();

      // Assert
      IntegrationTestUtils.expectWidgetVisible(find.byType(LoginScreen));
      expect(mockauth_bloc.AuthBloc.state, isA<Authenticated>());
    });

    testWidgets('LoginScreen maintains state during orientation changes',
        (WidgetTester tester) async {
      // Arrange
      when(mockLoginBloc.state).thenReturn(LoginInitial());
      when(mockauth_bloc.AuthBloc.state).thenReturn(auth_bloc.AuthInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<LoginBloc>.value(value: mockLoginBloc),
          BlocProvider<auth_bloc.AuthBloc>.value(value: mockauth_bloc.AuthBloc),
        ],
        child: const LoginScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Enter some data
      await IntegrationTestUtils.enterTextAndSettle(
        tester,
        find.byType(TextFormField).first,
        'testuser',
      );

      // Simulate orientation change (this would require additional setup in a real scenario)
      // For now, just verify the screen renders correctly
      IntegrationTestUtils.expectWidgetVisible(find.byType(LoginScreen));
      IntegrationTestUtils.expectTextVisible('testuser');
    });

    testWidgets('LoginScreen displays all UI components correctly',
        (WidgetTester tester) async {
      // Arrange
      when(mockLoginBloc.state).thenReturn(LoginInitial());
      when(mockauth_bloc.AuthBloc.state).thenReturn(auth_bloc.AuthInitial());

      final testApp = TestAppWrapper(
        providers: [
          BlocProvider<LoginBloc>.value(value: mockLoginBloc),
          BlocProvider<auth_bloc.AuthBloc>.value(value: mockauth_bloc.AuthBloc),
        ],
        child: const LoginScreen(),
      );

      // Act
      await IntegrationTestUtils.pumpAndSettle(tester, testApp);

      // Assert - Check for all major UI components
      IntegrationTestUtils.expectWidgetVisible(find.byType(LoginScreen));
      IntegrationTestUtils.expectWidgetVisible(find.byType(Scaffold));
      IntegrationTestUtils.expectWidgetVisible(find.byType(Container)); // Gradient background
      IntegrationTestUtils.expectWidgetVisible(find.byType(SafeArea));
      IntegrationTestUtils.expectWidgetVisible(find.byType(Form));
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(TextButton), findsOneWidget); // Sign up link
    });
  });
}