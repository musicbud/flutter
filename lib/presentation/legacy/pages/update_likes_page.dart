import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/likes/likes_bloc.dart';
import '../../blocs/likes/likes_event.dart';
import '../../blocs/likes/likes_state.dart';
import '../widgets/loading_indicator.dart';

class UpdateLikesPage extends StatefulWidget {
  final String channelId;

  const UpdateLikesPage({
    super.key,
    required this.channelId,
  });

  @override
  State<UpdateLikesPage> createState() => _UpdateLikesPageState();
}

class _UpdateLikesPageState extends State<UpdateLikesPage> {
  @override
  void initState() {
    super.initState();
    _updateLikes();
  }

  void _updateLikes() {
    context.read<LikesBloc>().add(LikesUpdateRequested(widget.channelId));
  }

  void _connectSpotify() {
    context.read<LikesBloc>().add(SpotifyConnectionRequested());
  }

  void _showConnectSpotifyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Connect Spotify'),
        content: const Text(
            'You need to connect your Spotify account to update likes.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _connectSpotify();
            },
            child: const Text('Connect'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Likes'),
      ),
      body: BlocConsumer<LikesBloc, LikesState>(
        listener: (context, state) {
          if (state is LikesUpdateFailure && state.needsSpotifyConnection) {
            _showConnectSpotifyDialog();
          }
        },
        builder: (context, state) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is LikesUpdating) ...[
                    const LoadingIndicator(),
                    const SizedBox(height: 16),
                    const Text('Updating likes...'),
                  ] else if (state is LikesUpdateSuccess) ...[
                    Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(state.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _updateLikes,
                      child: const Text('Update Again'),
                    ),
                  ] else if (state is LikesUpdateFailure) ...[
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.error,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _updateLikes,
                      child: const Text('Try Again'),
                    ),
                  ] else ...[
                    ElevatedButton(
                      onPressed: _updateLikes,
                      child: const Text('Update Likes'),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
