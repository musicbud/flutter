import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:musicbud_flutter/blocs/spotify/spotify_bloc.dart';
import 'package:musicbud_flutter/data/models/common_track.dart';
import 'package:musicbud_flutter/injection_container.dart';
import 'package:musicbud_flutter/presentation/screens/spotify/played_tracks_map_screen.dart';

class SpotifyControlScreen extends StatelessWidget {
  const SpotifyControlScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SpotifyBloc>(),
      child: const _SpotifyControlScreenContent(),
    );
  }
}

class _SpotifyControlScreenContent extends StatefulWidget {
  const _SpotifyControlScreenContent({Key? key}) : super(key: key);

  @override
  _SpotifyControlScreenContentState createState() => _SpotifyControlScreenContentState();
}

class _SpotifyControlScreenContentState extends State<_SpotifyControlScreenContent> {
  List<CommonTrack> _playedTracks = [];
  List<Map<String, dynamic>> _spotifyDevices = [];
  String? _selectedDeviceId;

  @override
  void initState() {
    super.initState();
    context.read<SpotifyBloc>().add(LoadPlayedTracks());
    context.read<SpotifyBloc>().add(LoadSpotifyDevices());
  }

  Future<void> _sendLocation() async {
    try {
      final position = await _getCurrentLocation();
      context.read<SpotifyBloc>().add(SaveLocation(position.latitude, position.longitude));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location sent successfully')),
      );
    } catch (e) {
      print('Error sending location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send location')),
      );
    }
  }

  Future<void> _playSpotifyTrack(String trackId) async {
    context.read<SpotifyBloc>().add(PlaySpotifyTrack(trackId, _selectedDeviceId));
  }

  Widget _buildPlayedTracksList() {
    return BlocBuilder<SpotifyBloc, SpotifyState>(
      builder: (context, state) {
        if (state is PlayedTracksLoaded) {
          _playedTracks = state.tracks;
        }
        return ListView.builder(
          itemCount: _playedTracks.length,
          itemBuilder: (context, index) {
            final track = _playedTracks[index];
            return ListTile(
              title: Text(track.name),
              subtitle: Text(track.artistName ?? 'Unknown Artist'),
              onTap: () {
                // Navigate to track details if needed
              },
              trailing: IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () async {
                  try {
                    final position = await Geolocator.getCurrentPosition();
                    context.read<SpotifyBloc>().add(PlayTrackWithLocation(
                      track.id ?? '',
                      track.name,
                      position.latitude,
                      position.longitude,
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Track played with location')),
                    );
                  } catch (e) {
                    print('Error playing track with location: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to play track with location')),
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSpotifyDeviceDropdown() {
    return BlocBuilder<SpotifyBloc, SpotifyState>(
      builder: (context, state) {
        if (state is SpotifyDevicesLoaded) {
          _spotifyDevices = state.devices;
          if (_spotifyDevices.isNotEmpty && _selectedDeviceId == null) {
            _selectedDeviceId = _spotifyDevices[0]['id'];
          }
        }
        return DropdownButton<String>(
          value: _selectedDeviceId,
          items: _spotifyDevices.map((device) {
            return DropdownMenuItem<String>(
              value: device['id'],
              child: Text(device['name']),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedDeviceId = newValue;
            });
          },
          hint: const Text('Select Spotify Device'),
        );
      },
    );
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotify Control'),
        actions: [
          IconButton(
            icon: const Icon(Icons.devices),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Select Spotify Device'),
                    content: _buildSpotifyDeviceDropdown(),
                    actions: [
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.location_on),
            onPressed: _sendLocation,
            tooltip: 'Send Location',
          ),
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlayedTracksMapScreen(),
                ),
              );
            },
            tooltip: 'View Tracks on Map',
          ),
        ],
      ),
      body: BlocListener<SpotifyBloc, SpotifyState>(
        listener: (context, state) {
          if (state is TrackPlayed) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Track played successfully')),
            );
          } else if (state is LocationSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Location saved successfully')),
            );
          } else if (state is SpotifyError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: _buildPlayedTracksList(),
      ),
    );
  }
}