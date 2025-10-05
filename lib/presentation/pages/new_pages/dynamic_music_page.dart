import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/content/content_bloc.dart';
import '../../../blocs/content/content_event.dart';
import '../../../blocs/content/content_state.dart';
import '../../../blocs/likes/likes_bloc.dart';
import '../../../blocs/likes/likes_event.dart';
import '../../../domain/models/common_track.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_genre.dart';
import '../../widgets/common/bloc_tab_view.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/app_app_bar.dart';
import '../../constants/app_constants.dart';
import '../../mixins/page_mixin.dart';

class DynamicMusicPage extends StatefulWidget {
  const DynamicMusicPage({Key? key}) : super(key: key);

  @override
  State<DynamicMusicPage> createState() => _DynamicMusicPageState();
}

class _DynamicMusicPageState extends State<DynamicMusicPage> with PageMixin {
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
            icon: const Icon(Icons.refresh),
            onPressed: _refreshContent,
          ),
        ],
      ),
      body: BlocTabView<ContentBloc, ContentState, ContentEvent>(
        title: 'Music',
        showAppBar: false,
        isScrollable: true,
        tabs: [
          // Liked Tracks
          BlocTab<ContentState, ContentEvent>(
            title: 'Liked Tracks',
            icon: const Icon(Icons.favorite, size: 18),
            loadEvent: LoadLikedContent(),
            isLoading: (state) => state is ContentLoading,
            isError: (state) => state is ContentError,
            getErrorMessage: (state) => state is ContentError ? state.message : 'An error occurred',
            builder: (context, state) => _buildTracksList(state, 'liked'),
          ),

          // Top Tracks
          BlocTab<ContentState, ContentEvent>(
            title: 'Top Tracks',
            icon: const Icon(Icons.trending_up, size: 18),
            loadEvent: LoadTopContent(),
            isLoading: (state) => state is ContentLoading,
            isError: (state) => state is ContentError,
            builder: (context, state) => _buildTracksList(state, 'top'),
          ),

          // Played Tracks
          BlocTab<ContentState, ContentEvent>(
            title: 'Recently Played',
            icon: const Icon(Icons.history, size: 18),
            loadEvent: LoadPlayedTracks(),
            isLoading: (state) => state is ContentLoading,
            isError: (state) => state is ContentError,
            builder: (context, state) => _buildTracksList(state, 'played'),
          ),

          // Liked Artists
          BlocTab<ContentState, ContentEvent>(
            title: 'Liked Artists',
            icon: const Icon(Icons.person, size: 18),
            loadEvent: LoadLikedContent(),
            isLoading: (state) => state is ContentLoading,
            isError: (state) => state is ContentError,
            builder: (context, state) => _buildArtistsList(state, 'liked'),
          ),

          // Top Artists
          BlocTab<ContentState, ContentEvent>(
            title: 'Top Artists',
            icon: const Icon(Icons.star, size: 18),
            loadEvent: LoadTopContent(),
            isLoading: (state) => state is ContentLoading,
            isError: (state) => state is ContentError,
            builder: (context, state) => _buildArtistsList(state, 'top'),
          ),

          // Genres
          BlocTab<ContentState, ContentEvent>(
            title: 'Genres',
            icon: const Icon(Icons.category, size: 18),
            loadEvent: LoadTopContent(),
            isLoading: (state) => state is ContentLoading,
            isError: (state) => state is ContentError,
            builder: (context, state) => _buildGenresList(state),
          ),
        ],
      ),
    );
  }

  Widget _buildTracksList(ContentState state, String category) {
    if (state is ContentLoaded) {
      List<CommonTrack> tracks = [];

      switch (category) {
        case 'liked':
          tracks = state.likedTracks ?? [];
          break;
        case 'top':
          tracks = state.topTracks;
          break;
        case 'played':
          tracks = state.playedTracks ?? [];
          break;
      }

      if (tracks.isEmpty) {
        return _buildEmptyState(
          'No $category tracks',
          _getTracksEmptyMessage(category),
          Icons.music_note_outlined,
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: tracks.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildTrackItem(tracks[index]),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildArtistsList(ContentState state, String category) {
    if (state is ContentLoaded) {
      List<CommonArtist> artists = [];

      switch (category) {
        case 'liked':
          artists = state.likedArtists ?? [];
          break;
        case 'top':
          artists = state.topArtists;
          break;
      }

      if (artists.isEmpty) {
        return _buildEmptyState(
          'No $category artists',
          _getArtistsEmptyMessage(category),
          Icons.person_outline,
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: artists.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildArtistItem(artists[index]),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildGenresList(ContentState state) {
    if (state is ContentLoaded) {
      final genres = state.topGenres;

      if (genres.isEmpty) {
        return _buildEmptyState(
          'No genres found',
          'Start listening to discover your favorite genres',
          Icons.category_outlined,
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: genres.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _buildGenreItem(genres[index]),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildTrackItem(CommonTrack track) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: AppConstants.borderColor.withValues(alpha: 0.2),
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
              // Track Image
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppConstants.primaryColor.withValues(alpha: 0.2),
                  image: track.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(track.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: track.imageUrl == null
                    ? const Icon(
                        Icons.music_note,
                        color: AppConstants.primaryColor,
                        size: 24,
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
                    if (track.artistName != null)
                      Text(
                        track.artistName!,
                        style: AppConstants.captionStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (track.albumName != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        track.albumName!,
                        style: AppConstants.captionStyle.copyWith(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _toggleTrackLike(track.id),
                    icon: Icon(
                      track.isLiked ? Icons.favorite : Icons.favorite_border,
                      color: track.isLiked ? AppConstants.primaryColor : AppConstants.textSecondaryColor,
                      size: 20,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _playTrack(track),
                    icon: const Icon(
                      Icons.play_arrow,
                      color: AppConstants.primaryColor,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArtistItem(CommonArtist artist) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: AppConstants.borderColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _viewArtist(artist),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Artist Image
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConstants.primaryColor.withValues(alpha: 0.2),
                  image: artist.imageUrl != null
                      ? DecorationImage(
                          image: NetworkImage(artist.imageUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: artist.imageUrl == null
                    ? const Icon(
                        Icons.person,
                        color: AppConstants.primaryColor,
                        size: 24,
                      )
                    : null,
              ),

              const SizedBox(width: 16),

              // Artist Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artist.name,
                      style: AppConstants.subheadingStyle.copyWith(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    if (artist.genres?.isNotEmpty == true)
                      Text(
                        artist.genres!.join(', '),
                        style: AppConstants.captionStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),

              // Like Button
              IconButton(
                onPressed: () => _toggleArtistLike(artist.id),
                icon: Icon(
                  artist.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: artist.isLiked ? AppConstants.primaryColor : AppConstants.textSecondaryColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenreItem(CommonGenre genre) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.surfaceColor,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        border: Border.all(
          color: AppConstants.borderColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _viewGenre(genre),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Genre Icon
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppConstants.primaryColor.withValues(alpha: 0.2),
                ),
                child: const Icon(
                  Icons.category,
                  color: AppConstants.primaryColor,
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              // Genre Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      genre.name,
                      style: AppConstants.subheadingStyle.copyWith(fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Music genre',
                      style: AppConstants.captionStyle,
                    ),
                  ],
                ),
              ),

              // Like Button
              IconButton(
                onPressed: () => _toggleGenreLike(genre.id),
                icon: Icon(
                  genre.isLiked ? Icons.favorite : Icons.favorite_border,
                  color: genre.isLiked ? AppConstants.primaryColor : AppConstants.textSecondaryColor,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppConstants.textSecondaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppConstants.headingStyle.copyWith(
                color: AppConstants.textSecondaryColor,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppConstants.captionStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getTracksEmptyMessage(String category) {
    switch (category) {
      case 'liked':
        return 'Start liking tracks to build your music collection';
      case 'top':
        return 'Keep listening to discover your top tracks';
      case 'played':
        return 'Your recently played tracks will appear here';
      default:
        return 'No tracks available';
    }
  }

  String _getArtistsEmptyMessage(String category) {
    switch (category) {
      case 'liked':
        return 'Like artists to see them here';
      case 'top':
        return 'Listen to more music to discover your top artists';
      default:
        return 'No artists available';
    }
  }

  void _playTrack(CommonTrack track) {
    context.read<ContentBloc>().add(ContentPlayRequested(trackId: track.id));
    showInfoSnackBar('Playing ${track.name}');
  }

  void _toggleTrackLike(String trackId) {
    context.read<LikesBloc>().add(TrackLikeRequested(trackId: trackId));
  }

  void _toggleArtistLike(String artistId) {
    context.read<LikesBloc>().add(ArtistLikeRequested(artistId: artistId));
  }

  void _toggleGenreLike(String genreId) {
    context.read<LikesBloc>().add(GenreLikeRequested(genreId: genreId));
  }

  void _viewArtist(CommonArtist artist) {
    navigateTo('/artist/${artist.id}');
  }

  void _viewGenre(CommonGenre genre) {
    navigateTo('/genre/${genre.id}');
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
                  hintText: 'Search tracks, artists, or genres',
                  hintStyle: AppConstants.captionStyle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppConstants.borderColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppConstants.primaryColor),
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

  void _performSearch(String query) {
    context.read<ContentBloc>().add(SearchContent(query: query, type: 'all'));
    showInfoSnackBar('Searching for "$query"...');
  }

  void _refreshContent() {
    context.read<ContentBloc>().add(LoadTopContent());
    showInfoSnackBar('Refreshing music content...');
  }
}