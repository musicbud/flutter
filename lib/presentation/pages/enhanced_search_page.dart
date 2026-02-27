import 'package:flutter/material.dart';
import '../../core/theme/design_system.dart';
import '../components/music_card.dart';

class EnhancedSearchPage extends StatefulWidget {
  const EnhancedSearchPage({super.key});

  @override
  State<EnhancedSearchPage> createState() => _EnhancedSearchPageState();
}

class _EnhancedSearchPageState extends State<EnhancedSearchPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  bool _isSearching = false;

  // Mock data for demonstration
  final List<MusicCardData> _mockSongs = [
    const MusicCardData(
      id: '1',
      artistName: 'Taylor Swift',
      songTitle: 'Anti-Hero',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b2738a3a3d9a7b0a1a0b3a3a3d9a',
    ),
    const MusicCardData(
      id: '2',
      artistName: 'The Weeknd',
      songTitle: 'Blinding Lights',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273e3b3b3a3d9a7b0a1a0b3a3a3d9a',
    ),
    const MusicCardData(
      id: '3',
      artistName: 'Olivia Rodrigo',
      songTitle: 'good 4 u',
      imageUrl: 'https://i.scdn.co/image/ab67616d0000b273b3a3d9a7b0a1a0b3a3a3d9a7',
    ),
  ];

  final List<String> _mockArtists = [
    'Taylor Swift',
    'The Weeknd',
    'Olivia Rodrigo',
    'Dua Lipa',
    'Harry Styles',
  ];

  final List<String> _mockGenres = [
    'Pop',
    'Hip Hop',
    'Rock',
    'Electronic',
    'R&B',
    'Country',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DesignSystem.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Search',
          style: DesignSystem.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(DesignSystem.spacingMD),
            child: _buildSearchBar(),
          ),

          // Tab bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: DesignSystem.spacingMD,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: DesignSystem.surfaceContainer,
                borderRadius: BorderRadius.circular(
                  DesignSystem.radiusMD,
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: DesignSystem.primary,
                  borderRadius: BorderRadius.circular(
                    DesignSystem.radiusMD,
                  ),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle: DesignSystem.labelLarge.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: DesignSystem.labelLarge,
                tabs: const [
                  Tab(text: 'Songs'),
                  Tab(text: 'Artists'),
                  Tab(text: 'Genres'),
                ],
              ),
            ),
          ),

          const SizedBox(height: DesignSystem.spacingLG),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSongsTab(),
                _buildArtistsTab(),
                _buildGenresTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(
          DesignSystem.radiusMD,
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: DesignSystem.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search for songs, artists, or genres...',
          hintStyle: DesignSystem.bodyMedium.copyWith(
            color: DesignSystem.onSurfaceVariant,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: DesignSystem.onSurfaceVariant,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: DesignSystem.onSurfaceVariant,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingMD,
            vertical: DesignSystem.spacingSM,
          ),
        ),
        onChanged: (value) {
          setState(() {
            _isSearching = value.isNotEmpty;
          });
        },
      ),
    );
  }

  Widget _buildSongsTab() {
    if (_isSearching && _searchController.text.isNotEmpty) {
      // Filter songs based on search query
      final filteredSongs = _mockSongs.where((song) {
        final query = _searchController.text.toLowerCase();
        return song.songTitle.toLowerCase().contains(query) ||
               song.artistName.toLowerCase().contains(query);
      }).toList();

      if (filteredSongs.isEmpty) {
        return _buildEmptyState('No songs found');
      }

      return MusicCardList(
        songs: filteredSongs,
        onSongTap: (song) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Playing ${song.songTitle}')),
          );
        },
        onLikeToggle: (song, isLiked) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isLiked ? 'Liked ${song.songTitle}' : 'Unliked ${song.songTitle}'),
            ),
          );
        },
      );
    }

    return _buildPopularContent('Popular Songs', _mockSongs);
  }

  Widget _buildArtistsTab() {
    final filteredArtists = _isSearching
        ? _mockArtists.where((artist) =>
            artist.toLowerCase().contains(_searchController.text.toLowerCase())).toList()
        : _mockArtists;

    if (_isSearching && filteredArtists.isEmpty) {
      return _buildEmptyState('No artists found');
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingMD,
      ),
      itemCount: filteredArtists.length,
      itemBuilder: (context, index) {
        final artist = filteredArtists[index];
        return _buildArtistTile(artist);
      },
    );
  }

  Widget _buildGenresTab() {
    final filteredGenres = _isSearching
        ? _mockGenres.where((genre) =>
            genre.toLowerCase().contains(_searchController.text.toLowerCase())).toList()
        : _mockGenres;

    if (_isSearching && filteredGenres.isEmpty) {
      return _buildEmptyState('No genres found');
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.spacingMD,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: DesignSystem.spacingSM,
        mainAxisSpacing: DesignSystem.spacingSM,
      ),
      itemCount: filteredGenres.length,
      itemBuilder: (context, index) {
        final genre = filteredGenres[index];
        return _buildGenreCard(genre);
      },
    );
  }

  Widget _buildArtistTile(String artist) {
    return Container(
      margin: const EdgeInsets.only(bottom: DesignSystem.spacingSM),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer,
        borderRadius: BorderRadius.circular(
          DesignSystem.radiusMD,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: DesignSystem.primary.withValues(alpha: 0.1),
          child: const Icon(
            Icons.person_rounded,
            color: DesignSystem.primary,
          ),
        ),
        title: Text(
          artist,
          style: DesignSystem.titleSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Artist',
          style: DesignSystem.bodySmall.copyWith(
            color: DesignSystem.onSurfaceVariant,
          ),
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Viewing $artist')),
          );
        },
      ),
    );
  }

  Widget _buildGenreCard(String genre) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            DesignSystem.primary.withValues(alpha: 0.2),
            DesignSystem.primaryVariant.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(
          DesignSystem.radiusMD,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Exploring $genre music')),
            );
          },
          borderRadius: BorderRadius.circular(
            DesignSystem.radiusMD,
          ),
          child: Center(
            child: Text(
              genre,
              style: DesignSystem.titleMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: DesignSystem.onSurface,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopularContent(String title, List<MusicCardData> songs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacingMD,
          ),
          child: Text(
            title,
            style: DesignSystem.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: DesignSystem.spacingSM),
        Expanded(
          child: MusicCardList(
            songs: songs,
            onSongTap: (song) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Playing ${song.songTitle}')),
              );
            },
            onLikeToggle: (song, isLiked) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(isLiked ? 'Liked ${song.songTitle}' : 'Unliked ${song.songTitle}'),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 64,
            color: DesignSystem.onSurfaceVariant,
          ),
          const SizedBox(height: DesignSystem.spacingLG),
          Text(
            message,
            style: DesignSystem.bodyLarge.copyWith(
              color: DesignSystem.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
