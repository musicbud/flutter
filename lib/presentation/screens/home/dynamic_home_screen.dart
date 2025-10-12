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
import '../../../blocs/discover/discover_bloc.dart';
import '../../../blocs/discover/discover_event.dart';
import '../../../blocs/discover/discover_state.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../widgets/error_states/offline_error_widget.dart';
/// Dynamic home screen that adapts based on configuration
class DynamicHomeScreen extends StatefulWidget {
  const DynamicHomeScreen({super.key});

  @override
  State<DynamicHomeScreen> createState() => _DynamicHomeScreenState();
}

class _DynamicHomeScreenState extends State<DynamicHomeScreen> {
  final DynamicConfigService _config = DynamicConfigService.instance;
  final DynamicThemeService _theme = DynamicThemeService.instance;
  final DynamicNavigationService _navigation = DynamicNavigationService.instance;
  
  // State variables for different content types
  bool _hasTriggeredInitialLoad = false;
  bool _isOffline = false;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Mock data for offline fallback
  List<Map<String, dynamic>>? _mockTopArtists;
  List<Map<String, dynamic>>? _mockTopTracks;
  List<Map<String, dynamic>>? _mockActivity;
  List<Map<String, dynamic>>? _mockRecommendations;

  @override
  void initState() {
    super.initState();
    _initializeMockData();
  }

  void _initializeMockData() {
    _mockTopArtists = MockDataService.generateTopArtists(count: 10);
    _mockTopTracks = MockDataService.generateTopTracks(count: 15);
    _mockActivity = MockDataService.generateRecentActivity(count: 10);
    _mockRecommendations = MockDataService.generateTopTracks(count: 8);
  }

  void _triggerInitialDataLoad() {
    if (!_hasTriggeredInitialLoad && !_isOffline) {
      _hasTriggeredInitialLoad = true;
      try {
        // Load user profile
        context.read<UserBloc>().add(LoadMyProfile());
        // Load content
        context.read<ContentBloc>().add(LoadTopContent());
        context.read<ContentBloc>().add(LoadTopTracks());
        context.read<ContentBloc>().add(LoadTopArtists());
        // Load discover content
        context.read<DiscoverBloc>().add(const DiscoverPageLoaded());
        context.read<DiscoverBloc>().add(const FetchTrendingTracks());
      } catch (e) {
        _enableOfflineMode();
      }
    }
  }

