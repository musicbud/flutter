import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/lastfm/lastfm_bloc.dart';
import '../../blocs/auth/lastfm/lastfm_event.dart';
import '../../blocs/auth/lastfm/lastfm_state.dart';
import 'package:url_launcher/url_launcher.dart';

class LastFmConnectPage extends StatefulWidget {
  const LastFmConnectPage({super.key});

  @override
  State<LastFmConnectPage> createState() => _LastFmConnectPageState();
}

class _LastFmConnectPageState extends State<LastFmConnectPage> {
  @override
  void initState() {
    super.initState();
    context.read<LastFmBloc>().add(const LastFmAuthUrlRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Last.fm'),
      ),
      body: BlocConsumer<LastFmBloc, LastFmState>(
        listener: (context, state) {
          if (state is LastFmFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is LastFmConnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Connected to Last.fm')),
            );
            Navigator.of(context).pop();
          } else if (state is LastFmDisconnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Disconnected from Last.fm')),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is LastFmLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is LastFmAuthUrlLoaded) {
            launchUrl(Uri.parse(state.url));
            return const Center(
              child: Text('Waiting for authorization...'),
            );
          }
          return const Center(
            child: Text('Failed to load authorization URL'),
          );
        },
      ),
    );
  }
}
