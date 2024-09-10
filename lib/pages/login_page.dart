import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final ChatService chatService;
  final ApiService apiService;
  final Function? onLoginSuccess;

  const LoginPage({
    Key? key, 
    required this.chatService, 
    required this.apiService, 
    this.onLoginSuccess
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    try {
      print('Login button pressed');
      final response = await widget.chatService.login(
        _usernameController.text,
        _passwordController.text,
      );
      print('Login response received in UI');
      if (response.statusCode == 200) {
        print('Login successful: ${response.data}');
        // Navigate to the home page
        Navigator.pushReplacementNamed(context, '/home');
        await saveUsername(_usernameController.text);
      } else {
        print('Login failed with status code: ${response.statusCode}');
        print('Response data: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${response.data['message'] ?? 'Unknown error'}')),
        );
      }
    } catch (e) {
      if (e is DioError) {
        print('DioError in UI:');
        // ... error handling ...
      } else {
        print('Non-DioError exception in UI: $e');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    }
  }

  Future<void> saveUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}