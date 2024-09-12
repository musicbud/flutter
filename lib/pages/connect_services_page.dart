import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:js' as js;

class ConnectServicesPage extends StatefulWidget {
  final ApiService apiService;

  const ConnectServicesPage({Key? key, required this.apiService}) : super(key: key);

  @override
  _ConnectServicesPageState createState() => _ConnectServicesPageState();
}

class _ConnectServicesPageState extends State<ConnectServicesPage> {
  bool _isSpotifyConnected = false;
  bool _isLoading = false;
  String? _spotifyUserId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _setupSpotifyCallbackHandler();
  }

  void _setupSpotifyCallbackHandler() {
    if (kIsWeb) {
      js.context['handleSpotifyCallback'] = (dynamic data) {
        print('Received Spotify callback: $data');
        _handleSpotifyCallback(data);
      };
    }
  }

  void _handleSpotifyCallback(dynamic data) {
    setState(() {
      _isSpotifyConnected = true;
      _spotifyUserId = data['user_id'];
    });
  }

  Future<void> _connectSpotify() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final url = await widget.apiService.connectSpotify();
      print('Received Spotify authorization URL: $url');  // Debug print
      if (kIsWeb) {
        html.window.open(url, 'Spotify Auth');
      } else {
        // Handle mobile platforms here
        // You might want to use a package like url_launcher for mobile
        // await launch(url);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error connecting to Spotify: $e';
      });
      print('Error in _connectSpotify: $e');  // Debug print
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
        title: Text('Connect Services'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_isLoading)
              CircularProgressIndicator()
            else if (_isSpotifyConnected)
              Text('Spotify connected for user: $_spotifyUserId')
            else
              ElevatedButton(
                onPressed: _connectSpotify,
                child: Text('Connect Spotify'),
              ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
