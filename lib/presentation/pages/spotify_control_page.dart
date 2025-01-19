import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/blocs/spotify_control_bloc.dart';
import '../../data/blocs/spotify_control_event.dart';
import '../../data/blocs/spotify_control_state.dart';
import '../../domain/models/common_track.dart';
import '../../domain/models/spotify_device.dart';

class SpotifyControlPage extends StatefulWidget {
  const SpotifyControlPage({super.key});

  @override
  State<SpotifyControlPage> createState() => _SpotifyControlPageState();
}

class _SpotifyControlPageState extends State<SpotifyControlPage> {
  List<SpotifyDevice> _spotifyDevices = [];
  SpotifyDevice? _selectedDevice;
  double _volume = 50;
  CommonTrack? _currentTrack;

  @override
  void initState() {
    super.initState();
    context.read<SpotifyControlBloc>().add(const SpotifyDevicesRequested());
    context
        .read<SpotifyControlBloc>()
        .add(const SpotifyPlayedTracksRequested());
  }

  void _onDeviceSelected(SpotifyDevice device) {
    setState(() {
      _selectedDevice = device;
      _volume = device.volumePercent.toDouble();
    });
  }

  void _playbackControl(String action) {
    if (_selectedDevice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a device first')),
      );
      return;
    }

    context.read<SpotifyControlBloc>().add(
          SpotifyPlaybackControlRequested(
            command: action,
            deviceId: _selectedDevice!.id,
          ),
        );
  }

  void _onVolumeChanged(double value) {
    if (_selectedDevice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a device first')),
      );
      return;
    }

    setState(() {
      _volume = value;
    });

    context.read<SpotifyControlBloc>().add(
          SpotifyVolumeChangeRequested(
            volume: value.round(),
            deviceId: _selectedDevice!.id,
          ),
        );
  }

  void _sendLocation() {
    if (_currentTrack == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No track selected')),
      );
      return;
    }

    // In a real app, you would get these from the device's location
    const latitude = 0.0;
    const longitude = 0.0;

    context.read<SpotifyControlBloc>().add(
          SpotifyTrackLocationSaveRequested(
            track: _currentTrack!,
            latitude: latitude,
            longitude: longitude,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spotify Control'),
      ),
      body: BlocConsumer<SpotifyControlBloc, SpotifyControlState>(
        listener: (context, state) {
          if (state is SpotifyControlFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is SpotifyDevicesLoaded) {
            setState(() {
              _spotifyDevices = state.devices;
              // If we have devices and none selected, select the first active one
              if (_selectedDevice == null && _spotifyDevices.isNotEmpty) {
                _selectedDevice = _spotifyDevices.firstWhere(
                  (device) => device.isActive,
                  orElse: () => _spotifyDevices.first,
                );
                _volume = _selectedDevice!.volumePercent.toDouble();
              }
            });
          }
        },
        builder: (context, state) {
          if (state is SpotifyControlLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Devices dropdown
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButton<SpotifyDevice>(
                  isExpanded: true,
                  hint: const Text('Select a device'),
                  value: _selectedDevice,
                  items: _spotifyDevices.map((device) {
                    return DropdownMenuItem(
                      value: device,
                      child: Text('${device.name} (${device.type})'),
                    );
                  }).toList(),
                  onChanged: (device) {
                    if (device != null) {
                      _onDeviceSelected(device);
                    }
                  },
                ),
              ),

              // Playback controls
              Row(
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

              // Volume slider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    const Icon(Icons.volume_down),
                    Expanded(
                      child: Slider(
                        value: _volume,
                        min: 0,
                        max: 100,
                        onChanged: _onVolumeChanged,
                      ),
                    ),
                    const Icon(Icons.volume_up),
                  ],
                ),
              ),

              // Tracks list
              if (state is SpotifyPlayedTracksLoaded)
                Expanded(
                  child: ListView.builder(
                    itemCount: state.tracks.length,
                    itemBuilder: (context, index) {
                      final track = state.tracks[index];
                      return ListTile(
                        title: Text(track.name),
                        subtitle: Text(track.artistName ?? 'Unknown Artist'),
                        trailing: IconButton(
                          icon: const Icon(Icons.location_on),
                          onPressed: () {
                            setState(() {
                              _currentTrack = track;
                            });
                            _sendLocation();
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
