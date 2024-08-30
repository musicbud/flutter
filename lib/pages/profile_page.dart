import 'package:flutter/material.dart';
import '../models/track.dart';
import '../models/artist.dart';
import '../models/album.dart';
import '../models/anime.dart';
import '../models/manga.dart';
import '../models/user_profile.dart';
import '../models/content_service.dart';
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

  UserProfile? _userProfile;
  ContentService _selectedService = ContentService.music;

  // Music-related lists
  List<Track> _topTracks = [];
  List<Artist> _topArtists = [];
  List<String> _topGenres = [];
  List<Album> _likedAlbums = [];
  List<Track> _playedTracks = [];

  // Anime-related lists
  List<Anime> _topAnime = [];
  List<Manga> _topManga = [];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadDataForService(_selectedService);
  }

  Future<void> _loadDataForService(ContentService service) async {
    try {
      final userProfileFuture = _apiService.getUserProfile();

      setState(() {
        _topTracks = [];
        _topArtists = [];
        _topGenres = [];
        _likedAlbums = [];
        _playedTracks = [];
        _topAnime = [];
        _topManga = [];
      });

      switch (service) {
        case ContentService.music:
          final futures = await Future.wait<dynamic>([
            userProfileFuture,
            _apiService.getTopTracks(page: 1),
            _apiService.getTopArtists(page: 1),
            _apiService.getTopGenres(page: 1),
            _apiService.getLikedAlbums(page: 1),
            _apiService.getPlayedTracks(page: 1),
          ]);

          setState(() {
            _userProfile = futures[0] as UserProfile;
            _topTracks = futures[1] as List<Track>;
            _topArtists = futures[2] as List<Artist>;
            _topGenres = futures[3] as List<String>;
            _likedAlbums = futures[4] as List<Album>;
            _playedTracks = futures[5] as List<Track>;
          });
          break;

        case ContentService.anime:
          final futures = await Future.wait<dynamic>([
            userProfileFuture,
            _apiService.getTopAnime(page: 1),
            _apiService.getTopManga(page: 1),
          ]);

          setState(() {
            _userProfile = futures[0] as UserProfile;
            _topAnime = futures[1] as List<Anime>;
            _topManga = futures[2] as List<Manga>;
          });
          break;
      }
    } catch (e) {
      print('Error loading data for ${service.name}: $e');
      // TODO: Handle error state
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildUserProfileSection(),
          SizedBox(height: 20),
          _buildServiceDropdown(),
          SizedBox(height: 20),
          ..._buildContentLists(),
        ],
      ),
    );
  }

  Widget _buildUserProfileSection() {
    if (_userProfile == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_userProfile!.photoUrl != null)
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(_userProfile!.photoUrl!),
              )
            else
              CircleAvatar(
                radius: 60,
                backgroundColor: Theme.of(context).primaryColor,
                child: Text(
                  _userProfile!.username[0].toUpperCase(),
                  style: TextStyle(fontSize: 40, color: Colors.white),
                ),
              ),
            SizedBox(height: 20),
            Text(
              _userProfile!.displayName ?? _userProfile!.username,
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            if (_userProfile!.email != null)
              Text(
                _userProfile!.email!,
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 10),
            if (_userProfile!.bio != null)
              Text(
                _userProfile!.bio!,
                style: Theme.of(context).textTheme.bodyText2,
                textAlign: TextAlign.center,
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildInfoChip(
                  Icons.check_circle,
                  _userProfile!.isActive ? 'Active' : 'Inactive',
                  _userProfile!.isActive ? Colors.green : Colors.red,
                ),
                SizedBox(width: 10),
                _buildInfoChip(
                  Icons.verified_user,
                  _userProfile!.isAuthenticated ? 'Authenticated' : 'Not Authenticated',
                  _userProfile!.isAuthenticated ? Colors.blue : Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Chip(
      avatar: Icon(icon, color: color, size: 18),
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color),
    );
  }

  Widget _buildServiceDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<ContentService>(
        value: _selectedService,
        isExpanded: true,
        onChanged: (ContentService? newValue) {
          if (newValue != null) {
            setState(() {
              _selectedService = newValue;
            });
            _loadDataForService(newValue);
          }
        },
        items: ContentService.values.map<DropdownMenuItem<ContentService>>((ContentService value) {
          return DropdownMenuItem<ContentService>(
            value: value,
            child: Text(value.name),
          );
        }).toList(),
      ),
    );
  }

  List<Widget> _buildContentLists() {
    switch (_selectedService) {
      case ContentService.music:
        return [
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
            loadMore: () => _loadMore(_apiService.getTopArtists, _topArtists),
          ),
          _buildHorizontalList<String>(
            title: 'Top Genres',
            items: _topGenres,
            itemBuilder: _buildGenreItem,
            loadMore: () => _loadMore(_apiService.getTopGenres, _topGenres),
          ),
          _buildHorizontalList<Album>(
            title: 'Liked Albums',
            items: _likedAlbums,
            itemBuilder: _buildAlbumItem,
            loadMore: () => _loadMore(_apiService.getLikedAlbums, _likedAlbums),
          ),
          _buildHorizontalList<Track>(
            title: 'Recently Played',
            items: _playedTracks,
            itemBuilder: _buildTrackItem,
            loadMore: () => _loadMore(_apiService.getPlayedTracks, _playedTracks),
          ),
        ];
      case ContentService.anime:
        return [
          _buildHorizontalList<Anime>(
            title: 'Top Anime',
            items: _topAnime,
            itemBuilder: _buildAnimeItem,
            loadMore: () => _loadMore(_apiService.getTopAnime, _topAnime),
          ),
          _buildHorizontalList<Manga>(
            title: 'Top Manga',
            items: _topManga,
            itemBuilder: _buildMangaItem,
            loadMore: () => _loadMore(_apiService.getTopManga, _topManga),
          ),
        ];
    }
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

  Future<void> _loadMore<T>(
    Future<List<T>> Function({required int page}) fetchFunction,
    List<T> items
  ) async {
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
      imageUrl: track.imageUrl ?? 'default_image_url',
      title: track.name,
      subtitle: track.artistName ?? 'Unknown Artist',
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
      subtitle: album.artist ?? 'Unknown Artist',
    );
  }

  Widget _buildAnimeItem(Anime anime) {
    return _buildItemCard(
      imageUrl: anime.imageUrl,
      title: anime.title,
      subtitle: anime.studio,
    );
  }

  Widget _buildMangaItem(Manga manga) {
    return _buildItemCard(
      imageUrl: manga.imageUrl,
      title: manga.title,
      subtitle: manga.author,
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