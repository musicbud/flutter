import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/presentation/pages/buds_page.dart';
import 'package:musicbud_flutter/models/user_profile.dart';
import 'package:musicbud_flutter/models/content_service.dart';
import 'package:musicbud_flutter/models/common_track.dart';
import 'package:musicbud_flutter/models/common_artist.dart';
import 'package:musicbud_flutter/models/common_genre.dart';
import 'package:musicbud_flutter/models/common_album.dart';
import 'package:musicbud_flutter/presentation/widgets/horizontal_list.dart';
import 'package:musicbud_flutter/models/bud_match.dart';
import 'package:musicbud_flutter/presentation/pages/common_items_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musicbud_flutter/presentation/pages/login_page.dart';
import 'package:musicbud_flutter/presentation/widgets/track_list_item.dart';
import 'package:musicbud_flutter/presentation/widgets/artist_list_item.dart';
import 'package:musicbud_flutter/presentation/widgets/genre_list_item.dart';
import 'package:musicbud_flutter/presentation/widgets/album_list_item.dart';
import 'package:musicbud_flutter/presentation/widgets/bud_match_list_item.dart';
import 'package:musicbud_flutter/presentation/pages/buds_category_page.dart';
import 'package:musicbud_flutter/presentation/pages/chat_home_page.dart';
import 'package:musicbud_flutter/services/chat_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:musicbud_flutter/presentation/pages/track_details_page.dart';
import 'package:musicbud_flutter/presentation/pages/artist_details_page.dart';
import 'package:musicbud_flutter/presentation/pages/genre_details_page.dart';
import 'package:musicbud_flutter/presentation/widgets/anime_list_item.dart';
import 'package:musicbud_flutter/presentation/widgets/manga_list_item.dart';
import '../../models/common_anime.dart';
import '../../models/common_manga.dart';

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
    // _loadUserProfile();
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => LoginPage(
          chatService: ChatService(widget.apiService.dio),
          apiService: widget.apiService,
        ),
      ),
    );
  }

  Future<void> _checkAuthentication() async {
    try {
      await widget.apiService.getUserProfile();
      if (!context.mounted) return;
      setState(() {
        _isAuthenticated = true;
      });
    } catch (e) {
      print('Authentication failed: $e');
      if (!context.mounted) return;
      _navigateToLogin();
    }
  }

  Future<void> _loadUserProfile() async {
    try {
      if (!mounted) return;
      setState(() {
      });
    } catch (e) {
      print('Error loading user profile: $e');
      if (!mounted) return;
      _handleError('Failed to load user profile. Please try again.');
    }
  }

  void _handleError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
        return const BudsPage();
      case 2:
        return FutureBuilder<String?>(
          future: getUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data != null) {
                return ChatHomePage(
                  chatService: ChatService(widget.apiService.dio),
                  currentUsername: snapshot.data!,
                );
              } else {
                return const Center(
                    child: Text('Please log in to access chat.'));
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        );
      default:
        return ProfilePageContent(apiService: widget.apiService);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAuthenticated) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BudsCategoryPage(),
                ),
              );
            },
          ),
        ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String? username = await getUsername();
          if (username != null) {
            if (!context.mounted) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatHomePage(
                  chatService: ChatService(widget.apiService.dio),
                  currentUsername: username,
                ),
              ),
            );
          } else {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please log in first')),
            );
          }
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}

class ProfilePageContent extends StatefulWidget {
  final ApiService apiService;

  const ProfilePageContent({Key? key, required this.apiService})
      : super(key: key);

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
  List<CommonTrack> _playedTracks = [];

