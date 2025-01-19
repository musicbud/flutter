import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/spotify/spotify_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/spotify/spotify_event.dart';
import 'package:musicbud_flutter/blocs/auth/spotify/spotify_state.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

class SpotifyConnectPage extends StatefulWidget {
  const SpotifyConnectPage({
    Key? key,
  }) : super(key: key);

  @override
  _SpotifyConnectPageState createState() => _SpotifyConnectPageState();
}

class _SpotifyConnectPageState extends State<SpotifyConnectPage> {
  final TextEditingController _authDataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupMessageListener();
    context.read<SpotifyBloc>().add(SpotifyAuthUrlRequested());
  }

  void _setupMessageListener() {
    html.window.onMessage.listen((html.MessageEvent e) {
      if (e.data is Map && e.data['type'] == 'SPOTIFY_AUTH_CALLBACK') {
        _handleCallback(e.data['data']);
      }
    });
  }

  void _handleCallback(dynamic data) {
    if (data is Map<String, dynamic>) {
      final accessToken = data['access_token'] as String?;
      if (accessToken != null) {
        context.read<SpotifyBloc>().add(SpotifyConnectRequested(accessToken));
      }
    }
  }

  void _connect() {
    context.read<SpotifyBloc>().add(SpotifyAuthUrlRequested());
  }

  void _disconnect() {
    context.read<SpotifyBloc>().add(SpotifyDisconnectRequested());
  }

  void _submitManualAuthData() {
    final authData = _authDataController.text.trim();
    if (authData.isNotEmpty) {
      try {
        final decodedData = json.decode(authData);
        if (decodedData is Map<String, dynamic>) {
          final token = decodedData['token'] ?? decodedData['access_token'];
          if (token != null) {
            context.read<SpotifyBloc>().add(SpotifyConnectRequested(token));
          }
        } else if (authData.startsWith('ya29.') || authData.length > 20) {
          context.read<SpotifyBloc>().add(SpotifyConnectRequested(authData));
        }
      } catch (e) {
        if (authData.startsWith('ya29.') || authData.length > 20) {
          context.read<SpotifyBloc>().add(SpotifyConnectRequested(authData));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SpotifyBloc, SpotifyState>(
      listener: (context, state) {
        if (state is SpotifyAuthUrlLoaded && kIsWeb) {
          html.window.open(state.url, 'Spotify Auth', 'width=800,height=600');
        } else if (state is SpotifyFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is SpotifyConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Successfully connected to Spotify')),
          );
        } else if (state is SpotifyDisconnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Successfully disconnected from Spotify')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Connect Spotify'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<SpotifyBloc, SpotifyState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state is SpotifyConnected)
                    Column(
                      children: [
                        const Text('Connected to Spotify'),
                        ElevatedButton(
                          onPressed: _disconnect,
                          child: const Text('Disconnect'),
                        ),
                      ],
                    )
                  else
                    ElevatedButton(
                      onPressed: state is! SpotifyLoading ? _connect : null,
                      child: state is SpotifyLoading
                          ? const CircularProgressIndicator()
                          : const Text('Connect Spotify'),
                    ),
                  const SizedBox(height: 20),
                  const Text(
                      'If automatic connection fails, paste the authentication data here:'),
                  TextField(
                    controller: _authDataController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Paste authentication data here',
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed:
                        state is! SpotifyLoading ? _submitManualAuthData : null,
                    child: state is SpotifyLoading
                        ? const CircularProgressIndicator()
                        : const Text('Submit Authentication Data'),
                  ),
                  if (state is SpotifyFailure)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        state.error,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
