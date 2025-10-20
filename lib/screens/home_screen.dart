import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/simple_content_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SimpleContentBloc, SimpleContentState>(
      builder: (context, state) {
        if (state is SimpleContentLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is SimpleContentError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Oops! Something went wrong',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    context.read<SimpleContentBloc>().add(RefreshContent());
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                ),
              ],
            ),
          );
        }
        if (state is SimpleContentLoaded) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<SimpleContentBloc>().add(RefreshContent());
              await Future.delayed(const Duration(seconds: 1));
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildWelcomeSection(),
                  const SizedBox(height: 24),
                  if (state.topArtists.isNotEmpty) 
                    ..._buildArtistsSection(state.topArtists),
                  if (state.topTracks.isNotEmpty) 
                    ..._buildTracksSection(state.topTracks),
                  if (state.buds.isNotEmpty) 
                    ..._buildBudsSection(state.buds),
                  if (state.chats.isNotEmpty) 
                    ..._buildChatsSection(state.chats),
                  if (state.playlists.isNotEmpty) 
                    ..._buildPlaylistsSection(state.playlists),
                ],
              ),
            ),
          );
        }
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.music_note,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome to MusicBud!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text('Pull down to refresh and load your content'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
            Theme.of(context).colorScheme.secondary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good ${_getTimeOfDayGreeting()}!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ready to discover new music and connect with fellow music lovers?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeOfDayGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  List<Widget> _buildArtistsSection(List<Map<String, dynamic>> artists) {
    return [
      _buildSectionHeader('Top Artists', Icons.person, () {
        // Navigate to full artists view
        _showSnackBar('Navigate to Artists');
      }),
      const SizedBox(height: 12),
      SizedBox(
        height: 140,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: artists.length,
          itemBuilder: (context, index) {
            final artist = artists[index];
            return _buildArtistCard(artist);
          },
        ),
      ),
      const SizedBox(height: 24),
    ];
  }

  Widget _buildArtistCard(Map<String, dynamic> artist) {
    return Card(
      margin: const EdgeInsets.only(right: 12),
      elevation: 4,
      child: Container(
        width: 110,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: const Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              artist['name'] ?? 'Unknown',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${artist['playCount'] ?? 0} plays',
              style: TextStyle(
                fontSize: 10,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTracksSection(List<Map<String, dynamic>> tracks) {
    return [
      _buildSectionHeader('Top Tracks', Icons.music_note, () {
        _showSnackBar('Navigate to Tracks');
      }),
      const SizedBox(height: 12),
      ...tracks.take(5).map((track) => _buildTrackTile(track)).toList(),
      const SizedBox(height: 24),
    ];
  }

  Widget _buildTrackTile(Map<String, dynamic> track) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.music_note, color: Colors.white),
        ),
        title: Text(
          track['name'] ?? 'Unknown Track',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(track['artist'] ?? 'Unknown Artist'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('${track['playCount'] ?? 0}'),
            const Text('plays', style: TextStyle(fontSize: 12)),
          ],
        ),
        onTap: () => _showSnackBar('Playing ${track['name']}'),
      ),
    );
  }

  List<Widget> _buildBudsSection(List<Map<String, dynamic>> buds) {
    return [
      _buildSectionHeader('Music Buds', Icons.people, () {
        _showSnackBar('Navigate to Buds');
      }),
      const SizedBox(height: 12),
      SizedBox(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: buds.take(8).length,
          itemBuilder: (context, index) {
            final bud = buds[index];
            return _buildBudCard(bud);
          },
        ),
      ),
      const SizedBox(height: 24),
    ];
  }

  Widget _buildBudCard(Map<String, dynamic> bud) {
    return Card(
      margin: const EdgeInsets.only(right: 12),
      elevation: 4,
      child: Container(
        width: 130,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              child: const Icon(Icons.person, color: Colors.white, size: 30),
            ),
            const SizedBox(height: 8),
            Text(
              bud['displayName'] ?? 'Unknown',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${bud['matchPercentage'] ?? 0}% match',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildChatsSection(List<Map<String, dynamic>> chats) {
    return [
      _buildSectionHeader('Recent Chats', Icons.chat, () {
        _showSnackBar('Navigate to Chats');
      }),
      const SizedBox(height: 12),
      ...chats.take(3).map((chat) => _buildChatTile(chat)).toList(),
      const SizedBox(height: 24),
    ];
  }

  Widget _buildChatTile(Map<String, dynamic> chat) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          child: const Icon(Icons.chat, color: Colors.white),
        ),
        title: Text(
          chat['name'] ?? 'Unknown',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          chat['lastMessage'] ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: chat['unreadCount'] != null && chat['unreadCount'] > 0
            ? Badge(
                label: Text('${chat['unreadCount']}'),
                backgroundColor: Theme.of(context).colorScheme.primary,
              )
            : null,
        onTap: () => _showSnackBar('Opening chat with ${chat['name']}'),
      ),
    );
  }

  List<Widget> _buildPlaylistsSection(List<Map<String, dynamic>> playlists) {
    return [
      _buildSectionHeader('My Playlists', Icons.playlist_play, () {
        _showSnackBar('Navigate to Library');
      }),
      const SizedBox(height: 12),
      ...playlists.take(3).map((playlist) => _buildPlaylistTile(playlist)).toList(),
      const SizedBox(height: 24),
    ];
  }

  Widget _buildPlaylistTile(Map<String, dynamic> playlist) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          child: const Icon(Icons.playlist_play, color: Colors.white),
        ),
        title: Text(
          playlist['name'] ?? 'Unknown',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text('${playlist['trackCount'] ?? 0} tracks'),
        trailing: Icon(
          playlist['isPublic'] == true ? Icons.public : Icons.lock,
          color: Theme.of(context).colorScheme.outline,
        ),
        onTap: () => _showSnackBar('Opening ${playlist['name']}'),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, VoidCallback onTap) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: const Text('View All'),
        ),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}