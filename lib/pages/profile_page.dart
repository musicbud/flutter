import 'package:flutter/material.dart';
import 'package:musicbud_flutter/models/track.dart';
import 'package:musicbud_flutter/services/api_service.dart'; // Make sure this import exists
import 'package:musicbud_flutter/widgets/top_tracks_horizontal_list.dart';
import '../widgets/top_artists_horizontal_list.dart';
import '../widgets/top_genres_horizontal_list.dart';

class ProfilePageWrapper extends StatelessWidget {
  const ProfilePageWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfilePage();
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ProfilePageContent();
  }
}

class _ProfilePageContent extends StatefulWidget {
  @override
  _ProfilePageContentState createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<_ProfilePageContent> {
  final ApiService _apiService = ApiService(); // Instantiate your API service
  List<Track> _initialTracks = [];
  bool _isLoading = true;

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://example.com/profile_picture.jpg'),
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Username',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const Text('email@example.com'),
                  const Text('Mobile: +1234567890'),
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Bio: This is a sample bio of the user. It can contain information about their music preferences, favorite artists, or anything else they want to share.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Divider(),
                  const Text(
                    'Top Tracks',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 100,
                    child: TopTracksHorizontalList(
                      initialTracks: _initialTracks,
                      loadMoreTracks: _loadMoreTracks,
                    ),
                  ),
                  const Divider(),
                  const Text(
                    'Top Artists',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 100,
                    child: TopArtistsHorizontalList(),
                  ),
                  const Divider(),
                  const Text(
                    'Top Genres',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 100,
                    child: TopGenresHorizontalList(),
                  ),
                ],
              ),
            ),
    );
  }
}