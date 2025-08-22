import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/track/track_bloc.dart';
import '../../../blocs/track/track_event.dart';
import '../../../blocs/track/track_state.dart';
import '../../../blocs/spotify_control/spotify_control_bloc.dart';
import '../../../blocs/spotify_control/spotify_control_event.dart';
import '../../../blocs/spotify_control/spotify_control_state.dart';
import '../../../blocs/likes/likes_bloc.dart';
import '../../../blocs/likes/likes_event.dart';
import '../../../blocs/likes/likes_state.dart';
import '../../../domain/models/track.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_album.dart';
import '../../../domain/models/common_track.dart';
import '../../widgets/loading_indicator.dart';
import '../../constants/app_constants.dart';
import '../../mixins/page_mixin.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({Key? key}) : super(key: key);

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> with PageMixin {
  int _selectedCategoryIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  final List<String> _categories = [
    'All',
    'Tracks',
    'Artists',
    'Albums',
    'Playlists',
    'Genres',
    'Recently Played',
    'Liked Songs',
  ];

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    // Load initial music data
    context.read<TrackBloc>().add(const TrackBudsRequested('recent'));
    // Note: Using a placeholder event since SpotifyControlLoadUserProfile doesn't exist
    context.read<SpotifyControlBloc>().add(SpotifyDevicesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TrackBloc, TrackState>(
          listener: _handleTrackStateChange,
        ),
        BlocListener<SpotifyControlBloc, SpotifyControlState>(
          listener: _handleSpotifyControlStateChange,
        ),
        BlocListener<LikesBloc, LikesState>(
          listener: _handleLikesStateChange,
        ),
      ],
      child: Scaffold(
        backgroundColor: AppConstants.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildCategoryTabs(),
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Music',
                style: AppConstants.headingStyle,
              ),
              const SizedBox(height: 4),
              Text(
                'Discover and enjoy your music',
                style: AppConstants.captionStyle,
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                onPressed: _showNowPlaying,
                icon: const Icon(
                  Icons.play_circle_filled,
                  color: AppConstants.primaryColor,
                  size: 32,
                ),
              ),
              IconButton(
                onPressed: _showMusicSettings,
                icon: const Icon(
                  Icons.settings,
                  color: AppConstants.textColor,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Search for songs, artists, albums...',
          hintStyle: TextStyle(color: AppConstants.textSecondaryColor),
          prefixIcon: const Icon(Icons.search, color: AppConstants.textSecondaryColor),
          suffixIcon: _isSearching
              ? const Icon(Icons.clear, color: AppConstants.textSecondaryColor)
              : null,
          filled: true,
          fillColor: AppConstants.surfaceColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        style: const TextStyle(color: AppConstants.textColor),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == _selectedCategoryIndex;
          return GestureDetector(
            onTap: () => _onCategorySelected(index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppConstants.primaryColor : AppConstants.surfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppConstants.primaryColor : AppConstants.borderColor,
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  _categories[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppConstants.textColor,
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent() {
    return BlocBuilder<TrackBloc, TrackState>(
      builder: (context, trackState) {
        if (trackState is TrackLoading) {
          return const Center(child: LoadingIndicator());
        }

        if (trackState is TrackFailure) {
          return _buildErrorWidget(trackState.error);
        }

        return _buildMusicContent();
      },
    );
  }

  Widget _buildMusicContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNowPlayingSection(),
          const SizedBox(height: 24),
          _buildQuickActions(),
          const SizedBox(height: 24),
          _buildRecentlyPlayed(),
          const SizedBox(height: 24),
          _buildTopTracks(),
          const SizedBox(height: 24),
          _buildRecommendedArtists(),
          const SizedBox(height: 24),
          _buildNewReleases(),
          const SizedBox(height: 24),
          _buildPlaylists(),
        ],
      ),
    );
  }

  Widget _buildNowPlayingSection() {
    return BlocBuilder<SpotifyControlBloc, SpotifyControlState>(
      builder: (context, state) {
        // Note: Using a placeholder since SpotifyControlUserProfileLoaded doesn't exist
        if (state is SpotifyDevicesLoaded) {
          return _buildNowPlayingCard({
            'name': 'Sample Track',
            'artist': 'Sample Artist',
            'album_cover': 'assets/music_cover.jpg',
          });
        }
        return _buildNoTrackPlaying();
      },
    );
  }

  Widget _buildNowPlayingCard(Map<String, dynamic> track) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primaryColor.withOpacity(0.8),
            AppConstants.primaryColor.withOpacity(0.4),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: AssetImage(track['album_cover'] ?? 'assets/music_cover.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track['name'] ?? 'Unknown Track',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  track['artist'] ?? 'Unknown Artist',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    IconButton(
                      onPressed: _togglePlayPause,
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    IconButton(
                      onPressed: _skipToPrevious,
                      icon: const Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    IconButton(
                      onPressed: _skipToNext,
                      icon: const Icon(
                        Icons.skip_next,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoTrackPlaying() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppConstants.borderColor),
      ),
      child: Row(
        children: [
          Icon(
            Icons.music_note,
            color: AppConstants.primaryColor,
            size: 32,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No track playing',
                  style: AppConstants.subheadingStyle,
                ),
                const SizedBox(height: 4),
                Text(
                  'Start playing music to see what\'s currently playing',
                  style: AppConstants.captionStyle,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _browseMusic,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Browse'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppConstants.subheadingStyle,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Create Playlist',
                Icons.playlist_add,
                AppConstants.primaryColor,
                _createPlaylist,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionCard(
                'Discover',
                Icons.explore,
                Colors.blue,
                _discoverMusic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Radio',
                Icons.radio,
                Colors.green,
                _startRadio,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildQuickActionCard(
                'Library',
                Icons.library_music,
                Colors.orange,
                _openLibrary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppConstants.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentlyPlayed() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recently Played',
              style: AppConstants.subheadingStyle,
            ),
            TextButton(
              onPressed: _viewAllRecentlyPlayed,
              child: Text(
                'View All',
                style: TextStyle(color: AppConstants.primaryColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return _buildTrackCard(
                'Track ${index + 1}',
                'Artist ${index + 1}',
                'assets/music_cover.jpg',
                () => _playTrack('track_$index'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTopTracks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Top Tracks',
              style: AppConstants.subheadingStyle,
            ),
            TextButton(
              onPressed: _viewAllTopTracks,
              child: Text(
                'View All',
                style: TextStyle(color: AppConstants.primaryColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildTrackList(),
      ],
    );
  }

  Widget _buildTrackList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildTrackListItem(
          'Top Track ${index + 1}',
          'Top Artist ${index + 1}',
          '3:${(index + 1) * 10}',
          () => _playTrack('top_track_$index'),
        );
      },
    );
  }

  Widget _buildTrackListItem(String title, String artist, String duration, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: AppConstants.surfaceColor,
        ),
        child: Icon(
          Icons.music_note,
          color: AppConstants.primaryColor,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: AppConstants.textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        artist,
        style: AppConstants.captionStyle,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            duration,
            style: AppConstants.captionStyle,
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _toggleLike('track_$title'),
            icon: Icon(
              Icons.favorite_border,
              color: AppConstants.primaryColor,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedArtists() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recommended Artists',
          style: AppConstants.subheadingStyle,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 8,
            itemBuilder: (context, index) {
              return _buildArtistCard(
                'Artist ${index + 1}',
                'assets/music_cover.jpg',
                () => _viewArtist('artist_$index'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildArtistCard(String name, String imageUrl, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage(imageUrl),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: const TextStyle(
                color: AppConstants.textColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewReleases() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Releases',
          style: AppConstants.subheadingStyle,
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
            itemBuilder: (context, index) {
              return _buildAlbumCard(
                'Album ${index + 1}',
                'Artist ${index + 1}',
                'assets/music_cover.jpg',
                () => _viewAlbum('album_$index'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAlbumCard(String title, String artist, String imageUrl, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppConstants.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              artist,
              style: AppConstants.captionStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylists() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Playlists',
              style: AppConstants.subheadingStyle,
            ),
            TextButton(
              onPressed: _createNewPlaylist,
              child: Text(
                'Create New',
                style: TextStyle(color: AppConstants.primaryColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemCount: 4,
          itemBuilder: (context, index) {
            return _buildPlaylistCard(
              'Playlist ${index + 1}',
              '${(index + 1) * 5} songs',
              'assets/music_cover.jpg',
              () => _viewPlaylist('playlist_$index'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPlaylistCard(String title, String songCount, String imageUrl, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppConstants.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppConstants.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        songCount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                style: const TextStyle(
                  color: AppConstants.textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackCard(String title, String artist, String imageUrl, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: AppConstants.textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              artist,
              style: AppConstants.captionStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: AppConstants.errorColor,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading music',
            style: AppConstants.subheadingStyle,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: AppConstants.captionStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _retryLoading,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // Event handlers
  void _onSearchChanged(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
    });

    if (query.isNotEmpty) {
      // Implement search functionality
      context.read<TrackBloc>().add(TrackBudsRequested(query));
    }
  }

  void _onCategorySelected(int index) {
    setState(() {
      _selectedCategoryIndex = index;
    });

    // Load data based on category
    switch (_categories[index].toLowerCase()) {
      case 'tracks':
        context.read<TrackBloc>().add(const TrackBudsRequested('tracks'));
        break;
      case 'artists':
        context.read<TrackBloc>().add(const TrackBudsRequested('artists'));
        break;
      case 'albums':
        context.read<TrackBloc>().add(const TrackBudsRequested('albums'));
        break;
      case 'playlists':
        context.read<TrackBloc>().add(const TrackBudsRequested('playlists'));
        break;
      case 'genres':
        context.read<TrackBloc>().add(const TrackBudsRequested('genres'));
        break;
      case 'recently played':
        context.read<TrackBloc>().add(const TrackBudsRequested('recent'));
        break;
      case 'liked songs':
        context.read<TrackBloc>().add(const TrackBudsRequested('liked'));
        break;
      default:
        context.read<TrackBloc>().add(const TrackBudsRequested('all'));
    }
  }

  // Action methods
  void _showNowPlaying() {
    // Show now playing modal or navigate to now playing page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Now playing details coming soon!')),
    );
  }

  void _showMusicSettings() {
    // Show music settings
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Music settings coming soon!')),
    );
  }

  void _togglePlayPause() {
    // Toggle play/pause
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Play/pause functionality coming soon!')),
    );
  }

  void _skipToPrevious() {
    // Skip to previous track
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Skip to previous coming soon!')),
    );
  }

  void _skipToNext() {
    // Skip to next track
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Skip to next coming soon!')),
    );
  }

  void _browseMusic() {
    // Browse music
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Music browser coming soon!')),
    );
  }

  void _createPlaylist() {
    // Create playlist
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Playlist creation coming soon!')),
    );
  }

  void _discoverMusic() {
    // Discover music
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Music discovery coming soon!')),
    );
  }

  void _startRadio() {
    // Start radio
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Radio functionality coming soon!')),
    );
  }

  void _openLibrary() {
    // Open library
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Music library coming soon!')),
    );
  }

  void _viewAllRecentlyPlayed() {
    // View all recently played
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Recently played expanded view coming soon!')),
    );
  }

  void _playTrack(String trackId) {
    // Play track
    context.read<TrackBloc>().add(TrackPlayRequested(trackId: trackId));
  }

  void _toggleLike(String trackId) {
    // Toggle like
    context.read<TrackBloc>().add(TrackLikeToggled(trackId));
  }

  void _viewAllTopTracks() {
    // View all top tracks
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Top tracks expanded view coming soon!')),
    );
  }

  void _viewArtist(String artistId) {
    // View artist
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Artist view coming soon!')),
    );
  }

  void _viewAlbum(String albumId) {
    // View album
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Album view coming soon!')),
    );
  }

  void _createNewPlaylist() {
    // Create new playlist
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Playlist creation coming soon!')),
    );
  }

  void _viewPlaylist(String playlistId) {
    // View playlist
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Playlist view coming soon!')),
    );
  }

  void _retryLoading() {
    // Retry loading
    _loadInitialData();
  }

  // Bloc state handlers
  void _handleTrackStateChange(BuildContext context, TrackState state) {
    if (state is TrackFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Track error: ${state.error}')),
      );
    }
  }

  void _handleSpotifyControlStateChange(BuildContext context, SpotifyControlState state) {
    if (state is SpotifyControlFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Spotify error: ${state.error}')),
      );
    }
  }

  void _handleLikesStateChange(BuildContext context, LikesState state) {
    if (state is LikesUpdateSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    } else if (state is LikesUpdateFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${state.error}')),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Placeholder variables for demo
  bool _isPlaying = false;
}