import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/spotify_auth/spotify_auth_bloc.dart';
import '../../blocs/spotify_auth/spotify_auth_event.dart';
import '../../blocs/spotify_auth/spotify_auth_state.dart';

class SpotifyCallbackPage extends StatefulWidget {
  const SpotifyCallbackPage({super.key});

  @override
  State<SpotifyCallbackPage> createState() => _SpotifyCallbackPageState();
}

class _SpotifyCallbackPageState extends State<SpotifyCallbackPage> {
  @override
  void initState() {
    super.initState();
    _handleSpotifyToken();
  }

  void _handleSpotifyToken() {
    final uri = Uri.base;
    final code = uri.queryParameters['code'];
    if (code != null) {
      context.read<SpotifyAuthBloc>().add(SpotifyAuthCodeReceived(code));
    } else {
      print('Error: No authorization code found in the callback URI');
      Navigator.of(context).pushReplacementNamed('/connect_services');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SpotifyAuthBloc, SpotifyAuthState>(
        listener: (context, state) {
          if (state is SpotifyAuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Successfully connected to Spotify')),
            );
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is SpotifyAuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to connect: ${state.error}')),
            );
            Navigator.of(context).pushReplacementNamed('/connect_services');
          }
        },
        builder: (context, state) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (state is SpotifyAuthLoading) ...[
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Connecting to Spotify...'),
                ] else if (state is SpotifyAuthFailure) ...[
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    state.error,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ] else ...[
                  const CircularProgressIndicator(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
