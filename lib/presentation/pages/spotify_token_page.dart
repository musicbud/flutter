import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';

class SpotifyCallbackPage extends StatefulWidget {
  final ApiService apiService;

  const SpotifyCallbackPage({Key? key, required this.apiService})
      : super(key: key);

  @override
  _SpotifyCallbackPageState createState() => _SpotifyCallbackPageState();
}

class _SpotifyCallbackPageState extends State<SpotifyCallbackPage> {
  @override
  void initState() {
    super.initState();
    _handleSpotifyToken();
  }

  Future<void> _handleSpotifyToken() async {
    if (!mounted) return;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final uri = Uri.base;
    final code = uri.queryParameters['code'];
    if (code != null) {
      try {
        await widget.apiService.completeSpotifyAuth(code);
        if (!mounted) return;

        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Successfully connected to Spotify')),
        );
        navigator.pushReplacementNamed('/home');
      } catch (e) {
        print('Error completing Spotify authentication: $e');
        if (!mounted) return;

        scaffoldMessenger.showSnackBar(
          const SnackBar(
              content: Text('Failed to complete Spotify authentication')),
        );
        navigator.pushReplacementNamed('/connect_services');
      }
    } else {
      print('Error: No authorization code found in the callback URI');
      if (!mounted) return;

      navigator.pushReplacementNamed('/connect_services');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
