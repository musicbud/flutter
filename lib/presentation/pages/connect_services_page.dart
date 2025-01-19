import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/services/services_bloc.dart';
import '../../blocs/services/services_event.dart';
import '../../blocs/services/services_state.dart';
import '../../blocs/auth/spotify/spotify_bloc.dart';
import '../../blocs/auth/spotify/spotify_state.dart';
import '../../blocs/auth/ytmusic/ytmusic_bloc.dart';
import '../../blocs/auth/ytmusic/ytmusic_state.dart';
import '../../blocs/auth/lastfm/lastfm_bloc.dart';
import '../../blocs/auth/lastfm/lastfm_state.dart';
import '../../blocs/auth/mal/mal_bloc.dart';
import '../../blocs/auth/mal/mal_state.dart';
import '../widgets/loading_indicator.dart';
import 'spotify_connect_page.dart';
import 'ytmusic_connect_page.dart';
import 'lastfm_connect_page.dart';
import 'mal_connect_page.dart';

class ConnectServicesPage extends StatefulWidget {
  const ConnectServicesPage({super.key});

  @override
  State<ConnectServicesPage> createState() => _ConnectServicesPageState();
}

class _ConnectServicesPageState extends State<ConnectServicesPage> {
  @override
  void initState() {
    super.initState();
    context.read<ServicesBloc>().add(ServicesStatusRequested());
  }

  Widget _buildServiceTile(
    BuildContext context,
    String name,
    IconData icon,
    VoidCallback onTap,
    bool isConnected,
    VoidCallback? onDisconnect,
  ) {
    return ListTile(
      leading: Icon(icon),
      title: Text(name),
      trailing: isConnected
          ? IconButton(
              icon: const Icon(Icons.link_off),
              onPressed: onDisconnect,
              tooltip: 'Disconnect',
            )
          : const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _handleDisconnect(String service) {
    context.read<ServicesBloc>().add(ServiceDisconnectRequested(service));
  }

  bool _isServiceConnected(String service, BuildContext context) {
    switch (service) {
      case 'spotify':
        final state = context.watch<SpotifyBloc>().state;
        return state is SpotifyConnected;
      case 'ytmusic':
        final state = context.watch<YTMusicBloc>().state;
        return state is YTMusicConnected;
      case 'lastfm':
        final state = context.watch<LastFMBloc>().state;
        return state is LastFMConnected;
      case 'mal':
        final state = context.watch<MALBloc>().state;
        return state is MALConnected;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Services'),
      ),
      body: BlocConsumer<ServicesBloc, ServicesState>(
        listener: (context, state) {
          if (state is ServicesFailure) {
            _showErrorSnackBar(state.error);
          } else if (state is ServiceDisconnected) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('${state.service} disconnected successfully')),
            );
            context.read<ServicesBloc>().add(ServicesStatusRequested());
          }
        },
        builder: (context, state) {
          if (state is ServicesLoading) {
            return const LoadingIndicator();
          }

          return ListView(
            children: [
              _buildServiceTile(
                context,
                'Spotify',
                Icons.music_note,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SpotifyConnectPage(),
                  ),
                ),
                _isServiceConnected('spotify', context),
                _isServiceConnected('spotify', context)
                    ? () => _handleDisconnect('spotify')
                    : null,
              ),
              _buildServiceTile(
                context,
                'YouTube Music',
                Icons.play_circle_filled,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const YtMusicConnectPage(),
                  ),
                ),
                _isServiceConnected('ytmusic', context),
                _isServiceConnected('ytmusic', context)
                    ? () => _handleDisconnect('ytmusic')
                    : null,
              ),
              _buildServiceTile(
                context,
                'Last.fm',
                Icons.radio,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LastFmConnectPage(),
                  ),
                ),
                _isServiceConnected('lastfm', context),
                _isServiceConnected('lastfm', context)
                    ? () => _handleDisconnect('lastfm')
                    : null,
              ),
              _buildServiceTile(
                context,
                'MyAnimeList',
                Icons.movie,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MalConnectPage(),
                  ),
                ),
                _isServiceConnected('mal', context),
                _isServiceConnected('mal', context)
                    ? () => _handleDisconnect('mal')
                    : null,
              ),
            ],
          );
        },
      ),
    );
  }
}
