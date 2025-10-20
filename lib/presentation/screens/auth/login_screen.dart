import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../blocs/auth/login/login_bloc.dart';
import '../../../blocs/auth/login/login_event.dart';
import '../../../blocs/auth/login/login_state.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../data/providers/token_provider.dart';
import '../../../core/theme/design_system.dart';
import '../../../blocs/auth/auth_event.dart';
import 'register_screen.dart';

// Enhanced UI Library
import '../../widgets/enhanced/enhanced_widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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
          child: MultiBlocListener(
            listeners: [
              BlocListener<LoginBloc, LoginState>(
                listener: (context, state) async {
                  if (state is LoginSuccess) {
                    // Store tokens securely
                    try {
                      final tokenProvider = GetIt.instance<TokenProvider>();
                      await tokenProvider.updateTokens(
                        state.data.accessToken,
                        state.data.refreshToken ?? '',
                      );
                      
                      // Trigger AuthBloc to update its state
                      if (context.mounted) {
                        context.read<AuthBloc>().add(TokenRefreshRequested());
                      }
                      
                      // Show success message
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Login successful! Welcome back!'),
                            backgroundColor: DesignSystem.success,
                            duration: Duration(seconds: 2),
                          ),
                        );
                        
                        // Navigate back to root by popping all routes
                        // This will bring us back to AuthGate which will properly show MainScreenWithGuest
                        // with authenticated state
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
                  } else if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        backgroundColor: DesignSystem.error,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                },
              ),
            ],
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
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    ModernInputField(
                      hintText: 'Password',
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Login button
                    BlocBuilder<LoginBloc, LoginState>(
                      builder: (context, state) {
                        return ModernButton(
                          text: state is LoginLoading ? 'Logging in...' : 'Login',
                          onPressed: state is LoginLoading ? null : _handleLogin,
                          variant: ModernButtonVariant.primary,
                          size: ModernButtonSize.large,
                          isLoading: state is LoginLoading,
                          isFullWidth: true,
                        );
                      },
                    ),

                    const SizedBox(height: 8),

                    // Forgot password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // TODO: Implement forgot password functionality
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

                    const SizedBox(height: 16),

                    // Register link
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Don\'t have an account? Sign up',
                        style: TextStyle(
                          color: DesignSystem.primary,
                          fontSize: 16,
                        ),
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

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<LoginBloc>().add(
        LoginSubmitted(
          username: _usernameController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }
}