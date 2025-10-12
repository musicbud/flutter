import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:musicbud_flutter/blocs/spotify/spotify_bloc.dart';
import 'package:musicbud_flutter/blocs/spotify/spotify_event.dart';
import 'package:musicbud_flutter/blocs/spotify/spotify_state.dart';
import 'package:musicbud_flutter/domain/entities/common_track.dart';
// For SpotifyCommonTrack
import 'package:musicbud_flutter/presentation/screens/spotify/played_tracks_map_screen.dart';

class SpotifyControlScreen extends StatelessWidget {
  const SpotifyControlScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SpotifyControlScreenContent();
  }
}

class _SpotifyControlScreenContent extends StatefulWidget {
  const _SpotifyControlScreenContent();

  @override
  _SpotifyControlScreenContentState createState() => _SpotifyControlScreenContentState();
}

class _SpotifyControlScreenContentState extends State<_SpotifyControlScreenContent> {
  List<CommonTrack> _playedTracks = [];

  @override
  void initState() {
    super.initState();
    context.read<SpotifyBloc>().add(LoadPlayedTracks());
  }

  Future<void> _sendLocation() async {
    try {
      final position = await _getCurrentLocation();
      if (mounted) {
        context.read<SpotifyBloc>().add(SaveLocation(position.latitude, position.longitude));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location sent successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send location')),
        );
      }
    }
  }

  Widget _buildPlayedTracksList() {
    return BlocBuilder<SpotifyBloc, SpotifyState>(
      builder: (context, state) {
        if (state is PlayedTracksLoaded) {
          // Convert SpotifyCommonTrack to CommonTrack
          _playedTracks = state.tracks.map((spotifyTrack) => CommonTrack(
            id: spotifyTrack.id,
            title: spotifyTrack.name,
            artistName: spotifyTrack.artistName ?? 'Unknown Artist',
            genres: const [],
            imageUrl: spotifyTrack.images.isNotEmpty ? spotifyTrack.images.first.url : null,
          )).toList();
        }
        return ListView.builder(
          itemCount: _playedTracks.length,
          itemBuilder: (context, index) {
            final track = _playedTracks[index];
            return ListTile(
              title: Text(track.title),
              subtitle: Text(track.artistName),
              onTap: () {
                // Navigate to track details if needed
              },
              trailing: IconButton(
                icon: const Icon(Icons.play_arrow),
                onPressed: () async {
                  if (!mounted) return;
                  final bloc = context.read<SpotifyBloc>();
                  final messenger = ScaffoldMessenger.of(context);
                  try {
                    final position = await Geolocator.getCurrentPosition();
                    if (mounted) {
                      bloc.add(PlayTrackWithLocation(
                        track.id ?? '',
                        track.title,
                        position.latitude,
                        position.longitude,
                      ));
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Track played with location')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      messenger.showSnackBar(
                        const SnackBar(content: Text('Failed to play track with location')),
                      );
                    }
                  }
                },
              ),
            );
          },
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