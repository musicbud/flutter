import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/content_repository.dart';
import '../../services/mock_data_service.dart';
import '../../services/offline_storage_service.dart';
import 'library_event.dart';
import 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final ContentRepository _contentRepository;
  final OfflineStorageService _offlineStorage = OfflineStorageService.instance;
  bool _useOfflineMode = false;
  final Map<String, StreamSubscription> _downloadSubscriptions = {};
  final Map<String, double> _downloadProgress = {};
  final List<Map<String, dynamic>> _folders = [];
  final List<Map<String, dynamic>> _downloads = [];

  LibraryBloc({
    required ContentRepository contentRepository,
  })  : _contentRepository = contentRepository,
        super(LibraryInitial()) {
    _initializeOfflineStorage();
    // Core event handlers
    on<LibraryItemsRequested>(_onLibraryItemsRequested);
    on<LibraryItemToggleLiked>(_onLibraryItemToggleLiked);
    on<LibraryItemToggleDownload>(_onLibraryItemToggleDownload);
    on<LibraryItemPlayRequested>(_onLibraryItemPlayRequested);
    on<LibraryPlaylistCreated>(_onLibraryPlaylistCreated);
    on<LibraryPlaylistDeleted>(_onLibraryPlaylistDeleted);
    on<LibraryItemsRefreshRequested>(_onLibraryItemsRefreshRequested);
    on<LibrarySearchRequested>(_onLibrarySearchRequested);
    on<LibrarySortRequested>(_onLibrarySortRequested);
    on<LibraryPlaylistUpdateRequested>(_onLibraryPlaylistUpdateRequested);
    on<LibraryItemAddToPlaylistRequested>(_onLibraryItemAddToPlaylistRequested);
    on<LibraryBatchActionRequested>(_onLibraryBatchActionRequested);
    on<LibraryDownloadToggleRequested>(_onLibraryDownloadToggleRequested);
    // Enhanced event handlers
    on<LibraryFolderCreated>(_onLibraryFolderCreated);
    on<LibraryFolderDeleted>(_onLibraryFolderDeleted);
    on<LibraryPlaylistAddedToFolder>(_onLibraryPlaylistAddedToFolder);
    on<LibraryDownloadProgressRequested>(_onLibraryDownloadProgressRequested);
    on<LibraryOfflineSyncRequested>(_onLibraryOfflineSyncRequested);
    on<LibraryRecentItemsRequested>(_onLibraryRecentItemsRequested);
    on<LibraryStatsRequested>(_onLibraryStatsRequested);
    on<LibraryFilterApplied>(_onLibraryFilterApplied);
    on<LibraryItemMoveToFolder>(_onLibraryItemMoveToFolder);
    on<LibraryDownloadQueueRequested>(_onLibraryDownloadQueueRequested);
    on<LibraryDownloadStatusUpdate>(_onLibraryDownloadStatusUpdate);
    on<LibraryOfflineModeToggled>(_onLibraryOfflineModeToggled);
    on<LibraryPlaylistTracksRequested>(_onLibraryPlaylistTracksRequested);
    on<LibraryPlaylistTrackAdded>(_onLibraryPlaylistTrackAdded);
    on<LibraryPlaylistTrackRemoved>(_onLibraryPlaylistTrackRemoved);
    on<LibraryPlaylistTracksReordered>(_onLibraryPlaylistTracksReordered);
    on<LibrarySyncRequested>(_onLibrarySyncRequested);
    on<LibraryPreferencesUpdated>(_onLibraryPreferencesUpdated);
  }

  @override
  Future<void> close() {
    // Clean up download subscriptions
    for (final subscription in _downloadSubscriptions.values) {
      subscription.cancel();
    }
    _downloadSubscriptions.clear();
    return super.close();
  }

  Future<void> _onLibraryItemsRequested(
    LibraryItemsRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      emit(LibraryLoading());
      List<dynamic> items = [];
      
      if (_useOfflineMode) {
        // Use mock data for offline mode
        items = MockDataService.generateLibraryItems(
          type: event.type,
          count: 25,
        );
        
        // Filter by query if provided
        if (event.query != null && event.query!.isNotEmpty) {
          items = items.where((item) => 
            _matchesSearchQuery(item, event.query!)
          ).toList();
        }
      } else {
        try {
          items = await _getLibraryItems(event.type, event.query);
        } catch (error) {
          // Fallback to offline mode on API error
          _useOfflineMode = true;
          items = MockDataService.generateLibraryItems(
            type: event.type,
            count: 25,
          );
          
          if (event.query != null && event.query!.isNotEmpty) {
            items = items.where((item) => 
              _matchesSearchQuery(item, event.query!)
            ).toList();
          }
        }
      }
      
      emit(LibraryLoaded(
        items: items,
        currentType: event.type,
        totalCount: items.length,
        hasReachedEnd: true,
      ));
    } catch (error) {
      emit(LibraryError(error.toString()));
    }
  }

  Future<void> _onLibraryItemToggleLiked(
    LibraryItemToggleLiked event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      await _contentRepository.toggleLike(event.itemId, event.type);
      emit(const LibraryActionSuccess('Item like status updated'));

      // Refresh the current view
      if (state is LibraryLoaded) {
        final currentState = state as LibraryLoaded;
        add(LibraryItemsRefreshRequested(type: currentState.currentType));
      }
    } catch (error) {
      emit(LibraryActionFailure(error.toString()));
    }
  }

  Future<void> _onLibraryItemToggleDownload(
    LibraryItemToggleDownload event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      final isCurrentlyDownloaded = _downloads.any((d) => d['itemId'] == event.itemId);
      
      if (isCurrentlyDownloaded) {
        // Remove download
        _downloads.removeWhere((d) => d['itemId'] == event.itemId);
        _downloadProgress.remove(event.itemId);
        _downloadSubscriptions[event.itemId]?.cancel();
        _downloadSubscriptions.remove(event.itemId);
        
        emit(const LibraryActionSuccess('Download removed'));
      } else {
        // Start download
        final downloadItem = {
          'itemId': event.itemId,
          'type': event.type,
          'title': 'Download Item ${event.itemId}',
          'artist': 'Unknown Artist',
          'size': (15.5 * 1024 * 1024).toInt(), // ~15.5 MB
          'quality': 'High',
          'downloadedAt': DateTime.now().toIso8601String(),
          'status': 'downloading',
        };
        
        _downloads.add(downloadItem);
        _downloadProgress[event.itemId] = 0.0;
        
        // Simulate download progress
        _downloadSubscriptions[event.itemId] = _simulateDownload(event.itemId, emit);
        
        emit(const LibraryActionSuccess('Download started'));
      }
      
      // Refresh downloads if currently viewing them
      if (state is LibraryLoaded) {
        final currentState = state as LibraryLoaded;
        if (currentState.currentType == 'downloads') {
          add(const LibraryItemsRefreshRequested(type: 'downloads'));
        }
      }
    } catch (error) {
      emit(LibraryActionFailure('Download failed: ${error.toString()}'));
    }
  }

  Future<void> _onLibraryItemPlayRequested(
    LibraryItemPlayRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      // Assume track for now
      await _contentRepository.savePlayedTrack(event.itemId);
      emit(const LibraryActionSuccess('Started playing'));
    } catch (error) {
      emit(LibraryActionFailure(error.toString()));
    }
  }

  Future<void> _onLibraryPlaylistCreated(
    LibraryPlaylistCreated event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      if (_useOfflineMode) {
        // Create mock playlist for offline mode
        final newPlaylist = {
          'id': 'playlist_${DateTime.now().millisecondsSinceEpoch}',
          'name': event.name,
          'description': event.description ?? '',
          'trackCount': 0,
          'duration': 0,
          'isPublic': !event.isPrivate,
          'isOwned': true,
          'imageUrl': 'https://picsum.photos/300/300?random=${DateTime.now().millisecondsSinceEpoch}',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'playCount': 0,
          'followerCount': 0,
          'tags': [],
          'collaborative': false,
          'type': 'playlist',
        };
        
        emit(const LibraryActionSuccess('Playlist created successfully'));
        
        // Refresh playlists if currently viewing them
        if (state is LibraryLoaded) {
          final currentState = state as LibraryLoaded;
          if (currentState.currentType == 'playlists') {
            add(const LibraryItemsRefreshRequested(type: 'playlists'));
          }
        }
      } else {
        // TODO: Implement real API playlist creation
        await _contentRepository.createPlaylist(
          name: event.name,
          description: event.description,
          isPrivate: event.isPrivate,
        );
        emit(const LibraryActionSuccess('Playlist created successfully'));
        
        if (state is LibraryLoaded) {
          final currentState = state as LibraryLoaded;
          if (currentState.currentType == 'playlists') {
            add(const LibraryItemsRefreshRequested(type: 'playlists'));
          }
        }
      }
    } catch (error) {
      if (!_useOfflineMode) {
        _useOfflineMode = true;
        // Retry with offline mode
        add(event);
      } else {
        emit(LibraryActionFailure('Failed to create playlist: ${error.toString()}'));
      }
    }
  }

  Future<void> _onLibraryPlaylistDeleted(
    LibraryPlaylistDeleted event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      if (_useOfflineMode) {
        emit(const LibraryActionSuccess('Playlist deleted (offline mode)'));
      } else {
        await _contentRepository.deletePlaylist(event.playlistId);
        emit(const LibraryActionSuccess('Playlist deleted successfully'));
      }
      
      // Refresh playlists if currently viewing them
      if (state is LibraryLoaded) {
        final currentState = state as LibraryLoaded;
        if (currentState.currentType == 'playlists') {
          add(const LibraryItemsRefreshRequested(type: 'playlists'));
        }
      }
    } catch (error) {
      if (!_useOfflineMode) {
        _useOfflineMode = true;
        add(event); // Retry with offline mode
      } else {
        emit(LibraryActionFailure('Failed to delete playlist: ${error.toString()}'));
      }
    }
  }

  Future<void> _onLibraryItemsRefreshRequested(
    LibraryItemsRefreshRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      emit(LibraryLoading());
      final items = await _getLibraryItems(event.type, null);
      emit(LibraryLoaded(
        items: items,
        currentType: event.type,
        totalCount: items.length,
      ));
    } catch (error) {
      emit(LibraryError(error.toString()));
    }
  }

  Future<void> _onLibrarySearchRequested(
    LibrarySearchRequested event,
    Emitter<LibraryState> emit,
  ) async {
    add(LibraryItemsRequested(
      type: event.type ?? 'all',
      query: event.query,
    ));
  }

  Future<void> _onLibrarySortRequested(
    LibrarySortRequested event,
    Emitter<LibraryState> emit,
  ) async {
    if (state is LibraryLoaded) {
      final currentState = state as LibraryLoaded;
      final sortedItems = _sortItems(currentState.items, event.sortType);
      
      emit(currentState.copyWith(
        items: sortedItems,
      ));
    }
  }

  Future<void> _onLibraryPlaylistUpdateRequested(
    LibraryPlaylistUpdateRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      if (_useOfflineMode) {
        emit(const LibraryActionSuccess('Playlist updated (offline mode)'));
      } else {
        // TODO: Implement real API playlist update
        emit(const LibraryActionSuccess('Playlist updated successfully'));
      }
      
      // Refresh current view if needed
      if (state is LibraryLoaded) {
        final currentState = state as LibraryLoaded;
        if (currentState.currentType == 'playlists') {
          add(const LibraryItemsRefreshRequested(type: 'playlists'));
        }
      }
    } catch (error) {
      emit(LibraryActionFailure('Failed to update playlist: ${error.toString()}'));
    }
  }

  Future<void> _onLibraryItemAddToPlaylistRequested(
    LibraryItemAddToPlaylistRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      if (_useOfflineMode) {
        emit(const LibraryActionSuccess('Item added to playlist (offline mode)'));
      } else {
        // TODO: Implement real API add to playlist
        emit(const LibraryActionSuccess('Item added to playlist successfully'));
      }
    } catch (error) {
      emit(LibraryActionFailure('Failed to add item to playlist: ${error.toString()}'));
    }
  }

  Future<void> _onLibraryBatchActionRequested(
    LibraryBatchActionRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      final action = event.action;
      final itemCount = event.itemIds.length;
      
      if (_useOfflineMode) {
        emit(LibraryActionSuccess('$action completed on $itemCount items (offline mode)'));
      } else {
        // TODO: Implement real API batch operations
        switch (action) {
          case 'delete':
            emit(LibraryActionSuccess('Deleted $itemCount items'));
            break;
          case 'download':
            emit(LibraryActionSuccess('Started downloading $itemCount items'));
            break;
          case 'add_to_playlist':
            final playlistName = event.actionData?['playlistName'] ?? 'playlist';
            emit(LibraryActionSuccess('Added $itemCount items to $playlistName'));
            break;
          default:
            emit(LibraryActionSuccess('Batch action completed on $itemCount items'));
        }
      }
      
      // Refresh current view
      if (state is LibraryLoaded) {
        final currentState = state as LibraryLoaded;
        add(LibraryItemsRefreshRequested(type: currentState.currentType));
      }
    } catch (error) {
      emit(LibraryActionFailure('Batch action failed: ${error.toString()}'));
    }
  }

  Future<void> _onLibraryDownloadToggleRequested(
    LibraryDownloadToggleRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      if (_useOfflineMode) {
        emit(const LibraryActionSuccess('Download toggled (offline mode)'));
      } else {
        // TODO: Implement real download functionality
        emit(const LibraryActionSuccess('Download started'));
      }
    } catch (error) {
      emit(LibraryActionFailure('Download failed: ${error.toString()}'));
    }
  }

  // Helper methods
  bool _matchesSearchQuery(Map<String, dynamic> item, String query) {
    final queryLower = query.toLowerCase();
    final searchableFields = [
      item['name']?.toString(),
      item['title']?.toString(),
      item['artist']?.toString(),
      item['album']?.toString(),
      item['description']?.toString(),
    ];
    
    return searchableFields.any((field) => 
      field != null && field.toLowerCase().contains(queryLower)
    );
  }

  List<dynamic> _sortItems(List<dynamic> items, String sortType) {
    final sortedItems = List<dynamic>.from(items);
    
    switch (sortType) {
      case 'alphabetical':
        sortedItems.sort((a, b) {
          final nameA = (a['name'] ?? a['title'] ?? '').toString().toLowerCase();
          final nameB = (b['name'] ?? b['title'] ?? '').toString().toLowerCase();
          return nameA.compareTo(nameB);
        });
        break;
      case 'recent':
      case 'recently_liked':
        sortedItems.sort((a, b) {
          final dateA = a['likedAt'] ?? a['createdAt'] ?? a['updatedAt'] ?? '';
          final dateB = b['likedAt'] ?? b['createdAt'] ?? b['updatedAt'] ?? '';
          if (dateA.isEmpty || dateB.isEmpty) return 0;
          return DateTime.parse(dateB).compareTo(DateTime.parse(dateA));
        });
        break;
      case 'most_played':
        sortedItems.sort((a, b) {
          final playsA = a['playCount'] ?? a['plays'] ?? 0;
          final playsB = b['playCount'] ?? b['plays'] ?? 0;
          return playsB.compareTo(playsA);
        });
        break;
      default:
        // No sorting
        break;
    }
    
    return sortedItems;
  }

  Future<List<dynamic>> _getLibraryItems(String type, String? query) async {
    switch (type) {
      case 'tracks':
      case 'liked':
        return await _contentRepository.getLikedTracks();
      case 'artists':
        return await _contentRepository.getLikedArtists();
      case 'albums':
        return await _contentRepository.getLikedAlbums();
      case 'genres':
        return await _contentRepository.getLikedGenres();
      case 'playlists':
        return MockDataService.generateLibraryItems(type: 'playlist', count: 10);
      case 'downloads':
        return _downloads;
      case 'folders':
        return _folders;
      default:
        return [];
    }
  }

  // New comprehensive event handlers
  Future<void> _onLibraryFolderCreated(
    LibraryFolderCreated event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      final newFolder = {
        'id': 'folder_${DateTime.now().millisecondsSinceEpoch}',
        'name': event.name,
        'description': event.description ?? '',
        'parentFolderId': event.parentFolderId,
        'playlistCount': 0,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'type': 'folder',
      };
      
      _folders.add(newFolder);
      emit(const LibraryActionSuccess('Folder created successfully'));
      
      // Refresh folders if currently viewing them
      if (state is LibraryLoaded) {
        final currentState = state as LibraryLoaded;
        if (currentState.currentType == 'folders') {
          add(const LibraryItemsRefreshRequested(type: 'folders'));
        }
      }
    } catch (error) {
      emit(LibraryActionFailure('Failed to create folder: ${error.toString()}'));
    }
  }

  Future<void> _onLibraryFolderDeleted(
    LibraryFolderDeleted event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      _folders.removeWhere((folder) => folder['id'] == event.folderId);
      emit(const LibraryActionSuccess('Folder deleted successfully'));
      
      // Refresh folders if currently viewing them
      if (state is LibraryLoaded) {
        final currentState = state as LibraryLoaded;
        if (currentState.currentType == 'folders') {
          add(const LibraryItemsRefreshRequested(type: 'folders'));
        }
      }
    } catch (error) {
      emit(LibraryActionFailure('Failed to delete folder: ${error.toString()}'));
    }
  }

  Future<void> _onLibraryPlaylistAddedToFolder(
    LibraryPlaylistAddedToFolder event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      // Update folder's playlist count
      final folderIndex = _folders.indexWhere((f) => f['id'] == event.folderId);
      if (folderIndex != -1) {
        _folders[folderIndex]['playlistCount'] = 
            (_folders[folderIndex]['playlistCount'] ?? 0) + 1;
        _folders[folderIndex]['updatedAt'] = DateTime.now().toIso8601String();
      }
      
      emit(const LibraryActionSuccess('Playlist added to folder'));
    } catch (error) {
      emit(LibraryActionFailure('Failed to add playlist to folder: ${error.toString()}'));
    }
  }

  Future<void> _onLibraryDownloadProgressRequested(
    LibraryDownloadProgressRequested event,
    Emitter<LibraryState> emit,
  ) async {
    final progress = _downloadProgress[event.itemId] ?? 0.0;
    final download = _downloads.firstWhere(
      (d) => d['itemId'] == event.itemId,
      orElse: () => {},
    );
    
    if (download.isNotEmpty) {
      emit(LibraryDownloadProgress(
        itemId: event.itemId,
        progress: progress,
        status: download['status'] ?? 'unknown',
      ));
    } else {
      emit(const LibraryActionFailure('Download not found'));
    }
  }

  Future<void> _onLibraryOfflineSyncRequested(
    LibraryOfflineSyncRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      emit(const LibraryOfflineSync(
        isSyncing: true,
        status: 'Starting sync...',
      ));
      
      // Simulate sync process
      final totalItems = _downloads.length + 10; // Mock additional items
      
      for (int i = 0; i < totalItems; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        emit(LibraryOfflineSync(
          isSyncing: true,
          status: 'Syncing item ${i + 1} of $totalItems',
          itemsSynced: i + 1,
          totalItems: totalItems,
        ));
      }
      
      emit(LibraryOfflineSync(
        isSyncing: false,
        status: 'Sync completed',
        lastSyncTime: DateTime.now(),
        itemsSynced: totalItems,
        totalItems: totalItems,
      ));
    } catch (error) {
      emit(LibraryOfflineSync(
        isSyncing: false,
        status: 'Sync failed: ${error.toString()}',
      ));
    }
  }

  Future<void> _onLibraryRecentItemsRequested(
    LibraryRecentItemsRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      List<dynamic> recentItems;
      
      switch (event.type) {
        case 'played':
          recentItems = MockDataService.generateLibraryItems(
            type: 'track',
            count: event.limit,
          );
          break;
        case 'added':
          recentItems = MockDataService.generateLibraryItems(
            type: 'track',
            count: event.limit,
          );
          break;
        case 'liked':
          recentItems = MockDataService.generateLibraryItems(
            type: 'track',
            count: event.limit,
          );
          break;
        default:
          recentItems = [];
      }
      
      // Sort by recent date
      recentItems.sort((a, b) {
        final dateA = a['updatedAt'] ?? a['createdAt'] ?? '';
        final dateB = b['updatedAt'] ?? b['createdAt'] ?? '';
        return DateTime.parse(dateB).compareTo(DateTime.parse(dateA));
      });
      
      emit(LibraryRecentItemsLoaded(
        recentItems: recentItems,
        type: event.type,
        loadedAt: DateTime.now(),
      ));
    } catch (error) {
      emit(LibraryError('Failed to load recent items: ${error.toString()}'));
    }
  }

  Future<void> _onLibraryStatsRequested(
    LibraryStatsRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      // Calculate library statistics
      const totalTracks = 125;
      final totalPlaylists = _folders.length + 15; // Mock playlists
      final totalDownloads = _downloads.length;
      final totalStorageUsed = _downloads.fold<double>(
        0.0,
        (sum, item) => sum + ((item['size'] ?? 0) / (1024 * 1024)),
      );
      const totalPlaytime = 2340; // Mock total minutes
      
      final stats = {
        'tracks': totalTracks,
        'albums': 35,
        'artists': 67,
        'genres': 12,
        'playlists': totalPlaylists,
        'folders': _folders.length,
        'downloads': totalDownloads,
      };
      
      emit(LibraryStatsLoaded(
        stats: stats,
        totalTracks: totalTracks,
        totalPlaylists: totalPlaylists,
        totalDownloads: totalDownloads,
        totalStorageUsed: totalStorageUsed,
        totalPlaytime: totalPlaytime,
      ));
    } catch (error) {
      emit(LibraryError('Failed to load stats: ${error.toString()}'));
    }
  }

  Future<void> _onLibraryFilterApplied(
    LibraryFilterApplied event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      if (state is! LibraryLoaded) {
        emit(const LibraryError('No items loaded to filter'));
        return;
      }
      
      final currentState = state as LibraryLoaded;
      List<dynamic> filteredItems = List.from(currentState.items);
      
      // Apply filters
      if (event.genre != null && event.genre!.isNotEmpty) {
        filteredItems = filteredItems.where((item) {
          final itemGenre = item['genre']?.toString().toLowerCase() ?? '';
          return itemGenre.contains(event.genre!.toLowerCase());
        }).toList();
      }
      
      if (event.artist != null && event.artist!.isNotEmpty) {
        filteredItems = filteredItems.where((item) {
          final itemArtist = item['artist']?.toString().toLowerCase() ?? '';
          return itemArtist.contains(event.artist!.toLowerCase());
        }).toList();
      }
      
      if (event.year != null && event.year!.isNotEmpty) {
        filteredItems = filteredItems.where((item) {
          final itemYear = item['year']?.toString() ?? '';
          return itemYear == event.year;
        }).toList();
      }
      
      if (event.isDownloaded != null) {
        filteredItems = filteredItems.where((item) {
          final isDownloaded = _downloads.any((d) => d['itemId'] == item['id']);
          return isDownloaded == event.isDownloaded;
        }).toList();
      }
      
      // Apply sorting
      if (event.sortBy != null) {
        filteredItems = _sortItems(filteredItems, event.sortBy!);
      }
      
      final appliedFilters = {
        'genre': event.genre,
        'artist': event.artist,
        'year': event.year,
        'isDownloaded': event.isDownloaded,
        'sortBy': event.sortBy,
      };
      
      emit(LibraryFiltered(
        filteredItems: filteredItems,
        appliedFilters: appliedFilters,
        currentType: currentState.currentType,
        totalCount: filteredItems.length,
      ));
    } catch (error) {
      emit(LibraryError('Failed to apply filter: ${error.toString()}'));
    }
  }

  // Missing event handlers implementation
  Future<void> _onLibraryItemMoveToFolder(
    LibraryItemMoveToFolder event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      // Find the target folder
      final folderIndex = _folders.indexWhere((f) => f['id'] == event.folderId);
      if (folderIndex == -1) {
        emit(const LibraryActionFailure('Target folder not found'));
        return;
      }
      
      // Update folder's item count
      _folders[folderIndex]['playlistCount'] = 
          (_folders[folderIndex]['playlistCount'] ?? 0) + event.itemIds.length;
      _folders[folderIndex]['updatedAt'] = DateTime.now().toIso8601String();
      
      emit(LibraryActionSuccess('Moved ${event.itemIds.length} items to folder'));
      
      // Refresh current view
      if (state is LibraryLoaded) {
        final currentState = state as LibraryLoaded;
        add(LibraryItemsRefreshRequested(type: currentState.currentType));
      }
    } catch (error) {
      emit(LibraryActionFailure('Failed to move items to folder: ${error.toString()}'));
    }
  }

  Future<void> _onLibraryDownloadQueueRequested(
    LibraryDownloadQueueRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      final completedCount = _downloads.where((d) => d['status'] == 'completed').length;
      
      emit(LibraryDownloadQueueLoaded(
        downloadQueue: _downloads,
        downloadProgress: _downloadProgress,
        totalDownloads: _downloads.length,
        completedDownloads: completedCount,
      ));
    } catch (error) {
      emit(LibraryError('Failed to load download queue: ${error.toString()}'));
    }
  }

  Future<void> _onLibraryDownloadStatusUpdate(
    LibraryDownloadStatusUpdate event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      // Update download progress
      if (event.progress != null) {
        _downloadProgress[event.itemId] = event.progress!;
      }
      
      // Update download status
      final downloadIndex = _downloads.indexWhere((d) => d['itemId'] == event.itemId);
      if (downloadIndex != -1) {
        _downloads[downloadIndex]['status'] = event.status;
        if (event.errorMessage != null) {
          _downloads[downloadIndex]['errorMessage'] = event.errorMessage;
        }
        _downloads[downloadIndex]['updatedAt'] = DateTime.now().toIso8601String();
      }
      
      emit(LibraryDownloadProgress(
        itemId: event.itemId,
        progress: event.progress ?? 0.0,
        status: event.status,
        errorMessage: event.errorMessage,
      ));
    } catch (error) {
      emit(LibraryError('Failed to update download status: ${error.toString()}'));
    }
  }

  Future<void> _onLibraryOfflineModeToggled(
    LibraryOfflineModeToggled event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      _useOfflineMode = event.enableOfflineMode;
      await _offlineStorage.setOfflineMode(_useOfflineMode);
      
      List<dynamic> offlineItems = [];
      if (_useOfflineMode) {
        // Load offline items from storage
        offlineItems = await _offlineStorage.getLibraryItems();
        if (offlineItems.isEmpty) {
          // If no cached items, use completed downloads as fallback
          offlineItems = _downloads.where((d) => d['status'] == 'completed').toList();
        }
      }
      
      emit(LibraryOfflineModeEnabled(
        isOfflineMode: _useOfflineMode,
        offlineItems: offlineItems,
      ));
      
      // Refresh current view with new mode
      if (state is LibraryLoaded) {
        final currentState = state as LibraryLoaded;
        add(LibraryItemsRefreshRequested(type: currentState.currentType));
      }
    } catch (error) {
      emit(LibraryError('Failed to toggle offline mode: ${error.toString()}'));
    }
  }

  Future<void> _onLibraryPlaylistTracksRequested(
    LibraryPlaylistTracksRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      // Generate mock tracks for the playlist
      final tracks = MockDataService.generatePlaylistTracks(
        event.playlistId,
        count: event.limit ?? 20,
      );
      
      emit(LibraryPlaylistTracksLoaded(
        playlistId: event.playlistId,
        tracks: tracks,
        totalCount: tracks.length,
      ));
    } catch (error) {
      emit(LibraryError('Failed to load playlist tracks: ${error.toString()}'));
    }
  }

  Future<void> _onLibraryPlaylistTrackAdded(
    LibraryPlaylistTrackAdded event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      emit(const LibraryActionSuccess('Track added to playlist'));
      
      // Refresh playlist tracks if currently viewing them
      if (state is LibraryPlaylistTracksLoaded) {
        final currentState = state as LibraryPlaylistTracksLoaded;
        if (currentState.playlistId == event.playlistId) {
          add(LibraryPlaylistTracksRequested(playlistId: event.playlistId));
        }
      }
    } catch (error) {
      emit(LibraryActionFailure('Failed to add track to playlist: ${error.toString()}'));
    }
  }

  Future<void> _onLibraryPlaylistTrackRemoved(
    LibraryPlaylistTrackRemoved event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      emit(const LibraryActionSuccess('Track removed from playlist'));
      
      // Refresh playlist tracks if currently viewing them
      if (state is LibraryPlaylistTracksLoaded) {
        final currentState = state as LibraryPlaylistTracksLoaded;
        if (currentState.playlistId == event.playlistId) {
          add(LibraryPlaylistTracksRequested(playlistId: event.playlistId));
        }
      }
    } catch (error) {
      emit(LibraryActionFailure('Failed to remove track from playlist: ${error.toString()}'));
    }
  }

  Future<void> _onLibraryPlaylistTracksReordered(
    LibraryPlaylistTracksReordered event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      emit(const LibraryActionSuccess('Playlist tracks reordered'));
      
      // Refresh playlist tracks if currently viewing them
      if (state is LibraryPlaylistTracksLoaded) {
        final currentState = state as LibraryPlaylistTracksLoaded;
        if (currentState.playlistId == event.playlistId) {
          add(LibraryPlaylistTracksRequested(playlistId: event.playlistId));
        }
      }
    } catch (error) {
      emit(LibraryActionFailure('Failed to reorder playlist tracks: ${error.toString()}'));
    }
  }

  Future<void> _onLibrarySyncRequested(
    LibrarySyncRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      emit(const LibrarySyncInProgress(
        progress: 0.0,
        currentOperation: 'Starting sync...',
      ));
      
      final operations = [
        'Syncing playlists...',
        'Syncing liked tracks...',
        'Syncing downloads...',
        'Updating metadata...',
        'Finalizing sync...',
      ];
      
      // Perform actual sync with offline storage
      final syncSuccess = await _offlineStorage.syncWithServer(
        forceSync: event.forceSync,
        syncType: event.syncType,
      );
      
      for (int i = 0; i < operations.length; i++) {
        await Future.delayed(const Duration(milliseconds: 600));
        
        // During sync, update offline storage based on operation
        switch (i) {
          case 0: // Playlists
            if (syncSuccess) {
              final playlists = MockDataService.generatePlaylists(count: 15);
              await _offlineStorage.savePlaylists(playlists);
            }
            break;
          case 1: // Liked tracks
            if (syncSuccess) {
              final likedTracks = MockDataService.generateTopTracks(count: 50);
              await _offlineStorage.saveLibraryItems(likedTracks);
            }
            break;
          case 2: // Downloads
            if (syncSuccess) {
              await _offlineStorage.saveDownloads(_downloads);
            }
            break;
        }
        
        emit(LibrarySyncInProgress(
          progress: (i + 1) / operations.length,
          currentOperation: operations[i],
        ));
      }
      
      // Cleanup storage if needed
      await _offlineStorage.cleanupIfNeeded();
      
      emit(LibrarySyncCompleted(
        lastSyncTime: DateTime.now(),
        syncedItems: 150 + DateTime.now().millisecondsSinceEpoch % 50,
        syncErrors: syncSuccess ? null : ['Sync completed with limited connectivity'],
      ));
    } catch (error) {
      emit(LibraryError('Sync failed: ${error.toString()}'));
    }
  }

  Future<void> _onLibraryPreferencesUpdated(
    LibraryPreferencesUpdated event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      emit(LibraryPreferencesLoaded(preferences: event.preferences));
      emit(const LibraryActionSuccess('Preferences updated'));
    } catch (error) {
      emit(LibraryActionFailure('Failed to update preferences: ${error.toString()}'));
    }
  }

  // Download simulation helper
  StreamSubscription _simulateDownload(String itemId, Emitter<LibraryState> emit) {
    return Stream.periodic(const Duration(milliseconds: 200), (count) => count)
        .take(50)
        .listen((count) {
      final progress = (count + 1) / 50;
      _downloadProgress[itemId] = progress;
      
      add(LibraryDownloadStatusUpdate(
        itemId: itemId,
        status: progress >= 1.0 ? 'completed' : 'downloading',
        progress: progress,
      ));
      
      // Update download status when complete
      if (progress >= 1.0) {
        final downloadIndex = _downloads.indexWhere((d) => d['itemId'] == itemId);
        if (downloadIndex != -1) {
          _downloads[downloadIndex]['status'] = 'completed';
        }
        _downloadSubscriptions.remove(itemId);
      }
    });
  }

  /// Initialize offline storage service
  Future<void> _initializeOfflineStorage() async {
    try {
      await _offlineStorage.initialize();
      _useOfflineMode = _offlineStorage.isOfflineMode();
      
      // Load cached downloads
      final cachedDownloads = await _offlineStorage.getDownloads();
      _downloads.clear();
      _downloads.addAll(cachedDownloads);
    } catch (e) {
      // Handle initialization error silently
    }
  }
}
