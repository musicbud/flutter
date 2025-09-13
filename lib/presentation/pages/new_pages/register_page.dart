import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/register/register_bloc.dart';
import '../../../blocs/auth/register/register_event.dart';
import '../../../blocs/auth/register/register_state.dart';
import '../../widgets/common/bloc_form.dart';
import '../../widgets/common/app_button.dart';
import '../../constants/app_constants.dart';
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
    return BlocForm<RegisterBloc, RegisterState, RegisterEvent>(
      title: 'Create Account',
      fields: [
        BlocFormField(
          key: 'email',
          label: 'Email Address',
          hint: 'Enter your email address',
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined, color: AppConstants.primaryColor),
          validator: BlocFormField.emailValidator,
        ),
        BlocFormField(
          key: 'username',
          label: 'Username',
          hint: 'Choose a unique username',
          prefixIcon: const Icon(Icons.person_outline, color: AppConstants.primaryColor),
          validator: BlocFormField.usernameValidator,
        ),
        BlocFormField(
          key: 'password',
          label: 'Password',
          hint: 'Create a secure password',
          obscureText: true,
          prefixIcon: const Icon(Icons.lock_outline, color: AppConstants.primaryColor),
          validator: BlocFormField.passwordValidator,
          onChanged: (value) => _passwordController.text = value,
        ),
        BlocFormField(
          key: 'confirmPassword',
          label: 'Confirm Password',
          hint: 'Re-enter your password',
          obscureText: true,
          prefixIcon: const Icon(Icons.lock_outline, color: AppConstants.primaryColor),
          validator: BlocFormField.confirmPasswordValidator(_passwordController),
        ),
      ],
      submitButtonText: 'Create Account',
      onSubmit: (values) {
        // First check connectivity and server status like in legacy
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
        // Handle specific state changes that don't require user feedback
        if (state is RegisterConnectivityStatus && state.isConnected) {
          // Connection restored, could auto-retry if needed
        }
      },
      additionalActions: [
        // Sign in link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Already have an account?',
              style: AppConstants.captionStyle,
            ),
            TextButton(
              onPressed: () => navigateTo('/login'),
              child: Text(
                'Sign In',
                style: AppConstants.bodyStyle.copyWith(
                  color: AppConstants.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Terms and conditions
        Text(
          'By creating an account, you agree to our Terms of Service and Privacy Policy',
          style: AppConstants.captionStyle.copyWith(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
      customStateWidget: (state) {
        // Handle connectivity and server status checks
        if (state is RegisterConnectivityStatus && !state.isConnected) {
          return _buildConnectivityError();
        }
        if (state is RegisterServerStatus && !state.isReachable) {
          return _buildServerError(state.message);
        }
        return Container(); // Return empty container instead of null
      },
    );
  }

  Widget _buildConnectivityError() {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: AppConstants.backgroundColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.wifi_off,
                size: 64,
                color: AppConstants.errorColor,
              ),
              const SizedBox(height: 24),
              Text(
                'No Internet Connection',
                style: AppConstants.headingStyle.copyWith(
                  color: AppConstants.errorColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Please check your internet connection and try again.',
                style: AppConstants.bodyStyle.copyWith(
                  color: AppConstants.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AppButton(
                text: 'Retry',
                onPressed: () {
                  context.read<RegisterBloc>().add(RegisterConnectivityChecked());
                },
                backgroundColor: AppConstants.errorColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServerError(String? message) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: AppConstants.backgroundColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_off,
                size: 64,
                color: AppConstants.errorColor,
              ),
              const SizedBox(height: 24),
              Text(
                'Server Unavailable',
                style: AppConstants.headingStyle.copyWith(
                  color: AppConstants.errorColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                message ?? 'The server is currently unavailable. Please try again later.',
                style: AppConstants.bodyStyle.copyWith(
                  color: AppConstants.textSecondaryColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              AppButton(
                text: 'Check Server Status',
                onPressed: () {
                  context.read<RegisterBloc>().add(RegisterServerStatusChecked());
                },
                backgroundColor: AppConstants.errorColor,
              ),
              const SizedBox(height: 16),
              AppButton(
                text: 'Go Back',
                onPressed: () => navigateBack(),
                isOutlined: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}