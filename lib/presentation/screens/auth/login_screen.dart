import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/login/login_bloc.dart';
import '../../../blocs/auth/login/login_event.dart';
import '../../../blocs/auth/login/login_state.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../core/theme/design_system.dart';
import '../../../presentation/widgets/common/modern_input_field.dart';
import '../../../presentation/widgets/common/modern_button.dart';
import '../../../presentation/widgets/common/app_typography.dart';

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
                listener: (context, state) {
                  if (state is LoginSuccess) {
                    // Trigger AuthBloc login to handle token management
                    context.read<AuthBloc>().add(LoginRequested(
                      username: _usernameController.text.trim(),
                      password: _passwordController.text,
                    ));
                  } else if (state is LoginFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.error),
                        backgroundColor: DesignSystem.error,
                      ),
                    );
                  }
                },
              ),
              BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is Authenticated) {
                    // Navigate to home on successful authentication
                    Navigator.pushReplacementNamed(context, '/');
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
                    ),
                    const SizedBox(height: 16),

                    // Password field
                    ModernInputField(
                      hintText: 'Password',
                      controller: _passwordController,
                      obscureText: true,
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
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Register link
                    TextButton(
                      onPressed: () {
                        // TODO: Navigate to register screen
                      },
                      child: const Text(
                        'Don\'t have an account? Sign up',
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