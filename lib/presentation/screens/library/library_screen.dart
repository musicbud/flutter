import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/library/library_bloc.dart';
import '../../../blocs/library/library_event.dart';
import '../../../blocs/library/library_state.dart';
import '../../widgets/imported/index.dart';
import '../../../presentation/navigation/main_navigation.dart';
import '../../../presentation/navigation/navigation_drawer.dart';
import 'library_tab_manager.dart';
import 'tabs/playlists_tab.dart';
import 'tabs/liked_songs_tab.dart';
import 'tabs/downloads_tab.dart';
import 'tabs/recently_played_tab.dart';
import '../../widgets/library/offline_content_manager.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with LoadingStateMixin, ErrorStateMixin, TickerProviderStateMixin {
  
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  late final MainNavigationController _navigationController;
  
  String _selectedTab = 'Playlists';
  int _selectedIndex = 0;
  bool _isSearchMode = false;

  @override
  void initState() {
    super.initState();
    _navigationController = MainNavigationController();
    _initializeData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _navigationController.dispose();
    super.dispose();
  }

  void _initializeData() {
    setLoadingState(LoadingState.loading);
    context.read<LibraryBloc>().add(const LibraryItemsRequested(type: 'playlists'));
  }

  void _onTabChanged(String tab) {
    setState(() {
      _selectedTab = tab;
      _selectedIndex = ['Playlists', 'Liked Songs', 'Downloads', 'Recently Played'].indexOf(tab);
    });
    
    // Load data for the selected tab
    final tabType = tab.toLowerCase().replaceAll(' ', '_');
    context.read<LibraryBloc>().add(LibraryItemsRequested(type: tabType));
  }

  void _toggleSearchMode() {
    setState(() {
      _isSearchMode = !_isSearchMode;
      if (!_isSearchMode) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryBloc, LibraryState>(
      listener: (context, state) {
        if (state is LibraryActionFailure) {
          setError(
            state.error,
            type: ErrorType.network,
            retryable: true,
          );
          setLoadingState(LoadingState.error);
        } else if (state is LibraryActionSuccess) {
          setLoadingState(LoadingState.loaded);
          _showSuccessMessage(state.message);
        } else if (state is LibraryLoaded) {
          setLoadingState(LoadingState.loaded);
        } else if (state is LibraryLoading) {
          setLoadingState(LoadingState.loading);
        } else if (state is LibraryError) {
          setError(
            state.message,
            type: ErrorType.network,
            retryable: true,
          );
          setLoadingState(LoadingState.error);
        } else if (state is LibraryOfflineSync && state.isSyncing) {
          _showSyncingMessage(state.status ?? 'Syncing library...');
        } else if (state is LibraryDownloadProgress) {
          if (state.status == 'completed') {
            _showSuccessMessage('Download completed for ${state.itemId}');
          }
        }
      },
      builder: (context, state) {
        return AppScaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: const Text('Library'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(_isSearchMode ? Icons.close : Icons.search),
                onPressed: _toggleSearchMode,
                tooltip: _isSearchMode ? 'Close Search' : 'Search Library',
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _initializeData,
                tooltip: 'Refresh',
              ),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () => _showLibraryOptionsBottomSheet(context),
                tooltip: 'Library Options',
              ),
            ],
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
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
                  return _buildMobileLayout(state);
                case ResponsiveBreakpoint.md:
                case ResponsiveBreakpoint.lg:
                case ResponsiveBreakpoint.xl:
                  return _buildDesktopLayout(state);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(LibraryState state) {
    return buildLoadingState(
      context: context,
      loadedWidget: RefreshIndicator(
        onRefresh: () async {
          _initializeData();
          await Future.delayed(const Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: [
            _buildHeaderSection(state),
            if (_isSearchMode) _buildSearchSection(),
            _buildStatsSection(state),
            _buildQuickActionsSection(),
            _buildTabsSection(),
            _buildContentSection(),
            _buildOfflineSection(),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
      loadingWidget: _buildLoadingWidget(),
      errorWidget: buildDefaultErrorWidget(
        context: context,
        onRetry: _initializeData,
      ),
    );
  }

  Widget _buildDesktopLayout(LibraryState state) {
    return buildLoadingState(
      context: context,
      loadedWidget: Row(
        children: [
          SizedBox(
            width: 400,
            child: _buildLibrarySidebar(state),
          ),
          Expanded(
            child: _buildMainContent(state),
          ),
        ],
      ),
      loadingWidget: _buildLoadingWidget(),
      errorWidget: buildDefaultErrorWidget(
        context: context,
        onRetry: _initializeData,
      ),
    );
  }

  Widget _buildLibrarySidebar(LibraryState state) {
    return ModernCard(
      variant: ModernCardVariant.outlined,
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.library_music, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'My Library',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(_isSearchMode ? Icons.close : Icons.search),
                      onPressed: _toggleSearchMode,
                      tooltip: _isSearchMode ? 'Close Search' : 'Search Library',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _getLibrarySubtitle(state),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (_isSearchMode) _buildSidebarSearch(),
          _buildSidebarStats(state),
          Expanded(child: _buildSidebarActions()),
        ],
      ),
    );
  }

  Widget _buildSidebarSearch() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: ModernInputField(
        controller: _searchController,
        hintText: 'Search your library...',
        prefixIcon: const Icon(Icons.search),
        onChanged: (query) {
          // Implement search functionality
        },
      ),
    );
  }

  Widget _buildSidebarStats(LibraryState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ModernCard(
        variant: ModernCardVariant.primary,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('Playlists', '12', Icons.playlist_play),
              _buildStatItem('Songs', '2.4K', Icons.music_note),
              _buildStatItem('Artists', '189', Icons.person),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.blue[700]),
        const SizedBox(height: 4),
        Text(
          count,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSidebarActions() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          ModernButton(
            text: 'Create Playlist',
            onPressed: () => _showCreatePlaylistDialog(context),
            icon: Icons.add,
            size: ModernButtonSize.large,
            variant: ModernButtonVariant.primary,
          ),
          const SizedBox(height: 12),
          ModernButton(
            text: 'Create Folder',
            onPressed: () => _showCreateFolderDialog(context),
            icon: Icons.folder_outlined,
            size: ModernButtonSize.large,
            variant: ModernButtonVariant.outline,
          ),
          const SizedBox(height: 20),
          ModernButton(
            text: 'Sync Library',
            onPressed: () {
              context.read<LibraryBloc>().add(const LibrarySyncRequested());
            },
            icon: Icons.sync,
            variant: ModernButtonVariant.secondary,
            isFullWidth: true,
          ),
          const SizedBox(height: 8),
          ModernButton(
            text: 'Offline Mode',
            onPressed: () => _toggleOfflineMode(),
            icon: Icons.offline_bolt,
            variant: ModernButtonVariant.accent,
            isFullWidth: true,
          ),
          const SizedBox(height: 8),
          ModernButton(
            text: 'Statistics',
            onPressed: () {
              context.read<LibraryBloc>().add(const LibraryStatsRequested());
            },
            icon: Icons.analytics,
            variant: ModernButtonVariant.text,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(LibraryState state) {
    return RefreshIndicator(
      onRefresh: () async {
        _initializeData();
        await Future.delayed(const Duration(seconds: 1));
      },
      child: CustomScrollView(
        slivers: [
          _buildTabsSection(),
          _buildContentSection(),
          _buildOfflineSection(),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildHeaderSection(LibraryState state) {
    return SliverToBoxAdapter(
      child: ModernCard(
        variant: ModernCardVariant.elevated,
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.library_music, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Library',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getLibrarySubtitle(state),
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<LibraryBloc>().add(const LibraryStatsRequested());
                    },
                    icon: const Icon(Icons.analytics_outlined),
                    tooltip: 'View Statistics',
                  ),
                ],
              ),
              if (state is LibraryOfflineSync && !state.isSyncing && state.lastSyncTime != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.sync,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Last synced: ${_formatLastSync(state.lastSyncTime!)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ModernCard(
          variant: ModernCardVariant.outlined,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ModernInputField(
              controller: _searchController,
              hintText: 'Search playlists, songs, artists...',
              prefixIcon: const Icon(Icons.search),
              onChanged: (query) {
                // Implement search functionality
                if (query.isNotEmpty) {
                  context.read<LibraryBloc>().add(
                    LibrarySearchRequested(query: query, type: _selectedTab.toLowerCase().replaceAll(' ', '_')),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(LibraryState state) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ModernCard(
                variant: ModernCardVariant.primary,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.playlist_play, size: 24, color: Colors.blue),
                      const SizedBox(height: 8),
                      const Text(
                        '12',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Playlists',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ModernCard(
                variant: ModernCardVariant.primary,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.music_note, size: 24, color: Colors.green),
                      const SizedBox(height: 8),
                      const Text(
                        '2.4K',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Songs',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ModernCard(
                variant: ModernCardVariant.primary,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Icon(Icons.person, size: 24, color: Colors.purple),
                      const SizedBox(height: 8),
                      const Text(
                        '189',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Artists',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: ModernButton(
                text: 'Create Playlist',
                onPressed: () => _showCreatePlaylistDialog(context),
                icon: Icons.add,
                size: ModernButtonSize.large,
                variant: ModernButtonVariant.primary,
              ),
            ),
            const SizedBox(width: 12),
            ModernButton(
              text: 'Create Folder',
              onPressed: () => _showCreateFolderDialog(context),
              icon: Icons.folder_outlined,
              size: ModernButtonSize.large,
              variant: ModernButtonVariant.outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabsSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ModernCard(
          variant: ModernCardVariant.outlined,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: LibraryTabManager(
              selectedTab: _selectedTab,
              selectedIndex: _selectedIndex,
              onTabChanged: _onTabChanged,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ModernCard(
          variant: ModernCardVariant.elevated,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildTabContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildOfflineSection() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: OfflineContentManager(
          showFullInterface: false,
        ),
      ),
    );
  }

  Widget _buildLoadingWidget() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingIndicator(),
        SizedBox(height: 16),
        Text(
          'Loading your library...',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTab) {
      case 'Playlists':
        return const PlaylistsTab();
      case 'Liked Songs':
        return const LikedSongsTab();
      case 'Downloads':
        return const DownloadsTab();
      case 'Recently Played':
        return const RecentlyPlayedTab();
      default:
        return const PlaylistsTab();
    }
  }

  String _getLibrarySubtitle(LibraryState state) {
    if (state is LibraryLoaded) {
      return '${state.totalCount} ${state.currentType.replaceAll('_', ' ')}';
    } else if (state is LibraryStatsLoaded) {
      return '${state.totalTracks} tracks • ${state.totalPlaylists} playlists';
    } else if (state is LibraryFiltered) {
      return '${state.totalCount} filtered results';
    } else if (state is LibraryOfflineModeEnabled) {
      return state.isOfflineMode 
          ? '${state.offlineItems.length} items (offline)' 
          : 'Your personal music collection';
    }
    return 'Your personal music collection';
  }

  String _formatLastSync(DateTime lastSync) {
    final now = DateTime.now();
    final difference = now.difference(lastSync);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  void _showCreatePlaylistDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    bool isPrivate = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          child: ModernCard(
            variant: ModernCardVariant.elevated,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create New Playlist',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ModernInputField(
                    controller: nameController,
                    hintText: 'Enter playlist name',
                    prefixIcon: const Icon(Icons.playlist_play),
                  ),
                  const SizedBox(height: 16),
                  ModernInputField(
                    controller: descriptionController,
                    hintText: 'Enter description (optional)',
                    maxLines: 3,
                    prefixIcon: const Icon(Icons.description),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: isPrivate,
                        onChanged: (value) => setState(() => isPrivate = value ?? false),
                      ),
                      const SizedBox(width: 8),
                      const Text('Private Playlist'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ModernButton(
                        text: 'Cancel',
                        onPressed: () => Navigator.of(context).pop(),
                        variant: ModernButtonVariant.text,
                      ),
                      const SizedBox(width: 12),
                      ModernButton(
                        text: 'Create',
                        onPressed: () {
                          if (nameController.text.isNotEmpty) {
                            context.read<LibraryBloc>().add(
                              LibraryPlaylistCreated(
                                name: nameController.text,
                                description: descriptionController.text.isEmpty 
                                    ? null 
                                    : descriptionController.text,
                                isPrivate: isPrivate,
                              ),
                            );
                            Navigator.of(context).pop();
                          }
                        },
                        variant: ModernButtonVariant.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateFolderDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ModernCard(
          variant: ModernCardVariant.elevated,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create New Folder',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ModernInputField(
                  controller: nameController,
                  hintText: 'Enter folder name',
                  prefixIcon: const Icon(Icons.folder),
                ),
                const SizedBox(height: 16),
                ModernInputField(
                  controller: descriptionController,
                  hintText: 'Enter description (optional)',
                  maxLines: 3,
                  prefixIcon: const Icon(Icons.description),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ModernButton(
                      text: 'Cancel',
                      onPressed: () => Navigator.of(context).pop(),
                      variant: ModernButtonVariant.text,
                    ),
                    const SizedBox(width: 12),
                    ModernButton(
                      text: 'Create',
                      onPressed: () {
                        if (nameController.text.isNotEmpty) {
                          context.read<LibraryBloc>().add(
                            LibraryFolderCreated(
                              name: nameController.text,
                              description: descriptionController.text.isEmpty 
                                  ? null 
                                  : descriptionController.text,
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      },
                      variant: ModernButtonVariant.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showLibraryOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ModernCard(
        variant: ModernCardVariant.elevated,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Library Options',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildOptionTile(
                'Sync Library',
                'Sync your library with the cloud',
                Icons.sync,
                Colors.blue,
                () {
                  context.read<LibraryBloc>().add(const LibrarySyncRequested());
                  Navigator.pop(context);
                },
              ),
              _buildOptionTile(
                'Offline Mode',
                'Toggle offline-only content',
                Icons.offline_bolt,
                Colors.orange,
                () {
                  _toggleOfflineMode();
                  Navigator.pop(context);
                },
              ),
              _buildOptionTile(
                'Library Statistics',
                'View detailed stats',
                Icons.analytics,
                Colors.green,
                () {
                  context.read<LibraryBloc>().add(const LibraryStatsRequested());
                  Navigator.pop(context);
                },
              ),
              _buildOptionTile(
                'Advanced Filters',
                'Filter and sort options',
                Icons.filter_alt,
                Colors.purple,
                () {
                  Navigator.pop(context);
                  _showComingSoon('Advanced Filters');
                },
              ),
              _buildOptionTile(
                'Offline Management',
                'Downloads and sync settings',
                Icons.download,
                Colors.indigo,
                () {
                  Navigator.pop(context);
                  _showOfflineContentManager(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile(
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: iconColor.withValues(alpha: 0.1),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title),
      subtitle: Text(subtitle),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }

  void _toggleOfflineMode() {
    context.read<LibraryBloc>().add(const LibraryOfflineModeToggled(enableOfflineMode: true));
  }

  void _showOfflineContentManager(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => OfflineContentManager(
        showFullInterface: true,
        onSyncRequested: () {
          _showSuccessMessage('Library sync initiated');
        },
      ),
    );
  }

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showSyncingMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Text(message),
            ],
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
          content: Text('Library loaded!'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  };
}