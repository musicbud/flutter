import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/dynamic_config_service.dart';
import '../../../services/dynamic_theme_service.dart';
import '../../../services/dynamic_navigation_service.dart';
import '../../../services/mock_data_service.dart';
import '../../../blocs/discover/discover_bloc.dart';
import '../../../blocs/discover/discover_event.dart';
import '../../../blocs/discover/discover_state.dart';
import '../../../blocs/content/content_bloc.dart';
import '../../../blocs/content/content_event.dart';
import '../../../blocs/content/content_state.dart';
import '../../widgets/error_states/offline_error_widget.dart';

/// Dynamic discover screen that adapts based on API configuration
class DynamicDiscoverScreen extends StatefulWidget {
  const DynamicDiscoverScreen({super.key});

  @override
  State<DynamicDiscoverScreen> createState() => _DynamicDiscoverScreenState();
}

class _DynamicDiscoverScreenState extends State<DynamicDiscoverScreen>
    with TickerProviderStateMixin {
  final DynamicConfigService _config = DynamicConfigService.instance;
  final DynamicThemeService _theme = DynamicThemeService.instance;
  final DynamicNavigationService _navigation = DynamicNavigationService.instance;

  late TabController _tabController;
  bool _useOfflineMode = false;
  bool _hasTriggeredInitialLoad = false;
  
  // Mock data for offline fallback
  List<Map<String, dynamic>>? _mockTrendingTracks;

  @override
  void initState() {
    super.initState();
    _initializeMockData();
    _tabController = TabController(
      length: _getAvailableTabs().length,
      vsync: this,
    );
  }
  
  void _initializeMockData() {
    _mockTrendingTracks = MockDataService.generateTopTracks(count: 10);
  }
  
  void _triggerInitialDataLoad() {
    if (!_hasTriggeredInitialLoad) {
      _hasTriggeredInitialLoad = true;
      // Trigger various discover content loads
      context.read<DiscoverBloc>().add(const FetchTrendingTracks());
      context.read<DiscoverBloc>().add(const FetchFeaturedArtists());
      context.read<DiscoverBloc>().add(const FetchNewReleases());
      // Also trigger ContentBloc for consistency
      context.read<ContentBloc>().add(LoadTopContent());
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

    final tabs = _getAvailableTabs();

    return MultiBlocListener(
      listeners: [
        // DiscoverBloc error handling for offline mode
        BlocListener<DiscoverBloc, DiscoverState>(
          listener: (context, state) {
            if (state is DiscoverError || 
                state is TrendingTracksError ||
                state is FeaturedArtistsError ||
                state is NewReleasesError) {
              if (!_useOfflineMode) {
                Future.delayed(const Duration(seconds: 1), () {
                  if (mounted && !_useOfflineMode) {
                    _enableOfflineMode();
                  }
                });
              }
            }
          },
        ),
        // ContentBloc error handling
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
          title: const Text('Discover'),
          bottom: tabs.length > 1 ? TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: tabs.map((tab) => Tab(text: tab['title'])).toList(),
          ) : null,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => _navigation.navigateTo('/search'),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => _navigation.navigateTo('/settings'),
            ),
          ],
        ),
        body: tabs.isEmpty
            ? _buildEmptyState()
            : TabBarView(
                controller: _tabController,
                children: tabs.map((tab) => _buildTabContent(tab)).toList(),
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.explore_off,
            size: _theme.getDynamicFontSize(64),
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            'No Discover Content Available',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            'Enable music discovery features in settings',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: _theme.getDynamicSpacing(24)),
          ElevatedButton(
            onPressed: () => _navigation.navigateTo('/settings'),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(Map<String, dynamic> tab) {
    switch (tab['type']) {
      case 'trending':
        return _buildTrendingContent();
      case 'newReleases':
        return _buildNewReleasesContent();
      case 'topArtists':
        return _buildTopArtistsContent();
      case 'topTracks':
        return _buildTopTracksContent();
      case 'topGenres':
        return _buildTopGenresContent();
      case 'anime':
        return _buildAnimeContent();
      case 'manga':
        return _buildMangaContent();
      default:
        return _buildGenericContent(tab);
    }
  }

  Widget _buildTrendingContent() {
    return RefreshIndicator(
      onRefresh: _refreshTrendingContent,
      child: ListView(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        children: [
          _buildSectionHeader('Trending Now'),
          _buildTrendingList(),
          SizedBox(height: _theme.getDynamicSpacing(24)),
          _buildSectionHeader('Popular This Week'),
          _buildPopularList(),
        ],
      ),
    );
  }

  Widget _buildNewReleasesContent() {
    return RefreshIndicator(
      onRefresh: _refreshNewReleases,
      child: ListView(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        children: [
          _buildSectionHeader('New Releases'),
          _buildNewReleasesList(),
          SizedBox(height: _theme.getDynamicSpacing(24)),
          _buildSectionHeader('Recently Added'),
          _buildRecentlyAddedList(),
        ],
      ),
    );
  }

  Widget _buildTopArtistsContent() {
    return RefreshIndicator(
      onRefresh: _refreshTopArtists,
      child: ListView(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        children: [
          _buildSectionHeader('Top Artists'),
          _buildTopArtistsList(),
        ],
      ),
    );
  }

  Widget _buildTopTracksContent() {
    return RefreshIndicator(
      onRefresh: _refreshTopTracks,
      child: ListView(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        children: [
          _buildSectionHeader('Top Tracks'),
          _buildTopTracksList(),
        ],
      ),
    );
  }

  Widget _buildTopGenresContent() {
    return RefreshIndicator(
      onRefresh: _refreshTopGenres,
      child: ListView(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        children: [
          _buildSectionHeader('Top Genres'),
          _buildTopGenresList(),
        ],
      ),
    );
  }

  Widget _buildAnimeContent() {
    return RefreshIndicator(
      onRefresh: _refreshAnimeContent,
      child: ListView(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        children: [
          _buildSectionHeader('Top Anime'),
          _buildAnimeList(),
        ],
      ),
    );
  }

  Widget _buildMangaContent() {
    return RefreshIndicator(
      onRefresh: _refreshMangaContent,
      child: ListView(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        children: [
          _buildSectionHeader('Top Manga'),
          _buildMangaList(),
        ],
      ),
    );
  }

  Widget _buildGenericContent(Map<String, dynamic> tab) {
    return RefreshIndicator(
      onRefresh: () => _refreshGenericContent(tab),
      child: ListView(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        children: [
          _buildSectionHeader(tab['title']),
          _buildGenericList(tab),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: _theme.getDynamicSpacing(16),
        top: _theme.getDynamicSpacing(8),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontSize: _theme.getDynamicFontSize(20),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTrendingList() {
    return BlocBuilder<DiscoverBloc, DiscoverState>(
      builder: (context, state) {
        List<Map<String, dynamic>> trendingTracks = [];
        
        if (state is TrendingTracksLoaded) {
          // Use real data when available
          trendingTracks = state.tracks;
        } else if (state is TrendingTracksError || _useOfflineMode) {
          // Use mock data as fallback
          trendingTracks = _mockTrendingTracks?.take(10).toList() ?? [];
        } else if (state is TrendingTracksLoading && !_useOfflineMode) {
          return SizedBox(
            height: _theme.getDynamicSpacing(200),
            child: const Center(child: CircularProgressIndicator()),
          );
        }
        
        if (trendingTracks.isEmpty) {
          return NetworkErrorWidget(
            onRetry: () => context.read<DiscoverBloc>().add(const FetchTrendingTracks()),
            onUseMockData: _enableOfflineMode,
          );
        }
        
        return SizedBox(
          height: _theme.getDynamicSpacing(200),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: trendingTracks.length,
            itemBuilder: (context, index) {
              final track = trendingTracks[index];
              return Container(
                width: _theme.getDynamicSpacing(150),
                margin: EdgeInsets.only(right: _theme.getDynamicSpacing(12)),
                child: _buildTrendingCardWithData(track, index),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTrendingCardWithData(Map<String, dynamic> track, int index) {
    final trackName = track['trackName'] ?? track['title'] ?? track['name'] ?? 'Unknown Track';
    final artistName = track['artistName'] ?? track['artist'] ?? 'Unknown Artist';
    final imageUrl = track['imageUrl'] ?? track['image'];
    
    return Card(
      elevation: 2,
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
              child: imageUrl != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: Icon(
                            Icons.trending_up,
                            size: _theme.getDynamicFontSize(32),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.trending_up,
                        size: _theme.getDynamicFontSize(32),
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
                  trackName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: _theme.getDynamicFontSize(14),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  artistName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: _theme.getDynamicFontSize(12),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (_useOfflineMode)
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
  }

  Widget _buildPopularList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildPopularItem(index);
      },
    );
  }

  Widget _buildPopularItem(int index) {
    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(
            Icons.music_note,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text('Popular Track $index'),
        subtitle: Text('Artist Name • ${index + 1}M plays'),
        trailing: IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () => _playTrack(index),
        ),
        onTap: () => _viewTrackDetails(index),
      ),
    );
  }

  Widget _buildNewReleasesList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _theme.compactMode ? 3 : 2,
        crossAxisSpacing: _theme.getDynamicSpacing(12),
        mainAxisSpacing: _theme.getDynamicSpacing(12),
        childAspectRatio: 0.8,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _buildNewReleaseCard(index);
      },
    );
  }

  Widget _buildNewReleaseCard(int index) {
    return Card(
      elevation: 2,
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
              child: Center(
                child: Icon(
                  Icons.album,
                  size: _theme.getDynamicFontSize(48),
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(_theme.getDynamicSpacing(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'New Album $index',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: _theme.getDynamicFontSize(12),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Artist Name',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: _theme.getDynamicFontSize(10),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentlyAddedList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            child: Icon(
              Icons.add_circle,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          title: Text('Recently Added $index'),
          subtitle: Text('Added ${index + 1} hours ago'),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreOptions(index),
          ),
        );
      },
    );
  }

  Widget _buildTopArtistsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: _theme.getDynamicFontSize(14),
              ),
            ),
          ),
          title: Text('Top Artist ${index + 1}'),
          subtitle: Text('${(index + 1) * 1000} followers'),
          trailing: IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _followArtist(index),
          ),
          onTap: () => _viewArtistProfile(index),
        );
      },
    );
  }

  Widget _buildTopTracksList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).secondaryHeaderColor,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: _theme.getDynamicFontSize(14),
              ),
            ),
          ),
          title: Text('Top Track ${index + 1}'),
          subtitle: Text('Artist Name • ${(index + 1) * 1000} plays'),
          trailing: IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () => _playTrack(index),
          ),
          onTap: () => _viewTrackDetails(index),
        );
      },
    );
  }

  Widget _buildTopGenresList() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _theme.compactMode ? 3 : 2,
        crossAxisSpacing: _theme.getDynamicSpacing(12),
        mainAxisSpacing: _theme.getDynamicSpacing(12),
        childAspectRatio: 1.5,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _buildGenreCard(index);
      },
    );
  }

  Widget _buildGenreCard(int index) {
    final genres = ['Pop', 'Rock', 'Hip-Hop', 'Electronic', 'Jazz', 'Classical'];
    final colors = [
      Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple, Colors.teal
    ];

    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          color: colors[index % colors.length].withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.music_note,
                size: _theme.getDynamicFontSize(32),
                color: colors[index % colors.length],
              ),
              SizedBox(height: _theme.getDynamicSpacing(8)),
              Text(
                genres[index % genres.length],
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: _theme.getDynamicFontSize(16),
                  color: colors[index % colors.length],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimeList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            child: Icon(
              Icons.play_circle,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          title: Text('Anime ${index + 1}'),
          subtitle: Text('Season ${index + 1} • ${(index + 1) * 1000} ratings'),
          trailing: IconButton(
            icon: const Icon(Icons.star),
            onPressed: () => _rateAnime(index),
          ),
          onTap: () => _viewAnimeDetails(index),
        );
      },
    );
  }

  Widget _buildMangaList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
            child: Icon(
              Icons.menu_book,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          title: Text('Manga ${index + 1}'),
          subtitle: Text('Chapter ${index + 1} • ${(index + 1) * 1000} readers'),
          trailing: IconButton(
            icon: const Icon(Icons.bookmark_add),
            onPressed: () => _bookmarkManga(index),
          ),
          onTap: () => _viewMangaDetails(index),
        );
      },
    );
  }

  Widget _buildGenericList(Map<String, dynamic> tab) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Icon(
              Icons.explore,
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: Text('${tab['title']} Item ${index + 1}'),
          subtitle: Text('Description for ${tab['title']} item'),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showMoreOptions(index),
          ),
          onTap: () => _viewItemDetails(index, tab),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getAvailableTabs() {
    final tabs = <Map<String, dynamic>>[];

    if (_config.isFeatureEnabled('music_discovery')) {
      tabs.addAll([
        {'title': 'Trending', 'type': 'trending'},
        {'title': 'New Releases', 'type': 'newReleases'},
        {'title': 'Top Artists', 'type': 'topArtists'},
        {'title': 'Top Tracks', 'type': 'topTracks'},
        {'title': 'Genres', 'type': 'topGenres'},
      ]);
    }

    if (_config.isFeatureEnabled('anime_integration')) {
      tabs.addAll([
        {'title': 'Anime', 'type': 'anime'},
        {'title': 'Manga', 'type': 'manga'},
      ]);
    }

    return tabs;
  }

  // Action methods
  Future<void> _refreshTrendingContent() async {
    context.read<ContentBloc>().add(LoadTopContent());
  }

  Future<void> _refreshNewReleases() async {
    context.read<ContentBloc>().add(LoadTopContent());
  }

  Future<void> _refreshTopArtists() async {
    context.read<ContentBloc>().add(LoadTopArtists());
  }

  Future<void> _refreshTopTracks() async {
    context.read<ContentBloc>().add(LoadTopTracks());
  }

  Future<void> _refreshTopGenres() async {
    context.read<ContentBloc>().add(LoadTopGenres());
  }

  Future<void> _refreshAnimeContent() async {
    // Anime content not implemented in ContentBloc yet
  }

  Future<void> _refreshMangaContent() async {
    // Manga content not implemented in ContentBloc yet
  }

  Future<void> _refreshGenericContent(Map<String, dynamic> tab) async {
    context.read<ContentBloc>().add(LoadTopContent());
  }

  void _playTrack(int index) {
    // TODO: Implement track playback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing track $index')),
    );
  }

  void _viewTrackDetails(int index) {
    _navigation.navigateTo('/track-details', arguments: {'trackId': index});
  }

  void _viewArtistProfile(int index) {
    _navigation.navigateTo('/artist-details', arguments: {'artistId': index});
  }

  void _followArtist(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Following artist $index')),
    );
  }

  void _rateAnime(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Rating anime $index')),
    );
  }

  void _viewAnimeDetails(int index) {
    _navigation.navigateTo('/anime-details', arguments: {'animeId': index});
  }

  void _bookmarkManga(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bookmarked manga $index')),
    );
  }

  void _viewMangaDetails(int index) {
    _navigation.navigateTo('/manga-details', arguments: {'mangaId': index});
  }

  void _showMoreOptions(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.play_arrow),
              title: const Text('Play'),
              onTap: () {
                Navigator.pop(context);
                _playTrack(index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_to_queue),
              title: const Text('Add to Queue'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to queue')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite_border),
              title: const Text('Add to Favorites'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Added to favorites')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _viewItemDetails(int index, Map<String, dynamic> tab) {
    _navigation.navigateTo('/item-details', arguments: {
      'itemId': index,
      'type': tab['type'],
    });
  }
}
