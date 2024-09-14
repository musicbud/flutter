import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/pages/spotify_connect_page.dart';
import 'package:musicbud_flutter/pages/ytmusic_connect_page.dart';
import 'package:musicbud_flutter/pages/lastfm_connect_page.dart';
import 'package:musicbud_flutter/pages/mal_connect_page.dart';

class ConnectServicesPage extends StatelessWidget {
  final ApiService apiService;

  const ConnectServicesPage({Key? key, required this.apiService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Services'),
      ),
      body: ListView(
        children: [
          _buildServiceTile(
            context,
            'Spotify',
            Icons.music_note,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SpotifyConnectPage(apiService: apiService),
              ),
            ),
          ),
          _buildServiceTile(
            context,
            'YouTube Music',
            Icons.play_circle_filled,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => YtMusicConnectPage(apiService: apiService),
              ),
            ),
          ),
          _buildServiceTile(
            context,
            'Last.fm',
            Icons.radio,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LastFmConnectPage(apiService: apiService),
              ),
            ),
          ),
          _buildServiceTile(
            context,
            'MyAnimeList',
            Icons.tv,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MalConnectPage(apiService: apiService),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
