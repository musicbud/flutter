import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/library/library_bloc.dart';
import '../../../blocs/library/library_event.dart';
import '../../../blocs/library/library_state.dart';
import '../../../services/dynamic_theme_service.dart';

class OfflineDownloadManager extends StatefulWidget {
  const OfflineDownloadManager({super.key});

  @override
  State<OfflineDownloadManager> createState() => _OfflineDownloadManagerState();
}

class _OfflineDownloadManagerState extends State<OfflineDownloadManager>
    with SingleTickerProviderStateMixin {
  final DynamicThemeService _theme = DynamicThemeService.instance;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Load download queue on init
    context.read<LibraryBloc>().add(const LibraryDownloadQueueRequested());
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Download Manager',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontSize: _theme.getDynamicFontSize(20),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.download_outlined),
              text: 'Downloads',
            ),
            Tab(
              icon: Icon(Icons.queue_outlined),
              text: 'Queue',
            ),
            Tab(
              icon: Icon(Icons.offline_bolt_outlined),
              text: 'Offline',
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sync_all',
                child: ListTile(
                  leading: Icon(Icons.sync),
                  title: Text('Sync All'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'pause_all',
                child: ListTile(
                  leading: Icon(Icons.pause),
                  title: Text('Pause All'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'clear_completed',
                child: ListTile(
                  leading: Icon(Icons.clear_all),
                  title: Text('Clear Completed'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Download Settings'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<LibraryBloc, LibraryState>(
        builder: (context, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              _buildDownloadsTab(state),
              _buildQueueTab(state),
              _buildOfflineTab(state),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showDownloadOptions,
        icon: const Icon(Icons.add),
        label: const Text('Add Download'),
      ),
    );
  }

  Widget _buildDownloadsTab(LibraryState state) {
    if (state is LibraryDownloadQueueLoaded) {
      final completedDownloads = state.downloadQueue
          .where((download) => download['status'] == 'completed')
          .toList();

      if (completedDownloads.isEmpty) {
        return _buildEmptyState(
          icon: Icons.download_outlined,
          title: 'No Downloads',
          message: 'Your completed downloads will appear here',
        );
      }

      return RefreshIndicator(
        onRefresh: () async {
          context.read<LibraryBloc>().add(const LibraryDownloadQueueRequested());
        },
        child: ListView.builder(
          padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
          itemCount: completedDownloads.length,
          itemBuilder: (context, index) {
            return _buildDownloadItem(completedDownloads[index], true);
          },
        ),
      );
    }

    return _buildLoadingState();
  }

  Widget _buildQueueTab(LibraryState state) {
    if (state is LibraryDownloadQueueLoaded) {
      final queuedDownloads = state.downloadQueue
          .where((download) => download['status'] != 'completed')
          .toList();

      if (queuedDownloads.isEmpty) {
        return _buildEmptyState(
          icon: Icons.queue_outlined,
          title: 'Download Queue Empty',
          message: 'Add items to your download queue to see them here',
        );
      }

      return Column(
        children: [
          _buildQueueHeader(state),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
              itemCount: queuedDownloads.length,
              itemBuilder: (context, index) {
                return _buildDownloadItem(queuedDownloads[index], false);
              },
            ),
          ),
        ],
      );
    }

    return _buildLoadingState();
  }

  Widget _buildOfflineTab(LibraryState state) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryOfflineModeEnabled && state.isOfflineMode) {
          return _buildOfflineContent(state.offlineItems);
        }

        return _buildOfflineSettings();
      },
    );
  }

  Widget _buildQueueHeader(LibraryDownloadQueueLoaded state) {
    final progress = state.totalDownloads > 0
        ? state.completedDownloads / state.totalDownloads
        : 0.0;

    return Container(
      padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      margin: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Download Progress',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: _theme.getDynamicFontSize(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${state.completedDownloads}/${state.totalDownloads}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: _theme.getDynamicFontSize(14),
                ),
              ),
            ],
          ),
          SizedBox(height: _theme.getDynamicSpacing(12)),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadItem(Map<String, dynamic> download, bool isCompleted) {
    final progress = isCompleted ? 1.0 : (download['progress'] ?? 0.0);
    final status = download['status'] ?? 'unknown';

    return Card(
      margin: EdgeInsets.only(bottom: _theme.getDynamicSpacing(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor(status).withValues(alpha: 0.1),
          child: Icon(
            _getStatusIcon(status),
            color: _getStatusColor(status),
            size: _theme.getDynamicFontSize(20),
          ),
        ),
        title: Text(
          download['title'] ?? 'Unknown Item',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(14),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              download['artist'] ?? 'Unknown Artist',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontSize: _theme.getDynamicFontSize(12),
              ),
            ),
            SizedBox(height: _theme.getDynamicSpacing(4)),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getStatusColor(status),
                    ),
                  ),
                ),
                SizedBox(width: _theme.getDynamicSpacing(8)),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: _theme.getDynamicFontSize(10),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => _handleDownloadAction(action, download),
          itemBuilder: (context) => [
            if (!isCompleted) ...[
              PopupMenuItem(
                value: status == 'downloading' ? 'pause' : 'resume',
                child: ListTile(
                  leading: Icon(
                    status == 'downloading' ? Icons.pause : Icons.play_arrow,
                  ),
                  title: Text(
                    status == 'downloading' ? 'Pause' : 'Resume',
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            if (isCompleted) ...[
              const PopupMenuItem(
                value: 'play',
                child: ListTile(
                  leading: Icon(Icons.play_arrow),
                  title: Text('Play'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOfflineContent(List<dynamic> offlineItems) {
    return ListView(
      padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      children: [
        _buildOfflineStats(),
        SizedBox(height: _theme.getDynamicSpacing(16)),
        _buildSyncOptions(),
        SizedBox(height: _theme.getDynamicSpacing(16)),
        Text(
          'Offline Items',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: _theme.getDynamicSpacing(12)),
        ...offlineItems.map((item) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.green.withValues(alpha: 0.1),
                  child: const Icon(Icons.offline_bolt, color: Colors.green),
                ),
                title: Text(item['title'] ?? 'Unknown'),
                subtitle: Text(item['artist'] ?? 'Unknown Artist'),
                trailing: IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {
                    // Handle offline playback
                  },
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildOfflineSettings() {
    return ListView(
      padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.offline_bolt,
                      color: Theme.of(context).primaryColor,
                      size: _theme.getDynamicFontSize(24),
                    ),
                    SizedBox(width: _theme.getDynamicSpacing(12)),
                    Text(
                      'Offline Mode',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: _theme.getDynamicFontSize(20),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: _theme.getDynamicSpacing(16)),
                Text(
                  'Enable offline mode to access your downloaded content without an internet connection.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: _theme.getDynamicFontSize(14),
                  ),
                ),
                SizedBox(height: _theme.getDynamicSpacing(16)),
                ElevatedButton.icon(
                  onPressed: _enableOfflineMode,
                  icon: const Icon(Icons.offline_bolt),
                  label: const Text('Enable Offline Mode'),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: _theme.getDynamicSpacing(16)),
        _buildDownloadSettings(),
      ],
    );
  }

  Widget _buildOfflineStats() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Column(
          children: [
            Text(
              'Offline Statistics',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: _theme.getDynamicFontSize(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: _theme.getDynamicSpacing(16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Items', '25', Icons.music_note),
                _buildStatItem('Storage', '1.2GB', Icons.storage),
                _buildStatItem('Quality', 'High', Icons.high_quality),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncOptions() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sync Options',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: _theme.getDynamicFontSize(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: _theme.getDynamicSpacing(12)),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _syncLibrary,
                    icon: const Icon(Icons.sync),
                    label: const Text('Sync Now'),
                  ),
                ),
                SizedBox(width: _theme.getDynamicSpacing(8)),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _goOnline,
                    icon: const Icon(Icons.cloud),
                    label: const Text('Go Online'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadSettings() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Download Settings',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: _theme.getDynamicFontSize(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: _theme.getDynamicSpacing(16)),
            ListTile(
              leading: const Icon(Icons.high_quality),
              title: const Text('Audio Quality'),
              subtitle: const Text('High (320kbps)'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _showQualitySettings,
            ),
            ListTile(
              leading: const Icon(Icons.wifi),
              title: const Text('Download over WiFi only'),
              trailing: Switch(
                value: true,
                onChanged: (value) {
                  // Handle WiFi-only setting
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.storage),
              title: const Text('Storage Location'),
              subtitle: const Text('Internal Storage'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: _showStorageSettings,
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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: _theme.getDynamicFontSize(16),
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

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: _theme.getDynamicFontSize(64),
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'downloading':
        return Colors.blue;
      case 'paused':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.download_done;
      case 'downloading':
        return Icons.download;
      case 'paused':
        return Icons.pause;
      case 'failed':
        return Icons.error;
      default:
        return Icons.help_outline;
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'sync_all':
        context.read<LibraryBloc>().add(const LibraryOfflineSyncRequested());
        break;
      case 'pause_all':
        // Handle pause all downloads
        break;
      case 'clear_completed':
        // Handle clear completed downloads
        break;
      case 'settings':
        _showDownloadSettings();
        break;
    }
  }

  void _handleDownloadAction(String action, Map<String, dynamic> download) {
    switch (action) {
      case 'pause':
      case 'resume':
        context.read<LibraryBloc>().add(LibraryDownloadStatusUpdate(
          itemId: download['id'],
          status: action == 'pause' ? 'paused' : 'downloading',
        ));
        break;
      case 'delete':
        // Handle delete download
        break;
      case 'play':
        // Handle play downloaded item
        break;
    }
  }

  void _showDownloadOptions() {
    // Show dialog to add new downloads
  }

  void _enableOfflineMode() {
    context.read<LibraryBloc>().add(const LibraryOfflineModeToggled(
      enableOfflineMode: true,
    ));
  }

  void _syncLibrary() {
    context.read<LibraryBloc>().add(const LibrarySyncRequested());
  }

  void _goOnline() {
    context.read<LibraryBloc>().add(const LibraryOfflineModeToggled(
      enableOfflineMode: false,
    ));
  }

  void _showQualitySettings() {
    // Show quality selection dialog
  }

  void _showStorageSettings() {
    // Show storage location settings
  }

  void _showDownloadSettings() {
    // Show detailed download settings
  }
}