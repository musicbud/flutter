import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/register/register_bloc.dart';
import '../../../blocs/auth/register/register_event.dart';
import '../../../blocs/auth/register/register_state.dart';
import '../../widgets/common/bloc_form.dart';
import '../../widgets/error_card.dart';
import '../../theme/app_theme.dart';
import '../../mixins/page_mixin.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> with PageMixin {
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return BlocForm<RegisterBloc, RegisterState, RegisterEvent>(
      title: 'Create Account',
      fields: [
        BlocFormField(
          key: 'email',
          label: 'Email Address',
          hint: 'Enter your email address',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(Icons.email_outlined, color: appTheme.colors.primary),
          validator: BlocFormField.emailValidator,
        ),
        BlocFormField(
          key: 'username',
          label: 'Username',
          hint: 'Choose a unique username',
          prefixIcon: Icon(Icons.person_outline, color: appTheme.colors.primary),
          validator: BlocFormField.usernameValidator,
        ),
        BlocFormField(
          key: 'password',
          label: 'Password',
          hint: 'Create a secure password',
          obscureText: true,
          prefixIcon: Icon(Icons.lock_outline, color: appTheme.colors.primary),
          validator: BlocFormField.passwordValidator,
          onChanged: (value) => _passwordController.text = value,
        ),
        BlocFormField(
          key: 'confirmPassword',
          label: 'Confirm Password',
          hint: 'Re-enter your password',
          obscureText: true,
          prefixIcon: Icon(Icons.lock_outline, color: appTheme.colors.primary),
          validator: BlocFormField.confirmPasswordValidator(_passwordController),
        ),
      ],
      submitButtonText: 'Create Account',
      onSubmit: (values) {
        context.read<RegisterBloc>().add(RegisterConnectivityChecked());
        context.read<RegisterBloc>().add(RegisterServerStatusChecked());

        return RegisterSubmitted(
          username: values['username']!,
          email: values['email']!,
          password: values['password']!,
        );
      },
      isLoading: (state) => state is RegisterLoading,
      isSuccess: (state) => state is RegisterSuccess,
      isError: (state) => state is RegisterFailure,
      getErrorMessage: (state) {
        if (state is RegisterFailure) return state.error;
        if (state is RegisterConnectivityStatus && !state.isConnected) {
          return 'No internet connection';
        }
        if (state is RegisterServerStatus && !state.isReachable) {
          return state.message ?? 'Server is unreachable';
        }
        return 'An error occurred';
      },
      getSuccessMessage: (state) => 'Registration successful! Welcome to MusicBud!',
      onSuccess: () {
        navigateTo('/home');
      },
      onStateChanged: (state) {
        if (state is RegisterConnectivityStatus && state.isConnected) {
          // Connection restored, could auto-retry if needed
        }
      },
      additionalActions: [
        // Sign in link
        AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 300),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Already have an account?',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              TextButton(
                onPressed: () => navigateTo('/login'),
                child: Text(
                  'Sign In',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: appTheme.colors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Terms and conditions
        AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            'By creating an account, you agree to our Terms of Service and Privacy Policy',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
      customStateWidget: (state) {
        if (state is RegisterConnectivityStatus && !state.isConnected) {
          return _buildConnectivityError();
        }
        if (state is RegisterServerStatus && !state.isReachable) {
          return _buildServerError(state.message);
        }
        return Container();
      },
    );
  }

  Widget _buildConnectivityError() {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colors.surface,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: appTheme.colors.surface,
      ),
      body: Center(
        child: ErrorCard(
          message: 'Please check your internet connection and try again.',
          icon: Icons.wifi_off,
          onRetry: () {
            context.read<RegisterBloc>().add(RegisterConnectivityChecked());
          },
        ),
      ),
    );
  }

  Widget _buildServerError(String? message) {
    final appTheme = AppTheme.of(context);

    return Scaffold(
      backgroundColor: appTheme.colors.surface,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: appTheme.colors.surface,
      ),
      body: Center(
        child: ErrorCard(
          message: message ?? 'The server is currently unavailable. Please try again later.',
          icon: Icons.cloud_off,
          onRetry: () {
            context.read<RegisterBloc>().add(RegisterServerStatusChecked());
          },
        ),
      ),
    );
  }
}