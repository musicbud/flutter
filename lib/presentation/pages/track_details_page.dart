import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/models/common_track.dart';
import '../../blocs/track/track_bloc.dart';
import '../../blocs/track/track_event.dart';
import '../../blocs/track/track_state.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/bud_match_list_item.dart';

class TrackDetailsPage extends StatefulWidget {
  final CommonTrack track;

  const TrackDetailsPage({
    super.key,
    required this.track,
  });

  @override
  State<TrackDetailsPage> createState() => _TrackDetailsPageState();
}

class _TrackDetailsPageState extends State<TrackDetailsPage> {
  String get _trackIdentifier => widget.track.id;

  @override
  void initState() {
    super.initState();
    _loadBuds();
  }

  void _loadBuds() {
    context.read<TrackBloc>().add(TrackBudsRequested(_trackIdentifier));
  }

  void _toggleLike() {
    context.read<TrackBloc>().add(TrackLikeToggled(_trackIdentifier));
  }

  void _playTrack([String? deviceId]) {
    context.read<TrackBloc>().add(
          TrackPlayRequested(
            trackId: _trackIdentifier,
            deviceId: deviceId,
          ),
        );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.track.title),
        actions: [
          IconButton(
            icon: Icon(
              widget.track.isLiked ? Icons.favorite : Icons.favorite_border,
            ),
            onPressed: _toggleLike,
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () => _playTrack(),
          ),
        ],
      ),
      body: BlocConsumer<TrackBloc, TrackState>(
        listener: (context, state) {
          if (state is TrackFailure) {
            _showErrorSnackBar(state.error);
          } else if (state is TrackPlayStarted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Track started playing')),
            );
          }
        },
        builder: (context, state) {
          if (state is TrackLoading) {
            return const LoadingIndicator();
          }

          if (state is TrackBudsLoaded) {
            return ListView(
              children: [
                ListTile(
                  title: Text(widget.track.title),
                  subtitle: Text(widget.track.artistName ?? 'Unknown Artist'),
                ),
                if (widget.track.albumName != null)
                  ListTile(
                    title: const Text('Album'),
                    subtitle: Text(widget.track.albumName!),
                  ),
                if (widget.track.playedAt != null)
                  ListTile(
                    title: const Text('Last Played'),
                    subtitle: Text(widget.track.playedAt!.toString()),
                  ),
                if (widget.track.source != null)
                  ListTile(
                    title: const Text('Source'),
                    subtitle: Text(widget.track.source!),
                  ),
                const Divider(),
                if (state.buds.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Buds who like this track',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ...state.buds
                      .map((budMatch) => BudMatchListItem(budMatch: budMatch)),
                ] else
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No buds found for this track'),
                    ),
                  ),
              ],
            );
          }

          return const Center(
            child: Text('Failed to load track details'),
          );
        },
      ),
    );
  }
}
