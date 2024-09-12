import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:uni_links/uni_links.dart';
import 'dart:async';
import 'dart:convert';

class ConnectServicesPage extends StatefulWidget {
  final ApiService apiService;

  const ConnectServicesPage({Key? key, required this.apiService}) : super(key: key);

  @override
  _ConnectServicesPageState createState() => _ConnectServicesPageState();
}

class _ConnectServicesPageState extends State<ConnectServicesPage> {
  bool _isSpotifyConnected = false;
  bool _isLoading = false;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _checkSpotifyConnection();
    _initUniLinks();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  Future<void> _initUniLinks() async {
    _sub = uriLinkStream.listen((Uri? uri) {
      if (uri != null && uri.host == 'spotify-callback') {
        _handleSpotifyCallback(uri);
      }
    }, onError: (err) {
      print('Error in uni_links stream: $err');
    });
  }

  Future<void> _handleSpotifyCallback(Uri uri) async {
    final code = uri.queryParameters['code'];
    if (code != null) {
      try {
        final response = await widget.apiService.handleSpotifyCallback(code);
        if (response['code'] == 200) {
          setState(() {
            _isSpotifyConnected = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Successfully connected to Spotify')),
          );
          if (response['data']['parent_user_connected'] == false) {
            _showParentAccountDialog();
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to connect to Spotify: ${response['message']}')),
          );
        }
      } catch (e) {
        print('Error handling Spotify callback: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error connecting to Spotify: $e')),
        );
      }
    }
  }

  Future<void> _checkSpotifyConnection() async {
    // Implement this method to check if Spotify is already connected
  }

  Future<void> _connectSpotify() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.apiService.connectSpotify();
    } catch (e) {
      print('Error connecting to Spotify: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect to Spotify: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showParentAccountDialog() {
    // Implement this method to show a dialog about connecting the parent account
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Services'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _isSpotifyConnected
                ? Text('Spotify is connected')
                : ElevatedButton(
                    onPressed: _connectSpotify,
                    child: Text('Connect Spotify'),
                  ),
      ),
    );
  }
}
