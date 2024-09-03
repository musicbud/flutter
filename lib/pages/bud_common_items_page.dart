import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/widgets/horizontal_list.dart';
import 'package:musicbud_flutter/widgets/track_list_item.dart';
import 'package:musicbud_flutter/widgets/artist_list_item.dart';
import 'package:musicbud_flutter/widgets/genre_list_item.dart';
import 'package:musicbud_flutter/models/common_track.dart';
import 'package:musicbud_flutter/models/common_artist.dart';
import 'package:musicbud_flutter/models/common_genre.dart';

class BudCommonItemsPage extends StatefulWidget {
  final String budId;
  final String budName;

  const BudCommonItemsPage({Key? key, required this.budId, required this.budName}) : super(key: key);

  @override
  _BudCommonItemsPageState createState() => _BudCommonItemsPageState();
}

class _BudCommonItemsPageState extends State<BudCommonItemsPage> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  String? _error;

  List<CommonTrack> _commonTracks = [];
  List<CommonArtist> _commonArtists = [];
  List<CommonGenre> _commonGenres = [];
  List<CommonTrack> _commonPlayedTracks = [];

  @override
  void initState() {
    super.initState();
    _loadCommonItems();
  }

  Future<void> _loadCommonItems() async {
    try {
      final topTracks = await _apiService.getCommonTracks(widget.budId);
      final topArtists = await _apiService.getCommonArtists(widget.budId);
      final topGenres = await _apiService.getCommonGenres(widget.budId);
      final playedTracks = await _apiService.getCommonPlayedTracks(widget.budId);

      // Debug prints
      print('Top Tracks: ${topTracks.length}');
      if (topTracks.isNotEmpty) {
        print('First track image URL: ${topTracks[0].images.isNotEmpty ? topTracks[0].images[0].url : "No image"}');
      }

      print('Top Artists: ${topArtists.length}');
      if (topArtists.isNotEmpty) {
        print('First artist image URL: ${topArtists[0].images.isNotEmpty ? topArtists[0].images[0].url : "No image"}');
      }

      setState(() {
        _commonTracks = topTracks;
        _commonArtists = topArtists;
        _commonGenres = topGenres;
        _commonPlayedTracks = playedTracks;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading common items: $e');
      setState(() {
        _error = 'Failed to load common items: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Common Items with ${widget.budName}')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Common Items with ${widget.budName}')),
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Common Items with ${widget.budName}')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HorizontalList(
              title: 'Common Top Tracks',
              items: _commonTracks.map((track) => TrackListItem(track: track)).toList(),
              onSeeAll: () {
                // Navigate to full list of common top tracks
              },
            ),
            HorizontalList(
              title: 'Common Top Artists',
              items: _commonArtists.map((artist) => ArtistListItem(artist: artist)).toList(),
              onSeeAll: () {
                // Navigate to full list of common top artists
              },
            ),
            HorizontalList(
              title: 'Common Genres',
              items: _commonGenres.map((genre) => GenreListItem(genre: genre)).toList(),
              onSeeAll: () {
                // Navigate to full list of common genres
              },
            ),
            HorizontalList(
              title: 'Common Played Tracks',
              items: _commonPlayedTracks.map((track) => TrackListItem(track: track)).toList(),
              onSeeAll: () {
                // Navigate to full list of common played tracks
              },
            ),
          ],
        ),
      ),
    );
  }
}
