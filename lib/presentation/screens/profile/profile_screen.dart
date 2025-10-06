import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/user_profile/user_profile_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../widgets/common/app_button.dart';
import '../../../widgets/common/index.dart';
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
    // Load user profile when page initializes
    context.read<UserProfileBloc>().add(FetchMyProfile());
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
    final appTheme = AppTheme.of(context);

    return BlocListener<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: appTheme.colors.errorRed,
            ),
          );
        } else if (state is UserProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Profile updated successfully'),
              backgroundColor: appTheme.colors.successGreen,
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
            body: Container(
              decoration: BoxDecoration(
                gradient: appTheme.gradients.backgroundGradient,
              ),
              child: _buildBody(state),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onTabChanged,
              backgroundColor: appTheme.colors.surface,
              selectedItemColor: appTheme.colors.primary,
              unselectedItemColor: appTheme.colors.onSurfaceVariant,
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
    final appTheme = AppTheme.of(context);
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
          SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),

          // My Music Section
          SliverToBoxAdapter(
            child: ProfileMusicWidget(),
          ),

          SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),

          // Recent Activity Section
          SliverToBoxAdapter(
            child: ProfileActivityWidget(),
          ),

          SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),

          // Settings Section
          SliverToBoxAdapter(
            child: ProfileSettingsWidget(),
          ),

          SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),

          // Logout Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
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

          SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),
        ],
      ],
    );
  }

  Widget _buildTopTab(UserProfileState state) {
    final appTheme = AppTheme.of(context);

    return CustomScrollView(
      slivers: [
        // Top Tracks Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Top Tracks'),
                SizedBox(height: appTheme.spacing.md),
                _buildTopTracksList(),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),

        // Top Artists Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Top Artists'),
                SizedBox(height: appTheme.spacing.md),
                _buildTopArtistsList(),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),

        // Top Genres Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Top Genres'),
                SizedBox(height: appTheme.spacing.md),
                _buildTopGenresList(),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),
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
    final appTheme = AppTheme.of(context);

    return CustomScrollView(
      slivers: [
        // Liked Tracks Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Liked Tracks'),
                SizedBox(height: appTheme.spacing.md),
                _buildLikedTracksList(),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),

        // Liked Artists Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Liked Artists'),
                SizedBox(height: appTheme.spacing.md),
                _buildLikedArtistsList(),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),

        // Liked Genres Section
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: appTheme.spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SectionHeader(title: 'Liked Genres'),
                SizedBox(height: appTheme.spacing.md),
                _buildLikedGenresList(),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(child: SizedBox(height: appTheme.spacing.xl)),
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