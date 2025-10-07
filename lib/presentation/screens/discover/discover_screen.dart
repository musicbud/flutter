import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/content/content_bloc.dart';
import '../../../blocs/content/content_event.dart';
import '../../../blocs/content/content_state.dart';
import '../../../core/theme/design_system.dart';
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
    context.read<ContentBloc>().add(LoadTopContent());
  }

  @override
  void dispose() {
    _navigationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ContentBloc, ContentState>(
      listener: (context, state) {
        if (state is ContentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading content: ${state.message}'),
              backgroundColor: DesignSystem.error,
            ),
          );
        }
      },
      child: BlocBuilder<ContentBloc, ContentState>(
        builder: (context, state) {
          return Scaffold(
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
                          context.read<ContentBloc>().add(
                            SearchContent(query: query, type: _selectedCategory.toLowerCase()),
                          );
                        }
                      },
                    ),
                  ),

                  // Featured Artists Section
                  SliverToBoxAdapter(
                    child: FeaturedArtistsSection(
                      artists: state is ContentLoaded ? state.topArtists : [],
                      isLoading: state is ContentLoading,
                      onViewAllPressed: () {
                        // Navigate to all artists
                        Navigator.pushNamed(context, '/artists');
                      },
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: DesignSystem.spacingXL),
                  ),

                  // Trending Tracks Section
                  SliverToBoxAdapter(
                    child: TrendingTracksSection(
                      tracks: state is ContentLoaded ? state.topTracks : [],
                      isLoading: state is ContentLoading,
                      onViewAllPressed: () {
                        // Navigate to all tracks
                        Navigator.pushNamed(context, '/tracks');
                      },
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: DesignSystem.spacingXL),
                  ),

                  // New Releases Section
                  SliverToBoxAdapter(
                    child: NewReleasesSection(
                      albums: state is ContentLoaded ? state.likedAlbums ?? [] : [],
                      isLoading: state is ContentLoading,
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
          );
        },
      ),
    );
  }
}