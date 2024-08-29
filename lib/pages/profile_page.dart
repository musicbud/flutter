import 'package:flutter/material.dart';
import '../models/track.dart';
import '../models/artist.dart';
import '../models/album.dart';
import '../services/api_service.dart';
import '../widgets/horizontal_list.dart';

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
  final ApiService _apiService = ApiService();
  static const int _itemsPerPage = 20;

  List<Track> _topTracks = [];
  List<Artist> _topArtists = [];
  List<String> _topGenres = [];
  List<Artist> _likedArtists = [];
  List<Track> _likedTracks = [];
  List<String> _likedGenres = [];
  List<Album> _likedAlbums = [];
  List<Track> _playedTracks = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final futures = await Future.wait([
        _apiService.getTopTracks(page: 1),
        _apiService.fetchTopArtists(page: 1),
        _apiService.getTopGenres(page: 1),
        _apiService.getLikedArtists(page: 1),
        _apiService.getLikedTracks(page: 1),
        _apiService.getLikedGenres(page: 1),
        _apiService.getLikedAlbums(page: 1),
        _apiService.getPlayedTracks(page: 1),
      ]);

      setState(() {
        _topTracks = futures[0] as List<Track>;
        _topArtists = futures[1] as List<Artist>;
        _topGenres = futures[2] as List<String>;
        _likedArtists = futures[3] as List<Artist>;
        _likedTracks = futures[4] as List<Track>;
        _likedGenres = futures[5] as List<String>;
        _likedAlbums = futures[6] as List<Album>;
        _playedTracks = futures[7] as List<Track>;
      });
    } catch (e) {
      print('Error loading initial data: $e');
      // TODO: Handle error state
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHorizontalList<Track>(
            title: 'Top Tracks',
            items: _topTracks,
            itemBuilder: _buildTrackItem,
            loadMore: () => _loadMore(_apiService.getTopTracks, _topTracks),
          ),
          _buildHorizontalList<Artist>(
            title: 'Top Artists',
            items: _topArtists,
            itemBuilder: _buildArtistItem,
            loadMore: () => _loadMore(_apiService.fetchTopArtists, _topArtists),
          ),
          _buildHorizontalList<String>(
            title: 'Top Genres',
            items: _topGenres,
            itemBuilder: _buildGenreItem,
            loadMore: () => _loadMore(_apiService.getTopGenres, _topGenres),
          ),
          _buildHorizontalList<Artist>(
            title: 'Liked Artists',
            items: _likedArtists,
            itemBuilder: _buildArtistItem,
            loadMore: () => _loadMore(_apiService.getLikedArtists, _likedArtists),
          ),
          _buildHorizontalList<Track>(
            title: 'Liked Tracks',
            items: _likedTracks,
            itemBuilder: _buildTrackItem,
            loadMore: () => _loadMore(_apiService.getLikedTracks, _likedTracks),
          ),
          _buildHorizontalList<String>(
            title: 'Liked Genres',
            items: _likedGenres,
            itemBuilder: _buildGenreItem,
            loadMore: () => _loadMore(_apiService.getLikedGenres, _likedGenres),
          ),
          _buildHorizontalList<Album>(
            title: 'Liked Albums',
            items: _likedAlbums,
            itemBuilder: _buildAlbumItem,
            loadMore: () => _loadMore(_apiService.getLikedAlbums, _likedAlbums),
          ),
          _buildHorizontalList<Track>(
            title: 'Played Tracks',
            items: _playedTracks,
            itemBuilder: _buildTrackItem,
            loadMore: () => _loadMore(_apiService.getPlayedTracks, _playedTracks),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList<T>({
    required String title,
    required List<T> items,
    required Widget Function(T) itemBuilder,
    required Future<void> Function() loadMore,
  }) {
    return HorizontalList<T>(
      title: title,
      items: items,
      itemBuilder: itemBuilder,
      loadMore: loadMore,
    );
  }

  Future<void> _loadMore<T>(Future<List<T>> Function({required int page}) fetchFunction, List<T> items) async {
    try {
      final newItems = await fetchFunction(page: (items.length ~/ _itemsPerPage) + 1);
      setState(() {
        items.addAll(newItems);
      });
    } catch (e) {
      print('Error loading more items: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load more items. Please try again later.')),
      );
    }
  }

  Widget _buildTrackItem(Track track) {
    return _buildItemCard(
      imageUrl: track.imageUrl,
      title: track.name,
      subtitle: track.artist ?? 'Unknown Artist',
    );
  }

  Widget _buildArtistItem(Artist artist) {
    return _buildItemCard(
      imageUrl: artist.imageUrl,
      title: artist.name,
    );
  }

  Widget _buildGenreItem(String genre) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chip(
        label: Text(genre),
      ),
    );
  }

  Widget _buildAlbumItem(Album album) {
    return _buildItemCard(
      imageUrl: album.imageUrl,
      title: album.name,
      subtitle: album.artist,
    );
  }

  Widget _buildItemCard({required String? imageUrl, required String title, String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Image.network(
            imageUrl ?? 'https://example.com/default_image.png',
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          Text(title, overflow: TextOverflow.ellipsis),
          if (subtitle != null) Text(subtitle, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}