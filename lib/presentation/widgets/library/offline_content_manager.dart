import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/library/library_bloc.dart';
import '../../../blocs/library/library_event.dart';
import '../../../blocs/library/library_state.dart';
import '../../../core/theme/design_system.dart';

class OfflineContentManager extends StatefulWidget {
  final bool showFullInterface;
  final VoidCallback? onSyncRequested;

  const OfflineContentManager({
    super.key,
    this.showFullInterface = true,
    this.onSyncRequested,
  });

  @override
  State<OfflineContentManager> createState() => _OfflineContentManagerState();
}

class _OfflineContentManagerState extends State<OfflineContentManager>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isOfflineMode = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Load download queue and sync status
    context.read<LibraryBloc>().add(const LibraryDownloadQueueRequested());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showFullInterface) {
      return _buildCompactView();
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: DesignSystem.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: DesignSystem.onSurfaceVariant.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          _buildHeader(),
          
          // Tabs
          _buildTabBar(),
          
          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDownloadsTab(),
                _buildSyncTab(),
                _buildStorageTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactView() {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryDownloadProgress) {
          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: DesignSystem.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: DesignSystem.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    value: state.progress,
                    strokeWidth: 2,
                    color: DesignSystem.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Downloading...',
                        style: TextStyle(
                          color: DesignSystem.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${(state.progress * 100).toInt()}% complete',
                        style: const TextStyle(
                          color: DesignSystem.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showFullInterface();
                  },
                  icon: const Icon(Icons.expand_less),
                  color: DesignSystem.primary,
                  iconSize: 20,
                ),
              ],
            ),
          );
        }

        if (state is LibraryOfflineSync && state.isSyncing) {
          return Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: DesignSystem.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: DesignSystem.secondary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: DesignSystem.secondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Syncing Library',
                        style: TextStyle(
                          color: DesignSystem.secondary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        state.status ?? 'Preparing...',
                        style: const TextStyle(
                          color: DesignSystem.onSurfaceVariant,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showFullInterface();
                  },
                  icon: const Icon(Icons.expand_less),
                  color: DesignSystem.secondary,
                  iconSize: 20,
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: DesignSystem.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.offline_bolt,
              color: DesignSystem.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Offline Content',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Manage downloads and offline sync',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: DesignSystem.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          _buildOfflineModeToggle(),
        ],
      ),
    );
  }

  Widget _buildOfflineModeToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _isOfflineMode
            ? DesignSystem.primary.withValues(alpha: 0.2)
            : DesignSystem.surfaceContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isOfflineMode
              ? DesignSystem.primary
              : DesignSystem.onSurfaceVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isOfflineMode ? Icons.offline_bolt : Icons.cloud,
            size: 16,
            color: _isOfflineMode
                ? DesignSystem.primary
                : DesignSystem.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            _isOfflineMode ? 'Offline' : 'Online',
            style: TextStyle(
              color: _isOfflineMode
                  ? DesignSystem.primary
                  : DesignSystem.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          Switch(
            value: _isOfflineMode,
            onChanged: (value) {
              setState(() {
                _isOfflineMode = value;
              });
              context.read<LibraryBloc>().add(
                LibraryOfflineModeToggled(enableOfflineMode: value),
              );
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            activeThumbColor: DesignSystem.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: DesignSystem.primary,
      unselectedLabelColor: DesignSystem.onSurfaceVariant,
      indicatorColor: DesignSystem.primary,
      tabs: const [
        Tab(
          icon: Icon(Icons.download),
          text: 'Downloads',
        ),
        Tab(
          icon: Icon(Icons.sync),
          text: 'Sync',
        ),
        Tab(
          icon: Icon(Icons.storage),
          text: 'Storage',
        ),
      ],
    );
  }

  Widget _buildDownloadsTab() {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryDownloadQueueLoaded) {
          return _buildDownloadsList(state);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildDownloadQuickActions(),
              const SizedBox(height: 24),
              _buildDownloadPlaceholder(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDownloadsList(LibraryDownloadQueueLoaded state) {
    if (state.downloadQueue.isEmpty) {
      return _buildDownloadPlaceholder();
    }

    return Column(
      children: [
        // Download Summary
        Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: DesignSystem.surfaceContainer.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: DesignSystem.onSurfaceVariant.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildDownloadStat(
                  'Total',
                  '${state.totalDownloads}',
                  Icons.download,
                  DesignSystem.primary,
                ),
              ),
              Expanded(
                child: _buildDownloadStat(
                  'Completed',
                  '${state.completedDownloads}',
                  Icons.check_circle,
                  DesignSystem.success,
                ),
              ),
              Expanded(
                child: _buildDownloadStat(
                  'Active',
                  '${state.totalDownloads - state.completedDownloads}',
                  Icons.downloading,
                  DesignSystem.accentBlue,
                ),
              ),
            ],
          ),
        ),

        // Downloads List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: state.downloadQueue.length,
            itemBuilder: (context, index) {
              final download = state.downloadQueue[index];
              final progress = state.downloadProgress[download['itemId']] ?? 0.0;
              return _buildDownloadItem(download, progress);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: DesignSystem.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadItem(Map<String, dynamic> download, double progress) {
    final status = download['status'] ?? 'pending';
    final isCompleted = status == 'completed';
    final isDownloading = status == 'downloading';
    final isFailed = status == 'failed';

    Color statusColor;
    IconData statusIcon;

    if (isCompleted) {
      statusColor = DesignSystem.success;
      statusIcon = Icons.check_circle;
    } else if (isDownloading) {
      statusColor = DesignSystem.primary;
      statusIcon = Icons.downloading;
    } else if (isFailed) {
      statusColor = DesignSystem.error;
      statusIcon = Icons.error;
    } else {
      statusColor = DesignSystem.onSurfaceVariant;
      statusIcon = Icons.pending;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                statusIcon,
                color: statusColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      download['title'] ?? 'Unknown Item',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      download['artist'] ?? 'Unknown Artist',
                      style: const TextStyle(
                        color: DesignSystem.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (isDownloading) ...[
                Text(
                  '${(progress * 100).toInt()}%',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              PopupMenuButton<String>(
                onSelected: (action) => _handleDownloadAction(download, action),
                itemBuilder: (context) => [
                  if (isDownloading)
                    const PopupMenuItem(
                      value: 'pause',
                      child: Row(
                        children: [
                          Icon(Icons.pause, size: 16),
                          SizedBox(width: 8),
                          Text('Pause'),
                        ],
                      ),
                    ),
                  if (!isCompleted && !isDownloading)
                    const PopupMenuItem(
                      value: 'retry',
                      child: Row(
                        children: [
                          Icon(Icons.refresh, size: 16),
                          SizedBox(width: 8),
                          Text('Retry'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'remove',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16),
                        SizedBox(width: 8),
                        Text('Remove'),
                      ],
                    ),
                  ),
                ],
                icon: const Icon(
                  Icons.more_vert,
                  color: DesignSystem.onSurfaceVariant,
                  size: 16,
                ),
              ),
            ],
          ),
          if (isDownloading) ...[
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: DesignSystem.onSurfaceVariant.withValues(alpha: 0.2),
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDownloadQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickActionButton(
            'Download All Liked',
            Icons.favorite,
            DesignSystem.accentBlue,
            () => _downloadCategory('liked'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionButton(
            'Download Playlists',
            Icons.playlist_play,
            DesignSystem.secondary,
            () => _downloadCategory('playlists'),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadPlaceholder() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download_outlined,
            size: 64,
            color: DesignSystem.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Downloads Yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Downloaded songs will appear here',
            style: TextStyle(
              color: DesignSystem.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          _buildDownloadQuickActions(),
        ],
      ),
    );
  }

  Widget _buildSyncTab() {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildSyncStatus(state),
              const SizedBox(height: 24),
              _buildSyncActions(),
              const SizedBox(height: 24),
              _buildSyncSettings(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSyncStatus(LibraryState state) {
    if (state is LibraryOfflineSync) {
      return _buildActiveSyncStatus(state);
    }

    // Default sync status
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DesignSystem.onSurfaceVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.sync,
            size: 48,
            color: DesignSystem.secondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Library Sync',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Keep your library up to date across all devices',
            style: TextStyle(
              color: DesignSystem.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSyncStat('Last Sync', '2 hours ago', Icons.access_time),
              ),
              Expanded(
                child: _buildSyncStat('Items Synced', '1,234', Icons.library_music),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveSyncStatus(LibraryOfflineSync state) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignSystem.secondary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DesignSystem.secondary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          if (state.isSyncing) ...[
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: DesignSystem.secondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Syncing Library',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: DesignSystem.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.status ?? 'Preparing sync...',
              style: const TextStyle(
                color: DesignSystem.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (state.itemsSynced != null && state.totalItems != null) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: state.itemsSynced! / state.totalItems!,
                backgroundColor: DesignSystem.onSurfaceVariant.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(DesignSystem.secondary),
              ),
              const SizedBox(height: 8),
              Text(
                '${state.itemsSynced} / ${state.totalItems} items',
                style: const TextStyle(
                  color: DesignSystem.onSurfaceVariant,
                  fontSize: 12,
                ),
              ),
            ],
          ] else ...[
            const Icon(
              Icons.check_circle,
              size: 48,
              color: DesignSystem.success,
            ),
            const SizedBox(height: 16),
            Text(
              'Sync Complete',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: DesignSystem.success,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (state.lastSyncTime != null) ...[
              const SizedBox(height: 8),
              Text(
                'Last synced: ${_formatSyncTime(state.lastSyncTime!)}',
                style: const TextStyle(
                  color: DesignSystem.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSyncStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: DesignSystem.secondary, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: DesignSystem.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSyncActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              context.read<LibraryBloc>().add(const LibrarySyncRequested());
              widget.onSyncRequested?.call();
            },
            icon: const Icon(Icons.sync),
            label: const Text('Sync Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignSystem.secondary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<LibraryBloc>().add(const LibraryOfflineSyncRequested());
                },
                icon: const Icon(Icons.offline_bolt),
                label: const Text('Offline Sync'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  context.read<LibraryBloc>().add(
                    const LibrarySyncRequested(forceSync: true),
                  );
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Force Sync'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSyncSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sync Settings',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _buildSettingsTile(
          'Auto Sync',
          'Automatically sync when changes are detected',
          true,
          (value) {},
        ),
        _buildSettingsTile(
          'Sync on WiFi Only',
          'Only sync when connected to WiFi',
          true,
          (value) {},
        ),
        _buildSettingsTile(
          'Background Sync',
          'Continue syncing in the background',
          false,
          (value) {},
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: DesignSystem.onSurfaceVariant),
        ),
        value: value,
        onChanged: onChanged,
        activeThumbColor: DesignSystem.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        tileColor: DesignSystem.surfaceContainer.withValues(alpha: 0.1),
      ),
    );
  }

  Widget _buildStorageTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _buildStorageOverview(),
          const SizedBox(height: 24),
          _buildStorageBreakdown(),
          const SizedBox(height: 24),
          _buildStorageActions(),
        ],
      ),
    );
  }

  Widget _buildStorageOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DesignSystem.onSurfaceVariant.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Storage Usage',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: 0.65, // 65% used
                  strokeWidth: 12,
                  backgroundColor: DesignSystem.onSurfaceVariant.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(DesignSystem.accentPurple),
                ),
              ),
              Column(
                children: [
                  Text(
                    '2.1 GB',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Text(
                    'of 3.2 GB',
                    style: TextStyle(
                      color: DesignSystem.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            '1.1 GB available',
            style: TextStyle(
              color: DesignSystem.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageBreakdown() {
    final items = [
      {'label': 'Downloaded Music', 'size': '1.8 GB', 'color': DesignSystem.primary},
      {'label': 'Cache', 'size': '245 MB', 'color': DesignSystem.secondary},
      {'label': 'Thumbnails', 'size': '67 MB', 'color': DesignSystem.accentPurple},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Storage Breakdown',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map((item) => _buildStorageItem(
          item['label'] as String,
          item['size'] as String,
          item['color'] as Color,
        )),
      ],
    );
  }

  Widget _buildStorageItem(String label, String size, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            size,
            style: const TextStyle(
              color: DesignSystem.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.cleaning_services),
            label: const Text('Clear Cache'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.delete_sweep),
            label: const Text('Clear All Downloads'),
            style: OutlinedButton.styleFrom(
              foregroundColor: DesignSystem.error,
              side: const BorderSide(color: DesignSystem.error),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showFullInterface() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => OfflineContentManager(
        showFullInterface: true,
        onSyncRequested: widget.onSyncRequested,
      ),
    );
  }

  void _handleDownloadAction(Map<String, dynamic> download, String action) {
    switch (action) {
      case 'pause':
        // Handle pause
        break;
      case 'retry':
        // Handle retry
        break;
      case 'remove':
        // Handle remove
        break;
    }
  }

  void _downloadCategory(String category) {
    // Handle category download
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Starting download for $category'),
        backgroundColor: DesignSystem.primary,
      ),
    );
  }

  String _formatSyncTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
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
}