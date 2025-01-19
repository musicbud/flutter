import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/bud/common_items/bud_common_items_bloc.dart';
import '../../blocs/bud/common_items/bud_common_items_event.dart';
import '../../blocs/bud/common_items/bud_common_items_state.dart';
import '../../presentation/widgets/horizontal_list.dart';
import '../../presentation/widgets/track_list_item.dart';
import '../../presentation/widgets/artist_list_item.dart';
import '../../presentation/widgets/genre_list_item.dart';
import '../../presentation/widgets/loading_indicator.dart';

class BudCommonItemsPage extends StatefulWidget {
  final String userId;
  final String username;

  const BudCommonItemsPage({
    Key? key,
    required this.userId,
    required this.username,
  }) : super(key: key);

  @override
  State<BudCommonItemsPage> createState() => _BudCommonItemsPageState();
}

class _BudCommonItemsPageState extends State<BudCommonItemsPage> {
  @override
  void initState() {
    super.initState();
    _loadCommonItems();
  }

  void _loadCommonItems() {
    context
        .read<BudCommonItemsBloc>()
        .add(BudCommonItemsRequested(widget.userId));
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
        title: Text('Common Items with ${widget.username}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context
                  .read<BudCommonItemsBloc>()
                  .add(BudCommonItemsRefreshRequested(widget.userId));
            },
          ),
        ],
      ),
      body: BlocConsumer<BudCommonItemsBloc, BudCommonItemsState>(
        listener: (context, state) {
          if (state is BudCommonItemsFailure) {
            _showErrorSnackBar(state.error);
          }
        },
        builder: (context, state) {
          if (state is BudCommonItemsInitial) {
            _loadCommonItems();
            return const LoadingIndicator();
          }

          if (state is BudCommonItemsLoading) {
            return const LoadingIndicator();
          }

          if (state is BudCommonItemsLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<BudCommonItemsBloc>()
                    .add(BudCommonItemsRefreshRequested(widget.userId));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HorizontalList(
                      title: 'Common Top Tracks',
                      items: state.commonTracks
                          .map((track) => TrackListItem(track: track))
                          .toList(),
                      onSeeAll: () {
                        // Navigate to full list of common top tracks
                      },
                    ),
                    HorizontalList(
                      title: 'Common Top Artists',
                      items: state.commonArtists
                          .map((artist) => ArtistListItem(artist: artist))
                          .toList(),
                      onSeeAll: () {
                        // Navigate to full list of common top artists
                      },
                    ),
                    HorizontalList(
                      title: 'Common Genres',
                      items: state.commonGenres
                          .map((genre) => GenreListItem(genre: genre))
                          .toList(),
                      onSeeAll: () {
                        // Navigate to full list of common genres
                      },
                    ),
                    HorizontalList(
                      title: 'Common Played Tracks',
                      items: state.commonPlayedTracks
                          .map((track) => TrackListItem(track: track))
                          .toList(),
                      onSeeAll: () {
                        // Navigate to full list of common played tracks
                      },
                    ),
                  ],
                ),
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
