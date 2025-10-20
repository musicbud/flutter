import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/library/library_bloc.dart';
import '../../../blocs/library/library_event.dart';
import '../../../blocs/library/library_state.dart';
import '../../../core/theme/design_system.dart';
// MIGRATED: import '../../../widgets/common/index.dart';
import '../../../presentation/navigation/main_navigation.dart';
import '../../../presentation/navigation/navigation_drawer.dart';
import 'library_tab_manager.dart';
import 'library_search_section.dart';
import 'tabs/playlists_tab.dart';
import 'tabs/liked_songs_tab.dart';
import 'tabs/downloads_tab.dart';
import 'tabs/recently_played_tab.dart';
import '../../widgets/library/offline_content_manager.dart';
import '../../widgets/enhanced/enhanced_widgets.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();
  late final MainNavigationController _navigationController;
  String _selectedTab = 'Playlists';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _navigationController = MainNavigationController();
    // Load initial playlists
    context.read<LibraryBloc>().add(const LibraryItemsRequested(type: 'playlists'));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _navigationController.dispose();
    super.dispose();
  }

  void _onTabChanged(String tab) {
    setState(() {
      _selectedTab = tab;
      _selectedIndex = ['Playlists', 'Liked Songs', 'Downloads', 'Recently Played'].indexOf(tab);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Library'),
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
        decoration: const BoxDecoration(
          gradient: DesignSystem.gradientBackground,
        ),
        child: BlocConsumer<LibraryBloc, LibraryState>(
          listener: (context, state) {
            if (state is LibraryActionSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: DesignSystem.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is LibraryActionFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: DesignSystem.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is LibraryOfflineSync && state.isSyncing) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(state.status ?? 'Syncing library...'),
                    ],
                  ),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is LibraryDownloadProgress) {
              if (state.status == 'completed') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Download completed for ${state.itemId}'),
                    backgroundColor: DesignSystem.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          },
          builder: (context, state) {
            // Handle loading state
            if (state is LibraryLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: DesignSystem.primary,
                ),
              );
            }
            
            // Handle error state
            if (state is LibraryError) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<LibraryBloc>().add(LibraryItemsRequested(type: _selectedTab.toLowerCase().replaceAll(' ', '_')));
                },
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: DesignSystem.error,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Something went wrong',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: DesignSystem.onSurfaceVariant,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                context.read<LibraryBloc>().add(LibraryItemsRequested(type: _selectedTab.toLowerCase().replaceAll(' ', '_')));
                              },
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            
            // Handle sync progress state
            if (state is LibrarySyncInProgress) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: state.progress,
                      color: DesignSystem.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.currentOperation,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(state.progress * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: DesignSystem.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                context.read<LibraryBloc>().add(LibraryItemsRequested(type: _selectedTab.toLowerCase().replaceAll(' ', '_')));
              },
              child: CustomScrollView(
              slivers: [
                // Header Section with enhanced stats
                SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'My Library',
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _getLibrarySubtitle(state),
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: DesignSystem.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            // Action buttons
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context.read<LibraryBloc>().add(const LibraryStatsRequested());
                                  },
                                  icon: const Icon(Icons.analytics_outlined),
                                  color: DesignSystem.onSurfaceVariant,
                                ),
                                IconButton(
                                  onPressed: () {
                                    _showLibraryOptionsBottomSheet(context);
                                  },
                                  icon: const Icon(Icons.more_vert),
                                  color: DesignSystem.onSurfaceVariant,
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Sync status indicator
                        if (state is LibraryOfflineSync && !state.isSyncing && state.lastSyncTime != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.sync,
                                size: 16,
                                color: DesignSystem.onSurfaceVariant,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Last synced: ${_formatLastSync(state.lastSyncTime!)}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: DesignSystem.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Search Section
                SliverToBoxAdapter(
                  child: LibrarySearchSection(
                    selectedTab: _selectedTab,
                    searchController: _searchController,
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),

                // Create Playlist Button (only show in Playlists tab)
                if (_selectedTab == 'Playlists')
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              text: 'Create New Playlist',
                              onPressed: () {
                                _showCreatePlaylistDialog(context);
                              },
                              icon: Icons.add,
                              size: ModernButtonSize.large,
                            ),
                          ),
                          const SizedBox(width: 12),
                          SecondaryButton(
                            text: 'Create Folder',
                            onPressed: () {
                              _showCreateFolderDialog(context);
                            },
                            icon: Icons.folder_outlined,
                            size: ModernButtonSize.large,
                          ),
                        ],
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),

                // Library Items Section (for search results)
                if (state is LibraryLoaded && state.items.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        '${state.totalCount} $_selectedTab',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: DesignSystem.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: 24),
                  ),
                ],

                // Tab Manager
                SliverToBoxAdapter(
                  child: LibraryTabManager(
                    selectedTab: _selectedTab,
                    selectedIndex: _selectedIndex,
                    onTabChanged: _onTabChanged,
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),

                // Content based on selected tab
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildTabContent(),
                  ),
                ),

                // Offline Content Manager (Compact View)
                const SliverToBoxAdapter(
                  child: OfflineContentManager(
                    showFullInterface: false,
                  ),
                ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],
            ),
           );
         },
       ),
      ),
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
        builder: (context, setState) => AlertDialog(
          backgroundColor: DesignSystem.surface,
          title: const Text(
            'Create New Playlist',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Playlist Name',
                  labelStyle: TextStyle(color: DesignSystem.onSurfaceVariant),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: DesignSystem.onSurfaceVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: DesignSystem.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  labelStyle: TextStyle(color: DesignSystem.onSurfaceVariant),
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: DesignSystem.onSurfaceVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: DesignSystem.primary),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text('Private Playlist', style: TextStyle(color: Colors.white)),
                value: isPrivate,
                onChanged: (value) => setState(() => isPrivate = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancel',
                style: TextStyle(color: DesignSystem.onSurfaceVariant),
              ),
            ),
            ElevatedButton(
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
              style: ElevatedButton.styleFrom(
                backgroundColor: DesignSystem.primary,
              ),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateFolderDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignSystem.surface,
        title: const Text(
          'Create New Folder',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Folder Name',
                labelStyle: TextStyle(color: DesignSystem.onSurfaceVariant),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: DesignSystem.onSurfaceVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: DesignSystem.primary),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              style: const TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Description (optional)',
                labelStyle: TextStyle(color: DesignSystem.onSurfaceVariant),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: DesignSystem.onSurfaceVariant),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: DesignSystem.primary),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: DesignSystem.onSurfaceVariant),
            ),
          ),
          ElevatedButton(
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
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignSystem.primary,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showLibraryOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: DesignSystem.surface,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Library Options',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.sync, color: DesignSystem.primary),
              title: const Text('Sync Library', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Sync your library with the cloud', style: TextStyle(color: DesignSystem.onSurfaceVariant)),
              onTap: () {
                context.read<LibraryBloc>().add(const LibrarySyncRequested());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.offline_bolt, color: DesignSystem.accentBlue),
              title: const Text('Offline Mode', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Toggle offline-only content', style: TextStyle(color: DesignSystem.onSurfaceVariant)),
              onTap: () {
                context.read<LibraryBloc>().add(const LibraryOfflineModeToggled(enableOfflineMode: true));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics, color: DesignSystem.secondary),
              title: const Text('Library Statistics', style: TextStyle(color: Colors.white)),
              subtitle: const Text('View detailed stats', style: TextStyle(color: DesignSystem.onSurfaceVariant)),
              onTap: () {
                context.read<LibraryBloc>().add(const LibraryStatsRequested());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.filter_alt, color: DesignSystem.accentPurple),
              title: const Text('Advanced Filters', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Filter and sort options', style: TextStyle(color: DesignSystem.onSurfaceVariant)),
              onTap: () {
                Navigator.pop(context);
                _showAdvancedFiltersSheet(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.offline_bolt, color: DesignSystem.accentBlue),
              title: const Text('Offline Management', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Downloads and sync settings', style: TextStyle(color: DesignSystem.onSurfaceVariant)),
              onTap: () {
                Navigator.pop(context);
                _showOfflineContentManager(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAdvancedFiltersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: DesignSystem.surface,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Filter Options', style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 16),
            const Text('Advanced filtering coming soon!', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showOfflineContentManager(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => OfflineContentManager(
        showFullInterface: true,
        onSyncRequested: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Library sync initiated'),
              backgroundColor: DesignSystem.success,
            ),
          );
        },
      ),
    );
  }
}
