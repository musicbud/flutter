import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/login/login_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/login/login_event.dart';
import 'package:musicbud_flutter/blocs/auth/login/login_state.dart';
import 'package:musicbud_flutter/blocs/user/user_bloc.dart';
import 'package:musicbud_flutter/blocs/user/user_event.dart';
import 'package:musicbud_flutter/presentation/pages/home_page.dart';
import 'package:musicbud_flutter/blocs/auth/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  void _checkConnectivity() {
    context.read<LoginBloc>().add(LoginConnectivityChecked());
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginBloc>().add(LoginSubmitted(
            username: _usernameController.text,
            password: _passwordController.text,
          ));
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            debugPrint('LoginBloc State: ${state.runtimeType}');
            if (state is LoginConnectivityStatus && !state.isConnected) {
              debugPrint('Login Connectivity Error: No internet connection');
              _showSnackBar(
                  'No internet connection. Please check your network settings.');
            } else if (state is LoginServerStatus && !state.isReachable) {
              debugPrint('Login Server Error: ${state.error}');
              _showSnackBar(
                  'Unable to reach the server: ${state.error} - ${state.message}');
            } else if (state is LoginSuccess) {
              debugPrint('Login Success: ${state.data}');
              final accessToken = state.data['access_token'] as String;
              context.read<AuthBloc>().emit(Authenticated(token: accessToken));
              context.read<UserBloc>().add(UpdateToken(token: accessToken));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (state is LoginFailure) {
              debugPrint('Login Error: ${state.error}');
              _showSnackBar(state.error);
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            debugPrint('AuthBloc State: ${state.runtimeType}');
            if (state is Authenticated) {
              debugPrint('Auth Success - Token: ${state.token}');
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else if (state is AuthError) {
              debugPrint('Auth Error: ${state.message}');
              _showSnackBar(state.message);
            }
          },
        ),
      ],
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Login')),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is LoginLoading ? null : _login,
                        child: state is LoginLoading
                            ? const CircularProgressIndicator()
                            : const Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
