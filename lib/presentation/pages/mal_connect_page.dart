import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/mal/mal_bloc.dart';
import 'package:musicbud_flutter/blocs/auth/mal/mal_event.dart';
import 'package:musicbud_flutter/blocs/auth/mal/mal_state.dart';
import 'dart:html' as html;
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

class MalConnectPage extends StatefulWidget {
  const MalConnectPage({
    Key? key,
  }) : super(key: key);

  @override
  _MalConnectPageState createState() => _MalConnectPageState();
}

class _MalConnectPageState extends State<MalConnectPage> {
  final TextEditingController _authDataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setupMessageListener();
    context.read<MALBloc>().add(MALAuthUrlRequested());
  }

  void _setupMessageListener() {
    html.window.onMessage.listen((html.MessageEvent e) {
      if (e.data is Map && e.data['type'] == 'MAL_AUTH_CALLBACK') {
        _handleCallback(e.data['data']);
      }
    });
  }

  void _handleCallback(dynamic data) {
    if (data is Map<String, dynamic>) {
      final token = data['token'] as String?;
      if (token != null) {
        context.read<MALBloc>().add(MALConnectRequested(token));
      }
    }
  }

  void _connect() {
    context.read<MALBloc>().add(MALAuthUrlRequested());
  }

  void _disconnect() {
    context.read<MALBloc>().add(MALDisconnectRequested());
  }

  void _submitManualAuthData() {
    final authData = _authDataController.text.trim();
    if (authData.isNotEmpty) {
      try {
        final decodedData = json.decode(authData);
        if (decodedData is Map<String, dynamic>) {
          final token = decodedData['token'] ?? decodedData['access_token'];
          if (token != null) {
            context.read<MALBloc>().add(MALConnectRequested(token));
          }
        } else if (authData.startsWith('ya29.') || authData.length > 20) {
          context.read<MALBloc>().add(MALConnectRequested(authData));
        }
      } catch (e) {
        if (authData.startsWith('ya29.') || authData.length > 20) {
          context.read<MALBloc>().add(MALConnectRequested(authData));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MALBloc, MALState>(
      listener: (context, state) {
        if (state is MALAuthUrlLoaded && kIsWeb) {
          html.window
              .open(state.url, 'MyAnimeList Auth', 'width=800,height=600');
        } else if (state is MALFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        } else if (state is MALConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Successfully connected to MyAnimeList')),
          );
        } else if (state is MALDisconnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Successfully disconnected from MyAnimeList')),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Connect MyAnimeList'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<MALBloc, MALState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state is MALConnected)
                    Column(
                      children: [
                        const Text('Connected to MyAnimeList'),
                        ElevatedButton(
                          onPressed: _disconnect,
                          child: const Text('Disconnect'),
                        ),
                      ],
                    )
                  else
                    ElevatedButton(
                      onPressed: state is! MALLoading ? _connect : null,
                      child: state is MALLoading
                          ? const CircularProgressIndicator()
                          : const Text('Connect MyAnimeList'),
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
                        state is! MALLoading ? _submitManualAuthData : null,
                    child: state is MALLoading
                        ? const CircularProgressIndicator()
                        : const Text('Submit Authentication Data'),
                  ),
                  if (state is MALFailure)
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
