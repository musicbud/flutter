import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/bud_matching/bud_matching_bloc.dart';
import '../../../core/theme/design_system.dart';
import '../../../models/bud_match.dart';
import '../../../models/bud_search_result.dart';
import '../../../presentation/widgets/bud_match_list_item.dart';
import '../../../presentation/widgets/common/loading_indicator.dart';
import '../../../presentation/widgets/common/empty_state.dart';

class BudsScreen extends StatefulWidget {
  const BudsScreen({super.key});

  @override
  State<BudsScreen> createState() => _BudsScreenState();
}

class _BudsScreenState extends State<BudsScreen> {
  final List<Map<String, dynamic>> _contentTypes = [
    {'label': 'Top Artists', 'event': FindBudsByTopArtists()},
    {'label': 'Top Tracks', 'event': FindBudsByTopTracks()},
    {'label': 'Top Genres', 'event': FindBudsByTopGenres()},
    {'label': 'Top Anime', 'event': FindBudsByTopAnime()},
    {'label': 'Top Manga', 'event': FindBudsByTopManga()},
    {'label': 'Liked Artists', 'event': FindBudsByLikedArtists()},
    {'label': 'Liked Tracks', 'event': FindBudsByLikedTracks()},
    {'label': 'Liked Genres', 'event': FindBudsByLikedGenres()},
    {'label': 'Liked Albums', 'event': FindBudsByLikedAlbums()},
    {'label': 'Liked All-in-One', 'event': FindBudsByLikedAio()},
    {'label': 'Played Tracks', 'event': FindBudsByPlayedTracks()},
  ];

  BudMatchingEvent? _lastEvent;

  void _findBuds(BudMatchingEvent event) {
    _lastEvent = event;
    context.read<BudMatchingBloc>().add(event);
  }

  BudMatch _convertBudSearchItemToBudMatch(BudSearchItem item) {
    return BudMatch(
      id: item.uid,
      userId: item.uid,
      username: item.displayName,
      email: item.email,
      avatarUrl: null, // BudSearchItem doesn't have avatar URL
      matchScore: 0.0, // Calculate based on common counts if needed
      commonArtists: item.commonArtistsCount ?? 0,
      commonTracks: item.commonTracksCount ?? 0,
      commonGenres: item.commonGenresCount ?? 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Find Buds',
          style: DesignSystem.headlineSmall,
        ),
        backgroundColor: DesignSystem.surface,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Content Type Selection
          Container(
            padding: const EdgeInsets.all(DesignSystem.spacingLG),
            decoration: const BoxDecoration(
              color: DesignSystem.surface,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(DesignSystem.radiusLG),
                bottomRight: Radius.circular(DesignSystem.radiusLG),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Find buds by shared content',
                  style: DesignSystem.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: DesignSystem.spacingMD),
                Wrap(
                  spacing: DesignSystem.spacingSM,
                  runSpacing: DesignSystem.spacingSM,
                  children: _contentTypes.map((type) => ActionChip(
                    label: Text(type['label'] as String),
                    onPressed: () => _findBuds(type['event'] as BudMatchingEvent),
                    backgroundColor: DesignSystem.background,
                  )).toList(),
                ),
              ],
            ),
          ),

          // Results Section
          Expanded(
            child: BlocBuilder<BudMatchingBloc, BudMatchingState>(
              builder: (context, state) {
                Widget content;

                if (state is BudMatchingInitial) {
                  content = const EmptyState(
                    icon: Icons.people_outline,
                    title: 'Find Your Music Buds',
                    message: 'Select a content type to find people with similar tastes',
                  );
                } else if (state is BudMatchingLoading) {
                  content = const LoadingIndicator();
                } else if (state is BudsFound) {
                  if (state.searchResult.data.buds.isEmpty) {
                    content = const EmptyState(
                      icon: Icons.search_off,
                      title: 'No Buds Found',
                      message: 'Try a different content type',
                    );
                  } else {
                    content = ListView.builder(
                      padding: const EdgeInsets.all(DesignSystem.spacingMD),
                      itemCount: state.searchResult.data.buds.length,
                      itemBuilder: (context, index) {
                        final budItem = state.searchResult.data.buds[index];
                        final budMatch = _convertBudSearchItemToBudMatch(budItem);

                        return BudMatchListItem(budMatch: budMatch);
                      },
                    );
                  }
                } else if (state is BudMatchingError) {
                  content = EmptyState(
                    icon: Icons.error_outline,
                    title: 'Search Failed',
                    message: state.message,
                  );
                } else {
                  content = const SizedBox.shrink();
                }

                // Only add refresh indicator if there's a current search result
                if (state is BudsFound && _lastEvent != null) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<BudMatchingBloc>().add(_lastEvent!);
                    },
                    child: content,
                  );
                }

                return content;
              },
            ),
          ),
        ],
      ),
    );
  }
}