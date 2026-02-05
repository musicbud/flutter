import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../blocs/auth/login/login_bloc.dart';
import '../../../blocs/auth/login/login_event.dart';
import '../../../blocs/auth/login/login_state.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../data/providers/token_provider.dart';
import '../../../core/theme/design_system.dart';
import 'register_screen.dart';

// Enhanced UI Library
import '../../widgets/enhanced/enhanced_widgets.dart';

// Enhanced BLoC Widgets
import '../../../widgets/enhanced_bloc_widgets.dart';

/// Enhanced Login Screen using BlocFormWidget
/// 
/// This is the migrated version of login_screen.dart that uses the new
/// BlocFormWidget to reduce boilerplate by ~67%.
/// 
/// Key improvements:
/// - Automatic loading state handling
/// - Built-in snackbar notifications
/// - Cleaner code structure
/// - Better separation of concerns
class LoginScreenEnhanced extends StatefulWidget {
  const LoginScreenEnhanced({super.key});

  @override
  State<LoginScreenEnhanced> createState() => _LoginScreenEnhancedState();
}

class _LoginScreenEnhancedState extends State<LoginScreenEnhanced> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSuccess(BuildContext context, LoginState state) async {
    if (state is! LoginSuccess) return;

    try {
      // Store tokens securely
      final tokenProvider = GetIt.instance<TokenProvider>();
      await tokenProvider.updateTokens(
        state.data.accessToken ?? '',
        state.data.refreshToken ?? '',
      );

      // Trigger AuthBloc to update its state
      if (context.mounted) {
        context.read<AuthBloc>().add(TokenRefreshRequested());
      }

      // Navigate back to root
      if (context.mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error storing auth data: $e'),
            backgroundColor: DesignSystem.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              DesignSystem.surfaceContainer,
              DesignSystem.background,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Title Section
                  const Text(
                    'MusicBud',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: DesignSystem.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Connect through music',
                    style: TextStyle(
                      fontSize: 16,
                      color: DesignSystem.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Form using BlocFormWidget
                  BlocFormWidget<LoginBloc, LoginState>(
                    formKey: _formKey,
                    padding: EdgeInsets.zero,
                    showLoadingOverlay: false, // Use inline button loading
                    formFields: (context) => [
                      // Username field
                      ModernInputField(
                        hintText: 'Username',
                        controller: _usernameController,
                        prefixIcon: const Icon(Icons.person),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      
                      // Password field
                      ModernInputField(
                        hintText: 'Password',
                        controller: _passwordController,
                        prefixIcon: const Icon(Icons.lock),
                        obscureText: true,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please enter your password';
                          }
                          if (value!.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                    ],
                    submitButtonText: 'Login',
                    submitButtonVariant: ModernButtonVariant.primary,
                    onSubmit: (context) {
                      if (_formKey.currentState!.validate()) {
                        context.read<LoginBloc>().add(
                              LoginSubmitted(
                                username: _usernameController.text.trim(),
                                password: _passwordController.text,
                              ),
                            );
                      }
                    },
                    isLoading: (state) => state is LoginLoading,
                    isSuccess: (state) => state is LoginSuccess,
                    isError: (state) => state is LoginFailure,
                    getErrorMessage: (state) => (state as LoginFailure).error,
                    onSuccess: _handleSuccess,
                    fieldSpacing: 16.0,
                  ),

                  const SizedBox(height: 8),

                  // Forgot password link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Forgot password functionality coming soon!'),
                            backgroundColor: DesignSystem.info,
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: DesignSystem.primary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: DesignSystem.onSurfaceVariant),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                            color: DesignSystem.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}