import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/bud/bud_bloc.dart';
import '../../../blocs/bud/bud_event.dart';
import '../../../blocs/bud/bud_state.dart';
import '../../../domain/models/bud_match.dart';
import '../../widgets/common/bloc_tab_view.dart';
import '../../widgets/common/app_scaffold.dart';
import '../../widgets/common/app_app_bar.dart';
import '../../constants/app_constants.dart';
import '../../mixins/page_mixin.dart';

class DynamicBudsPage extends StatefulWidget {
  const DynamicBudsPage({Key? key}) : super(key: key);

  @override
  State<DynamicBudsPage> createState() => _DynamicBudsPageState();
}

class _DynamicBudsPageState extends State<DynamicBudsPage> with PageMixin {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppAppBar(
        title: 'Find Music Buds',
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showSearchDialog,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshAllBuds,
          ),
        ],
      ),
      body: BlocTabView<BudBloc, BudState, BudEvent>(
        title: 'Music Buds',
        showAppBar: false,
        isScrollable: true,
        tabs: [
          // Liked Artists
          BlocTab<BudState, BudEvent>(
            title: 'Liked Artists',
            icon: const Icon(Icons.favorite_outline, size: 18),
            loadEvent: BudsByLikedArtistsRequested(),
            isLoading: (state) => state is BudLoading,
            isError: (state) => state is BudFailure,
            getErrorMessage: (state) => state is BudFailure ? state.error : 'An error occurred',
            builder: (context, state) => _buildBudsList(state, 'liked_artists'),
          ),

          // Liked Tracks
          BlocTab<BudState, BudEvent>(
            title: 'Liked Tracks',
            icon: const Icon(Icons.music_note_outlined, size: 18),
            loadEvent: BudsByLikedTracksRequested(),
            isLoading: (state) => state is BudLoading,
            isError: (state) => state is BudFailure,
            builder: (context, state) => _buildBudsList(state, 'liked_tracks'),
          ),

          // Liked Genres
          BlocTab<BudState, BudEvent>(
            title: 'Liked Genres',
            icon: const Icon(Icons.category_outlined, size: 18),
            loadEvent: BudsByLikedGenresRequested(),
            isLoading: (state) => state is BudLoading,
            isError: (state) => state is BudFailure,
            builder: (context, state) => _buildBudsList(state, 'liked_genres'),
          ),

          // Liked Albums
          BlocTab<BudState, BudEvent>(
            title: 'Liked Albums',
            icon: const Icon(Icons.album_outlined, size: 18),
            loadEvent: BudsByLikedAlbumsRequested(),
            isLoading: (state) => state is BudLoading,
            isError: (state) => state is BudFailure,
            builder: (context, state) => _buildBudsList(state, 'liked_albums'),
          ),

          // Top Artists
          BlocTab<BudState, BudEvent>(
            title: 'Top Artists',
            icon: const Icon(Icons.trending_up, size: 18),
            loadEvent: BudsByTopArtistsRequested(),
            isLoading: (state) => state is BudLoading,
            isError: (state) => state is BudFailure,
            builder: (context, state) => _buildBudsList(state, 'top_artists'),
          ),

          // Top Tracks
          BlocTab<BudState, BudEvent>(
            title: 'Top Tracks',
            icon: const Icon(Icons.star_outline, size: 18),
            loadEvent: BudsByTopTracksRequested(),
            isLoading: (state) => state is BudLoading,
            isError: (state) => state is BudFailure,
            builder: (context, state) => _buildBudsList(state, 'top_tracks'),
          ),

          // Top Genres
          BlocTab<BudState, BudEvent>(
            title: 'Top Genres',
            icon: const Icon(Icons.equalizer, size: 18),
            loadEvent: BudsByTopGenresRequested(),
            isLoading: (state) => state is BudLoading,
            isError: (state) => state is BudFailure,
            builder: (context, state) => _buildBudsList(state, 'top_genres'),
          ),

          // Played Tracks
          BlocTab<BudState, BudEvent>(
            title: 'Played Tracks',
            icon: const Icon(Icons.history, size: 18),
            loadEvent: BudsByPlayedTracksRequested(),
            isLoading: (state) => state is BudLoading,
            isError: (state) => state is BudFailure,
            builder: (context, state) => _buildBudsList(state, 'played_tracks'),
          ),
        ],
      ),
    );
  }

  Widget _buildBudsList(BudState state, String category) {
    if (state is BudsLoaded) {
      final buds = state.buds;

      if (buds.isEmpty) {
        return _buildEmptyState(category);
      }

      return ListView.separated(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        itemCount: buds.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          // Convert dynamic to BudMatch if possible
          final budData = buds[index];
          BudMatch bud;

          if (budData is BudMatch) {
            bud = budData;
          } else if (budData is Map<String, dynamic>) {
            bud = BudMatch.fromJson(budData);
          } else {
            // Create a dummy BudMatch for now
            bud = const BudMatch(
              id: 'unknown',
              userId: 'unknown',
              username: 'Unknown User',
              matchScore: 0.0,
              commonArtists: 0,
              commonTracks: 0,
              commonGenres: 0,
            );
          }

          return _buildBudCard(bud, category);
        },
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildBudCard(BudMatch bud, String category) {
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
        onTap: () => _onBudTap(bud),
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Profile Image
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppConstants.primaryColor.withValues(alpha: 0.2),
                  image: bud.avatarUrl != null
                      ? DecorationImage(
                          image: NetworkImage(bud.avatarUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: bud.avatarUrl == null
                    ? Icon(
                        Icons.person,
                        size: 30,
                        color: AppConstants.primaryColor,
                      )
                    : null,
              ),

              const SizedBox(width: 16),

              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bud.username,
                      style: AppConstants.subheadingStyle.copyWith(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          _getCategoryIcon(category),
                          size: 16,
                          color: AppConstants.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${(bud.matchScore * 100).round()}% match',
                          style: AppConstants.captionStyle.copyWith(
                            color: AppConstants.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getMatchDescription(bud, category),
                      style: AppConstants.captionStyle.copyWith(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Action Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppConstants.primaryColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  'Connect',
                  style: AppConstants.captionStyle.copyWith(
                    color: AppConstants.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
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
              _getCategoryIcon(category),
              size: 64,
              color: AppConstants.textSecondaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              _getEmptyTitle(category),
              style: AppConstants.headingStyle.copyWith(
                color: AppConstants.textSecondaryColor,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getEmptySubtitle(category),
              style: AppConstants.captionStyle,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'liked_artists':
        return Icons.favorite;
      case 'liked_tracks':
        return Icons.music_note;
      case 'liked_genres':
        return Icons.category;
      case 'liked_albums':
        return Icons.album;
      case 'top_artists':
        return Icons.trending_up;
      case 'top_tracks':
        return Icons.star;
      case 'top_genres':
        return Icons.equalizer;
      case 'played_tracks':
        return Icons.history;
      default:
        return Icons.people;
    }
  }

  String _getEmptyTitle(String category) {
    switch (category) {
      case 'liked_artists':
        return 'No buds with similar liked artists';
      case 'liked_tracks':
        return 'No buds with similar liked tracks';
      case 'liked_genres':
        return 'No buds with similar liked genres';
      case 'liked_albums':
        return 'No buds with similar liked albums';
      case 'top_artists':
        return 'No buds with similar top artists';
      case 'top_tracks':
        return 'No buds with similar top tracks';
      case 'top_genres':
        return 'No buds with similar top genres';
      case 'played_tracks':
        return 'No buds with similar played tracks';
      default:
        return 'No buds found';
    }
  }

  String _getEmptySubtitle(String category) {
    switch (category) {
      case 'liked_artists':
        return 'Start liking artists to find music buds with similar taste';
      case 'liked_tracks':
        return 'Like some tracks to discover buds with similar music taste';
      case 'liked_genres':
        return 'Explore different genres to find like-minded music lovers';
      case 'liked_albums':
        return 'Like albums to connect with buds who share your taste';
      case 'top_artists':
        return 'Listen to more artists to find buds with similar preferences';
      case 'top_tracks':
        return 'Build your listening history to discover similar music buds';
      case 'top_genres':
        return 'Explore various genres to find buds with matching tastes';
      case 'played_tracks':
        return 'Keep listening to find buds with similar music activity';
      default:
        return 'Try different categories to discover music buds';
    }
  }

  String _getMatchDescription(BudMatch bud, String category) {
    switch (category) {
      case 'liked_artists':
        return '${bud.commonArtists} common artists';
      case 'liked_tracks':
        return '${bud.commonTracks} common tracks';
      case 'liked_genres':
        return '${bud.commonGenres} common genres';
      case 'liked_albums':
        return 'Similar album taste';
      case 'top_artists':
        return '${bud.commonArtists} shared top artists';
      case 'top_tracks':
        return '${bud.commonTracks} shared top tracks';
      case 'top_genres':
        return '${bud.commonGenres} shared genres';
      case 'played_tracks':
        return 'Similar listening history';
      default:
        return 'Music compatibility';
    }
  }

  void _onBudTap(BudMatch bud) {
    showDialog(
      context: context,
      builder: (context) => _buildBudDialog(bud),
    );
  }

  Widget _buildBudDialog(BudMatch bud) {
    return Dialog(
      backgroundColor: AppConstants.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppConstants.primaryColor.withValues(alpha: 0.2),
                image: bud.avatarUrl != null
                    ? DecorationImage(
                        image: NetworkImage(bud.avatarUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: bud.avatarUrl == null
                  ? Icon(
                      Icons.person,
                      size: 40,
                      color: AppConstants.primaryColor,
                    )
                  : null,
            ),

            const SizedBox(height: 16),

            // Name and Match
            Text(
              bud.username,
              style: AppConstants.headingStyle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 4),
            Text(
              '${(bud.matchScore * 100).round()}% match',
              style: AppConstants.bodyStyle.copyWith(
                color: AppConstants.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            // Match Details
            _buildMatchDetails(bud),

            const SizedBox(height: 16),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: AppConstants.bodyStyle.copyWith(
                      color: AppConstants.textSecondaryColor,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _connectWithBud(bud);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Connect'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _viewBudProfile(bud);
                  },
                  child: Text(
                    'View Profile',
                    style: AppConstants.bodyStyle.copyWith(
                      color: AppConstants.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchDetails(BudMatch bud) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppConstants.backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'Common Interests',
            style: AppConstants.subheadingStyle.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMatchStat('Artists', bud.commonArtists, Icons.person),
              _buildMatchStat('Tracks', bud.commonTracks, Icons.music_note),
              _buildMatchStat('Genres', bud.commonGenres, Icons.category),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMatchStat(String label, int count, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppConstants.primaryColor,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: AppConstants.subheadingStyle.copyWith(
            color: AppConstants.primaryColor,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: AppConstants.captionStyle.copyWith(fontSize: 12),
        ),
      ],
    );
  }

  void _connectWithBud(BudMatch bud) {
    context.read<BudBloc>().add(BudRequestSent(userId: bud.userId));
    showSuccessSnackBar('Connection request sent to ${bud.username}!');
  }

  void _viewBudProfile(BudMatch bud) {
    navigateTo('/profile/${bud.userId}');
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
                'Search Music Buds',
                style: AppConstants.headingStyle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 16),
              TextField(
                autofocus: true,
                style: AppConstants.bodyStyle,
                decoration: InputDecoration(
                  hintText: 'Enter username or music preference',
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

  void _performSearch(String query) {
    context.read<BudBloc>().add(BudSearchRequested(query: query));
    showInfoSnackBar('Searching for "$query"...');
  }

  void _refreshAllBuds() {
    // Refresh current tab data
    showInfoSnackBar('Refreshing music buds...');
  }
}