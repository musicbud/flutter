import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'profile_page.dart';
import 'package:musicbud_flutter/pages/home_page.dart'; // Add this import
import 'package:musicbud_flutter/pages/profile_page.dart'; // Add this import

class LoginPage extends StatefulWidget {
  final ApiService apiService;

  const LoginPage({Key? key, required this.apiService}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false; // Add this line to show a loading indicator

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      try {
        final token = await widget.apiService.login(username, password);
        if (token != null) {
          // Login successful, navigate to the ProfilePage
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ProfilePage(apiService: widget.apiService)),
          );
        }
      } catch (e) {
        print('Login error: $e');
        String errorMessage = 'An error occurred. Please try again later.';
        if (e is Exception && e.toString().contains('Invalid username or password')) {
          errorMessage = 'Invalid username or password. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
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