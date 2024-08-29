import 'package:flutter/material.dart';
import 'package:musicbud_flutter/widgets/top_tracks_horizontal_list.dart' as tracks;
import 'package:musicbud_flutter/widgets/top_genres_horizontal_list.dart' show TopGenresHorizontalList;
import 'package:musicbud_flutter/widgets/top_artists_horizontal_list.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/models/track.dart'; // Import the Track model

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: ProfilePageContent(),
    );
  }
}

class ProfilePageContent extends StatefulWidget {
  @override
  _ProfilePageContentState createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent> {
  List<Track> _initialTracks = [];
  bool _isLoading = true;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadInitialTracks();
  }

  Future<void> _loadInitialTracks() async {
    try {
      final tracks = await _apiService.getTopTracks(page: 1);
      setState(() {
        _initialTracks = tracks;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading initial tracks: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Track>> _loadMoreTracks(int page) async {
    try {
      return await _apiService.getTopTracks(page: page);
    } catch (e) {
      print('Error loading more tracks: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info section
          // ...

          // Top Tracks section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Top Tracks', style: Theme.of(context).textTheme.headline6),
          ),
          SizedBox(
            height: 200,
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : tracks.TopTracksHorizontalList(
                    initialTracks: _initialTracks,
                    loadMoreTracks: _loadMoreTracks,
                  ),
          ),

          // Top Artists section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Top Artists', style: Theme.of(context).textTheme.headline6),
          ),
          SizedBox(
            height: 200,
            child: TopArtistsHorizontalList(),
          ),

          // Top Genres section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Top Genres', style: Theme.of(context).textTheme.headline6),
          ),
          SizedBox(
            height: 50, // Match the height in TopGenresHorizontalList
            child: TopGenresHorizontalList(),
          ),
        ],
      ),
    );
  }
}