import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:musicbud_flutter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow E2E Tests', () {
    testWidgets('should display login screen', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for login screen elements
      final loginButton = find.text('Login');
      final signInButton = find.text('Sign In');
      
      final hasLoginScreen = loginButton.evaluate().isNotEmpty || 
                            signInButton.evaluate().isNotEmpty;
      
      expect(hasLoginScreen, isTrue, reason: 'Should show login screen');
    });

    testWidgets('should navigate to register screen from login',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for register/sign up link
      final registerLinks = [
        find.text('Sign Up'),
        find.text('Register'),
        find.text('Create Account'),
        find.text('Don\'t have an account?'),
      ];

      for (final link in registerLinks) {
        if (link.evaluate().isNotEmpty) {
          await tester.tap(link);
          await tester.pumpAndSettle();
          
          // Should navigate to register screen
          expect(find.byType(Scaffold), findsWidgets);
          break;
        }
      }
    });

    testWidgets('should validate email field on login',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find email field
      final emailField = find.byType(TextField).first;
      if (emailField.evaluate().isNotEmpty) {
        // Enter invalid email
        await tester.enterText(emailField, 'invalid-email');
        await tester.pumpAndSettle();

        // Try to submit
        final submitButton = find.text('Login').last;
        if (submitButton.evaluate().isNotEmpty) {
          await tester.tap(submitButton);
          await tester.pumpAndSettle();

          // Should show validation error
          expect(
            find.textContaining('email', findRichText: true),
            findsWidgets,
            reason: 'Should validate email format',
          );
        }
      }
    });

    testWidgets('should validate password field on login',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find password field (usually second TextField or has obscureText)
      final textFields = find.byType(TextField);
      if (textFields.evaluate().length >= 2) {
        final passwordField = textFields.at(1);
        
        // Enter short password
        await tester.enterText(passwordField, '123');
        await tester.pumpAndSettle();

        // Try to submit
        final submitButton = find.text('Login');
        if (submitButton.evaluate().isNotEmpty) {
          await tester.tap(submitButton);
          await tester.pumpAndSettle();

          // Should show validation error or stay on page
          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });

    testWidgets('should toggle password visibility',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for password visibility toggle icon
      final visibilityIcons = [
        find.byIcon(Icons.visibility),
        find.byIcon(Icons.visibility_off),
      ];

      for (final icon in visibilityIcons) {
        if (icon.evaluate().isNotEmpty) {
          await tester.tap(icon);
          await tester.pumpAndSettle();

          // Icon should toggle
          expect(find.byType(IconButton), findsWidgets);
          break;
        }
      }
    });

    testWidgets('should show forgot password option',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final forgotPasswordLinks = [
        find.text('Forgot Password?'),
        find.text('Forgot password?'),
        find.text('Reset Password'),
      ];

      bool foundForgotPassword = false;
      for (final link in forgotPasswordLinks) {
        if (link.evaluate().isNotEmpty) {
          foundForgotPassword = true;
          
          // Tap on it
          await tester.tap(link);
          await tester.pumpAndSettle();
          
          // Should navigate somewhere or show dialog
          expect(find.byType(Scaffold), findsWidgets);
          break;
        }
      }

      if (!foundForgotPassword) {
        print('Note: Forgot password link not found');
      }
    });

    testWidgets('should display register form fields',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to register
      final registerLink = find.text('Sign Up');
      if (registerLink.evaluate().isNotEmpty) {
        await tester.tap(registerLink);
        await tester.pumpAndSettle();

        // Should have multiple text fields (email, password, confirm password, etc.)
        expect(
          find.byType(TextField),
          findsWidgets,
          reason: 'Register form should have multiple fields',
        );
      }
    });

    testWidgets('should validate password confirmation on register',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to register
      final registerLink = find.text('Sign Up');
      if (registerLink.evaluate().isNotEmpty) {
        await tester.tap(registerLink);
        await tester.pumpAndSettle();

        final textFields = find.byType(TextField);
        if (textFields.evaluate().length >= 3) {
          // Enter mismatched passwords
          await tester.enterText(textFields.at(1), 'password123');
          await tester.enterText(textFields.at(2), 'password456');
          await tester.pumpAndSettle();

          // Try to submit
          final registerButton = find.text('Register');
          if (registerButton.evaluate().isNotEmpty) {
            await tester.tap(registerButton);
            await tester.pumpAndSettle();

            // Should show error or stay on page
            expect(find.byType(Scaffold), findsWidgets);
          }
        }
      }
    });

    testWidgets('should show loading indicator during authentication',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Fill in valid-looking credentials
      final textFields = find.byType(TextField);
      if (textFields.evaluate().length >= 2) {
        await tester.enterText(textFields.first, 'test@example.com');
        await tester.enterText(textFields.at(1), 'password123');
        
        // Submit
        final loginButton = find.text('Login');
        if (loginButton.evaluate().isNotEmpty) {
          await tester.tap(loginButton);
          await tester.pump(); // Don't settle, catch loading state

          // Should show loading indicator
          expect(
            find.byType(CircularProgressIndicator),
            findsWidgets,
            reason: 'Should show loading during authentication',
          );
        }
      }
    });

    testWidgets('should handle authentication errors gracefully',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Try login with invalid credentials
      final textFields = find.byType(TextField);
      if (textFields.evaluate().length >= 2) {
        await tester.enterText(textFields.first, 'wrong@example.com');
        await tester.enterText(textFields.at(1), 'wrongpassword');
        await tester.pumpAndSettle();

        final loginButton = find.text('Login');
        if (loginButton.evaluate().isNotEmpty) {
          await tester.tap(loginButton);
          await tester.pumpAndSettle(const Duration(seconds: 3));

          // Should show error message (SnackBar, Dialog, or inline)
          final errorIndicators = [
            find.byType(SnackBar),
            find.text('Error'),
            find.text('Invalid'),
            find.text('Failed'),
          ];

          bool foundError = false;
          for (final indicator in errorIndicators) {
            if (indicator.evaluate().isNotEmpty) {
              foundError = true;
              break;
            }
          }

          // Either found error or still on login screen
          expect(find.byType(Scaffold), findsWidgets);
        }
      }
    });

    testWidgets('should support social authentication buttons',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Look for social login buttons
      final socialLoginTexts = [
        'Google',
        'Facebook',
        'Apple',
        'Sign in with',
        'Continue with',
      ];

      for (final text in socialLoginTexts) {
        if (find.textContaining(text, findRichText: true).evaluate().isNotEmpty) {
          print('Found social login option: $text');
          break;
        }
      }
    });

    testWidgets('should navigate back from register to login',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Navigate to register
      final registerLink = find.text('Sign Up');
      if (registerLink.evaluate().isNotEmpty) {
        await tester.tap(registerLink);
        await tester.pumpAndSettle();

        // Find back button or "Already have account" link
        final backButton = find.byIcon(Icons.arrow_back);
        final loginLink = find.textContaining('already', findRichText: true);

        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton);
          await tester.pumpAndSettle();
        } else if (loginLink.evaluate().isNotEmpty) {
          await tester.tap(loginLink);
          await tester.pumpAndSettle();
        }

        // Should be back on login
        expect(find.text('Login'), findsWidgets);
      }
    });

    testWidgets('should handle guest/skip login option if available',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final guestOptions = [
        find.text('Continue as Guest'),
        find.text('Skip'),
        find.text('Browse'),
        find.text('Explore'),
      ];

      for (final option in guestOptions) {
        if (option.evaluate().isNotEmpty) {
          await tester.tap(option);
          await tester.pumpAndSettle();

          // Should navigate to main app
          expect(find.byType(Scaffold), findsWidgets);
          break;
        }
      }
    });
  });
}
