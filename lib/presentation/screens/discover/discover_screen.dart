import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/content/content_bloc.dart';
import '../../../blocs/content/content_event.dart';
import '../../../blocs/content/content_state.dart';
import '../../../core/theme/app_theme.dart';
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
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    // Load dynamic content when screen initializes
    context.read<ContentBloc>().add(LoadTopContent());
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = AppTheme.of(context);

    return BlocListener<ContentBloc, ContentState>(
      listener: (context, state) {
        if (state is ContentError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error loading content: ${state.message}'),
              backgroundColor: appTheme.colors.errorRed,
            ),
          );
        }
      },
      child: BlocBuilder<ContentBloc, ContentState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: appTheme.gradients.backgroundGradient,
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

                SliverToBoxAdapter(
                  child: SizedBox(height: appTheme.spacing.xl),
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

                SliverToBoxAdapter(
                  child: SizedBox(height: appTheme.spacing.xl),
                ),

                // New Releases Section
                SliverToBoxAdapter(
                  child: NewReleasesSection(
                    albums: state is ContentLoaded ? state.likedAlbums ?? [] : [],
                    isLoading: state is ContentLoading,
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(height: appTheme.spacing.xl),
                ),

                // Discover More Section
                SliverToBoxAdapter(
                  child: DiscoverMoreSection(),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(height: appTheme.spacing.xl),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}