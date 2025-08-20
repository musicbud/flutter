import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../blocs/auth/spotify/spotify_bloc.dart';
import '../../blocs/auth/spotify/spotify_event.dart';
import '../../blocs/auth/spotify/spotify_state.dart';
import 'dart:convert';

class SpotifyConnectPage extends StatefulWidget {
  const SpotifyConnectPage({super.key});

  @override
  State<SpotifyConnectPage> createState() => _SpotifyConnectPageState();
}

class _SpotifyConnectPageState extends State<SpotifyConnectPage> {
  final TextEditingController _authDataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<SpotifyBloc>().add(SpotifyAuthUrlRequested());
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch Spotify auth')),
      );
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
    return BlocConsumer<SpotifyBloc, SpotifyState>(
      listener: (context, state) {
        if (state is SpotifyAuthUrlLoaded) {
          _launchUrl(state.url);
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
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Connect to Spotify'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
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
                        : const Text('Connect to Spotify'),
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
            ),
          ),
        );
      },
    );
  }
}