  // Anime-related lists
  List<CommonAnime> _topAnime = [];
  List<CommonManga> _topManga = [];

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
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
      await _loadPlayedTracks();
    } catch (e) {
      print('Error loading data: $e');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
      });
    }

    if (!mounted) return;
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _loadUserProfile() async {
    try {
      final userProfile = await _apiService.getUserProfile();
      if (!mounted) return;
      setState(() {
        _userProfile = userProfile;
      });
    } catch (e) {
      print('Error loading user profile: $e');
      if (!mounted) return;
      _handleError('Failed to load user profile. Please try again.');
    }
  }

  Future<void> _loadTopTracks() async {
    try {
      final topTracks = await _apiService.getTopTracks();
      if (!context.mounted) return;
      setState(() {
        _topTracks = topTracks;
      });
    } catch (e) {
      print('Error loading top tracks: $e');
      if (!mounted) return;
      _handleError('Unable to load top tracks. Please try again later.');
    }
  }

  Future<void> _loadTopArtists() async {
    try {
      final topArtists = await _apiService.getTopArtists();
      if (!context.mounted) return;
      setState(() {
        _topArtists = topArtists;
      });
    } catch (e) {
      print('Error loading top artists: $e');
      // Handle the error (e.g., show an error message to the user)
    }
  }

  Future<void> _loadTopGenres() async {
    try {
      final genres = await _apiService.getTopGenres();
      if (!context.mounted) return;
      setState(() {
        _topGenres = genres.map((genre) => CommonGenre(name: genre)).toList();
      });
    } catch (e) {
      print('Error loading top genres: $e');
      rethrow;
    }
  }

  Future<void> _loadPlayedTracks() async {
    try {
      final tracks = await _apiService.getPlayedTracks();
      if (!context.mounted) return;
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
      final topAnime = await _apiService.getTopAnime();
      setState(() {
        _topAnime = topAnime;
      });
    } catch (e) {
      print('Error loading top anime: $e');
      setState(() {
        _topAnime = []; // Set to an empty list in case of an error
      });
    }
  }

  Future<void> _loadTopManga() async {
    try {
      final topManga = await _apiService.getTopManga();
      setState(() {
        _topManga = topManga;
      });
    } catch (e) {
      print('Error loading top manga: $e');
      setState(() {
        _topManga = []; // Set to an empty list in case of an error
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      try {
        final String? newPhotoUrl =
            await _apiService.uploadProfilePhoto(image.path);
        if (!context.mounted) return;

        if (newPhotoUrl != null && _userProfile != null) {
          setState(() {
            _userProfile = _userProfile!.copyWith(photoUrl: newPhotoUrl);
          });
        }
      } catch (e) {
        print('Error uploading image: $e');
        if (!mounted) return;
        _handleError('Failed to upload image. Please try again.');
      }
    }
  }

  void _handleError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _initializeApiAndLoadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView(
      children: [
        _buildUserProfileSection(),
        const SizedBox(height: 20),
        _buildServiceDropdown(),
        const SizedBox(height: 20),
        ..._buildContentLists(),
        _buildCommonItemsSection(context),
      ],
    );
  }

  Widget _buildUserProfileSection() {
    if (_userProfile == null) {
      return const Center(child: Text('User profile not available'));
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _userProfile?.photoUrl != null
                    ? NetworkImage(_userProfile!.photoUrl!)
                    : null,
                child: _userProfile?.photoUrl == null
                    ? const Icon(Icons.person, size: 50)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _userProfile!.displayName ?? _userProfile!.username,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(_userProfile!.email),
            const SizedBox(height: 16),
            if (_userProfile!.bio != null)
              Text(
                _userProfile!.bio!,
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.circle,
                  size: 12,
                  color: _userProfile!.isActive ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 8),
                Text(
                  _userProfile!.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                      color:
                          _userProfile!.isActive ? Colors.green : Colors.red),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _userProfile!.isAuthenticated
                  ? 'Authenticated'
                  : 'Not Authenticated',
              style: TextStyle(
                  color: _userProfile!.isAuthenticated
                      ? Colors.blue
                      : Colors.orange),
            ),
          ],
        ),
      ),
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
        items: ContentService.values
            .map<DropdownMenuItem<ContentService>>((ContentService value) {
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
        HorizontalList(
          title: 'Top Tracks',
          items: _topTracks
              .map((track) => SizedBox(
                    width: 150, // Set a fixed width for each item
                    child: _buildTrackItem(track),
                  ))
              .toList(),
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommonItemsPage<CommonTrack>(
                  title: 'Top Tracks',
                  fetchItems: (page) => _apiService.getTopTracks(page: page),
                  itemBuilder: (context, track) => TrackListItem(track: track),
                ),
              ),
            );
          },
        ),
        HorizontalList(
          title: 'Top Artists',
          items: _topArtists
              .map((artist) => SizedBox(
                    width: 150, // Set a fixed width for each item
                    child: _buildArtistItem(artist),
                  ))
              .toList(),
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommonItemsPage<CommonArtist>(
                  title: 'Top Artists',
                  fetchItems: (page) => _apiService.getTopArtists(page: page),
                  itemBuilder: (context, artist) => ArtistListItem(
                    artist: artist,
                    onTap: () {
                      // Handle artist tap
                      print('Tapped on artist: ${artist.name}');
                      // You can navigate to a detail page or perform any other action
                    },
                  ),
                ),
              ),
            );
          },
        ),
        HorizontalList(
          title: 'Recently Played',
          items: _playedTracks
              .map((track) => SizedBox(
                    width: 150, // Set a fixed width for each item
                    child: _buildTrackItem(track),
                  ))
              .toList(),
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommonItemsPage<CommonTrack>(
                  title: 'Recently Played',
                  fetchItems: (page) => _apiService.getPlayedTracks(page: page),
                  itemBuilder: (context, track) => TrackListItem(track: track),
                ),
              ),
            );
          },
        ),
        const SizedBox(
            height: 16), // Add some space before the Top Genres section
        if (_topGenres.isNotEmpty)
          HorizontalList(
            title: 'Top Genres',
            items: _topGenres
                .map((genre) => SizedBox(
                      width: 150, // Set a fixed width for each item
                      child: _buildGenreItem(genre),
                    ))
                .toList(),
            onSeeAll: () {
              // Navigate to see all genres
            },
          ),
      ];
    } else if (_selectedService == ContentService.anime) {
      return [
        HorizontalList(
          title: 'Top Anime',
          items: _topAnime
              .map((anime) => SizedBox(
                    width: 150, // Set a fixed width for each item
                    child: _buildAnimeItem(anime),
                  ))
              .toList(),
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommonItemsPage<CommonAnime>(
                  title: 'Top Anime',
                  fetchItems: (page) => _apiService.getTopAnime(page: page),
                  itemBuilder: (context, anime) => AnimeListItem(anime: anime),
                ),
              ),
            );
          },
        ),
        HorizontalList(
          title: 'Top Manga',
          items: _topManga
              .map((manga) => SizedBox(
                    width: 150, // Set a fixed width for each item
                    child: _buildMangaItem(manga),
                  ))
              .toList(),
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommonItemsPage<CommonManga>(
                  title: 'Top Manga',
                  fetchItems: (page) => _apiService.getTopManga(page: page),
                  itemBuilder: (context, manga) => MangaListItem(manga: manga),
                ),
              ),
            );
          },
        ),
      ];
    } else {
      return [];
    }
  }

  Widget _buildTrackItem(CommonTrack track) {
    return TrackListItem(
      track: track,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrackDetailsPage(
              track: track,
              apiService: _apiService,
            ),
          ),
        );
      },
    );
  }

  Widget _buildArtistItem(CommonArtist artist) {
    return ArtistListItem(
      artist: artist,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArtistDetailsPage(
              artistId: artist.id ?? '', // Use id instead of uid
              artistName: artist.name ?? 'Unknown Artist',
              apiService: _apiService,
            ),
          ),
        );
      },
    );
  }

  Widget _buildGenreItem(CommonGenre genre) {
    return GenreListItem(
      genre: genre,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GenreDetailsPage(
              genreId: genre.name, // Use name as the ID for genres
              genreName: genre.name,
              apiService: _apiService,
            ),
          ),
        );
      },
    );
  }

  Widget _buildAlbumItem(CommonAlbum album) {
    return AlbumListItem(
      album: album,
      onTap: () {
        // Handle album tap
      },
    );
  }

  Widget _buildAnimeItem(CommonAnime anime) {
    return Card(
      child: Column(
        children: [
          Image.network(
            anime.imageUrl,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              anime.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMangaItem(CommonManga manga) {
    return Card(
      child: Column(
        children: [
          Image.network(
            manga.imageUrl,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              manga.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(
      {required String? imageUrl, required String title, String? subtitle}) {
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

  Widget _buildCommonItemsSection(BuildContext context) {
    return Column(
      children: [
        _buildSectionTitle('Played Tracks Buds'),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommonItemsPage<BudMatch>(
                  title: 'Played Tracks Buds',
                  fetchItems: (page) =>
                      ApiService().getPlayedTracksBuds(page: page),
                  itemBuilder: (context, budMatch) =>
                      BudMatchListItem(budMatch: budMatch),
                ),
              ),
            );
          },
          child: const Text('View All'),
        ),
        _buildSectionTitle('Liked Genres Buds'),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommonItemsPage<BudMatch>(
                  title: 'Liked Genres Buds',
                  fetchItems: (page) =>
                      ApiService().getLikedGenresBuds(page: page),
                  itemBuilder: (context, budMatch) =>
                      BudMatchListItem(budMatch: budMatch),
                ),
              ),
            );
          },
          child: const Text('View All'),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
