import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/spotify_control/spotify_control_bloc.dart';
import '../../blocs/spotify_control/spotify_control_event.dart';
import '../../blocs/spotify_control/spotify_control_state.dart';
import '../../domain/models/common_track.dart';
import '../widgets/loading_indicator.dart';
import 'played_tracks_map_page.dart';
import 'track_details_page.dart';

class SpotifyControlPage extends StatefulWidget {
  const SpotifyControlPage({Key? key}) : super(key: key);

  @override
  _SpotifyControlPageState createState() => _SpotifyControlPageState();
}

class _SpotifyControlPageState extends State<SpotifyControlPage> {
  List<CommonTrack> _playedTracks = [];
  List<Map<String, dynamic>> _spotifyDevices = [];
  String? _selectedDeviceId;
  int _volume = 50;

  @override
  void initState() {
    super.initState();
    _fetchPlayedTracks();
    _fetchSpotifyDevices();
  }

  Future<({double latitude, double longitude})> _getCurrentLocation() async {
    // TODO: Implement actual location service
    // For now, return mock location
    return (
      latitude: 0.0,
      longitude: 0.0,
    );
  }

  Future<void> _sendLocation() async {
    try {
      final position = await _getCurrentLocation();
      context.read<SpotifyControlBloc>().add(SpotifyTrackLocationSaved(
            trackId: '', // No track ID since we're just saving location
            latitude: position.latitude,
            longitude: position.longitude,
          ));
      if (!mounted) return;
      _showSnackBar('Location sent successfully');
    } catch (e) {
      print('Error sending location: $e');
      if (!mounted) return;
      _showSnackBar('Failed to send location');
    }
  }

  void _fetchPlayedTracks() {
    context.read<SpotifyControlBloc>().add(SpotifyPlayedTracksRequested());
  }

  void _fetchSpotifyDevices() {
    context.read<SpotifyControlBloc>().add(SpotifyDevicesRequested());
  }

  void _selectDevice(String deviceId) {
    context.read<SpotifyControlBloc>().add(SpotifyDeviceSelected(deviceId));
  }

  void _playbackControl(String action) {
    context.read<SpotifyControlBloc>().add(SpotifyPlaybackControlRequested(
          action: action,
          deviceId: _selectedDeviceId,
        ));
  }

  void _onVolumeChanged(int value) {
    setState(() {
      _volume = value;
    });
    context.read<SpotifyControlBloc>().add(SpotifyVolumeChanged(
          volume: value,
          deviceId: _selectedDeviceId,
        ));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpotifyControlBloc, SpotifyControlState>(
      listener: (context, state) {
        if (state is SpotifyControlFailure) {
          _showSnackBar('Error: ${state.error}');
        } else if (state is SpotifyTrackLocationSavedState) {
          _showSnackBar('Location saved successfully');
        }
      },
      builder: (context, state) {
        if (state is SpotifyPlayedTracksLoaded) {
          _playedTracks = List<CommonTrack>.from(state.tracks);
        } else if (state is SpotifyDevicesLoaded) {
          _spotifyDevices = state.devices;
          _selectedDeviceId = state.selectedDeviceId;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Spotify Control'),
            actions: [
              IconButton(
                icon: const Icon(Icons.map),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PlayedTracksMapPage(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  _fetchPlayedTracks();
                  _fetchSpotifyDevices();
                },
              ),
            ],
          ),
          body: state is SpotifyControlLoading
              ? const Center(child: LoadingIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDeviceSelector(),
                      const SizedBox(height: 16),
                      _buildPlaybackControls(),
                      const SizedBox(height: 16),
                      _buildVolumeControl(),
                      const SizedBox(height: 24),
                      const Text(
                        'Recently Played Tracks',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildTrackList(),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildDeviceSelector() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Devices',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: _selectedDeviceId,
              isExpanded: true,
              hint: const Text('Select a device'),
              items: _spotifyDevices.map((device) {
                return DropdownMenuItem<String>(
                  value: device['id'] as String,
                  child: Text(device['name'] as String),
                );
              }).toList(),
              onChanged: (deviceId) {
                if (deviceId != null) {
                  _selectDevice(deviceId);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaybackControls() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed: () => _playbackControl('previous'),
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () => _playbackControl('play'),
            ),
            IconButton(
              icon: const Icon(Icons.pause),
              onPressed: () => _playbackControl('pause'),
            ),
            IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: () => _playbackControl('next'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeControl() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Volume',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Slider(
              value: _volume.toDouble(),
              min: 0,
              max: 100,
              divisions: 100,
              label: _volume.toString(),
              onChanged: (value) => _onVolumeChanged(value.round()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _playedTracks.length,
      itemBuilder: (context, index) {
        final track = _playedTracks[index];
        return Card(
          child: ListTile(
            leading: track.imageUrl != null
                ? Image.network(
                    track.imageUrl!,
                    width: 48,
                    height: 48,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.music_note),
            title: Text(track.title),
            subtitle: Text(track.artistName),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrackDetailsPage(track: track),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
