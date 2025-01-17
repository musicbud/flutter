import 'package:flutter/material.dart';
import 'package:musicbud_flutter/services/api_service.dart';
import 'package:musicbud_flutter/pages/track_details_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:musicbud_flutter/models/common_track.dart';
import 'package:musicbud_flutter/pages/played_tracks_map_page.dart';

class SpotifyControlPage extends StatefulWidget {
  final ApiService apiService;

  const SpotifyControlPage({Key? key, required this.apiService})
      : super(key: key);

  @override
  _SpotifyControlPageState createState() => _SpotifyControlPageState();
}

class _SpotifyControlPageState extends State<SpotifyControlPage> {
  List<CommonTrack> _playedTracks = [];
  List<dynamic> _spotifyDevices = [];
  String? _selectedDeviceId;

  @override
  void initState() {
    super.initState();
    _fetchPlayedTracks();
    _fetchSpotifyDevices();
  }

  Future<void> _sendLocation() async {
    try {
      final position = await _getCurrentLocation();
      await widget.apiService
          .saveLocation(position.latitude, position.longitude);
      if (!mounted) return;
      _showSnackBar(context, 'Location sent successfully');
    } catch (e) {
      print('Error sending location: $e');
      if (!mounted) return;
      _showSnackBar(context, 'Failed to send location');
    }
  }

  Future<void> _fetchPlayedTracks() async {
    try {
      final tracks = await widget.apiService.getPlayedTracks();
      if (!mounted) return;
      setState(() {
        _playedTracks = tracks;
      });
    } catch (e) {
      print('Error fetching played tracks: $e');
      if (!mounted) return;
      _showSnackBar(context, 'Failed to load played tracks');
    }
  }

  Future<void> _fetchSpotifyDevices() async {
    try {
      final devices = await widget.apiService.getSpotifyDevices();
      if (!mounted) return;
      setState(() {
        _spotifyDevices = devices;
        if (devices.isNotEmpty) {
          _selectedDeviceId = devices[0]['id'];
        }
      });
    } catch (e) {
      print('Error fetching Spotify devices: $e');
      if (!mounted) return;
      _showSnackBar(context, 'Failed to load Spotify devices');
    }
  }

  Future<void> _playSpotifyTrack(String trackId) async {
    try {
      final success = await widget.apiService
          .playSpotifyTrack(trackId, deviceId: _selectedDeviceId);
      if (!mounted) return;

      if (success) {
        _showSnackBar(context, 'Track played on Spotify');
      } else {
        _showSnackBar(context, 'Failed to play track on Spotify');
      }
    } catch (e) {
      print('Error playing Spotify track: $e');
      if (!mounted) return;
      _showSnackBar(context, 'Error playing track on Spotify');
    }
  }

  Widget _buildPlayedTracksList() {
    return ListView.builder(
      itemCount: _playedTracks.length,
      itemBuilder: (context, index) {
        final track = _playedTracks[index];
        return ListTile(
          title: Text(track.name),
          subtitle: Text(track.artistName ?? 'Unknown Artist'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrackDetailsPage(
                  track: track,
                  apiService: widget.apiService,
                ),
              ),
            );
          },
          trailing: IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () async {
              try {
                final position = await Geolocator.getCurrentPosition();
                await widget.apiService.playTrackWithLocation(
                  track.id ?? '',
                  track.name,
                  position.latitude,
                  position.longitude,
                );
                if (context.mounted) {
                  _showSnackBar(context, 'Track played with location');
                }
              } catch (e) {
                print('Error playing track with location: $e');
                if (context.mounted) {
                  _showSnackBar(context, 'Failed to play track with location');
                }
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildSpotifyDeviceDropdown() {
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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                  builder: (context) =>
                      PlayedTracksMapPage(apiService: widget.apiService),
                ),
              );
            },
            tooltip: 'View Tracks on Map',
          ),
        ],
      ),
      body: _buildPlayedTracksList(),
    );
  }
}
