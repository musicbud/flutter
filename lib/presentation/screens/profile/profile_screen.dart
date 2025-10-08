import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/user/profile/profile_bloc.dart';
import '../../../blocs/user/profile/profile_event.dart';
import '../../../blocs/user/profile/profile_state.dart';
import '../../../core/theme/design_system.dart';
import '../../../widgets/common/index.dart';
import '../../../presentation/navigation/main_navigation.dart';
import '../../../presentation/navigation/navigation_drawer.dart';
import 'profile_header_widget.dart';
import 'profile_music_widget.dart';
import 'profile_activity_widget.dart';
import 'profile_settings_widget.dart';
import 'artist_details_screen.dart';
import 'genre_details_screen.dart';
import 'track_details_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late final MainNavigationController _navigationController;
  int _selectedIndex = 0;


  @override
  void initState() {
    super.initState();
    _navigationController = MainNavigationController();
    // Load user profile when page initializes
    context.read<ProfileBloc>().add(const GetProfile());
  }

  @override
  void dispose() {
    _navigationController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Load data based on tab
    switch (index) {
      case 0:
        context.read<ProfileBloc>().add(const GetProfile());
        break;
      case 1:
        // Top items - fetch all top content
        context.read<ProfileBloc>().add(TopTracksRequested());
        context.read<ProfileBloc>().add(TopArtistsRequested());
        context.read<ProfileBloc>().add(TopGenresRequested());
        break;
      case 2:
        // Liked items
        context.read<ProfileBloc>().add(LikedTracksRequested());
        context.read<ProfileBloc>().add(LikedArtistsRequested());
        context.read<ProfileBloc>().add(LikedGenresRequested());
        break;
      case 3:
        // Buds - fetch buds list (assuming there's a way)
        // For now, placeholder
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final designSystemColors = Theme.of(context).designSystemColors!;
    final designSystemGradients = Theme.of(context).designSystemGradients!;

    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError || state is ProfileFailure) {
          final error = state is ProfileError ? state.error : (state as ProfileFailure).error;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $error'),
              backgroundColor: designSystemColors.error,
            ),
          );
        } else if (state is ProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile updated successfully'),
              backgroundColor: designSystemColors.success,
            ),
          );
          // Refresh profile after update
          context.read<ProfileBloc>().add(const GetProfile());
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Profile'),
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
          decoration: BoxDecoration(
            gradient: designSystemGradients.background,
          ),
          child: _buildBody(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabChanged,
          backgroundColor: designSystemColors.surface,
          selectedItemColor: designSystemColors.primary,
          unselectedItemColor: designSystemColors.onSurfaceVariant,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              label: 'Top',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Liked',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Buds',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildProfileTab();
      case 1:
        return _buildTopTab();
      case 2:
        return _buildLikedTab();
      case 3:
        return _buildBudsTab();
      default:
        return _buildProfileTab();
    }
  }

  Widget _buildProfileTab() {
    final designSystemSpacing = Theme.of(context).designSystemSpacing!;
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<ProfileBloc>().add(const GetProfile());
          },
          child: CustomScrollView(
            slivers: [
              // Profile Header Section
              SliverToBoxAdapter(
                child: ProfileHeaderWidget(
                  userProfile: state is ProfileLoaded ? state.profile : null,
                  isLoading: state is ProfileLoading,
                  hasError: state is ProfileError || state is ProfileFailure,
                ),
              ),

              // Profile Sections
              if (state is ProfileLoaded) ...[
                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // My Music Section
                  SliverToBoxAdapter(
                    child: const ProfileMusicWidget(),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // Recent Activity Section
                  SliverToBoxAdapter(
                    child: const ProfileActivityWidget(),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // Settings Section
                  SliverToBoxAdapter(
                    child: const ProfileSettingsWidget(),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),

                  // Logout Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: designSystemSpacing.lg),
                      child: AppButton.secondary(
                        text: 'Logout',
                        onPressed: () {
                          // Handle logout
                        },
                        icon: Icons.logout,
                        size: AppButtonSize.large,
                        width: double.infinity,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopTab() {
    final designSystemSpacing = Theme.of(context).designSystemSpacing!;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileBloc>().add(TopTracksRequested());
        context.read<ProfileBloc>().add(TopArtistsRequested());
        context.read<ProfileBloc>().add(TopGenresRequested());
      },
      child: CustomScrollView(
        slivers: [
          // Top Tracks Section
          SliverToBoxAdapter(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final tracks = state is TopTracksLoaded ? state.tracks : [];
                final isLoading = state is ProfileLoading;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: designSystemSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Top Tracks'),
                      SizedBox(height: designSystemSpacing.md),
                      _buildTopTracksList(tracks, isLoading),
                    ],
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: designSystemSpacing.xl)),

          // Top Artists Section
          SliverToBoxAdapter(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final artists = state is TopArtistsLoaded ? state.artists : [];
                final isLoading = state is ProfileLoading;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: designSystemSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Top Artists'),
                      SizedBox(height: designSystemSpacing.md),
                      _buildTopArtistsList(artists, isLoading),
                    ],
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: designSystemSpacing.xl)),

          // Top Genres Section
          SliverToBoxAdapter(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final genres = state is TopGenresLoaded ? state.genres : [];
                final isLoading = state is ProfileLoading;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: designSystemSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Top Genres'),
                      SizedBox(height: designSystemSpacing.md),
                      _buildTopGenresList(genres, isLoading),
                    ],
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: designSystemSpacing.xl)),
        ],
      ),
    );
  }

  Widget _buildTopTracksList(List<dynamic> tracks, bool isLoading) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (tracks.isEmpty) {
      return const Text('No top tracks available');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        return ListTile(
          title: Text(track.name ?? 'Unknown Track'),
          subtitle: Text(track.artistName ?? 'Unknown Artist'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrackDetailsScreen(track: track),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTopArtistsList(List<dynamic> artists, bool isLoading) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (artists.isEmpty) {
      return const Text('No top artists available');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        final artist = artists[index];
        return ListTile(
          title: Text(artist.name ?? 'Unknown Artist'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArtistDetailsScreen(
                  artistId: artist.id ?? '',
                  artistName: artist.name ?? 'Unknown Artist',
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTopGenresList(List<dynamic> genres, bool isLoading) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (genres.isEmpty) {
      return const Text('No top genres available');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: genres.length,
      itemBuilder: (context, index) {
        final genre = genres[index];
        return ListTile(
          title: Text(genre.name ?? 'Unknown Genre'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GenreDetailsScreen(
                  genreId: genre.name ?? '',
                  genreName: genre.name ?? 'Unknown Genre',
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLikedTab() {
    final designSystemSpacing = Theme.of(context).designSystemSpacing!;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileBloc>().add(LikedTracksRequested());
        context.read<ProfileBloc>().add(LikedArtistsRequested());
        context.read<ProfileBloc>().add(LikedGenresRequested());
      },
      child: CustomScrollView(
        slivers: [
          // Liked Tracks Section
          SliverToBoxAdapter(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final tracks = state is LikedTracksLoaded ? state.tracks : [];
                final isLoading = state is ProfileLoading;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: designSystemSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Liked Tracks'),
                      SizedBox(height: designSystemSpacing.md),
                      _buildLikedTracksList(tracks, isLoading),
                    ],
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: designSystemSpacing.xl)),

          // Liked Artists Section
          SliverToBoxAdapter(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final artists = state is LikedArtistsLoaded ? state.artists : [];
                final isLoading = state is ProfileLoading;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: designSystemSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Liked Artists'),
                      SizedBox(height: designSystemSpacing.md),
                      _buildLikedArtistsList(artists, isLoading),
                    ],
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: designSystemSpacing.xl)),

          // Liked Genres Section
          SliverToBoxAdapter(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final genres = state is LikedGenresLoaded ? state.genres : [];
                final isLoading = state is ProfileLoading;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: designSystemSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SectionHeader(title: 'Liked Genres'),
                      SizedBox(height: designSystemSpacing.md),
                      _buildLikedGenresList(genres, isLoading),
                    ],
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: designSystemSpacing.xl)),
        ],
      ),
    );
  }

  Widget _buildLikedTracksList(List<dynamic> tracks, bool isLoading) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (tracks.isEmpty) {
      return const Text('No liked tracks available');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tracks.length,
      itemBuilder: (context, index) {
        final track = tracks[index];
        return ListTile(
          title: Text(track.name ?? 'Unknown Track'),
          subtitle: Text(track.artistName ?? 'Unknown Artist'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TrackDetailsScreen(track: track),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLikedArtistsList(List<dynamic> artists, bool isLoading) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (artists.isEmpty) {
      return const Text('No liked artists available');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: artists.length,
      itemBuilder: (context, index) {
        final artist = artists[index];
        return ListTile(
          title: Text(artist.name ?? 'Unknown Artist'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArtistDetailsScreen(
                  artistId: artist.id ?? '',
                  artistName: artist.name ?? 'Unknown Artist',
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildLikedGenresList(List<dynamic> genres, bool isLoading) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (genres.isEmpty) {
      return const Text('No liked genres available');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: genres.length,
      itemBuilder: (context, index) {
        final genre = genres[index];
        return ListTile(
          title: Text(genre.name ?? 'Unknown Genre'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GenreDetailsScreen(
                  genreId: genre.name ?? '',
                  genreName: genre.name ?? 'Unknown Genre',
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildBudsTab() {
    // Placeholder for buds - could integrate with BudMatchingBloc here
    return const Center(child: Text('Buds Coming Soon'));
  }
}