import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/ytmusic/ytmusic_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/ytmusic/ytmusic_event.dart';
import 'package:musicbud_flutter/blocs/auth/ytmusic/ytmusic_state.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

class YtMusicConnectPage extends StatefulWidget {
  const YtMusicConnectPage({
    Key? key,
  }) : super(key: key);

  @override
  _YtMusicConnectPageState createState() => _YtMusicConnectPageState();
}

class _YtMusicConnectPageState extends State<YtMusicConnectPage> {
  final TextEditingController _authDataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupMessageListener();
    context.read<YTMusicBloc>().add(YTMusicAuthUrlRequested());
  }

  void _setupMessageListener() {
    html.window.onMessage.listen((html.MessageEvent e) {
      if (e.data is Map && e.data['type'] == 'YTMUSIC_AUTH_CALLBACK') {
        _handleCallback(e.data['data']);
      }
    });
  }

  void _handleCallback(dynamic data) {
    if (data is Map<String, dynamic>) {
      final token = data['token'] as String?;
      if (token != null) {
        context.read<YTMusicBloc>().add(YTMusicConnectRequested(token));
      }
    }
  }

  void _connect() {
    context.read<YTMusicBloc>().add(YTMusicAuthUrlRequested());
  }

  void _disconnect() {
    context.read<YTMusicBloc>().add(YTMusicDisconnectRequested());
  }

  void _submitManualAuthData() {
    final authData = _authDataController.text.trim();
    if (authData.isNotEmpty) {
      try {
        final decodedData = json.decode(authData);
        if (decodedData is Map<String, dynamic>) {
          final token = decodedData['token'] ?? decodedData['access_token'];
          if (token != null) {
            context.read<YTMusicBloc>().add(YTMusicConnectRequested(token));
          }
        } else if (authData.startsWith('ya29.') || authData.length > 20) {
          context.read<YTMusicBloc>().add(YTMusicConnectRequested(authData));
        }
      } catch (e) {
        if (authData.startsWith('ya29.') || authData.length > 20) {
          context.read<YTMusicBloc>().add(YTMusicConnectRequested(authData));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<YTMusicBloc, YTMusicState>(
      listener: (context, state) {
        if (state is YTMusicAuthUrlLoaded && kIsWeb) {
          html.window
              .open(state.url, 'YouTube Music Auth', 'width=800,height=600');
        } else if (state is YTMusicFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is YTMusicConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Successfully connected to YouTube Music')),
          );
        } else if (state is YTMusicDisconnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Successfully disconnected from YouTube Music')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Connect YouTube Music'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<YTMusicBloc, YTMusicState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state is YTMusicConnected)
                    Column(
                      children: [
                        const Text('Connected to YouTube Music'),
                        ElevatedButton(
                          onPressed: _disconnect,
                          child: const Text('Disconnect'),
                        ),
                      ],
                    )
                  else
                    ElevatedButton(
                      onPressed: state is! YTMusicLoading ? _connect : null,
                      child: state is YTMusicLoading
                          ? const CircularProgressIndicator()
                          : const Text('Connect YouTube Music'),
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
                        state is! YTMusicLoading ? _submitManualAuthData : null,
                    child: state is YTMusicLoading
                        ? const CircularProgressIndicator()
                        : const Text('Submit Authentication Data'),
                  ),
                  if (state is YTMusicFailure)
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
