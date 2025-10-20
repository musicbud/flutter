import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/simple_content_bloc.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SimpleContentBloc, SimpleContentState>(
      builder: (context, state) {
        return Column(
          children: [
            _buildLibraryHeader(),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.playlist_play), text: 'Playlists'),
                Tab(icon: Icon(Icons.favorite), text: 'Liked'),
                Tab(icon: Icon(Icons.download), text: 'Downloads'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildPlaylistsTab(state),
                  _buildLikedTab(state),
                  _buildDownloadsTab(state),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLibraryHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green.withValues(alpha: 0.8),
            Colors.teal.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.library_music, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Library',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Your music collection',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylistsTab(SimpleContentState state) {
    if (state is SimpleContentLoaded && state.playlists.isNotEmpty) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<SimpleContentBloc>().add(LoadPlaylists());
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: state.playlists.length + 1, // +1 for create new button
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildCreatePlaylistTile();
            }
            final playlist = state.playlists[index - 1];
            return _buildPlaylistTile(playlist);
          },
        ),
      );
    }
    return _buildEmptyLibraryState('No playlists yet', Icons.playlist_add);
  }

  Widget _buildLikedTab(SimpleContentState state) {
    if (state is SimpleContentLoaded && state.topTracks.isNotEmpty) {
      final likedTracks = state.topTracks.where((track) => 
        track['isLiked'] == true || DateTime.now().millisecond % 3 == 0
      ).toList();
      
      return RefreshIndicator(
        onRefresh: () async {
          context.read<SimpleContentBloc>().add(LoadTopTracks());
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: likedTracks.length,
          itemBuilder: (context, index) {
            final track = likedTracks[index];
            return _buildLikedTrackTile(track);
          },
        ),
      );
    }
    return _buildEmptyLibraryState('No liked tracks yet', Icons.favorite_border);
  }

  Widget _buildDownloadsTab(SimpleContentState state) {
    // Simulate some downloads from tracks
    if (state is SimpleContentLoaded && state.topTracks.isNotEmpty) {
      final downloads = state.topTracks.take(7).map((track) {
        return {
          ...track,
          'downloadStatus': ['completed', 'downloading', 'paused'][DateTime.now().millisecond % 3],
          'progress': DateTime.now().millisecond % 100,
          'fileSize': '${3 + (DateTime.now().millisecond % 8)}MB',
        };
      }).toList();

      return RefreshIndicator(
        onRefresh: () async {
          context.read<SimpleContentBloc>().add(LoadTopTracks());
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: downloads.length,
          itemBuilder: (context, index) {
            final download = downloads[index];
            return _buildDownloadTile(download);
          },
        ),
      );
    }
    return _buildEmptyLibraryState('No downloads yet', Icons.download);
  }

  Widget _buildCreatePlaylistTile() {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
        title: const Text(
          'Create New Playlist',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: const Text('Make your own music collection'),
        onTap: () => _showCreatePlaylistDialog(),
      ),
    );
  }

  Widget _buildPlaylistTile(Map<String, dynamic> playlist) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.withValues(alpha: 0.8),
          child: const Icon(Icons.playlist_play, color: Colors.white),
        ),
        title: Text(
          playlist['name'] ?? 'Unknown Playlist',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text('${playlist['trackCount'] ?? 0} tracks'),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => _handlePlaylistAction(value, playlist),
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'play', child: Text('Play')),
            const PopupMenuItem(value: 'edit', child: Text('Edit')),
            const PopupMenuItem(value: 'share', child: Text('Share')),
            const PopupMenuItem(value: 'delete', child: Text('Delete')),
          ],
        ),
        onTap: () => _showSnackBar('Opening ${playlist['name']}'),
      ),
    );
  }

  Widget _buildLikedTrackTile(Map<String, dynamic> track) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          child: const Icon(Icons.favorite, color: Colors.white),
        ),
        title: Text(
          track['name'] ?? 'Unknown Track',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(track['artist'] ?? 'Unknown Artist'),
        trailing: IconButton(
          icon: const Icon(Icons.favorite, color: Colors.red),
          onPressed: () => _showSnackBar('Removed from liked songs'),
        ),
        onTap: () => _showSnackBar('Playing ${track['name']}'),
      ),
    );
  }

  Widget _buildDownloadTile(Map<String, dynamic> download) {
    final status = download['downloadStatus'] as String;
    final progress = download['progress'] as int;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getDownloadColor(status),
          child: Icon(_getDownloadIcon(status), color: Colors.white),
        ),
        title: Text(
          download['name'] ?? 'Unknown Track',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(download['artist'] ?? 'Unknown Artist'),
            if (status == 'downloading') ...[
              const SizedBox(height: 4),
              LinearProgressIndicator(value: progress / 100),
              Text('$progress% - ${download['fileSize']}'),
            ] else ...[
              Text('${download['fileSize']} - $status'),
            ],
          ],
        ),
        trailing: IconButton(
          icon: Icon(_getDownloadActionIcon(status)),
          onPressed: () => _handleDownloadAction(status, download),
        ),
        onTap: status == 'completed' 
            ? () => _showSnackBar('Playing offline ${download['name']}')
            : null,
      ),
    );
  }

  Widget _buildEmptyLibraryState(String message, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 8),
          const Text('Pull to refresh'),
        ],
      ),
    );
  }

  Color _getDownloadColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'downloading':
        return Colors.blue;
      case 'paused':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getDownloadIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.download_done;
      case 'downloading':
        return Icons.downloading;
      case 'paused':
        return Icons.pause_circle;
      default:
        return Icons.download;
    }
  }

  IconData _getDownloadActionIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.play_circle;
      case 'downloading':
        return Icons.pause;
      case 'paused':
        return Icons.play_arrow;
      default:
        return Icons.download;
    }
  }

  void _handlePlaylistAction(String action, Map<String, dynamic> playlist) {
    switch (action) {
      case 'play':
        _showSnackBar('Playing ${playlist['name']}');
        break;
      case 'edit':
        _showSnackBar('Editing ${playlist['name']}');
        break;
      case 'share':
        _showSnackBar('Sharing ${playlist['name']}');
        break;
      case 'delete':
        _showSnackBar('Deleted ${playlist['name']}');
        break;
    }
  }

  void _handleDownloadAction(String status, Map<String, dynamic> download) {
    switch (status) {
      case 'completed':
        _showSnackBar('Playing ${download['name']}');
        break;
      case 'downloading':
        _showSnackBar('Paused ${download['name']}');
        break;
      case 'paused':
        _showSnackBar('Resumed ${download['name']}');
        break;
    }
  }

  void _showCreatePlaylistDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Playlist'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Playlist Name',
            hintText: 'Enter playlist name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Created playlist: ${controller.text}');
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}