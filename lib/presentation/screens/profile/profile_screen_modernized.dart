import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/user/profile/profile_bloc.dart';
import '../../../blocs/user/profile/profile_event.dart';
import '../../../blocs/user/profile/profile_state.dart';
import '../../widgets/imported/index.dart';
import '../../../presentation/navigation/main_navigation.dart';
import '../../../presentation/navigation/navigation_drawer.dart';
import 'profile_header_widget.dart';
import 'profile_music_widget.dart';
import 'profile_activity_widget.dart';
import 'profile_settings_widget.dart';
import 'artist_details_screen.dart';
import 'genre_details_screen.dart';
import 'track_details_screen.dart';

class ModernizedProfileScreen extends StatefulWidget {
  const ModernizedProfileScreen({super.key});

  @override
  State<ModernizedProfileScreen> createState() => _ModernizedProfileScreenState();
}

class _ModernizedProfileScreenState extends State<ModernizedProfileScreen>
    with LoadingStateMixin, ErrorStateMixin, TickerProviderStateMixin {
  
  late final MainNavigationController _navigationController;
  late final TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _navigationController = MainNavigationController();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _initializeData();
  }

  @override
  void dispose() {
    _navigationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _initializeData() {
    setLoadingState(LoadingState.loading);
    context.read<ProfileBloc>().add(const GetProfile());
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    
    final newIndex = _tabController.index;
    if (newIndex == _selectedIndex) return;

    setState(() {
      _selectedIndex = newIndex;
    });

    // Load data based on tab
    switch (newIndex) {
      case 0:
        context.read<ProfileBloc>().add(const GetProfile());
        break;
      case 1:
        context.read<ProfileBloc>().add(TopTracksRequested());
        context.read<ProfileBloc>().add(TopArtistsRequested());
        context.read<ProfileBloc>().add(TopGenresRequested());
        break;
      case 2:
        context.read<ProfileBloc>().add(LikedTracksRequested());
        context.read<ProfileBloc>().add(LikedArtistsRequested());
        context.read<ProfileBloc>().add(LikedGenresRequested());
        break;
      case 3:
        context.read<ProfileBloc>().add(const BudProfileRequested('current_user'));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError || state is ProfileFailure) {
          final error = state is ProfileError ? state.error : (state as ProfileFailure).error;
          setError(
            error,
            type: ErrorType.server,
            retryable: true,
          );
          setLoadingState(LoadingState.error);
        } else if (state is ProfileUpdated) {
          setLoadingState(LoadingState.loaded);
          // Show success message
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
          // Refresh profile after update
          context.read<ProfileBloc>().add(const GetProfile());
        } else if (state is ProfileLoaded) {
          setLoadingState(LoadingState.loaded);
        }
      },
      builder: (context, state) {
        return AppScaffold(
          appBar: AppBar(
            title: const Text('Profile'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _initializeData,
                tooltip: 'Refresh Profile',
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(icon: Icon(Icons.person), text: 'Profile'),
                Tab(icon: Icon(Icons.trending_up), text: 'Top'),
                Tab(icon: Icon(Icons.favorite), text: 'Liked'),
                Tab(icon: Icon(Icons.people), text: 'Buds'),
              ],
            ),
          ),
          drawer: MainNavigationDrawer(
            navigationController: _navigationController,
          ),
          body: ResponsiveLayout(
            builder: (context, breakpoint) {
              switch (breakpoint) {
                case ResponsiveBreakpoint.xs:
                case ResponsiveBreakpoint.sm:
                  return _buildMobileLayout();
                case ResponsiveBreakpoint.md:
                  return _buildTabletLayout();
                case ResponsiveBreakpoint.lg:
                case ResponsiveBreakpoint.xl:
                  return _buildDesktopLayout();
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildProfileTab(),
              _buildTopTab(),
              _buildLikedTab(),
              _buildBudsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildProfileTab(),
              _buildTopTab(),
              _buildLikedTab(),
              _buildBudsTab(),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: _buildSidebar(),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: _buildSidebar(),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildProfileTab(),
              _buildTopTab(),
              _buildLikedTab(),
              _buildBudsTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebar() {
    return ModernCard(
      variant: ModernCardVariant.outlined,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Stats',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatItem('Total Plays', '1,234'),
            _buildStatItem('Favorite Artists', '42'),
            _buildStatItem('Liked Songs', '156'),
            _buildStatItem('Connected Buds', '8'),
            const SizedBox(height: 24),
            ModernButton(
              text: 'Edit Profile',
              variant: ModernButtonVariant.text,
              onPressed: () => _showComingSoon('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    return buildLoadingState(
      context: context,
      loadedWidget: RefreshIndicator(
        onRefresh: () async {
          _initializeData();
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Profile Header Section
            SliverToBoxAdapter(
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  return ProfileHeaderWidget(
                    userProfile: state is ProfileLoaded ? state.profile : null,
                    isLoading: state is ProfileLoading,
                    hasError: state is ProfileError || state is ProfileFailure,
                  );
                },
              ),
            ),

            // Profile Sections
            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // My Music Section
            const SliverToBoxAdapter(
              child: ProfileMusicWidget(),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // Recent Activity Section  
            const SliverToBoxAdapter(
              child: ProfileActivityWidget(),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // Settings Section
            const SliverToBoxAdapter(
              child: ProfileSettingsWidget(),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),

            // Logout Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ModernButton(
                  text: 'Logout',
                  variant: ModernButtonVariant.text,
                  onPressed: () => _showLogoutDialog(),
                  icon: Icons.logout,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
      loadingWidget: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading your profile...',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
      errorWidget: buildDefaultErrorWidget(
        context: context,
        onRetry: _initializeData,
      ),
    );
  }

  Widget _buildTopTab() {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileBloc>().add(TopTracksRequested());
        context.read<ProfileBloc>().add(TopArtistsRequested());
        context.read<ProfileBloc>().add(TopGenresRequested());
        await Future.delayed(const Duration(seconds: 1));
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Top Tracks Section
          SliverToBoxAdapter(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final tracks = state is TopTracksLoaded ? state.tracks : [];
                final isLoading = state is ProfileLoading;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ModernCard(
                    variant: ModernCardVariant.elevated,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(title: 'Top Tracks'),
                        const SizedBox(height: 16),
                        _buildTopTracksList(tracks, isLoading),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Top Artists Section
          SliverToBoxAdapter(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final artists = state is TopArtistsLoaded ? state.artists : [];
                final isLoading = state is ProfileLoading;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ModernCard(
                    variant: ModernCardVariant.elevated,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(title: 'Top Artists'),
                        const SizedBox(height: 16),
                        _buildTopArtistsList(artists, isLoading),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Top Genres Section
          SliverToBoxAdapter(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final genres = state is TopGenresLoaded ? state.genres : [];
                final isLoading = state is ProfileLoading;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ModernCard(
                    variant: ModernCardVariant.elevated,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(title: 'Top Genres'),
                        const SizedBox(height: 16),
                        _buildTopGenresList(genres, isLoading),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildTopTracksList(List<dynamic> tracks, bool isLoading) {
    if (isLoading) {
      return const Column(
        children: [
          LoadingIndicator(),
          SizedBox(height: 8),
          Text('Loading top tracks...'),
        ],
      );
    }
    if (tracks.isEmpty) {
      return EmptyState(
        icon: Icons.music_note,
        title: 'No top tracks yet',
        message: 'Start listening to see your top tracks here',
        actionText: 'Discover Music',
        actionCallback: () => _showComingSoon('Music Discovery'),
      );
    }

    return Column(
      children: tracks.take(5).map((track) => ModernCard(
        variant: ModernCardVariant.primary,
        margin: const EdgeInsets.only(bottom: 8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackDetailsScreen(track: track),
            ),
          );
        },
        child: ListTile(
          leading: const Icon(Icons.music_note),
          title: Text(track.name ?? 'Unknown Track'),
          subtitle: Text(track.artistName ?? 'Unknown Artist'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      )).toList(),
    );
  }

  Widget _buildTopArtistsList(List<dynamic> artists, bool isLoading) {
    if (isLoading) {
      return const Column(
        children: [
          LoadingIndicator(),
          SizedBox(height: 8),
          Text('Loading top artists...'),
        ],
      );
    }
    if (artists.isEmpty) {
      return EmptyState(
        icon: Icons.person,
        title: 'No top artists yet',
        message: 'Listen to your favorite artists to see them here',
        actionText: 'Discover Artists',
        actionCallback: () => _showComingSoon('Artist Discovery'),
      );
    }

    return Column(
      children: artists.take(5).map((artist) => ModernCard(
        variant: ModernCardVariant.primary,
        margin: const EdgeInsets.only(bottom: 8),
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
        child: ListTile(
          leading: const Icon(Icons.person),
          title: Text(artist.name ?? 'Unknown Artist'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      )).toList(),
    );
  }

  Widget _buildTopGenresList(List<dynamic> genres, bool isLoading) {
    if (isLoading) {
      return const Column(
        children: [
          LoadingIndicator(),
          SizedBox(height: 8),
          Text('Loading top genres...'),
        ],
      );
    }
    if (genres.isEmpty) {
      return EmptyState(
        icon: Icons.category,
        title: 'No top genres yet',
        message: 'Explore different genres to see your preferences',
        actionText: 'Browse Genres',
        actionCallback: () => _showComingSoon('Genre Browser'),
      );
    }

    return Column(
      children: genres.take(5).map((genre) => ModernCard(
        variant: ModernCardVariant.primary,
        margin: const EdgeInsets.only(bottom: 8),
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
        child: ListTile(
          leading: const Icon(Icons.category),
          title: Text(genre.name ?? 'Unknown Genre'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      )).toList(),
    );
  }

  Widget _buildLikedTab() {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProfileBloc>().add(LikedTracksRequested());
        context.read<ProfileBloc>().add(LikedArtistsRequested());
        context.read<ProfileBloc>().add(LikedGenresRequested());
        await Future.delayed(const Duration(seconds: 1));
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Liked Tracks Section
          SliverToBoxAdapter(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final tracks = state is LikedTracksLoaded ? state.tracks : [];
                final isLoading = state is ProfileLoading;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ModernCard(
                    variant: ModernCardVariant.elevated,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(title: 'Liked Tracks'),
                        const SizedBox(height: 16),
                        _buildLikedTracksList(tracks, isLoading),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Liked Artists Section
          SliverToBoxAdapter(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final artists = state is LikedArtistsLoaded ? state.artists : [];
                final isLoading = state is ProfileLoading;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ModernCard(
                    variant: ModernCardVariant.elevated,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(title: 'Liked Artists'),
                        const SizedBox(height: 16),
                        _buildLikedArtistsList(artists, isLoading),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),

          // Liked Genres Section
          SliverToBoxAdapter(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                final genres = state is LikedGenresLoaded ? state.genres : [];
                final isLoading = state is ProfileLoading;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ModernCard(
                    variant: ModernCardVariant.elevated,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SectionHeader(title: 'Liked Genres'),
                        const SizedBox(height: 16),
                        _buildLikedGenresList(genres, isLoading),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }

  Widget _buildLikedTracksList(List<dynamic> tracks, bool isLoading) {
    if (isLoading) {
      return const Column(
        children: [
          LoadingIndicator(),
          SizedBox(height: 8),
          Text('Loading liked tracks...'),
        ],
      );
    }
    if (tracks.isEmpty) {
      return EmptyState(
        icon: Icons.favorite,
        title: 'No liked tracks yet',
        message: 'Like songs to see them here',
        actionText: 'Discover Music',
        actionCallback: () => _showComingSoon('Music Discovery'),
      );
    }

    return Column(
      children: tracks.take(10).map((track) => ModernCard(
        variant: ModernCardVariant.primary,
        margin: const EdgeInsets.only(bottom: 8),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TrackDetailsScreen(track: track),
            ),
          );
        },
        child: ListTile(
          leading: const Icon(Icons.favorite, color: Colors.red),
          title: Text(track.name ?? 'Unknown Track'),
          subtitle: Text(track.artistName ?? 'Unknown Artist'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      )).toList(),
    );
  }

  Widget _buildLikedArtistsList(List<dynamic> artists, bool isLoading) {
    if (isLoading) {
      return const Column(
        children: [
          LoadingIndicator(),
          SizedBox(height: 8),
          Text('Loading liked artists...'),
        ],
      );
    }
    if (artists.isEmpty) {
      return EmptyState(
        icon: Icons.favorite,
        title: 'No liked artists yet',
        message: 'Follow artists to see them here',
        actionText: 'Discover Artists',
        actionCallback: () => _showComingSoon('Artist Discovery'),
      );
    }

    return Column(
      children: artists.take(10).map((artist) => ModernCard(
        variant: ModernCardVariant.primary,
        margin: const EdgeInsets.only(bottom: 8),
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
        child: ListTile(
          leading: const Icon(Icons.favorite, color: Colors.red),
          title: Text(artist.name ?? 'Unknown Artist'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      )).toList(),
    );
  }

  Widget _buildLikedGenresList(List<dynamic> genres, bool isLoading) {
    if (isLoading) {
      return const Column(
        children: [
          LoadingIndicator(),
          SizedBox(height: 8),
          Text('Loading liked genres...'),
        ],
      );
    }
    if (genres.isEmpty) {
      return EmptyState(
        icon: Icons.favorite,
        title: 'No liked genres yet',
        message: 'Explore genres and like your favorites',
        actionText: 'Browse Genres',
        actionCallback: () => _showComingSoon('Genre Browser'),
      );
    }

    return Column(
      children: genres.take(10).map((genre) => ModernCard(
        variant: ModernCardVariant.primary,
        margin: const EdgeInsets.only(bottom: 8),
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
        child: ListTile(
          leading: const Icon(Icons.favorite, color: Colors.red),
          title: Text(genre.name ?? 'Unknown Genre'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        ),
      )).toList(),
    );
  }

  Widget _buildBudsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: EmptyState(
        icon: Icons.people,
        title: 'Connect with Music Buds',
        message: 'Find friends who share your musical taste and discover new music together',
        actionText: 'Find Buds',
        actionCallback: () => _showComingSoon('Bud Matching'),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ModernButton(
            text: 'Logout',
            variant: ModernButtonVariant.text,
            onPressed: () {
              Navigator.of(context).pop();
              _showComingSoon('Logout functionality');
            },
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  VoidCallback? get retryLoading => _initializeData;

  @override
  VoidCallback? get onLoadingStarted => () {
    if (mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  };

  @override
  VoidCallback? get onLoadingCompleted => () {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated!'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  };
}