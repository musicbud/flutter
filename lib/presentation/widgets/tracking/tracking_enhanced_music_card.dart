import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/track.dart';
import '../../../blocs/content/content_bloc.dart';
import '../../../blocs/content/content_event.dart';
import '../../../blocs/content/content_state.dart';
import '../imported/enhanced_music_card.dart';

/// Enhanced music card with integrated tracking functionality
/// This widget combines the imported EnhancedMusicCard with tracking persistence
class TrackingEnhancedMusicCard extends StatelessWidget {
  final Track track;
  final bool showPlayButton;
  final VoidCallback? onPlay;
  final VoidCallback? onTap;
  final bool isPlaying;

  const TrackingEnhancedMusicCard({
    super.key,
    required this.track,
    this.showPlayButton = true,
    this.onPlay,
    this.onTap,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedMusicCard(
      imageUrl: track.imageUrl,
      title: track.name,
      subtitle: track.artistName ?? 'Unknown Artist',
      isPlaying: isPlaying,
      showPlayButton: showPlayButton,
      onTap: () {
        // Track the tap interaction
        _trackInteraction(context);
        
        // Call the custom onTap if provided
        if (onTap != null) {
          onTap!();
        } else {
          // Default behavior - play the track
          _playTrack(context);
        }
      },
      trailing: showPlayButton ? null : _buildTrailingWidget(context),
    );
  }

  /// Track user interaction with this music card
  void _trackInteraction(BuildContext context) {
    // Save played track for tracking
    context.read<ContentBloc>().add(SavePlayedTrack(trackId: track.id ?? ''));
  }

  /// Play track and save tracking data
  void _playTrack(BuildContext context) {
    if (onPlay != null) {
      onPlay!();
    } else {
      // Default play behavior - trigger content bloc to play track
      context.read<ContentBloc>().add(ContentPlayRequested(
        trackId: track.id ?? '',
      ));
    }
  }

  Widget _buildTrailingWidget(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Like button
        IconButton(
          icon: Icon(
            track.isLiked ? Icons.favorite : Icons.favorite_border,
            color: track.isLiked ? Colors.red : null,
            size: 20,
          ),
          onPressed: () => _toggleLike(context),
        ),
        // Play button
        IconButton(
          icon: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            size: 20,
          ),
          onPressed: () => _playTrack(context),
        ),
      ],
    );
  }

  void _toggleLike(BuildContext context) {
    context.read<ContentBloc>().add(ToggleTrackLike(trackId: track.id ?? ''));
  }
}

/// Grid variant with tracking
class TrackingEnhancedMusicCardGrid extends StatelessWidget {
  final Track track;
  final VoidCallback? onPlay;
  final VoidCallback? onTap;
  final bool isPlaying;

  const TrackingEnhancedMusicCardGrid({
    super.key,
    required this.track,
    this.onPlay,
    this.onTap,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return EnhancedMusicCardGrid(
      imageUrl: track.imageUrl,
      title: track.name,
      subtitle: track.artistName ?? 'Unknown Artist',
      isPlaying: isPlaying,
      onTap: () {
        // Track the interaction
        context.read<ContentBloc>().add(SavePlayedTrack(trackId: track.id ?? ''));
        
        // Call custom onTap or default to playing the track
        if (onTap != null) {
          onTap!();
        } else {
          _playTrack(context);
        }
      },
    );
  }

  void _playTrack(BuildContext context) {
    if (onPlay != null) {
      onPlay!();
    } else {
      context.read<ContentBloc>().add(ContentPlayRequested(
        trackId: track.id ?? '',
      ));
    }
  }
}

/// Compact variant with tracking
class TrackingCompactMusicCard extends StatelessWidget {
  final Track track;
  final VoidCallback? onPlay;
  final VoidCallback? onTap;

  const TrackingCompactMusicCard({
    super.key,
    required this.track,
    this.onPlay,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CompactMusicCard(
      imageUrl: track.imageUrl,
      title: track.name,
      subtitle: track.artistName ?? 'Unknown Artist',
      onTap: () {
        // Track the interaction
        context.read<ContentBloc>().add(SavePlayedTrack(trackId: track.id ?? ''));
        
        // Call custom onTap or default behavior
        if (onTap != null) {
          onTap!();
        } else {
          _playTrack(context);
        }
      },
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            track.isLiked ? Icons.favorite : Icons.favorite_border,
            color: track.isLiked ? Colors.red : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 8),
          if (track.playedAt != null)
            Text(
              _formatPlayedTime(track.playedAt!),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
        ],
      ),
    );
  }

  void _playTrack(BuildContext context) {
    if (onPlay != null) {
      onPlay!();
    } else {
      context.read<ContentBloc>().add(ContentPlayRequested(
        trackId: track.id ?? '',
      ));
    }
  }

  String _formatPlayedTime(DateTime playedAt) {
    final now = DateTime.now();
    final difference = now.difference(playedAt);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${playedAt.day}/${playedAt.month}';
    }
  }
}

/// Screen that displays recently played tracks using tracking data
class RecentlyPlayedTracksScreen extends StatelessWidget {
  const RecentlyPlayedTracksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recently Played'),
      ),
      body: BlocBuilder<ContentBloc, ContentState>(
        builder: (context, state) {
          if (state is ContentLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is ContentPlayedTracksLoaded) {
            if (state.tracks.isEmpty) {
              return const Center(
                child: Text('No recently played tracks'),
              );
            }
            
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.tracks.length,
              itemBuilder: (context, index) {
                final track = state.tracks[index];
                return TrackingCompactMusicCard(track: track);
              },
            );
          }
          
          return const Center(
            child: Text('Failed to load recently played tracks'),
          );
        },
      ),
    );
  }
}

// Events and states are now defined in the ContentBloc files
