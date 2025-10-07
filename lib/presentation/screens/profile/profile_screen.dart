import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/user_profile/user_profile_bloc.dart';
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

  // Top content data
  List<dynamic> _topTracks = [];
  List<dynamic> _topArtists = [];
  List<dynamic> _topGenres = [];

  // Liked content data
  List<dynamic> _likedTracks = [];
  List<dynamic> _likedArtists = [];
  List<dynamic> _likedGenres = [];

  @override
  void initState() {
    super.initState();
    _navigationController = MainNavigationController();
    // Load user profile when page initializes
    context.read<UserProfileBloc>().add(FetchMyProfile());
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
        context.read<UserProfileBloc>().add(FetchMyProfile());
        break;
      case 1:
        // Top items - fetch all top content
        context.read<UserProfileBloc>().add(FetchMyTopContent(contentType: 'tracks'));
        context.read<UserProfileBloc>().add(FetchMyTopContent(contentType: 'artists'));
        context.read<UserProfileBloc>().add(FetchMyTopContent(contentType: 'genres'));
        break;
      case 2:
        // Liked items
        context.read<UserProfileBloc>().add(FetchMyLikedContent(contentType: 'tracks'));
        context.read<UserProfileBloc>().add(FetchMyLikedContent(contentType: 'artists'));
        context.read<UserProfileBloc>().add(FetchMyLikedContent(contentType: 'genres'));
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
    final designSystemSpacing = Theme.of(context).designSystemSpacing!;
    final designSystemGradients = Theme.of(context).designSystemGradients!;

    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: designSystemColors.error,
            ),
          );
        } else if (state is UserProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile updated successfully'),
              backgroundColor: designSystemColors.success,
            ),
          );
          // Refresh profile after update
          context.read<UserProfileBloc>().add(FetchMyProfile());
        }
      },
      child: BlocBuilder<UserProfileBloc, UserProfileState>(
        builder: (context, state) {
          // Update content lists when MyContentLoaded is received
          if (state is MyContentLoaded) {
            switch (state.contentType) {
              case 'tracks':
                if (_selectedIndex == 1) {
                  _topTracks = state.content;
                } else if (_selectedIndex == 2) {
                  _likedTracks = state.content;
                }
                break;
              case 'artists':
                if (_selectedIndex == 1) {
                  _topArtists = state.content;
                } else if (_selectedIndex == 2) {
                  _likedArtists = state.content;
                }
                break;
              case 'genres':
                if (_selectedIndex == 1) {
                  _topGenres = state.content;
                } else if (_selectedIndex == 2) {
                  _likedGenres = state.content;
                }
                break;
            }
          }

          return Scaffold(
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
              child: _buildBody(state),
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
          );
        },
      ),
    );
  }

  Widget _buildBody(UserProfileState state) {
    switch (_selectedIndex) {
      case 0:
        return _buildProfileTab(state);
      case 1:
        return _buildTopTab(state);
      case 2:
        return _buildLikedTab(state);
      case 3:
        return _buildBudsTab(state);
      default:
        return _buildProfileTab(state);
    }
  }

  Widget _buildProfileTab(UserProfileState state) {
    final designSystemSpacing = Theme.of(context).designSystemSpacing!;
    return CustomScrollView(
      slivers: [
        // Profile Header Section
        SliverToBoxAdapter(
          child: ProfileHeaderWidget(
            userProfile: state is UserProfileLoaded ? state.userProfile : null,
            isLoading: state is UserProfileLoading,
            hasError: state is UserProfileError,
          ),
        ),

        // Profile Sections
        if (state is UserProfileLoaded) ...[
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
    );
  }

  Widget _buildTopTab(UserProfileState state) {
    final designSystemSpacing = Theme.of(context).designSystemSpacing!;

    return CustomScrollView(
      slivers: [
        // Top Tracks Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: designSystemSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Top Tracks'),
                SizedBox(height: designSystemSpacing.md),
                _buildTopTracksList(),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: designSystemSpacing.xl)),

        // Top Artists Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: designSystemSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Top Artists'),
                SizedBox(height: designSystemSpacing.md),
                _buildTopArtistsList(),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: designSystemSpacing.xl)),

        // Top Genres Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: designSystemSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Top Genres'),
                SizedBox(height: designSystemSpacing.md),
                _buildTopGenresList(),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: designSystemSpacing.xl)),
      ],
    );
  }

  Widget _buildTopTracksList() {
    if (_topTracks.isEmpty) {
      return const Text('No top tracks available');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _topTracks.length,
      itemBuilder: (context, index) {
        final track = _topTracks[index];
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

  Widget _buildTopArtistsList() {
    if (_topArtists.isEmpty) {
      return const Text('No top artists available');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _topArtists.length,
      itemBuilder: (context, index) {
        final artist = _topArtists[index];
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

  Widget _buildTopGenresList() {
    if (_topGenres.isEmpty) {
      return const Text('No top genres available');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _topGenres.length,
      itemBuilder: (context, index) {
        final genre = _topGenres[index];
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

  Widget _buildLikedTab(UserProfileState state) {
    final designSystemSpacing = Theme.of(context).designSystemSpacing!;

    return CustomScrollView(
      slivers: [
        // Liked Tracks Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: designSystemSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Liked Tracks'),
                SizedBox(height: designSystemSpacing.md),
                _buildLikedTracksList(),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: designSystemSpacing.xl)),

        // Liked Artists Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: designSystemSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Liked Artists'),
                SizedBox(height: designSystemSpacing.md),
                _buildLikedArtistsList(),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: designSystemSpacing.xl)),

        // Liked Genres Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: designSystemSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Liked Genres'),
                SizedBox(height: designSystemSpacing.md),
                _buildLikedGenresList(),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: designSystemSpacing.xl)),
      ],
    );
  }

  Widget _buildLikedTracksList() {
    if (_likedTracks.isEmpty) {
      return const Text('No liked tracks available');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _likedTracks.length,
      itemBuilder: (context, index) {
        final track = _likedTracks[index];
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

  Widget _buildLikedArtistsList() {
    if (_likedArtists.isEmpty) {
      return const Text('No liked artists available');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _likedArtists.length,
      itemBuilder: (context, index) {
        final artist = _likedArtists[index];
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

  Widget _buildLikedGenresList() {
    if (_likedGenres.isEmpty) {
      return const Text('No liked genres available');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _likedGenres.length,
      itemBuilder: (context, index) {
        final genre = _likedGenres[index];
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

  Widget _buildBudsTab(UserProfileState state) {
    // Placeholder for buds
    return const Center(child: Text('Buds Coming Soon'));
  }
}