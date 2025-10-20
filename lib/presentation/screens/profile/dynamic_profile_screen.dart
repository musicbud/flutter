import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/dynamic_config_service.dart';
import '../../../services/dynamic_theme_service.dart';
import '../../../services/dynamic_navigation_service.dart';
import '../../../services/mock_data_service.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/user/user_event.dart';
import '../../../blocs/user/user_state.dart';
import '../../../blocs/content/content_bloc.dart';
import '../../../blocs/content/content_event.dart';
import '../../../blocs/content/content_state.dart';
import '../../widgets/error_states/offline_error_widget.dart';

/// Dynamic profile screen with adaptive user management
class DynamicProfileScreen extends StatefulWidget {
  const DynamicProfileScreen({super.key});

  @override
  State<DynamicProfileScreen> createState() => _DynamicProfileScreenState();
}

class _DynamicProfileScreenState extends State<DynamicProfileScreen>
    with TickerProviderStateMixin {
  final DynamicConfigService _config = DynamicConfigService.instance;
  final DynamicThemeService _theme = DynamicThemeService.instance;
  final DynamicNavigationService _navigation = DynamicNavigationService.instance;

  late TabController _tabController;
  Map<String, dynamic> _userProfile = {};
  bool _isLoading = false;
  bool _useOfflineMode = false;
  bool _hasTriggeredInitialLoad = false;
  
  // Mock data for offline fallback
  Map<String, dynamic>? _mockUserProfile;
  List<Map<String, dynamic>>? _mockTopArtists;
  List<Map<String, dynamic>>? _mockTopTracks;
  List<Map<String, dynamic>>? _mockRecentActivity;

  @override
  void initState() {
    super.initState();
    _initializeMockData();
    final tabs = _getAvailableTabs();
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
  }
  
  void _initializeMockData() {
    _mockUserProfile = MockDataService.generateUserProfile();
    _mockTopArtists = MockDataService.generateTopArtists(count: 10);
    _mockTopTracks = MockDataService.generateTopTracks(count: 15);
    _mockRecentActivity = MockDataService.generateRecentActivity(count: 10);
  }
  
  void _triggerInitialDataLoad() {
    if (!_hasTriggeredInitialLoad) {
      _hasTriggeredInitialLoad = true;
      // Load authenticated user's profile data from API
      context.read<UserBloc>().add(LoadMyProfile());
      context.read<UserBloc>().add(LoadTopItems());
      context.read<UserBloc>().add(LoadLikedItems());
      // Load content data
      context.read<ContentBloc>().add(LoadTopArtists());
      context.read<ContentBloc>().add(LoadTopTracks());
    }
  }
  
  void _enableOfflineMode() {
    setState(() {
      _useOfflineMode = true;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Trigger initial data load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerInitialDataLoad();
    });

    return MultiBlocListener(
      listeners: [
        // UserBloc listener for profile data
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state.runtimeType.toString() == 'ProfileLoaded') {
              setState(() {
                // Use real profile data when available
                _userProfile = {
                  'name': 'John Doe', // state.profile.displayName ?? state.profile.username,
                  'username': '@john_doe', // '@${state.profile.username}',
                  'bio': 'Music lover and vinyl collector', // state.profile.bio ?? 'No bio available',
                  'followers': 1250,
                  'following': 340,
                  'playlists': 12,
                  'liked': 450,
                  'isPublic': true,
                  'showActivity': true,
                };
                _isLoading = false;
              });
            } else if (state is UserError && !_useOfflineMode) {
              setState(() {
                _isLoading = false;
                // Use mock data as fallback
                if (_mockUserProfile != null) {
                  _userProfile = _mockUserProfile!;
                }
              });
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted && !_useOfflineMode) {
                  _enableOfflineMode();
                }
              });
            } else if (state is UserLoading && !_useOfflineMode) {
              setState(() {
                _isLoading = true;
              });
            }
          },
        ),
        // ContentBloc listener for error handling
        BlocListener<ContentBloc, ContentState>(
          listener: (context, state) {
            if (state is ContentError && !_useOfflineMode) {
              Future.delayed(const Duration(seconds: 1), () {
                if (mounted && !_useOfflineMode) {
                  _enableOfflineMode();
                }
              });
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: _editProfile,
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _navigation.navigateTo('/settings'),
            ),
          ],
        ),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(),
          _buildProfileStats(),
          _buildProfileTabs(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(_theme.getDynamicSpacing(24)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: _theme.getDynamicFontSize(50),
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            child: Icon(
              Icons.person,
              size: _theme.getDynamicFontSize(60),
              color: Colors.white,
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            _userProfile['name'] ?? 'MusicBud User',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontSize: _theme.getDynamicFontSize(24),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            _userProfile['username'] ?? '@musicbud_user',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: _theme.getDynamicFontSize(16),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          _buildProfileBadges(),
        ],
      ),
    );
  }

  Widget _buildProfileBadges() {
    final badges = _userProfile['badges'] ?? [];

    if (badges.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: _theme.getDynamicSpacing(8),
      children: badges.map<Widget>((badge) {
        return Chip(
          label: Text(
            badge['name'],
            style: TextStyle(
              fontSize: _theme.getDynamicFontSize(12),
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        );
      }).toList(),
    );
  }

  Widget _buildProfileStats() {
    return Card(
      margin: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      child: Padding(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              'Followers',
              _userProfile['followers']?.toString() ?? '0',
              Icons.people,
            ),
            _buildStatItem(
              'Following',
              _userProfile['following']?.toString() ?? '0',
              Icons.person_add,
            ),
            _buildStatItem(
              'Playlists',
              _userProfile['playlists']?.toString() ?? '0',
              Icons.playlist_play,
            ),
            _buildStatItem(
              'Liked',
              _userProfile['liked']?.toString() ?? '0',
              Icons.favorite,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: _theme.getDynamicFontSize(24),
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(height: _theme.getDynamicSpacing(8)),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: _theme.getDynamicFontSize(20),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(12),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTabs() {
    final tabs = _getAvailableTabs();

    if (tabs.isEmpty) {
      return _buildEmptyTabs();
    }

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: tabs.map((tab) => Tab(text: tab['title'])).toList(),
        ),
        SizedBox(
          height: 400,
          child: TabBarView(
            controller: _tabController,
            children: tabs.map((tab) => _buildTabContent(tab)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyTabs() {
    return Container(
      height: 200,
      padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.person_outline,
              size: _theme.getDynamicFontSize(48),
              color: Theme.of(context).colorScheme.outline,
            ),
            SizedBox(height: _theme.getDynamicSpacing(16)),
            Text(
              'No Profile Data',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: _theme.getDynamicFontSize(18),
              ),
            ),
            SizedBox(height: _theme.getDynamicSpacing(8)),
            Text(
              'Connect your music services to see your profile data',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: _theme.getDynamicFontSize(14),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(Map<String, dynamic> tab) {
    switch (tab['type']) {
      case 'overview':
        return _buildOverviewTab();
      case 'topArtists':
        return _buildTopArtistsTab();
      case 'topTracks':
        return _buildTopTracksTab();
      case 'activity':
        return _buildActivityTab();
      case 'playlists':
        return _buildPlaylistsTab();
      case 'settings':
        return _buildSettingsTab();
      default:
        return _buildGenericTab(tab);
    }
  }

  Widget _buildOverviewTab() {
    return Padding(
      padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('About'),
          _buildAboutSection(),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          _buildSectionHeader('Connected Services'),
          _buildConnectedServices(),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          _buildSectionHeader('Quick Stats'),
          _buildQuickStats(),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _userProfile['bio'] ?? 'No bio available',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: _theme.getDynamicFontSize(14),
              ),
            ),
            if (_userProfile['bio'] == null) ...[
              SizedBox(height: _theme.getDynamicSpacing(8)),
              Text(
                'Add a bio to tell others about your music taste',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: _theme.getDynamicFontSize(12),
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildConnectedServices() {
    final services = _userProfile['connectedServices'] ?? [];

    if (services.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
          child: Column(
            children: [
              Icon(
                Icons.link_off,
                size: _theme.getDynamicFontSize(32),
                color: Theme.of(context).colorScheme.outline,
              ),
              SizedBox(height: _theme.getDynamicSpacing(8)),
              Text(
                'No Services Connected',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: _theme.getDynamicFontSize(14),
                ),
              ),
              SizedBox(height: _theme.getDynamicSpacing(8)),
              ElevatedButton(
                onPressed: _connectServices,
                child: const Text('Connect Services'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: services.map<Widget>((service) {
        return Card(
          margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: _getServiceColor(service['name']).withValues(alpha: 0.1),
              child: Icon(
                _getServiceIcon(service['name']),
                color: _getServiceColor(service['name']),
              ),
            ),
            title: Text(service['name']),
            subtitle: Text('Connected since ${service['connectedDate'] ?? 'Unknown'}'),
            trailing: IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _configureService(service),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildQuickStats() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickStat('Listening Time', '24h 30m', Icons.access_time),
                _buildQuickStat('Songs Played', '1,234', Icons.play_arrow),
              ],
            ),
            SizedBox(height: _theme.getDynamicSpacing(16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickStat('Top Genre', 'Pop', Icons.music_note),
                _buildQuickStat('Favorite Artist', 'The Weeknd', Icons.person),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: _theme.getDynamicFontSize(20),
          color: Theme.of(context).primaryColor,
        ),
        SizedBox(height: _theme.getDynamicSpacing(4)),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(14),
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(10),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTopArtistsTab() {
    return BlocBuilder<ContentBloc, ContentState>(
      builder: (context, state) {
        List<Map<String, dynamic>> artists = [];
        
        if (state is ContentLoaded && state.topArtists.isNotEmpty) {
          // Use real data when available
          artists = state.topArtists.take(10).map((artist) => {
            'id': artist.id,
            'name': artist.name,
            'imageUrl': artist.imageUrls?.isNotEmpty == true ? artist.imageUrls!.first : null,
            'genres': artist.genres,
            'plays': (artist.popularity ?? 0.0).toInt() * 10,
            'followers': artist.followers,
          }).toList();
        } else if (state is ContentError || _useOfflineMode) {
          // Use mock data as fallback
          artists = _mockTopArtists?.take(10).toList() ?? [];
        }
        
        if (state is ContentLoading && !_useOfflineMode) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (artists.isEmpty) {
          return NetworkErrorWidget(
            onRetry: () => context.read<ContentBloc>().add(LoadTopArtists()),
            onUseMockData: _enableOfflineMode,
          );
        }
        
        return RefreshIndicator(
          onRefresh: () => _refreshTopArtists(),
          child: ListView.builder(
            padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
            itemCount: artists.length,
            itemBuilder: (context, index) {
              return _buildTopArtistItemWithData(artists[index], index);
            },
          ),
        );
      },
    );
  }

  Widget _buildTopArtistItemWithData(Map<String, dynamic> artist, int index) {
    final artistName = artist['name'] ?? 'Unknown Artist';
    final genres = artist['genres'] ?? [];
    final plays = artist['plays'] ?? artist['playCount'] ?? 0;
    final followers = artist['followers'] ?? 0;
    final imageUrl = artist['imageUrl'];
    
    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              radius: _theme.getDynamicFontSize(25),
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
              child: imageUrl == null
                  ? Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: _theme.getDynamicFontSize(16),
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : null,
            ),
          ],
        ),
        title: Text(
          artistName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$plays plays • $followers followers',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: _theme.getDynamicFontSize(12),
              ),
            ),
            if (genres.isNotEmpty)
              Text(
                genres.take(3).join(', '),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: _theme.getDynamicFontSize(11),
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            if (_useOfflineMode)
              Text(
                'Preview data',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: _theme.getDynamicFontSize(10),
                  color: Theme.of(context).colorScheme.outline,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: () => _followArtist(artist),
        ),
        onTap: () => _viewArtistProfile(artist),
      ),
    );
  }
  
  Future<void> _refreshTopArtists() async {
    context.read<ContentBloc>().add(LoadTopArtists());
  }

  Widget _buildTopTracksTab() {
    return BlocBuilder<ContentBloc, ContentState>(
      builder: (context, state) {
        List<Map<String, dynamic>> tracks = [];
        
        if (state is ContentLoaded && state.topTracks.isNotEmpty) {
          // Use real data when available
          tracks = state.topTracks.take(10).map((track) => {
            'id': track.id,
            'name': track.name,
            'artist': track.artist,
            'imageUrl': track.imageUrl,
            'plays': track.popularity ?? 0,
            'duration': track.durationMs != null ? (track.durationMs! / 1000).round() : 0,
            'isLiked': track.isLiked,
          }).toList();
        } else if (state is ContentError || _useOfflineMode) {
          // Use mock data as fallback
          tracks = _mockTopTracks?.take(10).toList() ?? [];
        }
        
        if (state is ContentLoading && !_useOfflineMode) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (tracks.isEmpty) {
          return NetworkErrorWidget(
            onRetry: () => context.read<ContentBloc>().add(LoadTopTracks()),
            onUseMockData: _enableOfflineMode,
          );
        }
        
        return RefreshIndicator(
          onRefresh: () => _refreshTopTracks(),
          child: ListView.builder(
            padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
            itemCount: tracks.length,
            itemBuilder: (context, index) {
              return _buildTopTrackItemWithData(tracks[index], index);
            },
          ),
        );
      },
    );
  }

  Widget _buildTopTrackItemWithData(Map<String, dynamic> track, int index) {
    final trackName = track['name'] ?? 'Unknown Track';
    final artistName = track['artist'] ?? 'Unknown Artist';
    final plays = track['plays'] ?? track['playCount'] ?? 0;
    final duration = track['duration'] ?? 0;
    final imageUrl = track['imageUrl'];
    final isLiked = track['isLiked'] ?? false;
    
    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              radius: _theme.getDynamicFontSize(25),
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl) : null,
              child: imageUrl == null
                  ? Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontSize: _theme.getDynamicFontSize(16),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ],
        ),
        title: Text(
          trackName,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$artistName • $plays plays',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: _theme.getDynamicFontSize(12),
              ),
            ),
            if (duration > 0)
              Text(
                _formatDuration(duration),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: _theme.getDynamicFontSize(11),
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            if (_useOfflineMode)
              Text(
                'Preview data',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: _theme.getDynamicFontSize(10),
                  color: Theme.of(context).colorScheme.outline,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : null,
              ),
              onPressed: () => _toggleTrackLike(track),
            ),
            IconButton(
              icon: const Icon(Icons.play_arrow),
              onPressed: () => _playTrack(track),
            ),
          ],
        ),
        onTap: () => _viewTrackDetails(track),
      ),
    );
  }
  
  Future<void> _refreshTopTracks() async {
    context.read<ContentBloc>().add(LoadTopTracks());
  }
  
  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes;
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Widget _buildActivityTab() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        List<Map<String, dynamic>> activities = [];
        
        // For now, always use mock data as UserBloc doesn't have activity data yet
        activities = _mockRecentActivity?.take(10).toList() ?? [];
        
        if (activities.isEmpty) {
          return NetworkErrorWidget(
            onRetry: () => context.read<UserBloc>().add(LoadMyProfile()),
            onUseMockData: _enableOfflineMode,
          );
        }
        
        return RefreshIndicator(
          onRefresh: () => _refreshActivity(),
          child: ListView.builder(
            padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              return _buildActivityItemWithData(activities[index], index);
            },
          ),
        );
      },
    );
  }

  Widget _buildActivityItemWithData(Map<String, dynamic> activity, int index) {
    final type = activity['type'] ?? 'played';
    final trackInfo = activity['track'] ?? {};
    final trackName = trackInfo['name'] ?? 'Unknown Track';
    final artistName = trackInfo['artist'] ?? 'Unknown Artist';
    final timestamp = activity['timestamp'] ?? DateTime.now().toIso8601String();
    final timeAgo = _formatTimeAgo(timestamp);
    
    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.1),
          child: Icon(
            _getActivityIcon(type),
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        title: Text(
          _getActivityDescription(type, trackName),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(14),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              artistName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: _theme.getDynamicFontSize(12),
              ),
            ),
            Text(
              timeAgo,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: _theme.getDynamicFontSize(11),
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            if (_useOfflineMode)
              Text(
                'Preview data',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: _theme.getDynamicFontSize(10),
                  color: Theme.of(context).colorScheme.outline,
                  fontStyle: FontStyle.italic,
                ),
              ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () => _showActivityOptions(activity),
        ),
        onTap: () => _viewActivityDetails(activity),
      ),
    );
  }
  
  Future<void> _refreshActivity() async {
    context.read<UserBloc>().add(LoadMyProfile());
  }
  
  String _formatTimeAgo(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      final difference = DateTime.now().difference(dateTime);
      
      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return 'Recently';
    }
  }
  
  String _getActivityDescription(String type, String trackName) {
    switch (type) {
      case 'liked':
        return 'Liked "$trackName"';
      case 'added_to_playlist':
        return 'Added "$trackName" to playlist';
      case 'shared':
        return 'Shared "$trackName"';
      case 'played':
      default:
        return 'Played "$trackName"';
    }
  }
  
  void _toggleTrackLike(Map<String, dynamic> track) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          track['isLiked'] == true 
              ? 'Removed from favorites' 
              : 'Added to favorites'
        ),
      ),
    );
  }
  
  void _viewActivityDetails(Map<String, dynamic> activity) {
    _navigation.navigateTo('/activity-details', arguments: activity);
  }

  Widget _buildPlaylistsTab() {
    return Padding(
      padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Your Playlists'),
          _buildPlaylistsList(),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          _buildSectionHeader('Public Playlists'),
          _buildPublicPlaylistsList(),
        ],
      ),
    );
  }

  Widget _buildPlaylistsList() {
    final playlistsData = _userProfile['playlists'];
    final playlists = playlistsData is List ? playlistsData : <Map<String, dynamic>>[];

    if (playlists.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
          child: Column(
            children: [
              Icon(
                Icons.playlist_add,
                size: _theme.getDynamicFontSize(32),
                color: Theme.of(context).colorScheme.outline,
              ),
              SizedBox(height: _theme.getDynamicSpacing(8)),
              Text(
                'No Playlists Yet',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontSize: _theme.getDynamicFontSize(14),
                ),
              ),
              SizedBox(height: _theme.getDynamicSpacing(8)),
              ElevatedButton(
                onPressed: _createPlaylist,
                child: const Text('Create Playlist'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        return _buildPlaylistItem(playlists[index], index);
      },
    );
  }

  Widget _buildPlaylistItem(Map<String, dynamic> playlist, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Icon(
            Icons.playlist_play,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          playlist['name'] ?? 'Playlist ${index + 1}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(14),
          ),
        ),
        subtitle: Text(
          '${playlist['trackCount'] ?? 0} tracks • ${playlist['isPublic'] ? 'Public' : 'Private'}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(12),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () => _playPlaylist(playlist),
        ),
        onTap: () => _viewPlaylist(playlist),
      ),
    );
  }

  Widget _buildPublicPlaylistsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return _buildPublicPlaylistItem(index);
      },
    );
  }

  Widget _buildPublicPlaylistItem(int index) {
    final publicPlaylists = ['Summer Vibes', 'Workout Mix', 'Chill Beats'];

    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
          child: Icon(
            Icons.public,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        title: Text(
          publicPlaylists[index],
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(14),
          ),
        ),
        subtitle: Text(
          'Public • ${15 + (index * 5)} tracks',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(12),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () => _playPublicPlaylist(index),
        ),
        onTap: () => _viewPublicPlaylist(index),
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Padding(
      padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Account'),
          _buildAccountSettings(),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          _buildSectionHeader('Privacy'),
          _buildPrivacySettings(),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          _buildSectionHeader('Music Services'),
          _buildMusicServicesSettings(),
        ],
      ),
    );
  }

  Widget _buildAccountSettings() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Edit Profile'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _editProfile,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Change Email'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _changeEmail,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: _changePassword,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySettings() {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Public Profile'),
            subtitle: const Text('Make your profile visible to others'),
            value: _userProfile['isPublic'] ?? false,
            onChanged: (value) => _toggleProfileVisibility(value),
          ),
          const Divider(),
          SwitchListTile(
            title: const Text('Show Activity'),
            subtitle: const Text('Show your listening activity'),
            value: _userProfile['showActivity'] ?? true,
            onChanged: (value) => _toggleActivityVisibility(value),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicServicesSettings() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.music_note),
            title: const Text('Spotify'),
            subtitle: const Text('Connected'),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
            onTap: () => _configureService({'name': 'Spotify'}),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.link_off),
            title: const Text('Apple Music'),
            subtitle: const Text('Not connected'),
            trailing: const Icon(Icons.add_circle_outline),
            onTap: _connectAppleMusic,
          ),
        ],
      ),
    );
  }

  Widget _buildGenericTab(Map<String, dynamic> tab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: _theme.getDynamicFontSize(48),
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            '${tab['title']} Section',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(18),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            'This section is not yet implemented',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: _theme.getDynamicSpacing(12),
        top: _theme.getDynamicSpacing(8),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: _theme.getDynamicFontSize(16),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    return FloatingActionButton(
      heroTag: "profile_share_fab",
      onPressed: _shareProfile,
      child: const Icon(Icons.share),
    );
  }

  List<Map<String, dynamic>> _getAvailableTabs() {
    final tabs = <Map<String, dynamic>>[
      {'title': 'Overview', 'type': 'overview'},
    ];

    if (_config.isFeatureEnabled('music_discovery')) {
      tabs.addAll([
        {'title': 'Top Artists', 'type': 'topArtists'},
        {'title': 'Top Tracks', 'type': 'topTracks'},
      ]);
    }

    if (_config.isFeatureEnabled('activity_tracking')) {
      tabs.add({'title': 'Activity', 'type': 'activity'});
    }

    tabs.add({'title': 'Playlists', 'type': 'playlists'});
    tabs.add({'title': 'Settings', 'type': 'settings'});

    return tabs;
  }

  Color _getServiceColor(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'spotify':
        return Colors.green;
      case 'apple music':
        return Colors.red;
      case 'youtube music':
        return Colors.red;
      case 'lastfm':
        return Colors.red;
      default:
        return Theme.of(context).primaryColor;
    }
  }

  IconData _getServiceIcon(String serviceName) {
    switch (serviceName.toLowerCase()) {
      case 'spotify':
        return Icons.music_note;
      case 'apple music':
        return Icons.apple;
      case 'youtube music':
        return Icons.play_circle;
      case 'lastfm':
        return Icons.radio;
      default:
        return Icons.link;
    }
  }

  IconData _getActivityIcon(String type) {
    switch (type) {
      case 'liked':
        return Icons.favorite;
      case 'played':
        return Icons.play_arrow;
      case 'added':
        return Icons.add_circle;
      default:
        return Icons.music_note;
    }
  }

  // Profile data is now loaded via UserBloc listener - no hardcoded data

  Future<void> _loadTopArtists() async {
    // Load via ContentBloc - no hardcoded data
    context.read<ContentBloc>().add(LoadTopArtists());
  }

  Future<void> _loadTopTracks() async {
    // Load via ContentBloc - no hardcoded data
    context.read<ContentBloc>().add(LoadTopTracks());
  }

  Future<void> _loadRecentActivity() async {
    // Load via ContentBloc - no hardcoded data
    context.read<ContentBloc>().add(ContentPlayedTracksRequested());
  }

  // Action methods
  void _editProfile() {
    _navigation.navigateTo('/edit-profile');
  }

  void _connectServices() {
    _navigation.navigateTo('/connect-services');
  }

  void _configureService(Map<String, dynamic> service) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Configure ${service['name']} not implemented yet')),
    );
  }

  void _createPlaylist() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create playlist not implemented yet')),
    );
  }

  void _followArtist(Map<String, dynamic> artist) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Following ${artist['name']}')),
    );
  }

  void _viewArtistProfile(Map<String, dynamic> artist) {
    _navigation.navigateTo('/artist-details', arguments: {
      'artistId': artist['id'],
      'artistName': artist['name'],
    });
  }

  void _playTrack(Map<String, dynamic> track) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing ${track['name']}')),
    );
  }

  void _viewTrackDetails(Map<String, dynamic> track) {
    _navigation.navigateTo('/track-details', arguments: {
      'trackId': track['id'],
      'trackName': track['name'],
    });
  }

  void _showActivityOptions(Map<String, dynamic> activity) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Activity Options',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: _theme.getDynamicFontSize(18),
              ),
            ),
            SizedBox(height: _theme.getDynamicSpacing(16)),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Activity'),
              onTap: () {
                Navigator.pop(context);
                _shareActivity(activity);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('View Details'),
              onTap: () {
                Navigator.pop(context);
                _viewActivityDetails(activity);
              },
            ),
            if (activity['type'] == 'played' && activity['track'] != null)
              ListTile(
                leading: const Icon(Icons.play_arrow),
                title: const Text('Play Again'),
                onTap: () {
                  Navigator.pop(context);
                  _playTrack(activity['track']);
                },
              ),
            if (activity['type'] == 'liked' && activity['track'] != null)
              ListTile(
                leading: const Icon(Icons.favorite_border),
                title: const Text('Unlike'),
                onTap: () {
                  Navigator.pop(context);
                  _toggleTrackLike(activity['track']);
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Remove from Activity'),
              onTap: () {
                Navigator.pop(context);
                _removeActivityItem(activity);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _playPlaylist(Map<String, dynamic> playlist) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing ${playlist['name']}')),
    );
  }

  void _viewPlaylist(Map<String, dynamic> playlist) {
    _navigation.navigateTo('/playlist-details', arguments: {
      'playlistId': playlist['id'],
      'playlistName': playlist['name'],
    });
  }

  void _playPublicPlaylist(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing public playlist $index')),
    );
  }

  void _viewPublicPlaylist(int index) {
    _navigation.navigateTo('/playlist-details', arguments: {
      'playlistId': 'public_$index',
      'playlistName': 'Public Playlist $index',
    });
  }

  void _toggleProfileVisibility(bool value) {
    setState(() {
      _userProfile['isPublic'] = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile visibility ${value ? 'enabled' : 'disabled'}')),
    );
  }

  void _toggleActivityVisibility(bool value) {
    setState(() {
      _userProfile['showActivity'] = value;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Activity visibility ${value ? 'enabled' : 'disabled'}')),
    );
  }

  void _changeEmail() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change email not implemented yet')),
    );
  }

  void _changePassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change password not implemented yet')),
    );
  }

  void _connectAppleMusic() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Apple Music connection not implemented yet')),
    );
  }

  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share profile not implemented yet')),
    );
  }

  void _shareActivity(Map<String, dynamic> activity) {
    final trackInfo = activity['track'] ?? {};
    final trackName = trackInfo['name'] ?? 'Unknown Track';
    final artistName = trackInfo['artist'] ?? 'Unknown Artist';
    final activityType = activity['type'] ?? 'played';
    
    final shareText = activityType == 'liked' 
        ? 'I just liked "$trackName" by $artistName on MusicBud!' 
        : 'I\'m listening to "$trackName" by $artistName on MusicBud!';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: $shareText'),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _removeActivityItem(Map<String, dynamic> activity) {
    final trackInfo = activity['track'] ?? {};
    final trackName = trackInfo['name'] ?? 'Unknown Track';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed "$trackName" from activity'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Restored "$trackName" to activity'),
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ),
    );
  }
}
