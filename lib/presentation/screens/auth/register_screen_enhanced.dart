import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../core/theme/design_system.dart';

// Enhanced UI Library
import '../../widgets/enhanced/enhanced_widgets.dart';

// Enhanced BLoC Widgets
import '../../../widgets/enhanced_bloc_widgets.dart';

/// Enhanced Register Screen using BlocFormWidget
/// 
/// This is the migrated version of register_screen.dart that uses the new
/// BlocFormWidget to reduce boilerplate and add proper validation.
/// 
/// Key improvements:
/// - Automatic loading state handling
/// - Built-in snackbar notifications
/// - Comprehensive field validation
/// - Password matching validation
/// - Cleaner code structure
class RegisterScreenEnhanced extends StatefulWidget {
  const RegisterScreenEnhanced({super.key});

  @override
  State<RegisterScreenEnhanced> createState() => _RegisterScreenEnhancedState();
}

class _RegisterScreenEnhancedState extends State<RegisterScreenEnhanced> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
                  BlocFormWidget<AuthBloc, AuthState>(
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
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a username';
                          }
                          if (value.trim().length < 3) {
                            return 'Username must be at least 3 characters';
                          }
                          if (value.trim().length > 20) {
                            return 'Username must be less than 20 characters';
                          }
                          // Check for valid characters (alphanumeric and underscore)
                          if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                            return 'Username can only contain letters, numbers, and underscores';
                          }
                          return null;
                        },
                      ),

                      // Email field
                      ModernInputField(
                        hintText: 'Email',
                        controller: _emailController,
                        prefixIcon: const Icon(Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          // Basic email validation
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
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
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          if (value.length > 50) {
                            return 'Password must be less than 50 characters';
                          }
                          return null;
                        },
                      ),

                      // Confirm Password field
                      ModernInputField(
                        hintText: 'Confirm Password',
                        controller: _confirmPasswordController,
                        prefixIcon: const Icon(Icons.lock_outline),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                    ],
                    submitButtonText: 'Create Account',
                    submitButtonVariant: ModernButtonVariant.primary,
                    onSubmit: (context) {
                      if (_formKey.currentState!.validate()) {
                        context.read<AuthBloc>().add(
                              RegisterRequested(
                                username: _usernameController.text.trim(),
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              ),
                            );
                      }
                    },
                    isLoading: (state) => state is AuthLoading,
                    isSuccess: (state) => state is Authenticated,
                    isError: (state) => state is AuthError,
                    getErrorMessage: (state) => (state as AuthError).message,
                    onSuccess: (context, state) {
                      // Navigate to home on successful registration
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    fieldSpacing: 16.0,
                  ),

                  const SizedBox(height: 16),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(color: DesignSystem.onSurfaceVariant),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Go back to login
                        },
                        child: const Text(
                          'Sign in',
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
