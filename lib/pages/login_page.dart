import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:dio/dio.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    try {
      final response = await _apiService.login(
        _usernameController.text,
        _passwordController.text,
      );
      // Handle successful login
    } on DioError catch (e) {
      String errorMessage;
      if (e.type == DioErrorType.connectionError) {
        errorMessage = 'Connection error. Please check your internet connection and try again.';
      } else if (e.response?.statusCode == 403) {
        errorMessage = 'Access forbidden. CORS issue detected.';
      } else {
        errorMessage = 'An error occurred: ${e.message}';
      }
      print('Login error: $errorMessage');
      // Display errorMessage to the user
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _login,
              child: _isLoading ? CircularProgressIndicator() : Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}