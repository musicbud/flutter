import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/login/login_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/login/login_event.dart';
import 'package:musicbud_flutter/blocs/auth/login/login_state.dart';
import 'package:musicbud_flutter/blocs/user/user_bloc.dart';
import 'package:musicbud_flutter/blocs/user/user_event.dart';
import 'package:musicbud_flutter/blocs/auth/auth_bloc.dart';
import '../widgets/common/app_scaffold.dart';
import '../widgets/common/app_app_bar.dart';
import '../widgets/common/app_text_field.dart';
import '../widgets/common/app_button.dart';
import '../constants/app_constants.dart';
import '../mixins/page_mixin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with PageMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  void _checkConnectivity() {
    addBlocEvent<LoginBloc, LoginConnectivityChecked>(LoginConnectivityChecked());
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      addBlocEvent<LoginBloc, LoginSubmitted>(
        LoginSubmitted(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: _handleLoginStateChange,
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: _handleAuthStateChange,
        ),
      ],
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return AppScaffold(
            appBar: const AppAppBar(
              title: 'Login',
              automaticallyImplyLeading: false,
            ),
            body: _buildLoginForm(state),
          );
        },
      ),
    );
  }

  void _handleLoginStateChange(BuildContext context, LoginState state) {
    debugPrint('LoginBloc State: ${state.runtimeType}');

    if (state is LoginConnectivityStatus && !state.isConnected) {
      debugPrint('Login Connectivity Error: No internet connection');
      showErrorSnackBar('No internet connection. Please check your network settings.');
    } else if (state is LoginServerStatus && !state.isReachable) {
      debugPrint('Login Server Error: ${state.error}');
      showErrorSnackBar('Unable to reach the server: ${state.error} - ${state.message}');
    } else if (state is LoginSuccess) {
      debugPrint('Login Success: ${state.data}');
      final accessToken = state.data['access_token'] as String;
      addBlocEvent<AuthBloc, LoginRequested>(
        LoginRequested(
          username: _usernameController.text,
          password: _passwordController.text,
        ),
      );
      addBlocEvent<UserBloc, UpdateToken>(UpdateToken(token: accessToken));
      // Navigation will be handled by AuthBloc when it emits Authenticated state
    } else if (state is LoginFailure) {
      debugPrint('Login Error: ${state.error}');
      showErrorSnackBar(state.error);
    }
  }

  void _handleAuthStateChange(BuildContext context, AuthState state) {
    debugPrint('AuthBloc State: ${state.runtimeType}');

    if (state is Authenticated) {
      debugPrint('Auth Success - Token: ${state.token}');
      if (mounted) {
        replaceRoute(AppConstants.homeRoute);
      }
    } else if (state is AuthError) {
      debugPrint('Auth Error: ${state.message}');
      showErrorSnackBar(state.message);
    }
  }

  Widget _buildLoginForm(LoginState state) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo or App Title
            _buildAppTitle(),
            const SizedBox(height: 32),

            // Username Field
            AppTextField(
              controller: _usernameController,
              labelText: 'Username',
              hintText: 'Enter your username',
              prefixIcon: const Icon(Icons.person, color: AppConstants.borderColor),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),
            const SizedBox(height: AppConstants.defaultPadding),

            // Password Field
            AppTextField(
              controller: _passwordController,
              labelText: 'Password',
              hintText: 'Enter your password',
              obscureText: true,
              prefixIcon: const Icon(Icons.lock, color: AppConstants.borderColor),
              onSubmitted: (value) {
                if (_formKey.currentState!.validate()) {
                  _login();
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Login Button
            AppButton(
              text: 'Login',
              onPressed: state is LoginLoading ? null : _login,
              isLoading: state is LoginLoading,
              width: MediaQuery.of(context).size.width * 0.25,
            ),

            const SizedBox(height: 16),

            // Forgot Password Link
            _buildForgotPasswordLink(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppTitle() {
    return Column(
      children: [
        const Icon(
          Icons.music_note,
          size: 64,
          color: AppConstants.primaryColor,
        ),
        const SizedBox(height: 16),
        Text(
          'MusicBud',
          style: AppConstants.headingStyle.copyWith(
            fontSize: 32,
            color: AppConstants.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Connect through music',
          style: AppConstants.captionStyle.copyWith(
            fontSize: 16,
            color: AppConstants.textSecondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordLink() {
    return TextButton(
      onPressed: () {
        // TODO: Implement forgot password functionality
        showInfoSnackBar('Forgot password functionality coming soon!');
      },
      child: const Text(
        'Forgot Password?',
        style: TextStyle(
          color: AppConstants.primaryColor,
          fontSize: 14,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
