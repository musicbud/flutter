import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/track/track_bloc.dart';
import '../../../blocs/track/track_event.dart';
import '../../../blocs/track/track_state.dart';
import '../../../blocs/spotify_control/spotify_control_bloc.dart';
import '../../../blocs/spotify_control/spotify_control_event.dart';
import '../../../blocs/spotify_control/spotify_control_state.dart';
import '../../../blocs/likes/likes_bloc.dart';
import '../../../blocs/likes/likes_event.dart';
import '../../../blocs/likes/likes_state.dart';
import '../../../domain/models/common_track.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_album.dart';
import '../../widgets/common/bloc_tab_view.dart';
import '../../widgets/common/bloc_list.dart';
import '../../widgets/common/bloc_form.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/app_app_bar.dart';
import '../../constants/app_constants.dart';
import '../../mixins/page_mixin.dart';

class ModernMusicPage extends StatefulWidget {
  const ModernMusicPage({Key? key}) : super(key: key);

  @override
  State<ModernMusicPage> createState() => _ModernMusicPageState();
}

class _ModernMusicPageState extends State<ModernMusicPage> with PageMixin {
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    context.read<TrackBloc>().add(const TrackBudsRequested('recent'));
    context.read<SpotifyControlBloc>().add(SpotifyDevicesRequested());
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        title: 'Music Discovery',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.playlist_add),
            onPressed: _showCreatePlaylistDialog,
          ),
        ],
      ),
      body: BlocTabView<TrackBloc, TrackState, TrackEvent>(
        title: 'Music',
        showAppBar: false,
        isScrollable: true,
        tabs: [
          BlocTab<TrackState, TrackEvent>(
            title: 'Recent',
            icon: const Icon(Icons.history, size: 18),
            loadEvent: const TrackBudsRequested('recent'),
            isLoading: (state) => state is TrackLoading,
            isError: (state) => state is TrackFailure,
            builder: (context, state) => _buildTracksList(state, 'recent'),
          ),
          BlocTab<TrackState, TrackEvent>(
            title: 'Liked',
            icon: const Icon(Icons.favorite, size: 18),
            loadEvent: const TrackBudsRequested('liked'),
            isLoading: (state) => state is TrackLoading,
            isError: (state) => state is TrackFailure,
            builder: (context, state) => _buildTracksList(state, 'liked'),
          ),
          BlocTab<TrackState, TrackEvent>(
            title: 'Top Tracks',
            icon: const Icon(Icons.trending_up, size: 18),
            loadEvent: const TrackBudsRequested('top'),
            isLoading: (state) => state is TrackLoading,
            isError: (state) => state is TrackFailure,
            builder: (context, state) => _buildTracksList(state, 'top'),
          ),
          BlocTab<TrackState, TrackEvent>(
            title: 'Discover',
            icon: const Icon(Icons.explore, size: 18),
            loadEvent: const TrackBudsRequested('discover'),
            isLoading: (state) => state is TrackLoading,
            isError: (state) => state is TrackFailure,
            builder: (context, state) => _buildDiscoverContent(state),
          ),
        ],
      ),
    );
  }

  Widget _buildTracksList(TrackState state, String category) {
    if (state is TrackBudsLoaded) {
      final tracks = _getTracksForCategory(state, category);

      if (tracks.isEmpty) {
        return _buildEmptyState(category);
      }

      return ListView.separated(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: tracks.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildTrackCard(tracks[index]),
      );
    }

    return const SizedBox.shrink();
  }

  List<CommonTrack> _getTracksForCategory(TrackBudsLoaded state, String category) {
    // This would be implemented based on your actual state structure
    // For now, returning mock data structure
    switch (category) {
      case 'recent':
        return []; // state.recentTracks ?? [];
      case 'liked':
        return []; // state.likedTracks ?? [];
      case 'top':
        return []; // state.topTracks ?? [];
      default:
        return [];
    }
  }

  Widget _buildTrackCard(CommonTrack track) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: AppConstants.borderColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _playTrack(track),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Album Art
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppConstants.primaryColor.withOpacity(0.2),
                  image: track.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(track.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: track.imageUrl == null
                    ? Icon(
                        Icons.music_note,
                        size: 30,
                        color: AppConstants.primaryColor,
                      )
                    : null,
              ),

              const SizedBox(width: 16),

              // Track Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track.name,
                      style: AppConstants.subheadingStyle.copyWith(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      track.artists.map((a) => a.name).join(', '),
                      style: AppConstants.captionStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    if (track.album != null)
                      Text(
                        track.album!.name,
                        style: AppConstants.captionStyle.copyWith(
                          color: AppConstants.textSecondaryColor.withOpacity(0.7),
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      track.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: track.isLiked ? AppConstants.primaryColor : AppConstants.textSecondaryColor,
                      size: 20,
                    ),
                    onPressed: () => _toggleLike(track),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: AppConstants.textSecondaryColor,
                      size: 20,
                    ),
                    onPressed: () => _showTrackOptions(track),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscoverContent(TrackState state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search section
          Text(
            'Find New Music',
            style: AppConstants.subheadingStyle,
          ),
          const SizedBox(height: 16),

          // Quick search
          Container(
            decoration: BoxDecoration(
              color: AppConstants.surfaceColor,
              borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
            ),
            child: TextField(
              style: AppConstants.bodyStyle,
              decoration: InputDecoration(
                hintText: 'Search for tracks, artists, albums...',
                hintStyle: AppConstants.captionStyle,
                prefixIcon: Icon(
                  Icons.search,
                  color: AppConstants.textSecondaryColor,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
              onSubmitted: _performSearch,
            ),
          ),

          const SizedBox(height: 32),

          // Genre buttons
          Text(
            'Explore by Genre',
            style: AppConstants.subheadingStyle,
          ),
          const SizedBox(height: 16),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _buildGenreButtons(),
          ),

          const SizedBox(height: 32),

          // Recommendations
          Text(
            'Recommended for You',
            style: AppConstants.subheadingStyle,
          ),
          const SizedBox(height: 16),

          _buildRecommendationsList(),
        ],
      ),
    );
  }

  List<Widget> _buildGenreButtons() {
    final genres = ['Pop', 'Rock', 'Hip-Hop', 'Electronic', 'Jazz', 'Classical', 'Country', 'R&B'];

    return genres.map((genre) =>
      InkWell(
        onTap: () => _exploreGenre(genre),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppConstants.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppConstants.primaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            genre,
            style: AppConstants.bodyStyle.copyWith(
              color: AppConstants.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      )
    ).toList();
  }

  Widget _buildRecommendationsList() {
    // This would show AI-generated recommendations based on user's listening history
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Mock count
        itemBuilder: (context, index) => Container(
          width: 150,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: AppConstants.surfaceColor,
            borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor.withOpacity(0.2),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppConstants.defaultBorderRadius),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.music_note,
                      size: 40,
                      color: AppConstants.primaryColor,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recommended Track ${index + 1}',
                      style: AppConstants.bodyStyle.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Artist Name',
                      style: AppConstants.captionStyle.copyWith(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String category) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getIconForCategory(category),
              size: 64,
              color: AppConstants.textSecondaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              _getEmptyMessageForCategory(category),
              style: AppConstants.headingStyle.copyWith(
                color: AppConstants.textSecondaryColor,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getEmptySubMessageForCategory(category),
              style: AppConstants.captionStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'recent':
        return Icons.history;
      case 'liked':
        return Icons.favorite_border;
      case 'top':
        return Icons.trending_up;
      default:
        return Icons.music_note;
    }
  }

  String _getEmptyMessageForCategory(String category) {
    switch (category) {
      case 'recent':
        return 'No Recent Tracks';
      case 'liked':
        return 'No Liked Songs';
      case 'top':
        return 'No Top Tracks Yet';
      default:
        return 'No Music Found';
    }
  }

  String _getEmptySubMessageForCategory(String category) {
    switch (category) {
      case 'recent':
        return 'Start listening to see your recent tracks here';
      case 'liked':
        return 'Like songs to see them in your collection';
      case 'top':
        return 'Your most played tracks will appear here';
      default:
        return 'Try exploring different categories';
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppConstants.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Search Music',
                style: AppConstants.headingStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 16),
              TextField(
                autofocus: true,
                style: AppConstants.bodyStyle,
                decoration: InputDecoration(
                  hintText: 'Enter track, artist, or album name',
                  hintStyle: AppConstants.captionStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppConstants.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppConstants.primaryColor),
                  ),
                ),
                onSubmitted: (query) {
                  Navigator.of(context).pop();
                  _performSearch(query);
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCreatePlaylistDialog() {
    showInputDialog(
      title: 'Create Playlist',
      message: 'Enter a name for your new playlist',
      hintText: 'Playlist name',
    ).then((name) {
      if (name != null && name.isNotEmpty) {
        showSuccessSnackBar('Playlist "$name" created!');
      }
    });
  }

  void _playTrack(CommonTrack track) {
    context.read<TrackBloc>().add(TrackPlayRequested(trackId: track.id));
    showInfoSnackBar('Playing ${track.name}');
  }

  void _toggleLike(CommonTrack track) {
    context.read<LikesBloc>().add(TrackLikeRequested(trackId: track.id));
  }

  void _showTrackOptions(CommonTrack track) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppConstants.surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.playlist_add, color: AppConstants.textColor),
              title: const Text('Add to Playlist', style: AppConstants.bodyStyle),
              onTap: () {
                Navigator.of(context).pop();
                _addToPlaylist(track);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share, color: AppConstants.textColor),
              title: const Text('Share Track', style: AppConstants.bodyStyle),
              onTap: () {
                Navigator.of(context).pop();
                _shareTrack(track);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: AppConstants.textColor),
              title: const Text('Track Info', style: AppConstants.bodyStyle),
              onTap: () {
                Navigator.of(context).pop();
                _showTrackInfo(track);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _performSearch(String query) {
    showInfoSnackBar('Searching for "$query"...');
    // Implement search functionality
  }

  void _exploreGenre(String genre) {
    showInfoSnackBar('Exploring $genre music...');
    // Implement genre exploration
  }

  void _addToPlaylist(CommonTrack track) {
    showSuccessSnackBar('Added "${track.name}" to playlist!');
  }

  void _shareTrack(CommonTrack track) {
    showInfoSnackBar('Sharing "${track.name}"...');
  }

  void _showTrackInfo(CommonTrack track) {
    navigateTo('/track/${track.id}');
  }
}