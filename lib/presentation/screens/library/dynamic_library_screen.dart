import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../services/dynamic_config_service.dart';
import '../../../services/dynamic_theme_service.dart';
import '../../../services/dynamic_navigation_service.dart';
import '../../../blocs/content/content_bloc.dart';
import '../../../blocs/content/content_event.dart';
import '../../../blocs/library/library_bloc.dart';
import '../../../blocs/library/library_event.dart';
import '../../../blocs/library/library_state.dart';
import '../../widgets/library/playlist_creation_dialog.dart';
import '../../widgets/library/library_filter_sheet.dart';
import '../../widgets/library/enhanced_library_filter_sheet.dart';
import '../../widgets/library/download_manager_widget.dart';

/// Dynamic library screen with adaptive content management
class DynamicLibraryScreen extends StatefulWidget {
  const DynamicLibraryScreen({super.key});

  @override
  State<DynamicLibraryScreen> createState() => _DynamicLibraryScreenState();
}

class _DynamicLibraryScreenState extends State<DynamicLibraryScreen>
    with TickerProviderStateMixin {
  final DynamicConfigService _config = DynamicConfigService.instance;
  final DynamicThemeService _theme = DynamicThemeService.instance;
  final DynamicNavigationService _navigation = DynamicNavigationService.instance;

  late TabController _tabController;
  final String _currentSortType = 'recent';
  String? _searchQuery;
  bool _isOfflineMode = false;
  final List<Map<String, dynamic>> _libraryItems = [];
  List<Map<String, dynamic>> _playlists = [];
  List<Map<String, dynamic>> _downloads = [];
  final bool _isLoading = false;
  Map<String, dynamic>? _currentFilters;
  Map<String, int>? _libraryStats;

  @override
  void initState() {
    super.initState();
    final tabs = _getAvailableTabs();
    _tabController = TabController(
      length: tabs.length,
      vsync: this,
    );
    _loadInitialData();
    // Load library stats on initialization
    context.read<LibraryBloc>().add(const LibraryStatsRequested());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = _getAvailableTabs();

    return MultiBlocListener(
      listeners: [
        BlocListener<LibraryBloc, LibraryState>(
          listener: (context, state) {
            if (state is LibraryActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            } else if (state is LibraryActionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            } else if (state is LibrarySyncInProgress) {
              _showSyncProgress(context, state);
            } else if (state is LibrarySyncCompleted) {
              Navigator.of(context).pop(); // Close sync dialog if open
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sync completed: ${state.syncedItems} items'),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _searchQuery != null ? 'Search Results' : 'Your Library',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
          bottom: tabs.length > 1 ? TabBar(
            controller: _tabController,
            tabs: tabs.map((tab) => Tab(
              text: tab['title'],
              icon: _getTabIcon(tab['type']),
            )).toList(),
            onTap: (index) => _onTabChanged(tabs[index]['type']),
          ) : null,
          actions: [
            if (_searchQuery != null)
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearSearch,
              ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _showSearchDialog,
            ),
            IconButton(
              icon: const Icon(Icons.filter_alt),
              onPressed: _showFilterOptions,
            ),
            IconButton(
              icon: const Icon(Icons.sort),
              onPressed: _showSortOptions,
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'sync',
                  child: ListTile(
                    leading: Icon(Icons.sync),
                    title: Text('Sync Library'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'offline_mode',
                  child: ListTile(
                    leading: Icon(_isOfflineMode ? Icons.cloud : Icons.offline_bolt),
                    title: Text(_isOfflineMode ? 'Go Online' : 'Go Offline'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
              onSelected: _handleMenuAction,
            ),
          ],
        ),
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton(),
      ),
    );
  }

  Widget _buildBody() {
    final tabs = _getAvailableTabs();
    
    if (tabs.isEmpty) {
      return _buildEmptyState();
    }

    return TabBarView(
      controller: _tabController,
      children: tabs.map((tab) => _buildBlocTabContent(tab)).toList(),
    );
  }

  Widget _buildBlocTabContent(Map<String, dynamic> tab) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryLoading) {
          return _buildLoadingState();
        }
        
        if (state is LibraryError) {
          return _buildErrorState(state.message);
        }
        
        if (state is LibraryFiltered) {
          return _buildFilteredContent(state, tab);
        }
        
        if (state is LibraryLoaded) {
          return _buildLoadedContent(state, tab);
        }
        
        // Load initial data for this tab
        context.read<LibraryBloc>().add(LibraryItemsRequested(
          type: tab['type'],
        ));
        
        return _buildLoadingState();
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_music_outlined,
            size: _theme.getDynamicFontSize(64),
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            'Your Library is Empty',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            'Start adding music to build your personal library',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: _theme.getDynamicSpacing(24)),
          ElevatedButton.icon(
            onPressed: () => _navigation.navigateTo('/search'),
            icon: const Icon(Icons.search),
            label: const Text('Discover Music'),
          ),
        ],
      ),
    );
  }


  Widget _buildTabContent(Map<String, dynamic> tab, LibraryState state) {
    switch (tab['type']) {
      case 'liked':
        return _buildLikedContent(state);
      case 'playlists':
        return _buildPlaylistsContent(state);
      case 'downloads':
        return _buildDownloadsContent(state);
      case 'recent':
        return _buildRecentContent(state);
      default:
        return _buildGenericContent(tab);
    }
  }

  Widget _buildLikedContent(LibraryState state) {
    return RefreshIndicator(
      onRefresh: _loadLibraryData,
      child: ListView(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        children: [
          _buildQuickStats(state),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          _buildSectionHeader('Recently Liked'),
          _buildLikedItemsList(state),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          _buildSectionHeader('Most Played'),
          _buildMostPlayedList(),
        ],
      ),
    );
  }

  Widget _buildQuickStats(LibraryState state) {
    // Get stats from BLoC state if available
    if (state is LibraryStatsLoaded) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Tracks', state.totalTracks.toString(), Icons.music_note),
              _buildStatItem('Playlists', state.totalPlaylists.toString(), Icons.playlist_play),
              _buildStatItem('Downloads', state.totalDownloads.toString(), Icons.download),
            ],
          ),
        ),
      );
    }
    
    // Fallback to local state
    return Card(
      child: Padding(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Liked', _libraryItems.length.toString(), Icons.favorite),
            _buildStatItem('Playlists', _playlists.length.toString(), Icons.playlist_play),
            _buildStatItem('Downloads', _downloads.length.toString(), Icons.download),
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
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: _theme.getDynamicSpacing(12),
        top: _theme.getDynamicSpacing(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(16),
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () => _viewAllItems(title.toLowerCase()),
            child: const Text('View All'),
          ),
        ],
      ),
    );
  }

  Widget _buildLikedItemsList(LibraryState state) {
    List<dynamic> items = [];
    
    if (state is LibraryLoaded && state.currentType == 'liked') {
      items = state.items;
    } else if (state is LibraryFiltered) {
      items = state.filteredItems;
    } else {
      items = _libraryItems; // Fallback to local state
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.take(5).length,
      itemBuilder: (context, index) {
        return _buildLikedItem(items[index], index);
      },
    );
  }

  Widget _buildLikedItem(Map<String, dynamic> item, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(
            _getItemIcon(item['type']),
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          item['title'] ?? 'Item ${index + 1}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(14),
          ),
        ),
        subtitle: Text(
          item['subtitle'] ?? 'Unknown',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(12),
          ),
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'play',
              child: ListTile(
                leading: Icon(Icons.play_arrow),
                title: Text('Play'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'remove',
              child: ListTile(
                leading: Icon(Icons.favorite_border),
                title: Text('Remove from Liked'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'add_to_playlist',
              child: ListTile(
                leading: Icon(Icons.playlist_add),
                title: Text('Add to Playlist'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
          onSelected: (value) => _handleItemAction(value, item),
        ),
        onTap: () => _playItem(item),
      ),
    );
  }

  Widget _buildMostPlayedList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildMostPlayedItem(index);
      },
    );
  }

  Widget _buildMostPlayedItem(int index) {
    final playCount = 100 + (index * 25);
    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).secondaryHeaderColor,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: _theme.getDynamicFontSize(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.all(_theme.getDynamicSpacing(2)),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  size: _theme.getDynamicFontSize(12),
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        title: Text(
          'Most Played Track ${index + 1}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(14),
          ),
        ),
        subtitle: Text(
          'Artist Name • $playCount plays',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(12),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () => _playMostPlayedItem(index),
        ),
        onTap: () => _playMostPlayedItem(index),
      ),
    );
  }

  Widget _buildPlaylistsContent(LibraryState state) {
    return RefreshIndicator(
      onRefresh: _loadPlaylists,
      child: ListView(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        children: [
          _buildSectionHeader('Your Playlists'),
          _buildPlaylistsGrid(state),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          _buildSectionHeader('Made for You'),
          _buildRecommendedPlaylists(),
        ],
      ),
    );
  }

  Widget _buildPlaylistsGrid(LibraryState state) {
    List<dynamic> playlists = [];
    
    if (state is LibraryLoaded && state.currentType == 'playlists') {
      playlists = state.items;
    } else {
      playlists = _playlists; // Fallback to local state
    }
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _theme.compactMode ? 2 : 2,
        crossAxisSpacing: _theme.getDynamicSpacing(12),
        mainAxisSpacing: _theme.getDynamicSpacing(12),
        childAspectRatio: 1.2,
      ),
      itemCount: playlists.length,
      itemBuilder: (context, index) {
        return _buildPlaylistCard(playlists[index], index);
      },
    );
  }

  Widget _buildPlaylistCard(Map<String, dynamic> playlist, int index) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => _openPlaylist(playlist, index),
        borderRadius: BorderRadius.circular(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.playlist_play,
                    size: _theme.getDynamicFontSize(32),
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
                    playlist['name'] ?? 'Playlist ${index + 1}',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: _theme.getDynamicFontSize(12),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${playlist['trackCount'] ?? 0} tracks',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: _theme.getDynamicFontSize(10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedPlaylists() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        return _buildRecommendedPlaylistItem(index);
      },
    );
  }

  Widget _buildRecommendedPlaylistItem(int index) {
    final recommendations = [
      'Your Top Songs 2024',
      'Discover Weekly',
      'Release Radar',
    ];

    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
          child: Icon(
            Icons.recommend,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        title: Text(
          recommendations[index],
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
          ),
        ),
        subtitle: Text(
          'Made for you • Updated weekly',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(12),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () => _playRecommendedPlaylist(index),
        ),
        onTap: () => _openRecommendedPlaylist(index),
      ),
    );
  }

  Widget _buildDownloadsContent(LibraryState state) {
    return RefreshIndicator(
      onRefresh: _loadDownloads,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildDownloadStats(state),
            SizedBox(height: _theme.getDynamicSpacing(16)),
            const DownloadManagerWidget(),
            SizedBox(height: _theme.getDynamicSpacing(16)),
            _buildDownloadsList(state),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadStats(LibraryState state) {
    List<dynamic> downloads = [];
    
    if (state is LibraryLoaded && state.currentType == 'downloads') {
      downloads = state.items;
    } else if (state is LibraryStatsLoaded) {
      // Use stats from BLoC if available
      return Card(
        child: Padding(
          padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Downloads', state.totalDownloads.toString(), Icons.download),
              _buildStatItem('Storage', '${state.totalStorageUsed.toStringAsFixed(1)}MB', Icons.storage),
              _buildStatItem('Available', 'Offline', Icons.offline_bolt),
            ],
          ),
        ),
      );
    } else {
      downloads = _downloads; // Fallback
    }
    
    final totalSize = downloads.fold<int>(
      0,
      (sum, item) => sum + ((item['size'] ?? 0) as int),
    );
    final totalSizeMB = (totalSize / (1024 * 1024)).toStringAsFixed(1);

    return Card(
      child: Padding(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Downloads', downloads.length.toString(), Icons.download),
            _buildStatItem('Storage', '${totalSizeMB}MB', Icons.storage),
            _buildStatItem('Available', 'Offline', Icons.offline_bolt),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _downloads.length,
      itemBuilder: (context, index) {
        return _buildDownloadItem(_downloads[index], index);
      },
    );
  }

  Widget _buildDownloadItem(Map<String, dynamic> download, int index) {
    final sizeMB = ((download['size'] ?? 0) / (1024 * 1024)).toStringAsFixed(1);

    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.tertiary.withOpacity(0.1),
          child: Icon(
            Icons.offline_bolt,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        title: Text(
          download['title'] ?? 'Download ${index + 1}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(14),
          ),
        ),
        subtitle: Text(
          '${download['artist'] ?? 'Unknown'} • ${sizeMB}MB',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(12),
          ),
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'play',
              child: ListTile(
                leading: Icon(Icons.play_arrow),
                title: Text('Play'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
          onSelected: (value) => _handleDownloadAction(value, download, index),
        ),
        onTap: () => _playDownload(download),
      ),
    );
  }

  Widget _buildRecentContent(LibraryState state) {
    return RefreshIndicator(
      onRefresh: _loadRecentItems,
      child: ListView(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        children: [
          _buildSectionHeader('Recently Played'),
          _buildRecentItemsList(state),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          _buildSectionHeader('Recently Added'),
          _buildRecentlyAddedList(state),
        ],
      ),
    );
  }

  Widget _buildRecentItemsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildRecentItem(index);
      },
    );
  }

  Widget _buildRecentItem(int index, Map<String, dynamic> item) {
    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.outline.withOpacity(0.1),
          child: Icon(
            Icons.history,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
        title: Text(
          item['title'] ?? 'Recent Track ${index + 1}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(14),
          ),
        ),
        subtitle: Text(
          '${item['artist'] ?? 'Artist Name'} • ${index + 1} hours ago',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(12),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () => _playRecentItem(index, item),
        ),
        onTap: () => _playRecentItem(index, item),
      ),
    );
  }

  Widget _buildRecentlyAddedList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _buildRecentlyAddedItem(index);
      },
    );
  }

  Widget _buildRecentlyAddedItem(int index, Map<String, dynamic> item) {
    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Icon(
            Icons.add_circle,
            color: Theme.of(context).primaryColor,
          ),
        ),
        title: Text(
          item['title'] ?? 'New Track ${index + 1}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(14),
          ),
        ),
        subtitle: Text(
          '${item['artist'] ?? 'Artist Name'} • Added ${index + 1} days ago',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: _theme.getDynamicFontSize(12),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.play_arrow),
          onPressed: () => _playRecentlyAddedItem(index, item),
        ),
        onTap: () => _playRecentlyAddedItem(index, item),
      ),
    );
  }

  Widget _buildGenericContent(Map<String, dynamic> tab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_music_outlined,
            size: _theme.getDynamicFontSize(64),
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            '${tab['title']} Content',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
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

  Widget? _buildFloatingActionButton() {
    return FloatingActionButton(
      heroTag: "library_create_fab",
      onPressed: _showCreateOptions,
      child: const Icon(Icons.add),
    );
  }

  List<Map<String, dynamic>> _getAvailableTabs() {
    final tabs = <Map<String, dynamic>>[
      {'title': 'Liked', 'type': 'liked'},
    ];

    if (_config.isFeatureEnabled('playlists')) {
      tabs.add({'title': 'Playlists', 'type': 'playlists'});
    }

    if (_config.isFeatureEnabled('downloads')) {
      tabs.add({'title': 'Downloads', 'type': 'downloads'});
    }

    tabs.add({'title': 'Recent', 'type': 'recent'});

    return tabs;
  }
  
  IconData _getTabIcon(String type) {
    switch (type) {
      case 'liked':
        return Icons.favorite;
      case 'playlists':
        return Icons.playlist_play;
      case 'downloads':
        return Icons.download;
      case 'recent':
        return Icons.history;
      default:
        return Icons.library_music;
    }
  }
  
  void _onTabChanged(String type) {
    // Load data for the selected tab
    context.read<LibraryBloc>().add(
      LibraryItemsRequested(type: type),
    );
  }
  
  Future<void> _loadInitialData() async {
    // Load initial data for the first tab
    final tabs = _getAvailableTabs();
    if (tabs.isNotEmpty) {
      context.read<LibraryBloc>().add(
        LibraryItemsRequested(type: tabs.first['type']),
      );
    }
  }
  
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Library'),
        content: TextField(
          decoration: const InputDecoration(
            hintText: 'Search songs, playlists, etc...',
            prefixIcon: Icon(Icons.search),
          ),
          onSubmitted: (query) {
            Navigator.pop(context);
            _performSearch(query);
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
    
    final tabs = _getAvailableTabs();
    final currentTabIndex = _tabController.index;
    final currentTab = tabs[currentTabIndex];
    
    context.read<LibraryBloc>().add(
      LibrarySearchRequested(
        query: query,
        type: currentTab['type'],
      ),
    );
  }
  
  void _clearSearch() {
    setState(() {
      _searchQuery = null;
    });
    
    final tabs = _getAvailableTabs();
    final currentTabIndex = _tabController.index;
    final currentTab = tabs[currentTabIndex];
    
    context.read<LibraryBloc>().add(
      LibraryItemsRequested(type: currentTab['type']),
    );
  }
  
  void _handleMenuAction(String action) {
    switch (action) {
      case 'sync':
        context.read<LibraryBloc>().add(
          const LibrarySyncRequested(),
        );
        break;
      case 'offline_mode':
        setState(() {
          _isOfflineMode = !_isOfflineMode;
        });
        context.read<LibraryBloc>().add(
          LibraryOfflineModeToggled(enableOfflineMode: _isOfflineMode),
        );
        break;
    }
  }
  
  void _showSyncProgress(BuildContext context, LibrarySyncInProgress state) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Syncing Library'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(value: state.progress),
            SizedBox(height: _theme.getDynamicSpacing(16)),
            Text(
              state.currentOperation,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
  
  // Update method signatures to use BLoC state
  Widget _buildDownloadsList(LibraryState state) {
    List<dynamic> downloads = [];
    
    if (state is LibraryLoaded && state.currentType == 'downloads') {
      downloads = state.items;
    } else {
      downloads = _downloads; // Fallback
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: downloads.length,
      itemBuilder: (context, index) {
        return _buildDownloadItem(downloads[index], index);
      },
    );
  }
  
  Widget _buildRecentItemsList(LibraryState state) {
    List<dynamic> recentItems = [];
    
    if (state is LibraryRecentItemsLoaded && state.type == 'played') {
      recentItems = state.recentItems;
    } else {
      // Use mock data for now
      recentItems = List.generate(5, (index) => {
        'id': 'recent_$index',
        'title': 'Recent Track ${index + 1}',
        'artist': 'Artist Name',
        'type': 'track',
      });
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentItems.length,
      itemBuilder: (context, index) {
        return _buildRecentItem(index, recentItems[index]);
      },
    );
  }
  
  Widget _buildRecentlyAddedList(LibraryState state) {
    List<dynamic> recentItems = [];
    
    if (state is LibraryRecentItemsLoaded && state.type == 'added') {
      recentItems = state.recentItems;
    } else {
      // Use mock data for now
      recentItems = List.generate(5, (index) => {
        'id': 'new_$index',
        'title': 'New Track ${index + 1}',
        'artist': 'Artist Name',
        'type': 'track',
      });
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recentItems.length,
      itemBuilder: (context, index) {
        return _buildRecentlyAddedItem(index, recentItems[index]);
      },
    );
  }

  IconData _getItemIcon(String type) {
    switch (type) {
      case 'track':
        return Icons.music_note;
      case 'album':
        return Icons.album;
      case 'artist':
        return Icons.person;
      case 'playlist':
        return Icons.playlist_play;
      default:
        return Icons.music_note;
    }
  }
  
  void _showFilterOptions() {
    final tabs = _getAvailableTabs();
    final currentTabIndex = _tabController.index;
    final currentTab = tabs[currentTabIndex];
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LibraryFilterSheet(
        currentType: currentTab['type'],
        currentFilters: _currentFilters,
      ),
    );
  }
  
  Future<void> _loadLibraryData() async {
    // Load real API data via ContentBloc
    context.read<ContentBloc>().add(LoadLikedContent());
  }

  Future<void> _loadPlaylists() async {
    // Playlists functionality to be implemented
    _playlists = [];
  }

  Future<void> _loadDownloads() async {
    // Downloads functionality to be implemented
    _downloads = [];
  }

  Future<void> _loadRecentItems() async {
    // Recent items functionality to be implemented
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort Library',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: _theme.getDynamicFontSize(20),
              ),
            ),
            SizedBox(height: _theme.getDynamicSpacing(16)),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text('Alphabetical'),
              onTap: () {
                Navigator.pop(context);
                _sortLibrary('alphabetical');
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Recently Added'),
              onTap: () {
                Navigator.pop(context);
                _sortLibrary('recent');
              },
            ),
            ListTile(
              leading: const Icon(Icons.play_circle),
              title: const Text('Most Played'),
              onTap: () {
                Navigator.pop(context);
                _sortLibrary('most_played');
              },
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Recently Liked'),
              onTap: () {
                Navigator.pop(context);
                _sortLibrary('recently_liked');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create New',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontSize: _theme.getDynamicFontSize(20),
              ),
            ),
            SizedBox(height: _theme.getDynamicSpacing(16)),
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('New Playlist'),
              onTap: () {
                Navigator.pop(context);
                _createPlaylist();
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: const Text('New Folder'),
              onTap: () {
                Navigator.pop(context);
                _createFolder();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sortLibrary(String sortType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sorted by $sortType')),
    );
  }

  void _createPlaylist() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const PlaylistCreationDialog(),
    );
    
    if (result == true) {
      // Refresh playlists tab
      context.read<LibraryBloc>().add(
        const LibraryItemsRequested(type: 'playlists'),
      );
    }
  }

  void _createFolder() async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Folder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Folder Name',
                hintText: 'Enter folder name',
              ),
            ),
            SizedBox(height: _theme.getDynamicSpacing(16)),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description (Optional)',
                hintText: 'Enter folder description',
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isNotEmpty) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
    
    if (result == true && nameController.text.trim().isNotEmpty) {
      context.read<LibraryBloc>().add(LibraryFolderCreated(
        name: nameController.text.trim(),
        description: descriptionController.text.trim().isEmpty 
            ? null 
            : descriptionController.text.trim(),
      ));
    }
    
    nameController.dispose();
    descriptionController.dispose();
  }

  void _viewAllItems(String type) {
    _navigation.navigateTo('/library-section', arguments: {'type': type});
  }

  void _handleItemAction(String action, Map<String, dynamic> item) {
    switch (action) {
      case 'play':
        _playItem(item);
        break;
      case 'remove':
        _removeFromLiked(item);
        break;
      case 'add_to_playlist':
        _addToPlaylist(item);
        break;
      case 'download':
        _downloadItem(item);
        break;
      case 'share':
        _shareItem(item);
        break;
      case 'add_to_queue':
        _addToQueue(item);
        break;
    }
  }
  
  void _downloadItem(Map<String, dynamic> item) {
    context.read<LibraryBloc>().add(
      LibraryItemToggleDownload(
        itemId: item['id'],
        type: item['type'] ?? 'track',
      ),
    );
  }
  
  void _shareItem(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing: ${item['title']}')),
    );
  }
  
  void _addToQueue(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added to queue: ${item['title']}')),
    );
  }

  void _handleDownloadAction(String action, Map<String, dynamic> download, int index) {
    switch (action) {
      case 'play':
        _playDownload(download);
        break;
      case 'delete':
        _deleteDownload(index);
        break;
    }
  }

  void _playItem(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing: ${item['title']}')),
    );
  }

  void _removeFromLiked(Map<String, dynamic> item) {
    setState(() {
      _libraryItems.removeWhere((i) => i['id'] == item['id']);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Removed: ${item['title']}')),
    );
  }

  void _addToPlaylist(Map<String, dynamic> item) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add to playlist not implemented yet')),
    );
  }

  void _playDownload(Map<String, dynamic> download) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing: ${download['title']}')),
    );
  }

  void _deleteDownload(int index) {
    setState(() {
      _downloads.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Download deleted')),
    );
  }

  void _openPlaylist(Map<String, dynamic> playlist, int index) {
    _navigation.navigateTo('/playlist-details', arguments: {
      'playlistId': playlist['id'],
      'playlistName': playlist['name'],
    });
  }

  void _playRecentlyAddedItem(int index, Map<String, dynamic> item) {
    context.read<LibraryBloc>().add(
      LibraryItemPlayRequested(
        itemId: item['id'],
        type: item['type'] ?? 'track',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing: ${item['title']}')),
    );
  }

  // Enhanced BLoC integration helper methods
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: _theme.getDynamicFontSize(64),
            color: Theme.of(context).colorScheme.error,
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: _theme.getDynamicSpacing(24)),
          ElevatedButton.icon(
            onPressed: () => _loadInitialData(),
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilteredContent(LibraryFiltered state, Map<String, dynamic> tab) {
    if (state.filteredItems.isEmpty) {
      return _buildEmptyFilteredState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<LibraryBloc>().add(LibraryItemsRefreshRequested(
          type: state.currentType,
        ));
      },
      child: ListView.builder(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        itemCount: state.filteredItems.length,
        itemBuilder: (context, index) {
          return _buildEnhancedLibraryItem(state.filteredItems[index], index);
        },
      ),
    );
  }

  Widget _buildLoadedContent(LibraryLoaded state, Map<String, dynamic> tab) {
    if (state.items.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<LibraryBloc>().add(LibraryItemsRefreshRequested(
          type: state.currentType,
        ));
      },
      child: ListView.builder(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          return _buildEnhancedLibraryItem(state.items[index], index);
        },
      ),
    );
  }

  Widget _buildEmptyFilteredState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.filter_list_off,
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
            'Try adjusting your filters to find more content',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: _theme.getDynamicSpacing(24)),
          ElevatedButton.icon(
            onPressed: _showFilterSheet,
            icon: const Icon(Icons.filter_list),
            label: const Text('Adjust Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedLibraryItem(Map<String, dynamic> item, int index) {
    final isDownloaded = _downloads.any((d) => d['itemId'] == item['id']);
    final isLiked = item['isLiked'] ?? false;
    
    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Icon(
                _getItemIcon(item['type'] ?? 'track'),
                color: Theme.of(context).primaryColor,
              ),
            ),
            if (isDownloaded)
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.all(_theme.getDynamicSpacing(2)),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.offline_bolt,
                    size: _theme.getDynamicFontSize(12),
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        title: Text(
          item['title'] ?? item['name'] ?? 'Unknown Item',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(14),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item['subtitle'] ?? item['artist'] ?? 'Unknown',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: _theme.getDynamicFontSize(12),
              ),
            ),
            if (item['duration'] != null) ...[
              SizedBox(height: _theme.getDynamicSpacing(4)),
              Text(
                _formatDuration(item['duration']),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: _theme.getDynamicFontSize(10),
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
            ],
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                color: isLiked ? Colors.red : null,
                size: _theme.getDynamicFontSize(20),
              ),
              onPressed: () => _toggleLike(item),
            ),
            PopupMenuButton(
              itemBuilder: (context) => _buildItemMenu(item, isDownloaded),
              onSelected: (value) => _handleEnhancedItemAction(value, item),
            ),
          ],
        ),
        onTap: () => _playItem(item),
      ),
    );
  }

  List<PopupMenuEntry> _buildItemMenu(Map<String, dynamic> item, bool isDownloaded) {
    return [
      const PopupMenuItem(
        value: 'play',
        child: ListTile(
          leading: Icon(Icons.play_arrow),
          title: Text('Play'),
          contentPadding: EdgeInsets.zero,
        ),
      ),
      PopupMenuItem(
        value: isDownloaded ? 'remove_download' : 'download',
        child: ListTile(
          leading: Icon(isDownloaded ? Icons.download_done : Icons.download),
          title: Text(isDownloaded ? 'Remove Download' : 'Download'),
          contentPadding: EdgeInsets.zero,
        ),
      ),
      const PopupMenuItem(
        value: 'add_to_playlist',
        child: ListTile(
          leading: Icon(Icons.playlist_add),
          title: Text('Add to Playlist'),
          contentPadding: EdgeInsets.zero,
        ),
      ),
      const PopupMenuItem(
        value: 'share',
        child: ListTile(
          leading: Icon(Icons.share),
          title: Text('Share'),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    ];
  }

  void _handleEnhancedItemAction(String action, Map<String, dynamic> item) {
    final itemId = item['id'] ?? item['itemId'] ?? '';
    final itemType = item['type'] ?? 'track';

    switch (action) {
      case 'play':
        context.read<LibraryBloc>().add(LibraryItemPlayRequested(
          itemId: itemId,
          type: itemType,
        ));
        break;
      case 'download':
        context.read<LibraryBloc>().add(LibraryItemToggleDownload(
          itemId: itemId,
          type: itemType,
        ));
        break;
      case 'remove_download':
        context.read<LibraryBloc>().add(LibraryItemToggleDownload(
          itemId: itemId,
          type: itemType,
        ));
        break;
      case 'add_to_playlist':
        _showAddToPlaylistDialog(item);
        break;
      case 'share':
        _shareItem(item);
        break;
    }
  }

  void _toggleLike(Map<String, dynamic> item) {
    final itemId = item['id'] ?? item['itemId'] ?? '';
    final itemType = item['type'] ?? 'track';
    
    context.read<LibraryBloc>().add(LibraryItemToggleLiked(
      itemId: itemId,
      type: itemType,
    ));
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: EnhancedLibraryFilterSheet(
          currentFilters: _currentFilters,
          libraryType: _getAvailableTabs()[_tabController.index]['type'],
        ),
      ),
    );
  }

  void _showAddToPlaylistDialog(Map<String, dynamic> item) {
    // Show dialog to add item to playlist
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add to playlist functionality coming soon')),
    );
  }

  void _shareItem(Map<String, dynamic> item) {
    // Handle item sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share functionality coming soon')),
    );
  }

  String _formatDuration(dynamic duration) {
    if (duration == null) return '';
    
    int totalSeconds;
    if (duration is String) {
      totalSeconds = int.tryParse(duration) ?? 0;
    } else if (duration is int) {
      totalSeconds = duration;
    } else {
      return '';
    }
    
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

}
  void _openRecommendedPlaylist(int index) {
    _navigation.navigateTo('/playlist-details', arguments: {
      'playlistId': 'recommended_$index',
      'playlistName': 'Recommended Playlist $index',
    });
  }

  void _playMostPlayedItem(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing most played track $index')),
    );
  }

  void _playRecentItem(int index, Map<String, dynamic> item) {
    context.read<LibraryBloc>().add(
      LibraryItemPlayRequested(
        itemId: item['id'],
        type: item['type'] ?? 'track',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing: ${item['title']}')),
    );
  }

  void _playRecentlyAddedItem(int index, Map<String, dynamic> item) {
    context.read<LibraryBloc>().add(
      LibraryItemPlayRequested(
        itemId: item['id'],
        type: item['type'] ?? 'track',
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Playing: ${item['title']}')),
    );
  }
}
