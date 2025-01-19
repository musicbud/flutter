import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/lastfm/lastfm_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/lastfm/lastfm_event.dart';
import 'package:musicbud_flutter/blocs/auth/lastfm/lastfm_state.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

class LastFmConnectPage extends StatefulWidget {
  const LastFmConnectPage({Key? key}) : super(key: key);

  @override
  _LastFmConnectPageState createState() => _LastFmConnectPageState();
}

class _LastFmConnectPageState extends State<LastFmConnectPage> {
  final TextEditingController _authDataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupMessageListener();
    context.read<LastFMBloc>().add(LastFMAuthUrlRequested());
  }

  void _setupMessageListener() {
    html.window.onMessage.listen((html.MessageEvent e) {
      if (e.data is Map && e.data['type'] == 'LASTFM_AUTH_CALLBACK') {
        _handleCallback(e.data['data']);
      }
    });
  }

  void _handleCallback(dynamic data) {
    if (data is Map<String, dynamic>) {
      final token = data['token'] as String?;
      if (token != null) {
        context.read<LastFMBloc>().add(LastFMConnectRequested(token));
      }
    }
  }

  void _connect() {
    context.read<LastFMBloc>().add(LastFMAuthUrlRequested());
  }

  void _disconnect() {
    context.read<LastFMBloc>().add(LastFMDisconnectRequested());
  }

  void _submitManualAuthData() {
    final authData = _authDataController.text.trim();
    if (authData.isNotEmpty) {
      try {
        final decodedData = json.decode(authData);
        if (decodedData is Map<String, dynamic>) {
          final token = decodedData['token'] ?? decodedData['access_token'];
          if (token != null) {
            context.read<LastFMBloc>().add(LastFMConnectRequested(token));
          }
        } else if (authData.startsWith('ya29.') || authData.length > 20) {
          context.read<LastFMBloc>().add(LastFMConnectRequested(authData));
        }
      } catch (e) {
        if (authData.startsWith('ya29.') || authData.length > 20) {
          context.read<LastFMBloc>().add(LastFMConnectRequested(authData));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LastFMBloc, LastFMState>(
      listener: (context, state) {
        if (state is LastFMAuthUrlLoaded && kIsWeb) {
          html.window.open(state.url, 'Last.fm Auth', 'width=800,height=600');
        } else if (state is LastFMFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is LastFMConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Successfully connected to Last.fm')),
          );
        } else if (state is LastFMDisconnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Successfully disconnected from Last.fm')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Connect Last.fm'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<LastFMBloc, LastFMState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state is LastFMConnected)
                    Column(
                      children: [
                        const Text('Connected to Last.fm'),
                        ElevatedButton(
                          onPressed: _disconnect,
                          child: const Text('Disconnect'),
                        ),
                      ],
                    )
                  else
                    ElevatedButton(
                      onPressed: state is! LastFMLoading ? _connect : null,
                      child: state is LastFMLoading
                          ? const CircularProgressIndicator()
                          : const Text('Connect Last.fm'),
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
                        state is! LastFMLoading ? _submitManualAuthData : null,
                    child: state is LastFMLoading
                        ? const CircularProgressIndicator()
                        : const Text('Submit Authentication Data'),
                  ),
                  if (state is LastFMFailure)
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
