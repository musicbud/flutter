import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../core/theme/design_system.dart';

// Enhanced UI Library
import '../../widgets/enhanced/enhanced_widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Authenticated) {
                // Navigate to home on successful registration
                Navigator.pushReplacementNamed(context, '/');
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: DesignSystem.error,
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo/Title
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

                    // Username field
                    ModernInputField(
                      hintText: 'Username',
                      controller: _usernameController,
                    ),
                    const SizedBox(height: 16),

                    // Email field
                    ModernInputField(
                      hintText: 'Email',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    ModernInputField(
                      hintText: 'Password',
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password field
                    ModernInputField(
                      hintText: 'Confirm Password',
                      controller: _confirmPasswordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),

                    // Register button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return ModernButton(
                          text: state is AuthLoading ? 'Creating account...' : 'Create Account',
                          onPressed: state is AuthLoading ? null : _handleRegister,
                          variant: ModernButtonVariant.primary,
                          size: ModernButtonSize.large,
                          isLoading: state is AuthLoading,
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Login link
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Go back to login
                      },
                      child: const Text(
                        'Already have an account? Sign in',
                        style: TextStyle(color: DesignSystem.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(RegisterRequested(
        username: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      ));
    }
  }
}