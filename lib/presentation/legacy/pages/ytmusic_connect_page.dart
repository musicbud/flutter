import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth/ytmusic/ytmusic_bloc.dart';
import '../../blocs/auth/ytmusic/ytmusic_event.dart';
import '../../blocs/auth/ytmusic/ytmusic_state.dart';
import 'package:url_launcher/url_launcher.dart';

class YtMusicConnectPage extends StatefulWidget {
  const YtMusicConnectPage({super.key});

  @override
  State<YtMusicConnectPage> createState() => _YtMusicConnectPageState();
}

class _YtMusicConnectPageState extends State<YtMusicConnectPage> {
  @override
  void initState() {
    super.initState();
    context.read<YtMusicBloc>().add(const YtMusicAuthUrlRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect YouTube Music'),
      ),
      body: BlocConsumer<YtMusicBloc, YtMusicState>(
        listener: (context, state) {
          if (state is YtMusicFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is YtMusicConnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Connected to YouTube Music')),
            );
            Navigator.of(context).pop();
          } else if (state is YtMusicDisconnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Disconnected from YouTube Music')),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          if (state is YtMusicLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is YtMusicAuthUrlLoaded) {
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
