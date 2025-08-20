import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/common_track.dart';
import '../../blocs/top_tracks/top_tracks_bloc.dart';
import '../../blocs/top_tracks/top_tracks_event.dart';
import '../../blocs/top_tracks/top_tracks_state.dart';
import '../widgets/loading_indicator.dart';

class TopTracksPage extends StatefulWidget {
  final String artistId;

  const TopTracksPage({
    super.key,
    required this.artistId,
  });

  @override
  State<TopTracksPage> createState() => _TopTracksPageState();
}

class _TopTracksPageState extends State<TopTracksPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadTopTracks();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadTopTracks() {
    context
        .read<TopTracksBloc>()
        .add(TopTracksRequested(artistId: widget.artistId));
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context
          .read<TopTracksBloc>()
          .add(TopTracksLoadMoreRequested(widget.artistId));
    }
  }

  void _toggleLike(String trackId) {
    context.read<TopTracksBloc>().add(TopTrackLikeToggled(trackId));
  }

  void _playTrack(String trackId, [String? deviceId]) {
    context.read<TopTracksBloc>().add(TopTrackPlayRequested(
          trackId: trackId,
          deviceId: deviceId,
        ));
  }

  Widget _buildTrackTile(CommonTrack track) {
    return ListTile(
      leading: track.imageUrl != null
          ? Image.network(
              track.imageUrl!,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
            )
          : Container(
              width: 48,
              height: 48,
              color: Colors.grey[300],
              child: const Icon(Icons.music_note),
            ),
      title: Text(track.title),
      subtitle: Text(track.artistName ?? 'Unknown Artist'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              track.isLiked ? Icons.favorite : Icons.favorite_border,
              color: track.isLiked ? Colors.red : null,
            ),
            onPressed: () => _toggleLike(track.id),
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () => _playTrack(track.id),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Tracks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<TopTracksBloc>()
                  .add(TopTracksRefreshRequested(widget.artistId));
            },
          ),
        ],
      ),
      body: BlocConsumer<TopTracksBloc, TopTracksState>(
        listener: (context, state) {
          if (state is TopTracksFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          } else if (state is TopTrackPlaybackStarted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Playing track...')),
            );
          }
        },
        builder: (context, state) {
          if (state is TopTracksInitial) {
            context
                .read<TopTracksBloc>()
                .add(TopTracksRequested(artistId: widget.artistId));
            return const LoadingIndicator();
          }

          if (state is TopTracksLoading) {
            return const LoadingIndicator();
          }

          if (state is TopTracksLoaded || state is TopTracksLoadingMore) {
            final tracks = state is TopTracksLoaded
                ? state.tracks
                : (state as TopTracksLoadingMore).currentTracks;

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<TopTracksBloc>()
                    .add(TopTracksRefreshRequested(widget.artistId));
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount:
                    tracks.length + (state is TopTracksLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == tracks.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: LoadingIndicator(),
                      ),
                    );
                  }

                  return Card(
                    child: _buildTrackTile(tracks[index]),
                  );
                },
              ),
            );
          }

          if (state is TopTracksFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadTopTracks,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return const Center(
            child: Text('Something went wrong'),
          );
        },
      ),
    );
  }
}
