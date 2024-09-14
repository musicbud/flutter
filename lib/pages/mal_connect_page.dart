import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

class MalConnectPage extends StatefulWidget {
  final ApiService apiService;

  const MalConnectPage({Key? key, required this.apiService}) : super(key: key);

  @override
  _MalConnectPageState createState() => _MalConnectPageState();
}

class _MalConnectPageState extends State<MalConnectPage> {
  bool _isConnected = false;
  bool _isLoading = false;
  String? _userId;
  String? _displayName;
  String? _errorMessage;
  final TextEditingController _authDataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupMessageListener();
  }

  void _setupMessageListener() {
    html.window.onMessage.listen((html.MessageEvent e) {
      if (e.data is Map && e.data['type'] == 'MAL_AUTH_CALLBACK') {
        _handleCallback(e.data['data']);
      }
    });
  }

  void _handleCallback(dynamic data) {
    if (data is Map<String, dynamic>) {
      final token = data['token'] as String?;
      if (token != null) {
        _handleToken(token);
      } else {
        setState(() {
          _errorMessage = 'Token not found in callback data';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Invalid callback data format';
      });
    }
  }

  void _handleToken(String token) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await widget.apiService.handleMalToken(token);
      setState(() {
        _isConnected = result['success'];
        _userId = result['user_id'];
        _displayName = result['display_name'];
        _errorMessage = result['success'] ? null : result['message'];
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error handling MyAnimeList token: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _connect() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final url = await widget.apiService.connectService('mal');
      if (kIsWeb) {
        html.window.open(url, 'MyAnimeList Auth', 'width=800,height=600');
      } else {
        // Handle mobile platforms here
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error connecting to MyAnimeList: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submitManualAuthData() {
    final authData = _authDataController.text.trim();
    if (authData.isNotEmpty) {
      try {
        // First, try to parse as JSON
        final decodedData = json.decode(authData);
        if (decodedData is Map<String, dynamic>) {
          final token = decodedData['token'] ?? decodedData['access_token'];
          if (token != null) {
            _handleToken(token);
          } else {
            throw FormatException('Token not found in JSON data');
          }
        } else {
          throw FormatException('Invalid JSON format');
        }
      } catch (e) {
        // If JSON parsing fails, assume it's a plain token string
        if (authData.startsWith('ya29.') || authData.length > 20) {
          _handleToken(authData);
        } else {
          setState(() {
            _errorMessage = 'Invalid token format. Please enter a valid token.';
          });
        }
      }
    } else {
      setState(() {
        _errorMessage = 'Please enter the authentication data';
      });
    }
  }

  Future<void> _updateLikes() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await widget.apiService.updateLikes('mal');
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      } else {
        setState(() {
          _errorMessage = result['message'];
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error updating likes: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect MyAnimeList'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isConnected)
              Text('MyAnimeList connected for user: $_displayName ($_userId)'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _connect,
              child: _isLoading ? CircularProgressIndicator() : Text('Connect MyAnimeList'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _updateLikes,
              child: _isLoading ? CircularProgressIndicator() : Text('Update Likes'),
            ),
            SizedBox(height: 20),
            Text('If automatic connection fails, paste the authentication data here:'),
            TextField(
              controller: _authDataController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Paste authentication data here',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitManualAuthData,
              child: Text('Submit Authentication Data'),
            ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
