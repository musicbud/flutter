import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/top_artists/top_artists_bloc.dart';
import '../../../blocs/top_tracks/top_tracks_bloc.dart';
import '../../../blocs/genre/top_genres_bloc.dart';
import '../../../blocs/spotify_control/spotify_control_bloc.dart';
import '../../../blocs/spotify_control/spotify_control_event.dart';
import '../../../blocs/spotify_control/spotify_control_state.dart';
import '../../../blocs/likes/likes_bloc.dart';
import '../../../blocs/likes/likes_event.dart';
import '../../../blocs/likes/likes_state.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_track.dart';
import '../../../domain/models/common_genre.dart';
import '../../../domain/models/spotify_device.dart';
import '../../constants/app_constants.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/app_app_bar.dart';
import '../../widgets/common/app_button.dart';

class MusicPage extends StatefulWidget {
  const MusicPage({Key? key}) : super(key: key);

  @override
  State<MusicPage> createState() => _MusicPageState();
}

class _MusicPageState extends State<MusicPage> with TickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;
  SpotifyDevice? _selectedDevice;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _currentIndex = _tabController.index;
      });
    });
    _loadMusicData();
    context.read<SpotifyControlBloc>().add(SpotifyDevicesRequested());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadMusicData() {
    // Load top artists, tracks, and genres
    context.read<TopArtistsBloc>().add(const TopArtistsRequested());
    context.read<TopTracksBloc>().add(const TopTracksRequested(artistId: 'default'));
    context.read<TopGenresBloc>().add(const TopGenresRequested());

    // Load Spotify devices
    context.read<SpotifyControlBloc>().add(const SpotifyDevicesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LikesBloc, LikesState>(
      listener: (context, state) {
        if (state is LikesUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is LikesUpdateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }
      },
      child: BlocListener<SpotifyControlBloc, SpotifyControlState>(
        listener: (context, state) {
          if (state is SpotifyPlaybackStateChanged) {
            setState(() {
              _isPlaying = state.isPlaying;
            });
          } else if (state is SpotifyDevicesLoaded && _selectedDevice == null) {
            // Auto-select first active device
            final activeDevice = state.devices.firstWhere(
              (device) => device.isActive,
              orElse: () => state.devices.first,
            );
            if (activeDevice != null) {
              setState(() {
                _selectedDevice = activeDevice;
              });
            }
          } else if (state is SpotifyControlFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: AppScaffold(
          appBar: AppAppBar(
            title: 'Music',
            actions: [
              IconButton(
                icon: const Icon(Icons.playlist_play),
                onPressed: () => _showPlaylistDialog(),
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () => _showMusicSettings(),
              ),
            ],
          ),
          body: Column(
            children: [
              _buildMusicControls(),
              _buildTabBar(),
              Expanded(
                child: _buildTabView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMusicControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                Icons.skip_previous,
                'Previous',
                () => _previousTrack(),
              ),
              _buildControlButton(
                Icons.play_circle_filled,
                'Play/Pause',
                () => _togglePlayPause(),
                isPrimary: true,
              ),
              _buildControlButton(
                Icons.skip_next,
                'Next',
                () => _nextTrack(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildNowPlaying(),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, String label, VoidCallback onTap, {bool isPrimary = false}) {
    return Column(
      children: [
        IconButton(
          onPressed: onTap,
          icon: Icon(
            icon,
            size: isPrimary ? 48 : 32,
            color: isPrimary ? AppConstants.primaryColor : AppConstants.textColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppConstants.textColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildNowPlaying() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppConstants.primaryColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.music_note,
              color: Colors.white70,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No track playing',
                  style: TextStyle(
                    color: AppConstants.textColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Select a track to start listening',
                  style: TextStyle(
                    color: AppConstants.textSecondaryColor,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showQueue(),
            icon: const Icon(
              Icons.queue_music,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: AppConstants.borderColor.withOpacity(0.3)),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppConstants.primaryColor,
          borderRadius: BorderRadius.circular(25),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: AppConstants.textSecondaryColor,
        tabs: const [
          Tab(text: 'Top Artists'),
          Tab(text: 'Top Tracks'),
          Tab(text: 'Genres'),
          Tab(text: 'Devices'),
        ],
      ),
    );
  }

  Widget _buildTabView() {
    return TabBarView(
      controller: _tabController,
      children: [
        _buildTopArtistsTab(),
        _buildTopTracksTab(),
        _buildGenresTab(),
        _buildDevicesTab(),
      ],
    );
  }

  Widget _buildTopArtistsTab() {
    return BlocBuilder<TopArtistsBloc, TopArtistsState>(
      builder: (context, state) {
        if (state is TopArtistsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TopArtistsLoaded) {
          return _buildArtistsList(state.artists);
        }

        if (state is TopArtistsFailure) {
          return _buildErrorWidget(state.error);
        }

        return const Center(child: Text('No artists found'));
      },
    );
  }

  Widget _buildTopTracksTab() {
    return BlocBuilder<TopTracksBloc, TopTracksState>(
      builder: (context, state) {
        if (state is TopTracksLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TopTracksLoaded) {
          return _buildTracksList(state.tracks);
        }

        if (state is TopTracksFailure) {
          return _buildErrorWidget(state.error);
        }

        return const Center(child: Text('No tracks found'));
      },
    );
  }

  Widget _buildGenresTab() {
    return BlocBuilder<TopGenresBloc, TopGenresState>(
      builder: (context, state) {
        if (state is TopGenresLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is TopGenresLoaded) {
          return _buildGenresList(state.genres);
        }

        if (state is TopGenresFailure) {
          return _buildErrorWidget(state.error);
        }

        return const Center(child: Text('No genres found'));
      },
    );
  }

  Widget _buildDevicesTab() {
    return BlocBuilder<SpotifyControlBloc, SpotifyControlState>(
      builder: (context, state) {
        if (state is SpotifyDevicesLoaded) {
          return _buildDevicesList(state.devices);
        }

        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.devices, size: 64, color: Colors.white54),
              SizedBox(height: 16),
              Text(
                'No devices found',
                style: TextStyle(color: Colors.white54),
              ),
              Text(
                'Connect to Spotify to see available devices',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArtistsList(List<CommonArtist> artists) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        final artist = artists[index];
        return _buildArtistCard(artist);
      },
    );
  }

  Widget _buildArtistCard(CommonArtist artist) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppConstants.surfaceColor,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppConstants.primaryColor.withOpacity(0.3),
          child: Text(
            artist.name.isNotEmpty ? artist.name[0].toUpperCase() : 'A',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          artist.name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          '${artist.followers ?? 0} followers',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _likeArtist(artist.id),
              icon: Icon(
                artist.isLiked ? Icons.favorite : Icons.favorite_border,
                color: artist.isLiked ? Colors.red : Colors.white70,
              ),
            ),
            IconButton(
              onPressed: () => _playArtist(artist.id),
              icon: const Icon(
                Icons.play_circle_outline,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        onTap: () => _showArtistDetails(artist),
      ),
    );
  }

  Widget _buildTracksList(List<CommonTrack> tracks) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        return _buildTrackCard(track);
      },
    );
  }

  Widget _buildTrackCard(CommonTrack track) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppConstants.surfaceColor,
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.music_note,
            color: Colors.white70,
          ),
        ),
        title: Text(
          track.name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          track.artistName ?? 'Unknown Artist',
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => _likeTrack(track.id),
              icon: Icon(
                track.isLiked ? Icons.favorite : Icons.favorite_border,
                color: track.isLiked ? Colors.red : Colors.white70,
              ),
            ),
            IconButton(
              onPressed: () => _playTrack(track.id),
              icon: const Icon(
                Icons.play_circle_outline,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        onTap: () => _showTrackDetails(track),
      ),
    );
  }

  Widget _buildGenresList(List<CommonGenre> genres) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: genres.length,
      itemBuilder: (context, index) {
        final genre = genres[index];
        return _buildGenreCard(genre);
      },
    );
  }

  Widget _buildGenreCard(CommonGenre genre) {
    return Card(
      color: AppConstants.surfaceColor,
      child: InkWell(
        onTap: () => _showGenreDetails(genre),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppConstants.primaryColor.withOpacity(0.3),
                AppConstants.primaryColor.withOpacity(0.1),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.category,
                size: 48,
                color: AppConstants.primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                genre.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Various tracks',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDevicesList(List<SpotifyDevice> devices) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: devices.length,
      itemBuilder: (context, index) {
        final device = devices[index];
        return _buildDeviceCard(device);
      },
    );
  }

  Widget _buildDeviceCard(SpotifyDevice device) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppConstants.surfaceColor,
      child: ListTile(
        leading: Icon(
          _getDeviceIcon(device.type),
          color: AppConstants.primaryColor,
          size: 32,
        ),
        title: Text(
          device.name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          device.type,
          style: const TextStyle(color: Colors.white70),
        ),
        trailing: Switch(
          value: device.isActive,
          onChanged: (value) => _toggleDevice(device.id, value),
          activeColor: AppConstants.primaryColor,
        ),
        onTap: () => _selectDevice(device.id),
      ),
    );
  }

  IconData _getDeviceIcon(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'computer':
        return Icons.computer;
      case 'smartphone':
        return Icons.phone_android;
      case 'tablet':
        return Icons.tablet_android;
      case 'tv':
        return Icons.tv;
      case 'speaker':
        return Icons.speaker;
      default:
        return Icons.devices;
    }
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading data',
            style: TextStyle(
              color: AppConstants.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(
              color: AppConstants.textSecondaryColor,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          AppButton(
            text: 'Retry',
            onPressed: _loadMusicData,
          ),
        ],
      ),
    );
  }

  // Action methods
  void _previousTrack() {
    if (_selectedDevice != null) {
      context.read<SpotifyControlBloc>().add(
        SpotifyPlaybackControlRequested(
          command: 'previous',
          deviceId: _selectedDevice!.id,
        ),
      );
    } else {
      _showDeviceSelectionDialog();
    }
  }

  void _togglePlayPause() {
    if (_selectedDevice != null) {
      final command = _isPlaying ? 'pause' : 'play';
      context.read<SpotifyControlBloc>().add(
        SpotifyPlaybackControlRequested(
          command: command,
          deviceId: _selectedDevice!.id,
        ),
      );
    } else {
      _showDeviceSelectionDialog();
    }
  }

  void _nextTrack() {
    if (_selectedDevice != null) {
      context.read<SpotifyControlBloc>().add(
        SpotifyPlaybackControlRequested(
          command: 'next',
          deviceId: _selectedDevice!.id,
        ),
      );
    } else {
      _showDeviceSelectionDialog();
    }
  }

  void _showPlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Playlists'),
        content: const Text('Playlist functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showMusicSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Music Settings'),
        content: const Text('Music settings functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showQueue() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Queue'),
        content: const Text('Queue functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _likeArtist(String artistId) {
    context.read<LikesBloc>().add(ArtistLikeRequested(artistId: artistId));
  }

  void _playArtist(String artistId) {
    if (_selectedDevice != null) {
      // TODO: Implement artist play logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Playing artist: $artistId')),
      );
    } else {
      _showDeviceSelectionDialog();
    }
  }

  void _showArtistDetails(CommonArtist artist) {
    // TODO: Navigate to artist details page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Artist details for: ${artist.name}')),
    );
  }

  void _likeTrack(String trackId) {
    context.read<LikesBloc>().add(TrackLikeRequested(trackId: trackId));
  }

  void _playTrack(String trackId) {
    if (_selectedDevice != null) {
      context.read<SpotifyControlBloc>().add(
        SpotifyPlayTrackRequested(
          trackId: trackId,
          deviceId: _selectedDevice!.id,
        ),
      );

      // Save the played track
      context.read<SpotifyControlBloc>().add(
        SpotifySavePlayedTrackRequested(trackId: trackId),
      );
    } else {
      _showDeviceSelectionDialog();
    }
  }

  void _showTrackDetails(CommonTrack track) {
    // TODO: Navigate to track details page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Track details for: ${track.name}')),
    );
  }

  void _showGenreDetails(CommonGenre genre) {
    // TODO: Navigate to genre details page
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Genre details for: ${genre.name}')),
    );
  }

  void _toggleDevice(String deviceId, bool isActive) {
    // TODO: Implement device toggle logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Toggled device: $deviceId to $isActive')),
    );
  }

  void _selectDevice(String deviceId) {
    final devices = context.read<SpotifyControlBloc>().state;
    if (devices is SpotifyDevicesLoaded) {
      final device = devices.devices.firstWhere((d) => d.id == deviceId);
      setState(() {
        _selectedDevice = device;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selected device: ${device.name}')),
      );
    }
  }

  void _showDeviceSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Device'),
        content: const Text('Please select a device to control playback.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}