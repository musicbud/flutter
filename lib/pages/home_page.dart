import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import '../models/track.dart';
import '../widgets/top_tracks_horizontal_list.dart';
import '../widgets/top_artists_horizontal_list.dart';

class HomePage extends StatelessWidget {
  final ApiService apiService;

  const HomePage({Key? key, required this.apiService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example list of tracks
    final List<Track> tracks = [
      Track(
        id: '1',
        name: 'Track 1',
        artist: 'Artist 1',
        spotifyId: 'spotifyId1',
        spotifyUrl: 'https://open.spotify.com/track/spotifyId1',
        imageUrl: 'https://example.com/image1.png',
      ),
      Track(
        id: '2',
        name: 'Track 2',
        artist: 'Artist 2',
        spotifyId: 'spotifyId2',
        spotifyUrl: 'https://open.spotify.com/track/spotifyId2',
        imageUrl: 'https://example.com/image2.png',
      ),
      // Add more tracks as needed
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: TopArtistsHorizontalList(),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: TopTracksHorizontalList(
                initialTracks: tracks,
                loadMoreTracks: (page) async {
                  // Fetch more tracks from your API
                  // Return an empty list for now, but make sure it's not null
                  return <Track>[];
                },
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return ListTile(
                  title: Text('Item $index'),
                );
              },
              childCount: 50, // Add more items if needed
            ),
          ),
        ],
      ),
    );
  }
}