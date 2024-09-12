import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';

class LoginPage extends StatefulWidget {
  final ApiService apiService;
  final ChatService chatService;

  const LoginPage({Key? key, required this.apiService, required this.chatService}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Check device connectivity first
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.none) {
          throw Exception('No internet connection. Please check your network settings.');
        }

        // Check server connectivity
        final serverCheck = await widget.apiService.checkServerConnectivity();
        if (serverCheck['isReachable'] == false) {
          throw Exception('Unable to reach the server: ${serverCheck['error']} - ${serverCheck['message']}');
        }

        developer.log('Attempting login for user: ${_usernameController.text}');
        final response = await widget.apiService.login(
          _usernameController.text,
          _passwordController.text,
        );

        if (response['status'] == 'success') {
          developer.log('Login successful');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login successful')),
          );
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          developer.log('Login failed: ${response['message']}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'])),
          );
        }
      } catch (e) {
        developer.log('Error during login: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _checkServerConnectivity() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final hasInternet = await widget.apiService.checkInternetConnectivity();
      if (!hasInternet) {
        throw Exception('No internet connection. Please check your network settings.');
      }

      final serverCheck = await widget.apiService.checkServerConnectivity();
      String message;
      if (serverCheck['isReachable']) {
        message = 'Server is reachable. Status code: ${serverCheck['statusCode']}';
      } else {
        message = 'Server is not reachable.\n'
            'Error: ${serverCheck['error']}\n'
            'Type: ${serverCheck['type']}\n'
            'Message: ${serverCheck['message']}\n';
        if (serverCheck['requestOptions'] != null) {
          final requestOptions = serverCheck['requestOptions'];
          message += 'Request Options:\n'
              '  Method: ${requestOptions['method']}\n'
              '  Path: ${requestOptions['path']}\n'
              '  Base URL: ${requestOptions['baseUrl']}\n'
              '  Headers: ${requestOptions['headers']}\n'
              '  Query Parameters: ${requestOptions['queryParameters']}';
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), duration: Duration(seconds: 10)),
      );
      _log(message);
    } catch (e) {
      _log('Error checking server connectivity: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking server connectivity: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _log(String message) {
    developer.log(message);
    print(message); // This will output to the terminal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                  validator: (value) => value!.isEmpty ? 'Please enter your username' : null,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
                ),
                ElevatedButton(
                  onPressed: _login,
                  child: Text('Login'),
                ),
                SizedBox(height: 20),
                Text('Current Base URL: ${widget.apiService.baseUrl}'),
                ElevatedButton(
                  onPressed: _checkServerConnectivity,
                  child: Text('Check Server Connectivity'),
                ),
                if (_isLoading)
                  CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}