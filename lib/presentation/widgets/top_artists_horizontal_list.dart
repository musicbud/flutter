import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'loading_indicator.dart';
import '../../../models/common_artist.dart';
import '../../blocs/top_artists/top_artists_bloc.dart';
import '../../blocs/top_artists/top_artists_event.dart';
import '../../blocs/top_artists/top_artists_state.dart';
import '../../../core/theme/design_system.dart';
import 'common/modern_button.dart';
import 'factories/card_factory.dart';
import 'mixins/interaction/hover_mixin.dart';
import 'mixins/interaction/focus_mixin.dart';

class TopArtistsHorizontalList extends StatefulWidget {
  const TopArtistsHorizontalList({
    super.key,
    this.enableHover = true,
    this.enableFocus = true,
    this.showLoadMoreButton = false,
  });

  final bool enableHover;
  final bool enableFocus;
  final bool showLoadMoreButton;

  @override
  State<TopArtistsHorizontalList> createState() =>
      _TopArtistsHorizontalListState();
}

class _TopArtistsHorizontalListState extends State<TopArtistsHorizontalList>
    with HoverMixin<TopArtistsHorizontalList>, FocusMixin<TopArtistsHorizontalList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadTopArtists();
    if (!widget.showLoadMoreButton) {
      _scrollController.addListener(_onScroll);
    }
    if (widget.enableHover) {
      setupHover(
        onHover: () {},
        onExit: () {},
        enableScaleAnimation: false,
      );
    }
    if (widget.enableFocus) {
      setupFocus(
        onFocus: () {},
        onUnfocus: () {},
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadTopArtists() {
    context.read<TopArtistsBloc>().add(const TopArtistsRequested());
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      context.read<TopArtistsBloc>().add(const TopArtistsLoadMoreRequested());
    }
  }

  void _loadMore() {
    context.read<TopArtistsBloc>().add(const TopArtistsLoadMoreRequested());
  }

  Widget _buildArtistCard(CommonArtist artist) {
    return CardFactory().createArtistCard(
      context: context,
      name: artist.name,
      genre: artist.genres?.isNotEmpty == true ? artist.genres!.first : 'Unknown',
      followerCount: artist.followers != null ? '${artist.followers} followers' : '0 followers',
      imageUrl: artist.imageUrls?.isNotEmpty == true ? artist.imageUrls!.first : '',
      onTap: () {
        // TODO: Navigate to artist details page when implemented
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Artist details for ${artist.name} coming soon!'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TopArtistsBloc, TopArtistsState>(
      listener: (context, state) {
        if (state is TopArtistsFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
        }
      },
      builder: (context, state) {
        if (state is TopArtistsInitial || state is TopArtistsLoading) {
          return const LoadingIndicator();
        }

        if (state is TopArtistsLoaded || state is TopArtistsLoadingMore) {
          final artists = state is TopArtistsLoaded
              ? state.artists
              : (state as TopArtistsLoadingMore).currentArtists;

          return Column(
            children: [
              SizedBox(
                height: 220,
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: DesignSystem.spacingMD),
                  itemCount: artists.length + (state is TopArtistsLoadingMore ? 1 : 0) +
                             (widget.showLoadMoreButton && state is TopArtistsLoaded && !state.hasReachedEnd ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == artists.length) {
                      if (state is TopArtistsLoadingMore) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: LoadingIndicator(),
                          ),
                        );
                      } else if (widget.showLoadMoreButton && state is TopArtistsLoaded && !state.hasReachedEnd) {
                        return Padding(
                          padding: const EdgeInsets.all(DesignSystem.spacingMD),
                          child: ModernButton(
                            text: 'Load More',
                            onPressed: _loadMore,
                            variant: ModernButtonVariant.outline,
                            size: ModernButtonSize.medium,
                          ),
                        );
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: DesignSystem.spacingMD),
                      child: _buildArtistCard(artists[index].toCommonArtist()),
                    );
                  },
                ),
              ),
              if (state is TopArtistsLoaded && state.hasReachedEnd)
                Padding(
                  padding: const EdgeInsets.all(DesignSystem.spacingMD),
                  child: Text(
                    'No more artists to load',
                    style: DesignSystem.bodySmall.copyWith(
                      color: DesignSystem.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          );
        }

        return Center(
          child: Text(
            'Failed to load top artists',
            style: DesignSystem.bodyMedium.copyWith(
              color: DesignSystem.onSurface,
            ),
          ),
        );
      },
    );
  }
}