import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import 'profile_page.dart';

class LoginPage extends StatefulWidget {
  final ApiService apiService;

  const LoginPage({Key? key, required this.apiService}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _username = 'mahmwood';
  String _password = 'password';

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        final token = await widget.apiService.login(_username, _password);
        await widget.apiService.setAuthToken(token);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfilePage(apiService: widget.apiService)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Username'),
              validator: (value) => value!.isEmpty ? 'Please enter your username' : null,
              onSaved: (value) => _username = value!,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
              validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
              onSaved: (value) => _password = value!,
            ),
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