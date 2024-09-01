import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/pages/login_page.dart';
import 'package:musicbud_flutter/pages/buds_page.dart';
import 'package:musicbud_flutter/models/user_profile.dart';
import 'package:musicbud_flutter/models/content_service.dart';
import 'package:musicbud_flutter/models/common_track.dart';
import 'package:musicbud_flutter/models/common_artist.dart';
import 'package:musicbud_flutter/models/common_genre.dart';
import 'package:musicbud_flutter/models/common_album.dart';
import 'package:musicbud_flutter/models/anime.dart';
import 'package:musicbud_flutter/models/manga.dart';
import 'package:musicbud_flutter/widgets/horizontal_list.dart';
import 'package:musicbud_flutter/models/bud_match.dart';
import 'package:musicbud_flutter/pages/common_items_page.dart';

class ProfilePage extends StatefulWidget {
  final ApiService apiService;

  const ProfilePage({Key? key, required this.apiService}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    try {
      await widget.apiService.getUserProfile();
      setState(() {
        _isAuthenticated = true;
      });
    } catch (e) {
      print('Authentication failed: $e');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage(apiService: widget.apiService)),
      );
    }
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Profile';
      case 1:
        return 'Buds';
      case 2:
        return 'Chat';
      default:
        return 'MusicBud';
    }
  }

  Widget _getBody() {
    switch (_selectedIndex) {
      case 0:
        return ProfilePageContent(apiService: widget.apiService);
      case 1:
        return BudsPage(apiService: widget.apiService);
      case 2:
        return Center(child: Text('Chat Page')); // Replace with actual Chat page content
      default:
        return ProfilePageContent(apiService: widget.apiService);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
      ),
      body: _getBody(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Buds',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ProfilePageContent extends StatefulWidget {
  final ApiService apiService;

  const ProfilePageContent({Key? key, required this.apiService}) : super(key: key);

  @override
  _ProfilePageContentState createState() => _ProfilePageContentState();
}

class _ProfilePageContentState extends State<ProfilePageContent> {
  late ApiService _apiService;
  bool _isLoading = true;
  String? _error;

  UserProfile? _userProfile;
  ContentService _selectedService = ContentService.music;

  // Music-related lists
  List<CommonTrack> _topTracks = [];
  List<CommonArtist> _topArtists = [];
  List<CommonGenre> _topGenres = [];
  List<CommonAlbum> _likedAlbums = [];
  List<CommonTrack> _playedTracks = [];

  // Anime-related lists
  List<Anime> _topAnime = [];
  List<Manga> _topManga = [];

  @override
  void initState() {
    super.initState();
    _apiService = widget.apiService;
    _initializeApiAndLoadData();
  }

  Future<void> _initializeApiAndLoadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      await _loadUserProfile();
      await _loadTopTracks();
      await _loadTopArtists();
      await _loadTopGenres();
      await _loadLikedAlbums();
      await _loadPlayedTracks();
      await _loadTopAnime();
      await _loadTopManga();
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      final userProfile = await _apiService.getUserProfile();
      setState(() {
        _userProfile = userProfile;
      });
    } catch (e) {
      print('Error loading user profile: $e');
      rethrow;
    }
  }

  Future<void> _loadTopTracks() async {
    try {
      final tracks = await _apiService.fetchItems<CommonTrack>('/me/top/tracks');
      setState(() {
        _topTracks = tracks;
      });
    } catch (e) {
      print('Error loading top tracks: $e');
      rethrow;
    }
  }

  Future<void> _loadTopArtists() async {
    try {
      final artists = await _apiService.fetchItems<CommonArtist>('/me/top/artists');
      setState(() {
        _topArtists = artists;
      });
    } catch (e) {
      print('Error loading top artists: $e');
      rethrow;
    }
  }

  Future<void> _loadTopGenres() async {
    try {
      final genres = await _apiService.fetchItems<CommonGenre>('/me/top/genres');
      setState(() {
        _topGenres = genres;
      });
    } catch (e) {
      print('Error loading top genres: $e');
      rethrow;
    }
  }

  Future<void> _loadLikedAlbums() async {
    try {
      final albums = await _apiService.getLikedAlbums();
      setState(() {
        _likedAlbums = albums;
      });
    } catch (e) {
      print('Error loading liked albums: $e');
      rethrow;
    }
  }

  Future<void> _loadPlayedTracks() async {
    try {
      final tracks = await _apiService.getPlayedTracks();
      setState(() {
        _playedTracks = tracks;
      });
    } catch (e) {
      print('Error loading played tracks: $e');
      rethrow;
    }
  }

  Future<void> _loadTopAnime() async {
    try {
      final anime = await _apiService.getTopAnime();
      setState(() {
        _topAnime = anime;
      });
    } catch (e) {
      print('Error loading top anime: $e');
      rethrow;
    }
  }

  Future<void> _loadTopManga() async {
    try {
      final manga = await _apiService.getTopManga();
      setState(() {
        _topManga = manga;
      });
    } catch (e) {
      print('Error loading top manga: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initializeApiAndLoadData,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
    if (_selectedService == ContentService.music) {
      return [
        if (_topTracks.isNotEmpty)
          HorizontalList<CommonTrack>(
            title: 'Top Tracks',
            items: _topTracks,
            itemBuilder: (track) => _buildTrackItem(track),
          )
        else
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('No top tracks available'),
          ),
        if (_topArtists.isNotEmpty)
          HorizontalList<CommonArtist>(
            title: 'Top Artists',
            items: _topArtists,
            itemBuilder: (artist) => _buildArtistItem(artist),
          )
        else
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('No top artists available'),
          ),
        if (_topGenres.isNotEmpty)
          HorizontalList<CommonGenre>(
            title: 'Top Genres',
            items: _topGenres,
            itemBuilder: (genre) => _buildGenreItem(genre),
          )
        else
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('No top genres available'),
          ),
        if (_likedAlbums.isNotEmpty)
          HorizontalList<CommonAlbum>(
            title: 'Liked Albums',
            items: _likedAlbums,
            itemBuilder: (album) => _buildAlbumItem(album),
          )
        else
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('No liked albums available'),
          ),
        if (_playedTracks.isNotEmpty)
          HorizontalList<CommonTrack>(
            title: 'Recently Played',
            items: _playedTracks,
            itemBuilder: (track) => _buildTrackItem(track),
          )
        else
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('No recently played tracks available'),
          ),
      ];
    } else if (_selectedService == ContentService.anime) {
      return [
        if (_topAnime.isNotEmpty)
          HorizontalList<Anime>(
            title: 'Top Anime',
            items: _topAnime,
            itemBuilder: (anime) => _buildAnimeItem(anime),
          )
        else
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('No top anime available'),
          ),
        if (_topManga.isNotEmpty)
          HorizontalList<Manga>(
            title: 'Top Manga',
            items: _topManga,
            itemBuilder: (manga) => _buildMangaItem(manga),
          )
        else
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('No top manga available'),
          ),
      ];
    } else {
      return [];
    }
  }

  Widget _buildTrackItem(CommonTrack track) {
    return Container(
      width: 150,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 150,
              color: Colors.grey,
              child: Icon(Icons.music_note, size: 50),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    track.name ?? 'Unknown Track',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Similarity: ${track.similarityScore?.toStringAsFixed(2) ?? 'N/A'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtistItem(CommonArtist artist) {
    return Container(
      width: 150,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              width: 150,
              color: Colors.grey,
              child: Icon(Icons.person, size: 50),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    artist.name ?? 'Unknown Artist',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Similarity: ${artist.similarityScore?.toStringAsFixed(2) ?? 'N/A'}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenreItem(CommonGenre genre) {
    return Container(
      width: 150,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.music_note, size: 40),
              SizedBox(height: 8),
              Text(
                genre.name ?? 'Unknown Genre',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                'Similarity: ${genre.similarityScore?.toStringAsFixed(2) ?? 'N/A'}',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumItem(CommonAlbum album) {
    return Container(
      width: 150,
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (album.imageUrl != null)
              Image.network(
                album.imageUrl!,
                height: 100,
                width: 150,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 100,
                width: 150,
                color: Colors.grey,
                child: Icon(Icons.album, size: 50),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    album.name ?? 'Unknown Album',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    album.artist ?? 'Unknown Artist',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
    return Container(
      width: 150, // Set a fixed width for each item
      child: Card(
        child: Column(
          children: [
            Image.network(
              manga.imageUrl ?? 'https://example.com/default_image.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            Text(manga.title, overflow: TextOverflow.ellipsis),
            if (manga.author != null) Text(manga.author!, overflow: TextOverflow.ellipsis),
          ],
        ),
      ),
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

