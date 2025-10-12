import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/library/library_bloc.dart';
import '../../../blocs/library/library_event.dart';
import '../../../blocs/library/library_state.dart';
import '../../../core/theme/design_system.dart';
import '../../../widgets/common/index.dart';

class LibrarySearchSection extends StatefulWidget {
  final String selectedTab;
  final TextEditingController searchController;
  final bool showBatchActions;
  final List<String> selectedItems;
  final Function(List<String>)? onSelectionChanged;

  const LibrarySearchSection({
    super.key,
    required this.selectedTab,
    required this.searchController,
    this.showBatchActions = false,
    this.selectedItems = const [],
    this.onSelectionChanged,
  });

  @override
  State<LibrarySearchSection> createState() => _LibrarySearchSectionState();
}

class _LibrarySearchSectionState extends State<LibrarySearchSection> {
  bool _showAdvancedOptions = false;
  String? _lastQuery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Main Search Bar
          Row(
            children: [
              Expanded(
                child: ModernInputField(
                  hintText: 'Search your ${widget.selectedTab.toLowerCase()}...',
                  controller: widget.searchController,
                  onChanged: _onSearch,
                  size: ModernInputFieldSize.large,
                ),
              ),
              const SizedBox(width: 12),
              // Filter Button
              Container(
                decoration: BoxDecoration(
                  color: DesignSystem.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: DesignSystem.onSurfaceVariant.withOpacity(0.3),
                  ),
                ),
                child: IconButton(
                  onPressed: _showFilterSheet,
                  icon: const Icon(Icons.tune),
                  color: DesignSystem.primary,
                  tooltip: 'Filter & Sort',
                ),
              ),
              if (widget.selectedTab == 'Playlists') ...[
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: DesignSystem.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: DesignSystem.onSurfaceVariant.withOpacity(0.3),
                    ),
                  ),
                  child: IconButton(
                    onPressed: _toggleAdvancedOptions,
                    icon: Icon(_showAdvancedOptions ? Icons.expand_less : Icons.expand_more),
                    color: DesignSystem.onSurfaceVariant,
                    tooltip: 'More Options',
                  ),
                ),
              ],
            ],
          ),
          
          // Advanced Options
          if (_showAdvancedOptions && widget.selectedTab == 'Playlists') ...[
            const SizedBox(height: 16),
            _buildAdvancedOptions(),
          ],
          
          // Batch Actions Bar
          if (widget.showBatchActions && widget.selectedItems.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildBatchActionsBar(),
          ],
          
          // Search Stats/Results Info
          BlocBuilder<LibraryBloc, LibraryState>(
            builder: (context, state) {
              if (state is LibraryLoaded && widget.searchController.text.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 16,
                        color: DesignSystem.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Found ${state.totalCount} results for "${widget.searchController.text}"',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: DesignSystem.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      if (_lastQuery != widget.searchController.text && _lastQuery != null)
                        TextButton(
                          onPressed: () {
                            widget.searchController.text = _lastQuery!;
                            _onSearch(_lastQuery!);
                          },
                          child: Text(
                            'Back to "$_lastQuery"',
                            style: const TextStyle(
                              color: DesignSystem.primary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesignSystem.surfaceContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DesignSystem.onSurfaceVariant.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildQuickFilterButton(
                  'My Playlists',
                  Icons.person,
                  () => _applyQuickFilter('owned', true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickFilterButton(
                  'Collaborative',
                  Icons.group,
                  () => _applyQuickFilter('collaborative', true),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickFilterButton(
                  'Public',
                  Icons.public,
                  () => _applyQuickFilter('public', true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickSortButton(
                  'Recent',
                  Icons.access_time,
                  () => _applyQuickSort('recent'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickSortButton(
                  'Most Played',
                  Icons.play_circle,
                  () => _applyQuickSort('most_played'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickSortButton(
                  'A-Z',
                  Icons.sort_by_alpha,
                  () => _applyQuickSort('alphabetical'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickFilterButton(
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: DesignSystem.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: DesignSystem.onSurfaceVariant.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 16,
              color: DesignSystem.primary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickSortButton(
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: DesignSystem.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: DesignSystem.secondary.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 16,
              color: DesignSystem.secondary,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBatchActionsBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DesignSystem.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: DesignSystem.primary.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.checklist,
            color: DesignSystem.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            '${widget.selectedItems.length} items selected',
            style: const TextStyle(
              color: DesignSystem.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _buildBatchActionButton(
                Icons.download,
                'Download',
                () => _performBatchAction('download'),
              ),
              const SizedBox(width: 8),
              _buildBatchActionButton(
                Icons.playlist_add,
                'Add to Playlist',
                () => _performBatchAction('add_to_playlist'),
              ),
              const SizedBox(width: 8),
              _buildBatchActionButton(
                Icons.delete,
                'Delete',
                () => _performBatchAction('delete'),
                isDestructive: true,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBatchActionButton(
    IconData icon,
    String tooltip,
    VoidCallback onPressed, {
    bool isDestructive = false,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      color: isDestructive ? DesignSystem.error : DesignSystem.primary,
      tooltip: tooltip,
      iconSize: 20,
    );
  }

  void _onSearch(String query) {
    if (query != widget.searchController.text) {
      _lastQuery = widget.searchController.text;
    }
    
    String type = widget.selectedTab.toLowerCase().replaceAll(' ', '_');
    context.read<LibraryBloc>().add(LibraryItemsRequested(
      type: type,
      query: query.isNotEmpty ? query : null,
    ));
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: DesignSystem.surface,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Filter & Sort', style: TextStyle(color: Colors.white, fontSize: 18)),
            const SizedBox(height: 16),
            const Text('Advanced filters coming soon!', style: TextStyle(color: Colors.white70)),
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

  void _toggleAdvancedOptions() {
    setState(() {
      _showAdvancedOptions = !_showAdvancedOptions;
    });
  }

  void _applyQuickFilter(String filterType, dynamic value) {
    // Apply quick filter based on type
    final type = widget.selectedTab.toLowerCase().replaceAll(' ', '_');
    context.read<LibraryBloc>().add(LibraryItemsRequested(
      type: type,
      query: widget.searchController.text.isNotEmpty ? widget.searchController.text : null,
    ));
  }

  void _applyQuickSort(String sortType) {
    context.read<LibraryBloc>().add(LibrarySortRequested(
      sortType: sortType,
      itemType: widget.selectedTab.toLowerCase().replaceAll(' ', '_'),
    ));
  }

  void _performBatchAction(String action) {
    if (widget.selectedItems.isEmpty) return;

    switch (action) {
      case 'download':
        context.read<LibraryBloc>().add(
          LibraryBatchActionRequested(
            itemIds: widget.selectedItems,
            action: 'download',
          ),
        );
        break;
      case 'add_to_playlist':
        _showPlaylistSelector();
        break;
      case 'delete':
        _showDeleteConfirmation();
        break;
    }
    
    // Clear selection after action
    widget.onSelectionChanged?.call([]);
  }

  void _showPlaylistSelector() {
    // Implementation for playlist selector dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignSystem.surface,
        title: const Text(
          'Add to Playlist',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Playlist selector would be implemented here',
          style: TextStyle(color: DesignSystem.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Perform add to playlist action
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DesignSystem.surface,
        title: const Text(
          'Delete Items',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete ${widget.selectedItems.length} items? This action cannot be undone.',
          style: const TextStyle(color: DesignSystem.onSurfaceVariant),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<LibraryBloc>().add(
                LibraryBatchActionRequested(
                  itemIds: widget.selectedItems,
                  action: 'delete',
                ),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignSystem.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
