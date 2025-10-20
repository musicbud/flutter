import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/discover/discover_bloc.dart';
import '../../../blocs/discover/discover_event.dart';
import '../../../blocs/discover/discover_state.dart';
import '../../../core/theme/design_system.dart';
import '../../../models/artist.dart';
import '../../../models/track.dart';
import '../../../models/album.dart';
import '../../../presentation/navigation/main_navigation.dart';
import '../../../presentation/navigation/navigation_drawer.dart';
import 'discover_search_section.dart';
import 'sections/featured_artists_section.dart';
import 'sections/trending_tracks_section.dart';
import 'sections/new_releases_section.dart';
import 'sections/discover_more_section.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final MainNavigationController _navigationController;
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _navigationController = MainNavigationController();
    // Load dynamic content when screen initializes
    context.read<DiscoverBloc>().add(const FetchTopTracks());
    context.read<DiscoverBloc>().add(const FetchTopArtists());
    context.read<DiscoverBloc>().add(const FetchTopGenres());
    context.read<DiscoverBloc>().add(const FetchTopAnime());
    context.read<DiscoverBloc>().add(const FetchTopManga());
    context.read<DiscoverBloc>().add(const FetchLikedAlbums());
  }

  @override
  void dispose() {
    _navigationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DiscoverBloc, DiscoverState>(
      listener: (context, state) {
        if (state is DiscoverError ||
            state is TopTracksError ||
            state is TopArtistsError ||
            state is TopGenresError ||
            state is TopAnimeError ||
            state is TopMangaError ||
            state is LikedAlbumsError) {
          String message = 'Error loading content';
          if (state is DiscoverError) message = state.message;
          if (state is TopTracksError) message = 'Error loading tracks: ${state.message}';
          if (state is TopArtistsError) message = 'Error loading artists: ${state.message}';
          if (state is TopGenresError) message = 'Error loading genres: ${state.message}';
          if (state is TopAnimeError) message = 'Error loading anime: ${state.message}';
          if (state is TopMangaError) message = 'Error loading manga: ${state.message}';
          if (state is LikedAlbumsError) message = 'Error loading albums: ${state.message}';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: DesignSystem.error,
            ),
          );
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Discover'),
          leading: IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
        ),
        drawer: MainNavigationDrawer(
          navigationController: _navigationController,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: DesignSystem.gradientBackground,
          ),
          child: RefreshIndicator(
            onRefresh: () async {
              context.read<DiscoverBloc>().add(const FetchTopTracks());
              context.read<DiscoverBloc>().add(const FetchTopArtists());
              context.read<DiscoverBloc>().add(const FetchTopGenres());
              context.read<DiscoverBloc>().add(const FetchTopAnime());
              context.read<DiscoverBloc>().add(const FetchTopManga());
              context.read<DiscoverBloc>().add(const FetchLikedAlbums());
            },
            child: CustomScrollView(
              slivers: [
                // Search and Filter Section
                SliverToBoxAdapter(
                  child: DiscoverSearchSection(
                    selectedCategory: _selectedCategory,
                    onCategorySelected: (category) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    onSearch: (query) {
                      // Handle search functionality with API
                      if (query.isNotEmpty) {
                        // TODO: Implement search with DiscoverBloc
                      }
                    },
                  ),
                ),

                // Featured Artists Section
                SliverToBoxAdapter(
                  child: BlocBuilder<DiscoverBloc, DiscoverState>(
                    builder: (context, state) {
                      final artists = state is TopArtistsLoaded ? state.artists : <Artist>[];
                      final isLoading = state is TopArtistsLoading;
                      final hasError = state is TopArtistsError;
                      final errorMessage = hasError ? (state).message : null;
                      return FeaturedArtistsSection(
                        artists: artists,
                        isLoading: isLoading,
                        hasError: hasError,
                        errorMessage: errorMessage,
                        onViewAllPressed: () {
                          // Navigate to all artists
                          Navigator.pushNamed(context, '/artists');
                        },
                        onRetry: () {
                          context.read<DiscoverBloc>().add(const FetchTopArtists());
                        },
                      );
                    },
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: DesignSystem.spacingXL),
                ),

                // Trending Tracks Section
                SliverToBoxAdapter(
                  child: BlocBuilder<DiscoverBloc, DiscoverState>(
                    builder: (context, state) {
                      final tracks = state is TopTracksLoaded ? state.tracks : <Track>[];
                      final isLoading = state is TopTracksLoading;
                      final hasError = state is TopTracksError;
                      final errorMessage = hasError ? (state).message : null;
                      return TrendingTracksSection(
                        tracks: tracks,
                        isLoading: isLoading,
                        hasError: hasError,
                        errorMessage: errorMessage,
                        onViewAllPressed: () {
                          // Navigate to all tracks
                          Navigator.pushNamed(context, '/tracks');
                        },
                        onRetry: () {
                          context.read<DiscoverBloc>().add(const FetchTopTracks());
                        },
                      );
                    },
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: DesignSystem.spacingXL),
                ),

                // New Releases Section
                SliverToBoxAdapter(
                  child: BlocBuilder<DiscoverBloc, DiscoverState>(
                    builder: (context, state) {
                      final albums = state is LikedAlbumsLoaded ? state.albums : <Album>[];
                      final isLoading = state is LikedAlbumsLoading;
                      final hasError = state is LikedAlbumsError;
                      final errorMessage = hasError ? (state).message : null;
                      return NewReleasesSection(
                        albums: albums,
                        isLoading: isLoading,
                        hasError: hasError,
                        errorMessage: errorMessage,
                        onRetry: () {
                          context.read<DiscoverBloc>().add(const FetchLikedAlbums());
                        },
                      );
                    },
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: DesignSystem.spacingXL),
                ),

                // Discover More Section
                const SliverToBoxAdapter(
                  child: DiscoverMoreSection(),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: DesignSystem.spacingXL),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}