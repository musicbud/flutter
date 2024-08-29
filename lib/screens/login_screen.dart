import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final success = await _authService.login(username, password);

    if (success) {
      // Navigate to the main screen or show a success message
      print('Login successful');
    } else {
      // Show an error message
      print('Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build your login UI here
  }
}
