import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/dynamic_theme_service.dart';
import '../../../services/dynamic_navigation_service.dart';
import '../../../services/dynamic_config_service.dart';
import '../../../services/mock_data_service.dart';
import '../../../presentation/blocs/search/search_bloc.dart';
import '../../../presentation/blocs/search/search_state.dart';
import '../../../presentation/blocs/search/search_event.dart';
import '../../../blocs/content/content_bloc.dart';
import '../../../blocs/content/content_event.dart';
import '../../widgets/error_states/offline_error_widget.dart';

/// Dynamic search screen with adaptive search capabilities
class DynamicSearchScreen extends StatefulWidget {
  const DynamicSearchScreen({super.key});

  @override
  State<DynamicSearchScreen> createState() => _DynamicSearchScreenState();
}

class _DynamicSearchScreenState extends State<DynamicSearchScreen>
    with TickerProviderStateMixin {
  final DynamicConfigService _config = DynamicConfigService.instance;
  final DynamicThemeService _theme = DynamicThemeService.instance;
  final DynamicNavigationService _navigation = DynamicNavigationService.instance;

  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _currentQuery = '';
  bool _useOfflineMode = false;
  bool _hasTriggeredInitialLoad = false;
  Timer? _debounceTimer;
  bool _isSearching = false;
  
  // State variables for search data
  List<String> _recentSearches = [];
  List<String> _trendingSearches = [];
  List<Map<String, dynamic>> _searchResults = [];
  
  // Mock data for offline fallback
  List<String>? _mockRecentSearches;
  List<String>? _mockTrendingSearches;
  List<Map<String, dynamic>>? _mockSearchResults;

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
    _mockRecentSearches = ['Taylor Swift', 'The Weeknd', 'Pop music', 'Chill playlist', 'Rock classics'];
    _mockTrendingSearches = ['Trending hits 2024', 'Summer vibes', 'Workout music', 'Lo-fi hip hop', 'Jazz standards'];
    _mockSearchResults = _generateMockSearchResults();
  }
  
  List<Map<String, dynamic>> _generateMockSearchResults() {
    final tracks = MockDataService.generateTopTracks(count: 15);
    final artists = MockDataService.generateTopArtists(count: 10);
    
    final results = <Map<String, dynamic>>[];
    
    // Add tracks
    for (final track in tracks) {
      results.add({
        'type': 'track',
        'title': track['name'],
        'artist': track['artist'],
        'album': track['album'] ?? 'Unknown Album',
        'imageUrl': track['imageUrl'],
        'duration': track['duration'] ?? 180,
        'isLiked': track['isLiked'] ?? false,
      });
    }
    
    // Add artists
    for (final artist in artists) {
      results.add({
        'type': 'artist',
        'name': artist['name'],
        'followers': artist['followers'],
        'genres': artist['genres'],
        'imageUrl': artist['imageUrl'],
        'isVerified': artist['isVerified'] ?? false,
      });
    }
    
    return results;
  }
  
  void _triggerInitialDataLoad() {
    if (!_hasTriggeredInitialLoad) {
      _hasTriggeredInitialLoad = true;
      // Load recent and trending searches
      context.read<SearchBloc>().add(const GetRecentSearches(limit: 10));
      context.read<SearchBloc>().add(const GetTrendingSearches(limit: 10));
    }
  }
  
  void _enableOfflineMode() {
    setState(() {
      _useOfflineMode = true;
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _tabController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
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
        // SearchBloc error handling for offline mode
        BlocListener<SearchBloc, SearchState>(
          listener: (context, state) {
            if (state is SearchError && !_useOfflineMode) {
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
          title: _buildSearchBar(),
          bottom: _currentQuery.isNotEmpty && tabs.length > 1
              ? TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: tabs.map((tab) => Tab(text: tab['title'])).toList(),
                )
              : null,
          actions: [
            if (_currentQuery.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearSearch,
              ),
            IconButton(
              icon: const Icon(Icons.tune),
              onPressed: _showFilterOptions,
            ),
            if (_useOfflineMode)
              IconButton(
                icon: const Icon(Icons.wifi_off),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Offline mode - using preview data'),
                    ),
                  );
                },
              ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      focusNode: _searchFocusNode,
      decoration: InputDecoration(
        hintText: 'Search music, artists, albums...',
        border: InputBorder.none,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _isSearching
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              )
            : null,
      ),
      onChanged: _onSearchChanged,
      onSubmitted: _performSearch,
    );
  }

  Widget _buildBody() {
    if (_currentQuery.isEmpty) {
      return _buildSearchSuggestions();
    } else {
      return _buildSearchResults();
    }
  }

  Widget _buildSearchSuggestions() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recent Searches with BLoC integration
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              List<String> recentSearches = [];
              
              if (state is RecentSearchesLoaded) {
                recentSearches = state.searches;
              } else if (state is SearchError || _useOfflineMode) {
                recentSearches = _mockRecentSearches ?? [];
              }
              
              if (recentSearches.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Recent Searches'),
                    _buildRecentSearchesListWithData(recentSearches),
                    SizedBox(height: _theme.getDynamicSpacing(24)),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
          // Trending Searches with BLoC integration
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              List<String> trendingSearches = [];
              
              if (state is TrendingSearchesLoaded) {
                trendingSearches = state.searches;
              } else if (state is SearchError || _useOfflineMode) {
                trendingSearches = _mockTrendingSearches ?? [];
              }
              
              if (trendingSearches.isNotEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Trending'),
                    _buildTrendingSearchesListWithData(trendingSearches),
                    SizedBox(height: _theme.getDynamicSpacing(24)),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
          _buildQuickSearchOptions(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: _theme.getDynamicSpacing(12)),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontSize: _theme.getDynamicFontSize(16),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRecentSearchesList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _recentSearches.length,
      itemBuilder: (context, index) {
        final search = _recentSearches[index];
        return ListTile(
          leading: Icon(
            Icons.history,
            color: Theme.of(context).colorScheme.outline,
          ),
          title: Text(
            search,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _removeRecentSearch(index),
          ),
          onTap: () => _selectSearchTerm(search),
        );
      },
    );
  }

  Widget _buildRecentSearchesListWithData(List<String> recentSearches) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentSearches.length,
      itemBuilder: (context, index) {
        final search = recentSearches[index];
        return Card(
          margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(4)),
          child: ListTile(
            leading: Icon(
              Icons.history,
              color: Theme.of(context).colorScheme.outline,
              size: _theme.getDynamicFontSize(20),
            ),
            title: Text(
              search,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: _theme.getDynamicFontSize(14),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_useOfflineMode)
                  Icon(
                    Icons.wifi_off,
                    size: _theme.getDynamicFontSize(16),
                    color: Theme.of(context).colorScheme.outline,
                  ),
                IconButton(
                  icon: const Icon(Icons.close),
                  iconSize: _theme.getDynamicFontSize(18),
                  onPressed: () => _removeRecentSearchFromList(search),
                ),
              ],
            ),
            onTap: () => _selectSearchTerm(search),
          ),
        );
      },
    );
  }

  Widget _buildTrendingSearchesList() {
    return Wrap(
      spacing: _theme.getDynamicSpacing(8),
      runSpacing: _theme.getDynamicSpacing(8),
      children: _trendingSearches.map((search) {
        return _buildTrendingChip(search);
      }).toList(),
    );
  }

  Widget _buildTrendingSearchesListWithData(List<String> trendingSearches) {
    return Column(
      children: [
        Wrap(
          spacing: _theme.getDynamicSpacing(8),
          runSpacing: _theme.getDynamicSpacing(8),
          children: trendingSearches.map((search) {
            return ActionChip(
              label: Text(
                search,
                style: TextStyle(
                  fontSize: _theme.getDynamicFontSize(12),
                  color: Theme.of(context).primaryColor,
                ),
              ),
              onPressed: () => _selectSearchTerm(search),
              backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              side: BorderSide(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              ),
            );
          }).toList(),
        ),
        if (_useOfflineMode)
          Padding(
            padding: EdgeInsets.only(top: _theme.getDynamicSpacing(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off,
                  size: _theme.getDynamicFontSize(16),
                  color: Theme.of(context).colorScheme.outline,
                ),
                SizedBox(width: _theme.getDynamicSpacing(4)),
                Text(
                  'Preview data',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: _theme.getDynamicFontSize(11),
                    color: Theme.of(context).colorScheme.outline,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTrendingChip(String search) {
    return ActionChip(
      label: Text(
        search,
        style: TextStyle(fontSize: _theme.getDynamicFontSize(12)),
      ),
      onPressed: () => _selectSearchTerm(search),
      backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
      labelStyle: TextStyle(
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildQuickSearchOptions() {
    final quickOptions = _getQuickSearchOptions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Quick Search'),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _theme.compactMode ? 3 : 2,
            crossAxisSpacing: _theme.getDynamicSpacing(12),
            mainAxisSpacing: _theme.getDynamicSpacing(12),
            childAspectRatio: 2.5,
          ),
          itemCount: quickOptions.length,
          itemBuilder: (context, index) {
            return _buildQuickOptionCard(quickOptions[index]);
          },
        ),
      ],
    );
  }

  Widget _buildQuickOptionCard(Map<String, dynamic> option) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _selectSearchTerm(option['query']),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(_theme.getDynamicSpacing(12)),
          child: Row(
            children: [
              Icon(
                option['icon'],
                size: _theme.getDynamicFontSize(20),
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: _theme.getDynamicSpacing(8)),
              Expanded(
                child: Text(
                  option['title'],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: _theme.getDynamicFontSize(12),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchLoading && !_useOfflineMode) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        if (state is SearchEmpty) {
          return _buildEmptyResults();
        }
        
        if (state is SearchError && !_useOfflineMode) {
          return NetworkErrorWidget(
            onRetry: () => _performSearch(_currentQuery),
            onUseMockData: _enableOfflineMode,
          );
        }
        
        List<Map<String, dynamic>> results = [];
        
        if (state is SearchResultsLoaded) {
          // Use real search results
          results = _convertSearchResultsToMap(state.results.items);
        } else if (state is SearchError || _useOfflineMode) {
          // Use mock data as fallback
          results = _mockSearchResults
              ?.where((result) => _matchesQuery(result, _currentQuery))
              .toList() ?? [];
        }
        
        if (results.isEmpty) {
          return _buildEmptyResults();
        }
        
        final tabs = _getAvailableTabs();
        
        if (tabs.isEmpty) {
          return _buildEmptyResults();
        }
        
        return TabBarView(
          controller: _tabController,
          children: tabs.map((tab) => _buildTabResultsWithData(tab, results)).toList(),
        );
      },
    );
  }

  Widget _buildTabResults(Map<String, dynamic> tab) {
    final filteredResults = _searchResults
        .where((result) => result['type'] == tab['type'])
        .toList();

    if (filteredResults.isEmpty) {
      return _buildEmptyTabResults(tab);
    }

    return RefreshIndicator(
      onRefresh: () => _performSearch(_currentQuery),
      child: ListView.builder(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        itemCount: filteredResults.length,
        itemBuilder: (context, index) {
          return _buildSearchResultItem(filteredResults[index], index);
        },
      ),
    );
  }

  Widget _buildTabResultsWithData(Map<String, dynamic> tab, List<Map<String, dynamic>> allResults) {
    final filteredResults = allResults
        .where((result) => result['type'] == tab['type'])
        .toList();

    if (filteredResults.isEmpty) {
      return _buildEmptyTabResults(tab);
    }

    return RefreshIndicator(
      onRefresh: () => _performSearch(_currentQuery),
      child: Column(
        children: [
          if (_useOfflineMode)
            Container(
              padding: EdgeInsets.all(_theme.getDynamicSpacing(8)),
              margin: EdgeInsets.all(_theme.getDynamicSpacing(16)),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.wifi_off,
                    size: _theme.getDynamicFontSize(16),
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  SizedBox(width: _theme.getDynamicSpacing(8)),
                  Text(
                    'Offline mode - showing preview data',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: _theme.getDynamicFontSize(12),
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
              itemCount: filteredResults.length,
              itemBuilder: (context, index) {
                return _buildSearchResultItem(filteredResults[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultItem(Map<String, dynamic> result, int index) {
    switch (result['type']) {
      case 'track':
        return _buildTrackResult(result, index);
      case 'artist':
        return _buildArtistResult(result, index);
      case 'album':
        return _buildAlbumResult(result, index);
      case 'playlist':
        return _buildPlaylistResult(result, index);
      default:
        return _buildGenericResult(result, index);
    }
  }

  Widget _buildTrackResult(Map<String, dynamic> result, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Icon(
            Icons.music_note,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          result['title'] ?? 'Track ${index + 1}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
          ),
        ),
        subtitle: Text(
          '${result['artist'] ?? 'Unknown Artist'} • ${result['album'] ?? 'Unknown Album'}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(12),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () => _playTrack(result),
        ),
        onTap: () => _viewTrackDetails(result),
      ),
    );
  }

  Widget _buildArtistResult(Map<String, dynamic> result, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          child: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        title: Text(
          result['name'] ?? 'Artist ${index + 1}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
          ),
        ),
        subtitle: Text(
          '${result['followers'] ?? 0} followers • ${result['genres']?.join(', ') ?? 'Various genres'}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(12),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.person_add),
          onPressed: () => _followArtist(result),
        ),
        onTap: () => _viewArtistProfile(result),
      ),
    );
  }

  Widget _buildAlbumResult(Map<String, dynamic> result, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          child: Icon(
            Icons.album,
            color: Theme.of(context).colorScheme.onTertiary,
          ),
        ),
        title: Text(
          result['name'] ?? 'Album ${index + 1}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
          ),
        ),
        subtitle: Text(
          '${result['artist'] ?? 'Unknown Artist'} • ${result['year'] ?? 'Unknown year'} • ${result['tracks'] ?? 0} tracks',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(12),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => _addAlbumToLibrary(result),
        ),
        onTap: () => _viewAlbumDetails(result),
      ),
    );
  }

  Widget _buildPlaylistResult(Map<String, dynamic> result, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.1),
          child: Icon(
            Icons.playlist_play,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        title: Text(
          result['name'] ?? 'Playlist ${index + 1}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
          ),
        ),
        subtitle: Text(
          '${result['owner'] ?? 'Unknown Owner'} • ${result['tracks'] ?? 0} tracks',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(12),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.playlist_add),
          onPressed: () => _addPlaylistToLibrary(result),
        ),
        onTap: () => _viewPlaylistDetails(result),
      ),
    );
  }

  Widget _buildGenericResult(Map<String, dynamic> result, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          child: Icon(
            Icons.search,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          result['title'] ?? 'Result ${index + 1}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
          ),
        ),
        subtitle: Text(
          result['subtitle'] ?? 'Search result',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(12),
          ),
        ),
        onTap: () => _viewGenericResult(result),
      ),
    );
  }

  Widget _buildEmptyResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: _theme.getDynamicFontSize(64),
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            'No Results Found',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            'Try different keywords or check your spelling',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyTabResults(Map<String, dynamic> tab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _getTabIcon(tab['type']),
            size: _theme.getDynamicFontSize(48),
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            'No ${tab['title']} Found',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(18),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            'Try searching for something else',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getAvailableTabs() {
    if (_currentQuery.isEmpty) return [];

    final tabs = <Map<String, dynamic>>[];
    // Get result types from either mock data or actual search results
    final results = _mockSearchResults ?? _searchResults;
    final resultTypes = results.map((r) => r['type']).toSet();

    if (resultTypes.contains('track')) {
      tabs.add({'title': 'Tracks', 'type': 'track'});
    }
    if (resultTypes.contains('artist')) {
      tabs.add({'title': 'Artists', 'type': 'artist'});
    }
    if (resultTypes.contains('album')) {
      tabs.add({'title': 'Albums', 'type': 'album'});
    }
    if (resultTypes.contains('playlist')) {
      tabs.add({'title': 'Playlists', 'type': 'playlist'});
    }

    return tabs;
  }

  List<Map<String, dynamic>> _getQuickSearchOptions() {
    return [
      {
        'title': 'Top Tracks',
        'query': 'top tracks',
        'icon': Icons.trending_up,
      },
      {
        'title': 'New Releases',
        'query': 'new releases',
        'icon': Icons.new_releases,
      },
      {
        'title': 'Popular Artists',
        'query': 'popular artists',
        'icon': Icons.people,
      },
      {
        'title': 'Charts',
        'query': 'charts',
        'icon': Icons.bar_chart,
      },
    ];
  }

  IconData _getTabIcon(String type) {
    switch (type) {
      case 'track':
        return Icons.music_note;
      case 'artist':
        return Icons.person;
      case 'album':
        return Icons.album;
      case 'playlist':
        return Icons.playlist_play;
      default:
        return Icons.search;
    }
  }

  Future<void> _loadSearchData() async {
    // Load recent searches from local storage - no hardcoded data
    setState(() {
      _recentSearches = [];
      _trendingSearches = [];
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _currentQuery = query;
    });

    if (query.isNotEmpty && query.length > 2) {
      _debounceSearch(query);
    }
  }

  void _debounceSearch(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_currentQuery == query && mounted) {
        _performSearch(query);
      }
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    // Use ContentBloc for real API search
    context.read<ContentBloc>().add(SearchContent(query: query, type: 'all'));

    // Add to recent searches
    setState(() {
      if (!_recentSearches.contains(query)) {
        _recentSearches.insert(0, query);
        if (_recentSearches.length > 10) {
          _recentSearches = _recentSearches.take(10).toList();
        }
      }
      _isSearching = false;
    });
  }

  // Search results are now handled by SearchBloc

  List<Map<String, dynamic>> _convertSearchResultsToMap(List<dynamic> items) {
    return items.map((item) {
      // Convert API result items to standardized Map format
      if (item is Map<String, dynamic>) {
        // Already in correct format
        return item;
      }
      
      // Handle different item types from API
      final Map<String, dynamic> converted = {};
      
      // Try to extract common properties
      if (item.runtimeType.toString().contains('Track')) {
        converted['type'] = 'track';
        converted['id'] = _getPropertySafely(item, 'id');
        converted['title'] = _getPropertySafely(item, 'name') ?? _getPropertySafely(item, 'title');
        converted['artist'] = _getPropertySafely(item, 'artist') ?? _getPropertySafely(item, 'artistName');
        converted['album'] = _getPropertySafely(item, 'album') ?? _getPropertySafely(item, 'albumName');
        converted['imageUrl'] = _getPropertySafely(item, 'imageUrl');
        converted['duration'] = _getPropertySafely(item, 'durationMs') != null 
            ? (_getPropertySafely(item, 'durationMs') / 1000).round()
            : _getPropertySafely(item, 'duration');
        converted['isLiked'] = _getPropertySafely(item, 'isLiked') ?? false;
      } else if (item.runtimeType.toString().contains('Artist')) {
        converted['type'] = 'artist';
        converted['id'] = _getPropertySafely(item, 'id');
        converted['name'] = _getPropertySafely(item, 'name');
        converted['followers'] = _getPropertySafely(item, 'followers');
        converted['genres'] = _getPropertySafely(item, 'genres') ?? [];
        converted['imageUrl'] = _getPropertySafely(item, 'imageUrls')?.isNotEmpty == true
            ? _getPropertySafely(item, 'imageUrls').first
            : _getPropertySafely(item, 'imageUrl');
        converted['isVerified'] = _getPropertySafely(item, 'isVerified') ?? false;
      } else if (item.runtimeType.toString().contains('Album')) {
        converted['type'] = 'album';
        converted['id'] = _getPropertySafely(item, 'id');
        converted['name'] = _getPropertySafely(item, 'name');
        converted['artist'] = _getPropertySafely(item, 'artist') ?? _getPropertySafely(item, 'artistName');
        converted['year'] = _getPropertySafely(item, 'releaseYear') ?? _getPropertySafely(item, 'year');
        converted['tracks'] = _getPropertySafely(item, 'trackCount') ?? _getPropertySafely(item, 'tracks');
        converted['imageUrl'] = _getPropertySafely(item, 'imageUrl');
      } else if (item.runtimeType.toString().contains('Playlist')) {
        converted['type'] = 'playlist';
        converted['id'] = _getPropertySafely(item, 'id');
        converted['name'] = _getPropertySafely(item, 'name');
        converted['owner'] = _getPropertySafely(item, 'owner') ?? _getPropertySafely(item, 'ownerName');
        converted['tracks'] = _getPropertySafely(item, 'trackCount') ?? _getPropertySafely(item, 'tracks');
        converted['imageUrl'] = _getPropertySafely(item, 'imageUrl');
        converted['isPublic'] = _getPropertySafely(item, 'isPublic') ?? false;
      } else {
        // Generic fallback
        converted['type'] = 'generic';
        converted['id'] = _getPropertySafely(item, 'id');
        converted['title'] = _getPropertySafely(item, 'name') ?? _getPropertySafely(item, 'title') ?? 'Unknown';
        converted['subtitle'] = _getPropertySafely(item, 'description') ?? _getPropertySafely(item, 'subtitle');
      }
      
      return converted;
    }).toList();
  }

  dynamic _getPropertySafely(dynamic item, String property) {
    try {
      if (item is Map) {
        return item[property];
      }
      // For objects, try to access property via reflection or toString parsing
      return null;
    } catch (e) {
      return null;
    }
  }

  bool _matchesQuery(Map<String, dynamic> result, String query) {
    if (query.isEmpty) return true;
    
    final queryLower = query.toLowerCase();
    final searchableFields = [
      result['title']?.toString(),
      result['name']?.toString(),
      result['artist']?.toString(),
      result['album']?.toString(),
      result['owner']?.toString(),
      result['subtitle']?.toString(),
    ];
    
    // Also search in genres array if present
    final genres = result['genres'];
    if (genres is List) {
      searchableFields.addAll(genres.map((g) => g?.toString()));
    }
    
    return searchableFields.any((field) => 
      field != null && field.toLowerCase().contains(queryLower)
    );
  }

  void _clearSearch() {
    setState(() {
      _currentQuery = '';
      _searchResults.clear();
      _searchController.clear();
    });
    _searchFocusNode.requestFocus();
  }

  void _selectSearchTerm(String term) {
    _searchController.text = term;
    setState(() {
      _currentQuery = term;
    });
    _performSearch(term);
  }

  void _removeRecentSearch(int index) {
    setState(() {
      _recentSearches.removeAt(index);
    });
  }

  void _removeRecentSearchFromList(String search) {
    // Remove from local list
    setState(() {
      _recentSearches.remove(search);
    });
    
    // If using BLoC data, trigger a removal request
    context.read<SearchBloc>().add(RemoveRecentSearch(search));
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed "$search" from recent searches'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Search Filters',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: _theme.getDynamicFontSize(20),
              ),
            ),
            SizedBox(height: _theme.getDynamicSpacing(16)),
            SwitchListTile(
              title: const Text('Explicit Content'),
              subtitle: const Text('Include explicit content in results'),
              value: true,
              onChanged: (value) {
                // TODO: Implement filter logic
              },
            ),
            SwitchListTile(
              title: const Text('Popular Only'),
              subtitle: const Text('Show only popular results'),
              value: false,
              onChanged: (value) {
                // TODO: Implement filter logic
              },
            ),
            ListTile(
              title: const Text('Sort By'),
              subtitle: const Text('Relevance'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // TODO: Implement sort options
              },
            ),
          ],
        ),
      ),
    );
  }

  // Action methods
  void _playTrack(Map<String, dynamic> track) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing: ${track['title']}')),
    );
  }

  void _viewTrackDetails(Map<String, dynamic> track) {
    _navigation.navigateTo('/track-details', arguments: {
      'trackId': track['id'],
      'trackName': track['title'],
    });
  }

  void _followArtist(Map<String, dynamic> artist) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Following: ${artist['name']}')),
    );
  }

  void _viewArtistProfile(Map<String, dynamic> artist) {
    _navigation.navigateTo('/artist-details', arguments: {
      'artistId': artist['id'],
      'artistName': artist['name'],
    });
  }

  void _addAlbumToLibrary(Map<String, dynamic> album) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to library: ${album['name']}')),
    );
  }

  void _viewAlbumDetails(Map<String, dynamic> album) {
    _navigation.navigateTo('/album-details', arguments: {
      'albumId': album['id'],
      'albumName': album['name'],
    });
  }

  void _addPlaylistToLibrary(Map<String, dynamic> playlist) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to library: ${playlist['name']}')),
    );
  }

  void _viewPlaylistDetails(Map<String, dynamic> playlist) {
    _navigation.navigateTo('/playlist-details', arguments: {
      'playlistId': playlist['id'],
      'playlistName': playlist['name'],
    });
  }

  void _viewGenericResult(Map<String, dynamic> result) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Viewing: ${result['title']}')),
    );
  }
}