  void _enableOfflineMode() {
    setState(() {
      _isOffline = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Trigger initial data load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerInitialDataLoad();
    });

    return MultiBlocListener(
      listeners: [
        // Handle Content BLoC states
        BlocListener<ContentBloc, ContentState>(
          listener: (context, state) {
            setState(() {
              _isLoading = state is ContentLoading;
            });
            
            if (state is ContentError) {
              setState(() {
                _errorMessage = state.message;
                if (state.message.contains('network') || state.message.contains('connection')) {
                  _isOffline = true;
                }
              });
              _showErrorSnackBar('Failed to load content: ${state.message}');
            } else if (state is ContentLoaded) {
              setState(() {
                _errorMessage = null;
                _isOffline = false;
              });
            }
          },
        ),
        // Handle User BLoC states
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserError) {
              _showErrorSnackBar('Failed to load user data: ${state.message}');
            }
          },
        ),
        // Handle Discover BLoC states
        BlocListener<DiscoverBloc, DiscoverState>(
          listener: (context, state) {
            if (state is DiscoverError) {
              setState(() {
                if (state.message.contains('network') || state.message.contains('connection')) {
                  _isOffline = true;
                }
              });
            } else if (state is DiscoverLoaded) {
              setState(() {
                _isOffline = false;
              });
            }
          },
        ),
        // Handle Auth state changes
        BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Unauthenticated) {
              // Navigate to login screen
              _navigation.navigateTo('/login');
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
        bottomNavigationBar: _shouldShowBottomNav() ? _buildBottomNavigation() : null,
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          const Text('MusicBud'),
          if (_isOffline) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange, width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_off,
                    size: 12,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Offline',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => _navigation.navigateTo('/search'),
        ),
        if (_isOffline)
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _retryConnection,
            tooltip: 'Retry Connection',
          ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => _navigation.navigateTo('/settings'),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: _theme.getDynamicPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            _buildQuickActions(),
            _buildFeaturedContent(),
            _buildRecentActivity(),
            _buildRecommendations(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back!',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontSize: _theme.getDynamicFontSize(24),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            'Discover new music and connect with friends',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontSize: _theme.getDynamicFontSize(14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    final actions = _getAvailableActions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: _theme.getDynamicSpacing(16)),
          child: Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _theme.compactMode ? 3 : 2,
            crossAxisSpacing: _theme.getDynamicSpacing(12),
            mainAxisSpacing: _theme.getDynamicSpacing(12),
            childAspectRatio: _theme.compactMode ? 1.2 : 1.5,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return _buildActionCard(action);
          },
        ),
      ],
    );
  }

  Widget _buildActionCard(Map<String, dynamic> action) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _navigation.navigateTo(action['route']),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                action['icon'],
                size: _theme.getDynamicFontSize(32),
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: _theme.getDynamicSpacing(8)),
              Text(
                action['title'],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: _theme.getDynamicFontSize(14),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedContent() {
    if (!_config.isFeatureEnabled('music_discovery')) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: _theme.getDynamicSpacing(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Featured Content',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: _theme.getDynamicFontSize(20),
                ),
              ),
              TextButton(
                onPressed: () => _navigation.navigateTo('/discover'),
                child: const Text('See All'),
              ),
            ],
          ),
        ),
        // Featured content with BLoC integration
        BlocBuilder<ContentBloc, ContentState>(
          builder: (context, state) {
            if (state is ContentLoading && !_isOffline) {
              return SizedBox(
                height: _theme.getDynamicSpacing(200),
                child: const Center(child: CircularProgressIndicator()),
              );
            }
            
            List<Map<String, dynamic>> artists = [];
            
            if (state is ContentLoaded) {
              // Use real data if available
              artists = state.topArtists.take(5).map((artist) => {
                'id': artist.id,
                'name': artist.name,
                'imageUrl': artist.imageUrls?.isNotEmpty == true ? artist.imageUrls!.first : null,
              }).toList();
            } else if (state is ContentError || _isOffline) {
              // Use mock data as fallback
              artists = _mockTopArtists?.take(5).toList() ?? [];
            }
            
            if (artists.isEmpty) {
              return NetworkErrorWidget(
                onRetry: () => context.read<ContentBloc>().add(LoadTopArtists()),
                onUseMockData: _enableOfflineMode,
              );
            }
            
            return SizedBox(
              height: _theme.getDynamicSpacing(200),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: artists.length,
                itemBuilder: (context, index) {
                  final artist = artists[index];
                  return Container(
                    width: _theme.getDynamicSpacing(150),
                    margin: EdgeInsets.only(right: _theme.getDynamicSpacing(12)),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                            ),
                            child: artist['imageUrl'] != null
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                    child: Image.network(
                                      artist['imageUrl'],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      errorBuilder: (context, error, stackTrace) => Center(
                                        child: Icon(
                                          Icons.music_note,
                                          size: _theme.getDynamicFontSize(48),
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  )
                                : Center(
                                    child: Icon(
                                      Icons.music_note,
                                      size: _theme.getDynamicFontSize(48),
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(_theme.getDynamicSpacing(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                artist['name'] ?? 'Unknown Artist',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontSize: _theme.getDynamicFontSize(14),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (_isOffline)
                                Text(
                                  'Preview Mode',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontSize: _theme.getDynamicFontSize(10),
                                    color: Theme.of(context).colorScheme.outline,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: _theme.getDynamicSpacing(16)),
          child: Text(
            'Recent Activity',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
        ),
        // Recent activity with BLoC integration
        BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            List<Map<String, dynamic>> activities = [];
            
            if (state.runtimeType.toString() == 'UserLoaded') {
              // Use real data if available - checking for recent activity in dynamic state
              activities = [];
            } else if (state.runtimeType.toString() == 'UserError' || _isOffline) {
              // Use mock data as fallback
              activities = _mockActivity?.take(3).toList() ?? [];
            }
            
            if (state is UserLoading && !_isOffline) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            if (activities.isEmpty) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
                  child: Column(
                    children: [
                      Icon(
                        Icons.history,
                        size: _theme.getDynamicFontSize(32),
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      SizedBox(height: _theme.getDynamicSpacing(8)),
                      Text(
                        'No recent activity',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (_isOffline)
                        Text(
                          'Preview mode - limited data available',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }
            
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];
                final activityType = activity['type'] ?? 'listened';
                final trackName = activity['trackName'] ?? activity['title'] ?? 'Unknown Track';
                final artistName = activity['artistName'] ?? activity['artist'] ?? 'Unknown Artist';
                final timestamp = activity['timestamp'] ?? activity['time'] ?? 'Recently';
                
                IconData iconData;
                switch (activityType) {
                  case 'liked':
                    iconData = Icons.favorite;
                    break;
                  case 'shared':
                    iconData = Icons.share;
                    break;
                  case 'playlist_added':
                    iconData = Icons.playlist_add;
                    break;
                  default:
                    iconData = Icons.music_note;
                }
                
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Icon(
                      iconData,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  title: Text(
                    trackName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artistName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        timestamp,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (_isOffline)
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
                    onPressed: () {
                      // Show context menu for track actions
                    },
                  ),
                  onTap: () {
                    // Navigate to track details or start playback
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecommendations() {
    if (!_config.isFeatureEnabled('music_discovery')) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: _theme.getDynamicSpacing(16)),
          child: Text(
            'Recommended for You',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
        ),
        // Recommendations with BLoC integration
        BlocBuilder<DiscoverBloc, DiscoverState>(
          builder: (context, state) {
            List<Map<String, dynamic>> recommendations = [];
            
            if (state.runtimeType.toString() == 'DiscoverLoaded') {
              // Use real data if available - checking for recommendations in dynamic state
              recommendations = [];
            } else if (state.runtimeType.toString() == 'DiscoverError' || _isOffline) {
              // Use mock data as fallback
              recommendations = _mockRecommendations?.take(5).toList() ?? [];
            }
            
            if (state is DiscoverLoading && !_isOffline) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            if (recommendations.isEmpty) {
              return Card(
                child: Padding(
                  padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
                  child: Column(
                    children: [
                      Icon(
                        Icons.recommend,
                        size: _theme.getDynamicFontSize(32),
                        color: Theme.of(context).colorScheme.outline,
                      ),
                      SizedBox(height: _theme.getDynamicSpacing(8)),
                      Text(
                        'No recommendations available',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (_isOffline)
                        Column(
                          children: [
                            SizedBox(height: _theme.getDynamicSpacing(4)),
                            Text(
                              'Preview mode - using sample data',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                            ),
                            SizedBox(height: _theme.getDynamicSpacing(8)),
                            TextButton(
                              onPressed: _retryConnection,
                              child: const Text('Retry Connection'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            }
            
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recommendations.length,
              itemBuilder: (context, index) {
                final recommendation = recommendations[index];
                final trackName = recommendation['trackName'] ?? 
                                recommendation['title'] ?? 
                                recommendation['name'] ?? 
                                'Unknown Track';
                final artistName = recommendation['artistName'] ?? 
                                 recommendation['artist'] ?? 
                                 'Unknown Artist';
                final albumName = recommendation['albumName'] ?? 
                                recommendation['album'] ?? 
                                '';
                final reason = recommendation['reason'] ?? 
                             'Based on your listening history';
                
                return Card(
                  margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      backgroundImage: recommendation['imageUrl'] != null 
                          ? NetworkImage(recommendation['imageUrl']) 
                          : null,
                      child: recommendation['imageUrl'] == null
                          ? Icon(
                              Icons.recommend,
                              color: Theme.of(context).primaryColor,
                            )
                          : null,
                    ),
                    title: Text(
                      trackName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artistName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (albumName.isNotEmpty)
                          Text(
                            albumName,
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        Text(
                          reason,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (_isOffline)
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
                          icon: const Icon(Icons.play_arrow),
                          onPressed: () {
                            // Start playback
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {
                            // Add to favorites
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      // Navigate to track details
                    },
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget? _buildBottomNavigation() {
    final navItems = _getNavigationItems();

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: navItems.map((item) => BottomNavigationBarItem(
        icon: Icon(item['icon']),
        label: item['label'],
      )).toList(),
      onTap: (index) {
        _navigation.navigateTo(navItems[index]['route']);
      },
    );
  }

  Widget? _buildFloatingActionButton() {
    if (!_config.isFeatureEnabled('chat_system')) {
      return null;
    }

    return FloatingActionButton(
      heroTag: "home_chat_fab",
      onPressed: () => _navigation.navigateTo('/chat'),
      child: const Icon(Icons.chat),
    );
  }

  List<Map<String, dynamic>> _getAvailableActions() {
    final actions = <Map<String, dynamic>>[];

    if (_config.isFeatureEnabled('music_discovery')) {
      actions.add({
        'title': 'Discover',
        'icon': Icons.explore,
        'route': '/discover',
      });
    }

    if (_config.isFeatureEnabled('bud_matching')) {
      actions.add({
        'title': 'Find Buds',
        'icon': Icons.people,
        'route': '/buds',
      });
    }

    actions.add({
      'title': 'Library',
      'icon': Icons.library_music,
      'route': '/library',
    });

    actions.add({
      'title': 'Search',
      'icon': Icons.search,
      'route': '/search',
    });

    return actions;
  }

  List<Map<String, dynamic>> _getNavigationItems() {
    final items = <Map<String, dynamic>>[];

    items.add({
      'icon': Icons.home,
      'label': 'Home',
      'route': '/',
    });

    if (_config.isFeatureEnabled('music_discovery')) {
      items.add({
        'icon': Icons.explore,
        'label': 'Discover',
        'route': '/discover',
      });
    }

    if (_config.isFeatureEnabled('bud_matching')) {
      items.add({
        'icon': Icons.people,
        'label': 'Buds',
        'route': '/buds',
      });
    }

    items.add({
      'icon': Icons.library_music,
      'label': 'Library',
      'route': '/library',
    });

    items.add({
      'icon': Icons.person,
      'label': 'Profile',
      'route': '/profile',
    });

    return items;
  }


  bool _shouldShowBottomNav() {
    return _navigation.shouldShowBottomNav(_navigation.currentRoute ?? '/');
  }

  Future<void> _refreshData() async {
    // Refresh data via BLoCs
    try {
      if (!_isOffline) {
        context.read<UserBloc>().add(LoadMyProfile());
        context.read<ContentBloc>().add(LoadTopContent());
        context.read<ContentBloc>().add(LoadTopTracks());
        context.read<ContentBloc>().add(LoadTopArtists());
        context.read<DiscoverBloc>().add(const DiscoverPageLoaded());
        context.read<DiscoverBloc>().add(const FetchTrendingTracks());
      }
    } catch (e) {
      debugPrint('Error refreshing data: $e');
      _enableOfflineMode();
    }
  }

  void _retryConnection() {
    setState(() {
      _isOffline = false;
      _errorMessage = null;
      _hasTriggeredInitialLoad = false;
    });
    _triggerInitialDataLoad();
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          action: _isOffline ? SnackBarAction(
            label: 'Retry',
            onPressed: _retryConnection,
          ) : null,
          backgroundColor: _isOffline ? Colors.orange : null,
        ),
      );
    }
  }
}
