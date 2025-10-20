import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';
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
    ),
    const MusicCardData(
      id: '2',
      artistName: 'The Weeknd',
      songTitle: 'Blinding Lights',
    ),
    const MusicCardData(
      id: '3',
      artistName: 'Olivia Rodrigo',
      songTitle: 'good 4 u',
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
      backgroundColor: MusicBudColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Search',
          style: MusicBudTypography.heading3.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(MusicBudSpacing.lg),
            child: _buildSearchBar(),
          ),
          
          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: MusicBudSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: MusicBudColors.backgroundTertiary,
              borderRadius: BorderRadius.circular(
                MusicBudSpacing.radiusLg,
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: MusicBudColors.primaryRed,
                borderRadius: BorderRadius.circular(
                  MusicBudSpacing.radiusLg,
                ),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelStyle: MusicBudTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: MusicBudTypography.bodyMedium,
              tabs: const [
                Tab(text: 'Songs'),
                Tab(text: 'Artists'),
                Tab(text: 'Genres'),
              ],
            ),
          ),
          
          const SizedBox(height: MusicBudSpacing.lg),
          
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
        color: MusicBudColors.backgroundTertiary,
        borderRadius: BorderRadius.circular(
          MusicBudSpacing.radiusLg,
        ),
      ),
      child: TextField(
        controller: _searchController,
        style: MusicBudTypography.bodyMedium,
        decoration: InputDecoration(
          hintText: 'Search for songs, artists, or genres...',
          hintStyle: MusicBudTypography.bodyMedium.copyWith(
            color: MusicBudColors.textSecondary,
          ),
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: MusicBudColors.textSecondary,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.clear_rounded,
                    color: MusicBudColors.textSecondary,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: MusicBudSpacing.lg,
            vertical: MusicBudSpacing.md,
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
        horizontal: MusicBudSpacing.lg,
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
        horizontal: MusicBudSpacing.lg,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
        crossAxisSpacing: MusicBudSpacing.md,
        mainAxisSpacing: MusicBudSpacing.md,
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
      margin: const EdgeInsets.only(bottom: MusicBudSpacing.sm),
      decoration: BoxDecoration(
        color: MusicBudColors.backgroundTertiary,
        borderRadius: BorderRadius.circular(
          MusicBudSpacing.radiusLg,
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: MusicBudColors.primaryRed.withValues(alpha: 0.1),
          child: const Icon(
            Icons.person_rounded,
            color: MusicBudColors.primaryRed,
          ),
        ),
        title: Text(
          artist,
          style: MusicBudTypography.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Artist',
          style: MusicBudTypography.bodySmall.copyWith(
            color: MusicBudColors.textSecondary,
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
            MusicBudColors.primaryRed.withValues(alpha: 0.2),
            MusicBudColors.primaryDark.withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(
          MusicBudSpacing.radiusLg,
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
            MusicBudSpacing.radiusLg,
          ),
          child: Center(
            child: Text(
              genre,
              style: MusicBudTypography.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: MusicBudColors.textPrimary,
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
            horizontal: MusicBudSpacing.lg,
          ),
          child: Text(
            title,
            style: MusicBudTypography.heading4.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: MusicBudSpacing.md),
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
            color: MusicBudColors.textSecondary,
          ),
          const SizedBox(height: MusicBudSpacing.lg),
          Text(
            message,
            style: MusicBudTypography.bodyLarge.copyWith(
              color: MusicBudColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}