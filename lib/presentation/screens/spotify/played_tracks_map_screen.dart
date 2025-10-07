import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:musicbud_flutter/blocs/spotify/spotify_bloc.dart';

class PlayedTracksMapScreen extends StatelessWidget {
  const PlayedTracksMapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const _PlayedTracksMapScreenContent();
  }
}

class _PlayedTracksMapScreenContent extends StatefulWidget {
  const _PlayedTracksMapScreenContent({Key? key}) : super(key: key);

  @override
  _PlayedTracksMapScreenContentState createState() => _PlayedTracksMapScreenContentState();
}

class _PlayedTracksMapScreenContentState extends State<_PlayedTracksMapScreenContent> {
  @override
  void initState() {
    super.initState();
    context.read<SpotifyBloc>().add(LoadPlayedTracksWithLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Played Tracks Map'),
      ),
      body: BlocBuilder<SpotifyBloc, SpotifyState>(
        builder: (context, state) {
          if (state is PlayedTracksWithLocationLoaded) {
            final tracks = state.tracks;
            return ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return ListTile(
                  title: Text(track.name),
                  subtitle: Text('Lat: ${track.latitude}, Lng: ${track.longitude}'),
                );
              },
            );
          } else if (state is SpotifyLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SpotifyError) {
            return Center(child: Text('Error: ${state.message}'));
          } else {
            return const Center(child: Text('No tracks with location data'));
          }
        },
      ),
    );
  }
}