import 'package:equatable/equatable.dart';

abstract class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object?> get props => [];
}

class LibraryInitial extends LibraryState {}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final List<dynamic> items;
  final String currentType;
  final bool hasReachedEnd;
  final int totalCount;
  final String? error;

  const LibraryLoaded({
    required this.items,
    required this.currentType,
    this.hasReachedEnd = false,
    this.totalCount = 0,
    this.error,
  });

  @override
  List<Object?> get props => [items, currentType, hasReachedEnd, totalCount, error];

  LibraryLoaded copyWith({
    List<dynamic>? items,
    String? currentType,
    bool? hasReachedEnd,
    int? totalCount,
    String? error,
  }) {
    return LibraryLoaded(
      items: items ?? this.items,
      currentType: currentType ?? this.currentType,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      totalCount: totalCount ?? this.totalCount,
      error: error ?? this.error,
    );
  }
}

class LibraryError extends LibraryState {
  final String message;

  const LibraryError(this.message);

  @override
  List<Object> get props => [message];
}

class LibraryActionSuccess extends LibraryState {
  final String message;

  const LibraryActionSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class LibraryActionFailure extends LibraryState {
  final String error;

  const LibraryActionFailure(this.error);

  @override
  List<Object> get props => [error];
}

// Enhanced states for playlist management
class LibraryPlaylistTracksLoaded extends LibraryState {
  final String playlistId;
  final List<dynamic> tracks;
  final int totalCount;

  const LibraryPlaylistTracksLoaded({
    required this.playlistId,
    required this.tracks,
    required this.totalCount,
  });

  @override
  List<Object> get props => [playlistId, tracks, totalCount];
}

// Enhanced states for folder management
class LibraryFoldersLoaded extends LibraryState {
  final List<dynamic> folders;
  final String? currentFolderId;

  const LibraryFoldersLoaded({
    required this.folders,
    this.currentFolderId,
  });

  @override
  List<Object?> get props => [folders, currentFolderId];
}

// Enhanced states for download management
class LibraryDownloadQueueLoaded extends LibraryState {
  final List<dynamic> downloadQueue;
  final Map<String, double> downloadProgress;
  final int totalDownloads;
  final int completedDownloads;

  const LibraryDownloadQueueLoaded({
    required this.downloadQueue,
    required this.downloadProgress,
    required this.totalDownloads,
    required this.completedDownloads,
  });

  @override
  List<Object> get props => [downloadQueue, downloadProgress, totalDownloads, completedDownloads];

  LibraryDownloadQueueLoaded copyWith({
    List<dynamic>? downloadQueue,
    Map<String, double>? downloadProgress,
    int? totalDownloads,
    int? completedDownloads,
  }) {
    return LibraryDownloadQueueLoaded(
      downloadQueue: downloadQueue ?? this.downloadQueue,
      downloadProgress: downloadProgress ?? this.downloadProgress,
      totalDownloads: totalDownloads ?? this.totalDownloads,
      completedDownloads: completedDownloads ?? this.completedDownloads,
    );
  }
}

// Enhanced states for offline mode
class LibraryOfflineModeEnabled extends LibraryState {
  final bool isOfflineMode;
  final List<dynamic> offlineItems;

  const LibraryOfflineModeEnabled({
    required this.isOfflineMode,
    required this.offlineItems,
  });

  @override
  List<Object> get props => [isOfflineMode, offlineItems];
}

// Enhanced states for sync management
class LibrarySyncInProgress extends LibraryState {
  final double progress;
  final String currentOperation;

  const LibrarySyncInProgress({
    required this.progress,
    required this.currentOperation,
  });

  @override
  List<Object> get props => [progress, currentOperation];
}

class LibrarySyncCompleted extends LibraryState {
  final DateTime lastSyncTime;
  final int syncedItems;
  final List<String>? syncErrors;

  const LibrarySyncCompleted({
    required this.lastSyncTime,
    required this.syncedItems,
    this.syncErrors,
  });

  @override
  List<Object?> get props => [lastSyncTime, syncedItems, syncErrors];
}


class LibraryPreferencesLoaded extends LibraryState {
  final Map<String, dynamic> preferences;

  const LibraryPreferencesLoaded({required this.preferences});

