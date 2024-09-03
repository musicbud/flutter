import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/pages/buds_page.dart';
import 'package:musicbud_flutter/models/user_profile.dart';
import 'package:musicbud_flutter/models/content_service.dart';
import 'package:musicbud_flutter/models/common_track.dart';
import 'package:musicbud_flutter/models/common_artist.dart';
import 'package:musicbud_flutter/models/common_genre.dart';
import 'package:musicbud_flutter/models/common_album.dart';
import 'package:musicbud_flutter/models/common_anime.dart';
import 'package:musicbud_flutter/models/common_manga.dart';
import 'package:musicbud_flutter/widgets/horizontal_list.dart';
import 'package:musicbud_flutter/models/bud_match.dart';
import 'package:musicbud_flutter/pages/common_items_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:musicbud_flutter/pages/login_page.dart'; // Add this import
import 'package:musicbud_flutter/widgets/track_list_item.dart';
import 'package:musicbud_flutter/widgets/artist_list_item.dart';
import 'package:musicbud_flutter/widgets/genre_list_item.dart';
import 'package:musicbud_flutter/widgets/album_list_item.dart';
import 'package:musicbud_flutter/widgets/anime_list_item.dart';
import 'package:musicbud_flutter/widgets/manga_list_item.dart';

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
  List<CommonTrack> _playedTracks = [];

  // Anime-related lists
  // List<CommonAnime> _topAnime = [];
  // List<CommonManga> _topManga = [];

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
      await _loadPlayedTracks();
      // await _loadTopAnime();
      // await _loadTopManga();
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
      final topTracks = await _apiService.getTopTracks();
      setState(() {
        _topTracks = topTracks;
      });
    } catch (e) {
      print('Error loading top tracks: $e');
      // Show a user-friendly error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to load top tracks. Please try again later.')),
      );
    }
  }

  Future<void> _loadTopArtists() async {
    try {
      final topArtists = await _apiService.getTopArtists();
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
      setState(() {
        _topGenres = genres;
      });
    } catch (e) {
      print('Error loading top genres: $e');
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

  // Future<void> _loadTopAnime() async {
  //   try {
  //     final topAnime = await _apiService.getTopAnime();
  //     setState(() {
  //       _topAnime = topAnime;
  //     });
  //   } catch (e) {
  //     print('Error loading top anime: $e');
  //     setState(() {
  //       _topAnime = []; // Set to an empty list in case of an error
  //     });
  //   }
  // }

  // Future<void> _loadTopManga() async {
  //   try {
  //     final topManga = await _apiService.getTopManga();
  //     setState(() {
  //       _topManga = topManga;
  //     });
  //   } catch (e) {
  //     print('Error loading top manga: $e');
  //     setState(() {
  //       _topManga = []; // Set to an empty list in case of an error
  //     });
  //   }
  // }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      try {
        // Implement the API call to upload the image
        final String? newPhotoUrl = await _apiService.uploadProfilePhoto(image.path);
        
        if (newPhotoUrl != null) {
          setState(() {
            _userProfile?.photoUrl = newPhotoUrl;
          });
        }
      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image. Please try again.')),
        );
      }
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

    return ListView(
      children: [
        _buildUserProfileSection(),
        SizedBox(height: 20),
        _buildServiceDropdown(),
        SizedBox(height: 20),
        ..._buildContentLists(),
      ],
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
            GestureDetector(
              onTap: _pickAndUploadImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _userProfile?.photoUrl != null
                  ? NetworkImage(_userProfile!.photoUrl!)
                  : null,
                child: _userProfile?.photoUrl == null
                  ? Icon(Icons.add_a_photo, size: 40)
                  : null,
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
        HorizontalList(
          title: 'Top Tracks',
          items: _topTracks.map((track) => SizedBox(
            width: 150, // Set a fixed width for each item
            child: _buildTrackItem(track),
          )).toList(),
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommonItemsPage<CommonTrack>(
                  title: 'Top Tracks',
                  fetchItems: (page) => _apiService.getTopTracks(page: page),
                  buildListItem: (track) => TrackListItem(track: track),
                ),
              ),
            );
          },
        ),
        HorizontalList(
          title: 'Top Artists',
          items: _topArtists.map((artist) => SizedBox(
            width: 150, // Set a fixed width for each item
            child: _buildArtistItem(artist),
          )).toList(),
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommonItemsPage<CommonArtist>(
                  title: 'Top Artists',
                  fetchItems: (page) => _apiService.getTopArtists(page: page),
                  buildListItem: (artist) => ArtistListItem(artist: artist),
                ),
              ),
            );
          },
        ),
        HorizontalList(
          title: 'Recently Played',
          items: _playedTracks.map((track) => SizedBox(
            width: 150, // Set a fixed width for each item
            child: _buildTrackItem(track),
          )).toList(),
          onSeeAll: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CommonItemsPage<CommonTrack>(
                  title: 'Recently Played',
                  fetchItems: (page) => _apiService.getPlayedTracks(page: page),
                  buildListItem: (track) => TrackListItem(track: track),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 16), // Add some space before the Top Genres section
        if (_topGenres.isNotEmpty)
          HorizontalList(
            title: 'Top Genres',
            items: _topGenres.map((genre) => SizedBox(
              width: 150, // Set a fixed width for each item
              child: _buildGenreItem(genre),
            )).toList(),
            onSeeAll: () {
              // Navigate to see all genres
            },
          ),
      ];
    } else if (_selectedService == ContentService.anime) {
      return [
        // HorizontalList(
        //   title: 'Top Anime',
        //   items: _topAnime.map((anime) => SizedBox(
        //     width: 150, // Set a fixed width for each item
        //     child: _buildAnimeItem(anime),
        //   )).toList(),
        //   onSeeAll: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => CommonItemsPage<CommonAnime>(
        //           title: 'Top Anime',
        //           fetchItems: (page) => _apiService.getTopAnime(page: page),
        //           buildListItem: (anime) => AnimeListItem(anime: anime),
        //         ),
        //       ),
        //     );
        //   },
        // ),
        // HorizontalList(
        //   title: 'Top Manga',
        //   items: _topManga.map((manga) => SizedBox(
        //     width: 150, // Set a fixed width for each item
        //     child: _buildMangaItem(manga),
        //   )).toList(),
        //   onSeeAll: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //         builder: (context) => CommonItemsPage<CommonManga>(
        //           title: 'Top Manga',
        //           fetchItems: (page) => _apiService.getTopManga(page: page),
        //           buildListItem: (manga) => MangaListItem(manga: manga),
        //         ),
        //       ),
        //     );
        //   },
        // ),
      ];
    } else {
      return [];
    }
  }

  Widget _buildTrackItem(CommonTrack track) {
    return TrackListItem(
      track: track,
      onTap: () {
        // Handle track tap
      },
    );
  }

  Widget _buildArtistItem(CommonArtist artist) {
    return ArtistListItem(
      artist: artist,
      onTap: () {
        // Handle artist tap
      },
    );
  }

  Widget _buildGenreItem(CommonGenre genre) {
    return GenreListItem(
      genre: genre,
      onTap: () {
        // Handle genre tap
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

  // Widget _buildAnimeItem(CommonAnime anime) {
  //   return AnimeListItem(
  //     anime: anime,
  //     onTap: () {
  //       // Handle anime tap
  //     },
  //   );
  // }

  // Widget _buildMangaItem(CommonManga manga) {
  //   return MangaListItem(
  //     manga: manga,
  //     onTap: () {
  //       // Handle manga tap
  //     },
  //   );
  // }

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



