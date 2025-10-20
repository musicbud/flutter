import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/library/library_bloc.dart';
import '../../../blocs/library/library_event.dart';
import '../../../blocs/library/library_state.dart';
import '../../../services/dynamic_theme_service.dart';

class DownloadManagerWidget extends StatefulWidget {
  const DownloadManagerWidget({super.key});

  @override
  State<DownloadManagerWidget> createState() => _DownloadManagerWidgetState();
}

class _DownloadManagerWidgetState extends State<DownloadManagerWidget> {
  final DynamicThemeService _theme = DynamicThemeService.instance;

  @override
  void initState() {
    super.initState();
    // Load download queue on initialization
    context.read<LibraryBloc>().add(const LibraryDownloadQueueRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LibraryBloc, LibraryState>(
      builder: (context, state) {
        if (state is LibraryDownloadQueueLoaded) {
          return _buildDownloadQueue(state);
        } else if (state is LibraryDownloadProgress) {
          return _buildSingleDownloadProgress(state);
        } else if (state is LibraryOfflineSync) {
          return _buildOfflineSync(state);
        }
        return _buildEmptyDownloads();
      },
    );
  }

  Widget _buildDownloadQueue(LibraryDownloadQueueLoaded state) {
    return Card(
      margin: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDownloadHeader(state),
          if (state.downloadQueue.isNotEmpty) ...[
            const Divider(height: 1),
            _buildDownloadList(state),
          ] else
            _buildEmptyDownloads(),
        ],
      ),
    );
  }

  Widget _buildDownloadHeader(LibraryDownloadQueueLoaded state) {
    final progress = state.totalDownloads > 0
        ? state.completedDownloads / state.totalDownloads
        : 0.0;

    return Padding(
      padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      child: Row(
        children: [
          Icon(
            Icons.download,
            size: _theme.getDynamicFontSize(24),
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(width: _theme.getDynamicSpacing(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Downloads',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: _theme.getDynamicFontSize(18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${state.completedDownloads} of ${state.totalDownloads} completed',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: _theme.getDynamicFontSize(12),
                  ),
                ),
                if (state.totalDownloads > 0) ...[
                  SizedBox(height: _theme.getDynamicSpacing(8)),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'pause_all',
                child: ListTile(
                  leading: Icon(Icons.pause),
                  title: Text('Pause All'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem(
                value: 'resume_all',
                child: ListTile(
                  leading: Icon(Icons.play_arrow),
                  title: Text('Resume All'),
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
            ],
            onSelected: _handleDownloadAction,
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadList(LibraryDownloadQueueLoaded state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.downloadQueue.length,
      itemBuilder: (context, index) {
        final download = state.downloadQueue[index];
        final progress = state.downloadProgress[download['id']] ?? 0.0;
        return _buildDownloadItem(download, progress);
      },
    );
  }

  Widget _buildDownloadItem(Map<String, dynamic> download, double progress) {
    final isCompleted = download['status'] == 'completed';
    final isPaused = download['status'] == 'paused';
    final isFailed = download['status'] == 'failed';

    return ListTile(
      leading: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: isCompleted ? 1.0 : progress,
            backgroundColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            strokeWidth: 3,
          ),
          Icon(
            _getDownloadStatusIcon(download['status']),
            size: _theme.getDynamicFontSize(16),
            color: _getDownloadStatusColor(download['status']),
          ),
        ],
      ),
      title: Text(
        download['title'] ?? 'Unknown Track',
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
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
              Text(
                _getDownloadStatusText(download['status'], progress),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: _theme.getDynamicFontSize(11),
                  color: _getDownloadStatusColor(download['status']),
                ),
              ),
              const Spacer(),
              Text(
                download['quality'] ?? 'Standard',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: _theme.getDynamicFontSize(11),
                ),
              ),
              SizedBox(width: _theme.getDynamicSpacing(8)),
              Text(
                _formatFileSize(download['size'] ?? 0),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: _theme.getDynamicFontSize(11),
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: PopupMenuButton<String>(
        itemBuilder: (context) => [
          if (!isCompleted && !isFailed)
            PopupMenuItem(
              value: isPaused ? 'resume' : 'pause',
              child: ListTile(
                leading: Icon(isPaused ? Icons.play_arrow : Icons.pause),
                title: Text(isPaused ? 'Resume' : 'Pause'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          if (isFailed)
            const PopupMenuItem(
              value: 'retry',
              child: ListTile(
                leading: Icon(Icons.refresh),
                title: Text('Retry'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          const PopupMenuItem(
            value: 'remove',
            child: ListTile(
              leading: Icon(Icons.delete),
              title: Text('Remove'),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
        onSelected: (action) => _handleItemAction(action, download),
      ),
    );
  }

  Widget _buildSingleDownloadProgress(LibraryDownloadProgress state) {
    return Card(
      margin: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      child: Padding(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: state.progress,
                  backgroundColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  strokeWidth: 3,
                ),
                Icon(
                  _getDownloadStatusIcon(state.status),
                  size: _theme.getDynamicFontSize(16),
                  color: _getDownloadStatusColor(state.status),
                ),
              ],
            ),
            SizedBox(width: _theme.getDynamicSpacing(16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Downloading...',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: _theme.getDynamicFontSize(16),
                    ),
                  ),
                  LinearProgressIndicator(
                    value: state.progress,
                    backgroundColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                  SizedBox(height: _theme.getDynamicSpacing(4)),
                  Text(
                    '${(state.progress * 100).toInt()}% complete',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: _theme.getDynamicFontSize(12),
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

  Widget _buildOfflineSync(LibraryOfflineSync state) {
    return Card(
      margin: EdgeInsets.all(_theme.getDynamicSpacing(16)),
      child: Padding(
        padding: EdgeInsets.all(_theme.getDynamicSpacing(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  state.isSyncing ? Icons.sync : Icons.sync_disabled,
                  size: _theme.getDynamicFontSize(24),
                  color: state.isSyncing ? Theme.of(context).primaryColor : Theme.of(context).colorScheme.outline,
                ),
                SizedBox(width: _theme.getDynamicSpacing(12)),
                Expanded(
                  child: Text(
                    state.isSyncing ? 'Syncing Library...' : 'Offline Library Sync',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: _theme.getDynamicFontSize(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (state.status != null) ...[
              SizedBox(height: _theme.getDynamicSpacing(8)),
              Text(
                state.status!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: _theme.getDynamicFontSize(14),
                ),
              ),
            ],
            if (state.itemsSynced != null && state.totalItems != null) ...[
              SizedBox(height: _theme.getDynamicSpacing(8)),
              LinearProgressIndicator(
                value: state.totalItems! > 0 ? state.itemsSynced! / state.totalItems! : 0.0,
                backgroundColor: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
              ),
              SizedBox(height: _theme.getDynamicSpacing(4)),
              Text(
                '${state.itemsSynced} of ${state.totalItems} items synced',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: _theme.getDynamicFontSize(12),
                ),
              ),
            ],
            if (state.lastSyncTime != null) ...[
              SizedBox(height: _theme.getDynamicSpacing(8)),
              Text(
                'Last sync: ${_formatDateTime(state.lastSyncTime!)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: _theme.getDynamicFontSize(12),
                ),
              ),
            ],
            if (!state.isSyncing) ...[
              SizedBox(height: _theme.getDynamicSpacing(16)),
              ElevatedButton.icon(
                onPressed: () {
                  context.read<LibraryBloc>().add(const LibraryOfflineSyncRequested());
                },
                icon: const Icon(Icons.sync),
                label: const Text('Sync Now'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyDownloads() {
    return Padding(
      padding: EdgeInsets.all(_theme.getDynamicSpacing(32)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.download_outlined,
            size: _theme.getDynamicFontSize(64),
            color: Theme.of(context).colorScheme.outline,
          ),
          SizedBox(height: _theme.getDynamicSpacing(16)),
          Text(
            'No Downloads',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: _theme.getDynamicFontSize(20),
            ),
          ),
          SizedBox(height: _theme.getDynamicSpacing(8)),
          Text(
            'Download music to listen offline',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: _theme.getDynamicFontSize(14),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getDownloadStatusIcon(String status) {
    switch (status) {
      case 'completed':
        return Icons.check;
      case 'downloading':
        return Icons.downloading;
      case 'paused':
        return Icons.pause;
      case 'failed':
        return Icons.error;
      default:
        return Icons.download;
    }
  }

  Color _getDownloadStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'downloading':
        return Theme.of(context).primaryColor;
      case 'paused':
        return Theme.of(context).colorScheme.outline;
      case 'failed':
        return Theme.of(context).colorScheme.error;
      default:
        return Theme.of(context).colorScheme.outline;
    }
  }

  String _getDownloadStatusText(String status, double progress) {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'downloading':
        return 'Downloading ${(progress * 100).toInt()}%';
      case 'paused':
        return 'Paused';
      case 'failed':
        return 'Failed';
      default:
        return 'Waiting';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  void _handleDownloadAction(String action) {
    switch (action) {
      case 'pause_all':
        // Implement pause all functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Paused all downloads')),
        );
        break;
      case 'resume_all':
        // Implement resume all functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Resumed all downloads')),
        );
        break;
      case 'clear_completed':
        // Implement clear completed functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cleared completed downloads')),
        );
        break;
    }
  }

  void _handleItemAction(String action, Map<String, dynamic> download) {
    switch (action) {
      case 'pause':
      case 'resume':
        context.read<LibraryBloc>().add(
          LibraryDownloadStatusUpdate(
            itemId: download['id'],
            status: action == 'pause' ? 'paused' : 'downloading',
          ),
        );
        break;
      case 'retry':
        context.read<LibraryBloc>().add(
          LibraryDownloadStatusUpdate(
            itemId: download['id'],
            status: 'downloading',
            progress: 0.0,
          ),
        );
        break;
      case 'remove':
        // Implement remove download functionality
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed ${download['title']}')),
        );
        break;
    }
  }
}