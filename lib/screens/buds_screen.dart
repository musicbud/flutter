import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/simple_content_bloc.dart';

class BudsScreen extends StatefulWidget {
  const BudsScreen({super.key});

  @override
  State<BudsScreen> createState() => _BudsScreenState();
}

class _BudsScreenState extends State<BudsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SimpleContentBloc, SimpleContentState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<SimpleContentBloc>().add(LoadBuds());
            await Future.delayed(const Duration(seconds: 1));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBudsHeader(),
                const SizedBox(height: 24),
                if (state is SimpleContentLoaded && state.buds.isNotEmpty) ...[
                  _buildBudsGrid(state.buds),
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

  Widget _buildBudsHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.pink.withOpacity(0.8),
            Colors.orange.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.people, color: Colors.white, size: 32),
          const SizedBox(height: 8),
          Text(
            'Music Buds',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Connect with people who share your music taste',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBudsGrid(List<Map<String, dynamic>> buds) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: buds.length,
      itemBuilder: (context, index) {
        final bud = buds[index];
        return _buildBudCard(bud);
      },
    );
  }

  Widget _buildBudCard(Map<String, dynamic> bud) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 35,
              backgroundColor: _getRandomColor(),
              child: const Icon(Icons.person, color: Colors.white, size: 35),
            ),
            const SizedBox(height: 12),
            Text(
              bud['displayName'] ?? 'Unknown',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${bud['matchPercentage'] ?? 0}% match',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (bud['distance'] != null)
              Text(
                '${bud['distance']} km away',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () => _connectWithBud(bud),
                  icon: const Icon(Icons.person_add, color: Colors.blue),
                  iconSize: 20,
                ),
                IconButton(
                  onPressed: () => _chatWithBud(bud),
                  icon: const Icon(Icons.chat_bubble, color: Colors.green),
                  iconSize: 20,
                ),
                IconButton(
                  onPressed: () => _viewBudProfile(bud),
                  icon: const Icon(Icons.info, color: Colors.orange),
                  iconSize: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getRandomColor() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
      Colors.indigo,
      Colors.pink,
    ];
    return colors[DateTime.now().microsecond % colors.length].withOpacity(0.8);
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Failed to load music buds'),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => context.read<SimpleContentBloc>().add(LoadBuds()),
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
          Icon(Icons.people_outline, size: 64),
          SizedBox(height: 16),
          Text('No music buds found'),
          SizedBox(height: 8),
          Text('Pull to refresh and discover music buddies!'),
        ],
      ),
    );
  }

  void _connectWithBud(Map<String, dynamic> bud) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Connect with ${bud['displayName']}?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Music match: ${bud['matchPercentage']}%'),
            if (bud['commonArtists'] != null) ...[
              const SizedBox(height: 8),
              Text('Common artists: ${(bud['commonArtists'] as List).join(', ')}'),
            ],
            if (bud['bio'] != null) ...[
              const SizedBox(height: 8),
              Text('Bio: ${bud['bio']}'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showSnackBar('Connection request sent to ${bud['displayName']}');
            },
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  void _chatWithBud(Map<String, dynamic> bud) {
    _showSnackBar('Starting chat with ${bud['displayName']}');
  }

  void _viewBudProfile(Map<String, dynamic> bud) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${bud['displayName']}\'s Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${bud['username'] ?? 'Unknown'}'),
            Text('Match: ${bud['matchPercentage']}%'),
            if (bud['distance'] != null)
              Text('Distance: ${bud['distance']} km'),
            if (bud['mutualFriends'] != null)
              Text('Mutual friends: ${bud['mutualFriends']}'),
            if (bud['bio'] != null) ...[
              const SizedBox(height: 8),
              Text('Bio: ${bud['bio']}'),
            ],
            if (bud['commonArtists'] != null) ...[
              const SizedBox(height: 8),
              const Text('Common artists:'),
              ...((bud['commonArtists'] as List).map((artist) => 
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text('• $artist'),
                ),
              )),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _connectWithBud(bud);
            },
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}