import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/track.dart';
import '../../../blocs/content/content_bloc.dart';
import '../../../blocs/content/content_event.dart';
import '../../../blocs/content/content_state.dart';
import '../../widgets/tracking/tracking_enhanced_music_card.dart';

/// Example screen demonstrating the tracking functionality
class TrackingExampleScreen extends StatelessWidget {
  const TrackingExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Generate some example tracks for demonstration
    final exampleTracks = _generateExampleTracks();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking Integration Example'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              context.read<ContentBloc>().add(LoadPlayedTracksWithLocation());
            },
            tooltip: 'Load Recent Tracks',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with instructions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue.shade700, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Tracking Demo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '• Tap any music card to track your interaction\n'
                  '• Cards will save play history with timestamps\n'
                  '• Like/unlike functionality is tracked\n'
                  '• Location data is automatically saved\n'
                  '• Pull down to refresh and see tracking status',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),

          // Music Cards Section
          Expanded(
            child: BlocListener<ContentBloc, ContentState>(
              listener: (context, state) {
                // Show feedback when tracks are saved
                if (state is ContentTrackSaved) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Track saved: ${state.trackId}'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else if (state is ContentError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: BlocBuilder<ContentBloc, ContentState>(
                builder: (context, state) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ContentBloc>().add(LoadPlayedTracksWithLocation());
                    },
                    child: CustomScrollView(
                      slivers: [
                        // Example Tracks Section
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                            child: Row(
                              children: [
                                const Icon(Icons.library_music, size: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  'Example Tracks',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  '${exampleTracks.length} tracks',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final track = exampleTracks[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: TrackingEnhancedMusicCard(
                                  track: track,
                                  showPlayButton: true,
                                  onPlay: () {
                                    _simulateLocation(context, track);
                                  },
                                ),
                              );
                            },
                            childCount: exampleTracks.length,
                          ),
                        ),

                        // Recently Played Section (if available)
                        if (state is ContentPlayedTracksWithLocationLoaded) ...[
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                              child: Row(
                                children: [
                                  const Icon(Icons.history, size: 20),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Recently Played (with Location)',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${state.tracks.length} tracks',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final track = state.tracks[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: TrackingCompactMusicCard(track: track),
                                );
                              },
                              childCount: state.tracks.length,
                            ),
                          ),
                        ],

                        // Loading indicator
                        if (state is ContentLoading)
                          const SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(),
                                  SizedBox(height: 16),
                                  Text('Loading tracking data...'),
                                ],
                              ),
                            ),
                          ),

                        // Empty state
                        if (state is ContentPlayedTracksWithLocationLoaded &&
                            state.tracks.isEmpty)
                          SliverFillRemaining(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.music_note_outlined,
                                    size: 64,
                                    color: Colors.grey.shade400,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'No tracked music yet',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Play some tracks above to start tracking!',
                                    style: TextStyle(
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Spacing at bottom
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Generate example tracks for demonstration
  List<Track> _generateExampleTracks() {
    return [
      Track(
        uid: 'example_1',
        title: 'Blinding Lights',
        artistName: 'The Weeknd',
        albumName: 'After Hours',
        imageUrl: 'https://via.placeholder.com/300x300.png?text=Blinding+Lights',
        isLiked: false,
      ),
      Track(
        uid: 'example_2',
        title: 'Watermelon Sugar',
        artistName: 'Harry Styles',
        albumName: 'Fine Line',
        imageUrl: 'https://via.placeholder.com/300x300.png?text=Watermelon+Sugar',
        isLiked: true,
      ),
      Track(
        uid: 'example_3',
        title: 'Levitating',
        artistName: 'Dua Lipa',
        albumName: 'Future Nostalgia',
        imageUrl: 'https://via.placeholder.com/300x300.png?text=Levitating',
        isLiked: false,
      ),
      Track(
        uid: 'example_4',
        title: 'Good 4 U',
        artistName: 'Olivia Rodrigo',
        albumName: 'SOUR',
        imageUrl: 'https://via.placeholder.com/300x300.png?text=Good+4+U',
        isLiked: true,
      ),
      Track(
        uid: 'example_5',
        title: 'Stay',
        artistName: 'The Kid LAROI, Justin Bieber',
        albumName: 'Stay',
        imageUrl: 'https://via.placeholder.com/300x300.png?text=Stay',
        isLiked: false,
      ),
    ];
  }

  /// Simulate saving location data for a track when played
  void _simulateLocation(BuildContext context, Track track) {
    // Simulate different locations
    final locations = [
      {'lat': 37.7749, 'lng': -122.4194}, // San Francisco
      {'lat': 40.7128, 'lng': -74.0060},  // New York
      {'lat': 34.0522, 'lng': -118.2437}, // Los Angeles
      {'lat': 41.8781, 'lng': -87.6298},  // Chicago
      {'lat': 29.7604, 'lng': -95.3698},  // Houston
    ];
    
    final location = locations[track.id.hashCode % locations.length];
    
    // Save track with location
    context.read<ContentBloc>().add(SaveTrackLocation(
      trackId: track.id ?? '',
      latitude: location['lat']!,
      longitude: location['lng']!,
    ));
    
    // Also save as played
    context.read<ContentBloc>().add(SavePlayedTrack(trackId: track.id ?? ''));
  }
}

/// Floating action button to launch tracking example from anywhere
class LaunchTrackingExampleButton extends StatelessWidget {
  const LaunchTrackingExampleButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrackingExampleScreen()),
        );
      },
      icon: const Icon(Icons.track_changes),
      label: const Text('Tracking Demo'),
      backgroundColor: Colors.deepPurple,
      foregroundColor: Colors.white,
    );
  }
}