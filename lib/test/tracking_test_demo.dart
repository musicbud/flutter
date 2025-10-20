import 'package:flutter/material.dart';
import '../models/track.dart';
import '../data/data_sources/local/tracking_local_data_source.dart';
import '../injection_container.dart' as di;

/// Demo screen to test tracking functionality
class TrackingTestDemo extends StatefulWidget {
  const TrackingTestDemo({super.key});

  @override
  State<TrackingTestDemo> createState() => _TrackingTestDemoState();
}

class _TrackingTestDemoState extends State<TrackingTestDemo> {
  final TrackingLocalDataSource _trackingDataSource = di.sl<TrackingLocalDataSource>();
  List<Track> _recentTracks = [];
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _loadRecentTracks();
  }

  Future<void> _loadRecentTracks() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Loading recent tracks...';
    });

    try {
      final tracks = await _trackingDataSource.getPlayedTracks();
      setState(() {
        _recentTracks = tracks;
        _statusMessage = 'Loaded ${tracks.length} tracks';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error loading tracks: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveTestTrack() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Saving test track...';
    });

    try {
      // Create a test track
      final testTrack = Track(
        uid: 'test_${DateTime.now().millisecondsSinceEpoch}',
        title: 'Test Track ${DateTime.now().millisecondsSinceEpoch % 1000}',
        artistName: 'Test Artist',
        albumName: 'Test Album',
        imageUrl: 'https://via.placeholder.com/300x300.png?text=Test',
        latitude: 37.7749, // San Francisco coordinates
        longitude: -122.4194,
        playedAt: DateTime.now(),
        isLiked: false,
      );

      await _trackingDataSource.savePlayedTrack(testTrack);
      setState(() {
        _statusMessage = 'Test track saved successfully!';
      });

      // Reload tracks to show the new one
      await _loadRecentTracks();
    } catch (e) {
      setState(() {
        _statusMessage = 'Error saving track: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveTrackLocation() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Saving track location...';
    });

    try {
      // Save location for the first track if available
      if (_recentTracks.isNotEmpty) {
        await _trackingDataSource.saveTrackLocation(
          _recentTracks.first.id ?? '',
          37.7749, // San Francisco
          -122.4194,
        );
        setState(() {
          _statusMessage = 'Location saved for first track!';
        });
        
        // Reload to show updated location
        await _loadRecentTracks();
      } else {
        setState(() {
          _statusMessage = 'No tracks available to save location for';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'Error saving location: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _clearAllTracks() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Clearing all tracks...';
    });

    try {
      await _trackingDataSource.clearPlayedTracks();
      setState(() {
        _recentTracks = [];
        _statusMessage = 'All tracks cleared successfully!';
      });
    } catch (e) {
      setState(() {
        _statusMessage = 'Error clearing tracks: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking Test Demo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    if (_isLoading)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      Icon(
                        Icons.info,
                        color: Colors.blue.shade700,
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _statusMessage.isEmpty ? 'Ready to test tracking' : _statusMessage,
                        style: TextStyle(
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            const Text(
              'Test Actions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveTestTrack,
                  icon: const Icon(Icons.add),
                  label: const Text('Save Test Track'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _saveTrackLocation,
                  icon: const Icon(Icons.location_on),
                  label: const Text('Add Location'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _loadRecentTracks,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Refresh'),
                ),
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _clearAllTracks,
                  icon: const Icon(Icons.clear_all),
                  label: const Text('Clear All'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                    foregroundColor: Colors.red.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Tracks List
            Text(
              'Recent Tracks (${_recentTracks.length}):',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _recentTracks.isEmpty
                  ? const Center(
                      child: Text(
                        'No tracks yet.\nTap "Save Test Track" to create one.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _recentTracks.length,
                      itemBuilder: (context, index) {
                        final track = _recentTracks[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.music_note, color: Colors.grey),
                            ),
                            title: Text(
                              track.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (track.artistName != null)
                                  Text('Artist: ${track.artistName}'),
                                if (track.playedAt != null)
                                  Text(
                                    'Played: ${_formatDateTime(track.playedAt!)}',
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                if (track.latitude != null && track.longitude != null)
                                  Text(
                                    'Location: ${track.latitude!.toStringAsFixed(4)}, ${track.longitude!.toStringAsFixed(4)}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: track.isLiked
                                ? const Icon(Icons.favorite, color: Colors.red)
                                : null,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

/// Simple button to launch the tracking test from anywhere in the app
class LaunchTrackingTestButton extends StatelessWidget {
  const LaunchTrackingTestButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrackingTestDemo()),
        );
      },
      icon: const Icon(Icons.bug_report),
      label: const Text('Test Tracking'),
      backgroundColor: Colors.deepPurple,
    );
  }
}