import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/simple_content_bloc.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SimpleContentBloc, SimpleContentState>(
      builder: (context, state) {
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
                _buildDiscoverHeader(),
                const SizedBox(height: 24),
                if (state is SimpleContentLoaded) ...[
                  _buildTrendingSection(state.topTracks),
                  const SizedBox(height: 24),
                  _buildNewArtistsSection(state.topArtists),
                  const SizedBox(height: 24),
                  _buildRecommendationsSection(state.topTracks),
                ] else if (state is SimpleContentLoading) ...[
                  const Center(child: CircularProgressIndicator()),
                ] else if (state is SimpleContentError) ...[
                  _buildErrorState(state.message),
                ] else ...[
                  _buildEmptyState(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiscoverHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.withValues(alpha: 0.8),
            Colors.blue.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.explore, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            'Discover',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Find new music and trending tracks',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingSection(List<Map<String, dynamic>> tracks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('🔥 Trending Now', Icons.trending_up),
        const SizedBox(height: 12),
        ...tracks.take(5).map((track) => _buildTrendingTile(track)),
      ],
    );
  }

  Widget _buildNewArtistsSection(List<Map<String, dynamic>> artists) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('✨ New Artists', Icons.new_releases),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: artists.length,
            itemBuilder: (context, index) {
              final artist = artists[index];
              return _buildArtistCard(artist);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendationsSection(List<Map<String, dynamic>> tracks) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('🎯 Recommended for You', Icons.recommend),
        const SizedBox(height: 12),
        ...tracks.skip(5).take(5).map((track) => _buildRecommendationTile(track)),
      ],
    );
  }

  Widget _buildTrendingTile(Map<String, dynamic> track) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          child: const Icon(Icons.trending_up, color: Colors.white),
        ),
        title: Text(
          track['name'] ?? 'Unknown Track',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(track['artist'] ?? 'Unknown Artist'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.play_circle_fill, color: Colors.green),
            const SizedBox(width: 8),
            Text('${track['playCount'] ?? 0}'),
          ],
        ),
        onTap: () => _showSnackBar('Playing trending ${track['name']}'),
      ),
    );
  }

  Widget _buildArtistCard(Map<String, dynamic> artist) {
    return Card(
      margin: const EdgeInsets.only(right: 12),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.purple.withValues(alpha: 0.8),
              child: const Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              artist['name'] ?? 'Unknown',
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationTile(Map<String, dynamic> track) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withValues(alpha: 0.8),
          child: const Icon(Icons.recommend, color: Colors.white),
        ),
        title: Text(
          track['name'] ?? 'Unknown Track',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(track['artist'] ?? 'Unknown Artist'),
        trailing: IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () => _showSnackBar('Added ${track['name']} to library'),
        ),
        onTap: () => _showSnackBar('Playing ${track['name']}'),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Failed to load discover content'),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<SimpleContentBloc>().add(RefreshContent()),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.explore, size: 64),
          SizedBox(height: 16),
          Text('Pull to refresh and discover new music!'),
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