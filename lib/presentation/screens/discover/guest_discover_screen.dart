import 'package:flutter/material.dart';
import '../../../core/theme/design_system.dart';
import '../../../services/guest_service.dart';

/// Guest-friendly discover screen with demo data
class GuestDiscoverScreen extends StatefulWidget {
  const GuestDiscoverScreen({super.key});

  @override
  State<GuestDiscoverScreen> createState() => _GuestDiscoverScreenState();
}

class _GuestDiscoverScreenState extends State<GuestDiscoverScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentTabIndex = 0;
  final GuestService _guestService = GuestService();
  
  bool _isLoading = true;
  String? _errorMessage;
  
  List<Map<String, dynamic>> _artists = [];
  List<Map<String, dynamic>> _tracks = [];
  List<Map<String, dynamic>> _genres = [];

  final List<Map<String, dynamic>> _mockArtists = [
    {
      'name': 'Taylor Swift',
      'image': null,
      'genre': 'Pop',
      'popularity': 95,
    },
    {
      'name': 'The Weeknd', 
      'image': null,
      'genre': 'R&B',
      'popularity': 89,
    },
    {
      'name': 'Billie Eilish',
      'image': null,
      'genre': 'Alternative',
      'popularity': 87,
    },
    {
      'name': 'Drake',
      'image': null,
      'genre': 'Hip Hop',
      'popularity': 92,
    },
  ];

  final List<Map<String, dynamic>> _mockTracks = [
    {
      'name': 'Anti-Hero',
      'artist': 'Taylor Swift',
      'album': 'Midnights',
      'duration': '3:20',
    },
    {
      'name': 'Blinding Lights',
      'artist': 'The Weeknd', 
      'album': 'After Hours',
      'duration': '3:22',
    },
    {
      'name': 'What Was I Made For?',
      'artist': 'Billie Eilish',
      'album': 'Barbie Soundtrack',
      'duration': '3:42',
    },
    {
      'name': 'God\'s Plan',
      'artist': 'Drake',
      'album': 'Scorpion',
      'duration': '3:19',
    },
  ];

  final List<Map<String, dynamic>> _mockGenres = [
    {'name': 'Pop', 'color': Colors.pink},
    {'name': 'Hip Hop', 'color': Colors.orange},
    {'name': 'Rock', 'color': Colors.red},
    {'name': 'Electronic', 'color': Colors.blue},
    {'name': 'Jazz', 'color': Colors.purple},
    {'name': 'Classical', 'color': Colors.green},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadGuestData();
  }
  
  Future<void> _loadGuestData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Fetch data in parallel
      final results = await Future.wait([
        _guestService.getTrendingArtists(),
        _guestService.getTrendingTracks(),
        _guestService.getGenres(),
      ]);
      
      setState(() {
        _artists = results[0] as List<Map<String, dynamic>>;
        _tracks = results[1] as List<Map<String, dynamic>>;
        final genresData = results[2] as Map<String, List<Map<String, dynamic>>>;
        _genres = genresData['music'] ?? [];
        _isLoading = false;
        
        // Fallback to mock data if API returns empty
        if (_artists.isEmpty) {
          _artists = _mockArtists;
        }
        if (_tracks.isEmpty) {
          _tracks = _mockTracks;
        }
        if (_genres.isEmpty) {
          _genres = _mockGenres.map((g) => {
            'name': g['name'],
            'id': g['name'].toString().toLowerCase().replaceAll(' ', '_'),
            'color': '#${g['color'].value.toRadixString(16).substring(2)}',
          }).toList();
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: $e';
        _isLoading = false;
        // Use mock data as fallback
        _artists = _mockArtists;
        _tracks = _mockTracks;
        _genres = _mockGenres.map((g) => {
          'name': g['name'],
          'id': g['name'].toString().toLowerCase().replaceAll(' ', '_'),
          'color': '#${g['color'].value.toRadixString(16).substring(2)}',
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover'),
        backgroundColor: DesignSystem.surface,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Artists'),
            Tab(text: 'Tracks'),
            Tab(text: 'Genres'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showGuestInfo,
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildArtistsTab(),
          _buildTracksTab(), 
          _buildGenresTab(),
        ],
      ),
    );
  }

  Widget _buildArtistsTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadGuestData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadGuestData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _artists.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildSectionHeader('Trending Artists');
          }
          final artist = _artists[index - 1];
          return _buildArtistCard(artist);
        },
      ),
    );
  }

  Widget _buildTracksTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadGuestData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadGuestData,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tracks.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildSectionHeader('Popular Tracks');
          }
          final track = _tracks[index - 1];
          return _buildTrackCard(track);
        },
      ),
    );
  }

  Widget _buildGenresTab() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadGuestData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadGuestData,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Browse by Genre'),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: _genres.length,
                itemBuilder: (context, index) {
                  final genre = _genres[index];
                  return _buildGenreCardFromApi(genre);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: DesignSystem.headlineSmall.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildArtistCard(Map<String, dynamic> artist) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: DesignSystem.primary.withValues(alpha: 0.1),
          child: Text(
            artist['name'][0],
            style: const TextStyle(
              color: DesignSystem.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          artist['name'],
          style: DesignSystem.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${artist['genre']} • ${artist['popularity']}% popularity',
          style: DesignSystem.bodyMedium.copyWith(
            color: Colors.grey[600],
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () => _showSignInPrompt('save favorites'),
        ),
        onTap: () => _showSignInPrompt('view full artist details'),
      ),
    );
  }

  Widget _buildTrackCard(Map<String, dynamic> track) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: DesignSystem.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.music_note,
            color: DesignSystem.primary,
          ),
        ),
        title: Text(
          track['name'],
          style: DesignSystem.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          '${track['artist']} • ${track['duration']}',
          style: DesignSystem.bodyMedium.copyWith(
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () => _showSignInPrompt('play full tracks'),
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () => _showSignInPrompt('save favorites'),
            ),
          ],
        ),
        onTap: () => _showSignInPrompt('view full track details'),
      ),
    );
  }

  Widget _buildGenreCard(Map<String, dynamic> genre) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              genre['color'].withValues(alpha: 0.8),
              genre['color'].withValues(alpha: 0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => _showSignInPrompt('explore genres'),
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              genre['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildGenreCardFromApi(Map<String, dynamic> genre) {
    // Parse hex color from API
    Color genreColor = DesignSystem.primary;
    try {
      final colorString = genre['color'] as String?;
      if (colorString != null && colorString.startsWith('#')) {
        genreColor = Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
      }
    } catch (e) {
      // Use default color if parsing fails
    }
    
    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              genreColor.withValues(alpha: 0.8),
              genreColor.withValues(alpha: 0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () => _showSignInPrompt('explore genres'),
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Text(
              genre['name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showSignInPrompt(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign in Required'),
        content: Text('Sign in to $feature and access all MusicBud features!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Maybe Later'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignSystem.primary,
            ),
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }

  void _showGuestInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Guest Mode'),
        content: const Text(
          'You\'re browsing as a guest! Sign in to unlock full features like saving favorites, creating playlists, and connecting with music buds.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue as Guest'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignSystem.primary,
            ),
            child: const Text('Sign In'),
          ),
        ],
      ),
    );
  }
}