  @override
  List<Object> get props => [preferences];
}

// Enhanced LibraryLoaded state with additional metadata
class LibraryLoadedEnhanced extends LibraryState {
  final List<dynamic> items;
  final String currentType;
  final bool hasReachedEnd;
  final int totalCount;
  final String? error;
  final String? currentSortType;
  final String? currentFilter;
  final Map<String, dynamic>? metadata;
  final bool isOfflineMode;
  final DateTime? lastSyncTime;

  const LibraryLoadedEnhanced({
    required this.items,
    required this.currentType,
    this.hasReachedEnd = false,
    this.totalCount = 0,
    this.error,
    this.currentSortType,
    this.currentFilter,
    this.metadata,
    this.isOfflineMode = false,
    this.lastSyncTime,
  });

  @override
  List<Object?> get props => [
    items,
    currentType,
    hasReachedEnd,
    totalCount,
    error,
    currentSortType,
    currentFilter,
    metadata,
    isOfflineMode,
    lastSyncTime,
  ];

  LibraryLoadedEnhanced copyWith({
    List<dynamic>? items,
    String? currentType,
    bool? hasReachedEnd,
    int? totalCount,
    String? error,
    String? currentSortType,
    String? currentFilter,
    Map<String, dynamic>? metadata,
    bool? isOfflineMode,
    DateTime? lastSyncTime,
  }) {
    return LibraryLoadedEnhanced(
      items: items ?? this.items,
      currentType: currentType ?? this.currentType,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      totalCount: totalCount ?? this.totalCount,
      error: error ?? this.error,
      currentSortType: currentSortType ?? this.currentSortType,
      currentFilter: currentFilter ?? this.currentFilter,
      metadata: metadata ?? this.metadata,
      isOfflineMode: isOfflineMode ?? this.isOfflineMode,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

// Enhanced states for better functionality
class LibraryStatsLoaded extends LibraryState {
  final Map<String, int> stats;
  final int totalTracks;
  final int totalPlaylists;
  final int totalDownloads;
  final double totalStorageUsed; // in MB
  final int totalPlaytime; // in minutes

  const LibraryStatsLoaded({
    required this.stats,
    required this.totalTracks,
    required this.totalPlaylists,
    required this.totalDownloads,
    required this.totalStorageUsed,
    required this.totalPlaytime,
  });

  @override
  List<Object> get props => [
        stats,
        totalTracks,
        totalPlaylists,
        totalDownloads,
        totalStorageUsed,
        totalPlaytime,
      ];
}

class LibraryDownloadProgress extends LibraryState {
  final String itemId;
  final double progress; // 0.0 to 1.0
  final String status; // 'downloading', 'paused', 'completed', 'failed'
  final String? errorMessage;

  const LibraryDownloadProgress({
    required this.itemId,
    required this.progress,
    required this.status,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [itemId, progress, status, errorMessage];
}

class LibraryOfflineSync extends LibraryState {
  final bool isSyncing;
  final String? status;
  final DateTime? lastSyncTime;
  final int? itemsSynced;
  final int? totalItems;

  const LibraryOfflineSync({
    required this.isSyncing,
    this.status,
    this.lastSyncTime,
    this.itemsSynced,
    this.totalItems,
  });

  @override
  List<Object?> get props => [
        isSyncing,
        status,
        lastSyncTime,
        itemsSynced,
        totalItems,
      ];
}

class LibraryFiltered extends LibraryState {
  final List<dynamic> filteredItems;
  final Map<String, dynamic> appliedFilters;
  final String currentType;
  final int totalCount;

  const LibraryFiltered({
    required this.filteredItems,
    required this.appliedFilters,
    required this.currentType,
    required this.totalCount,
  });

  @override
  List<Object> get props => [
        filteredItems,
        appliedFilters,
        currentType,
        totalCount,
      ];
}

class LibraryRecentItemsLoaded extends LibraryState {
  final List<dynamic> recentItems;
  final String type;
  final DateTime loadedAt;

  const LibraryRecentItemsLoaded({
    required this.recentItems,
    required this.type,
    required this.loadedAt,
  });

  @override
  List<Object> get props => [recentItems, type, loadedAt];
}
