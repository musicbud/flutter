import 'package:equatable/equatable.dart';

abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object?> get props => [];
}

class LibraryItemsRequested extends LibraryEvent {
  final String type; // 'playlists', 'liked', 'downloads', 'recent'
  final String? query;

  const LibraryItemsRequested({
    required this.type,
    this.query,
  });

  @override
  List<Object?> get props => [type, query];
}

class LibraryItemToggleLiked extends LibraryEvent {
  final String itemId;
  final String type;

  const LibraryItemToggleLiked({
    required this.itemId,
    required this.type,
  });

  @override
  List<Object> get props => [itemId, type];
}

class LibraryItemToggleDownload extends LibraryEvent {
  final String itemId;
  final String type;

  const LibraryItemToggleDownload({
    required this.itemId,
    required this.type,
  });

  @override
  List<Object> get props => [itemId, type];
}

class LibraryItemPlayRequested extends LibraryEvent {
  final String itemId;
  final String type;

  const LibraryItemPlayRequested({
    required this.itemId,
    required this.type,
  });

  @override
  List<Object> get props => [itemId, type];
}

class LibraryPlaylistCreated extends LibraryEvent {
  final String name;
  final String? description;
  final bool isPrivate;

  const LibraryPlaylistCreated({
    required this.name,
    this.description,
    this.isPrivate = false,
  });

  @override
  List<Object?> get props => [name, description, isPrivate];
}

class LibraryPlaylistDeleted extends LibraryEvent {
  final String playlistId;

  const LibraryPlaylistDeleted({required this.playlistId});

  @override
  List<Object> get props => [playlistId];
}

class LibraryItemsRefreshRequested extends LibraryEvent {
  final String type;

  const LibraryItemsRefreshRequested({required this.type});

  @override
  List<Object> get props => [type];
}

class LibrarySearchRequested extends LibraryEvent {
  final String query;
  final String? type;

  const LibrarySearchRequested({
    required this.query,
    this.type,
  });

  @override
  List<Object?> get props => [query, type];
}

class LibrarySortRequested extends LibraryEvent {
  final String sortType; // 'alphabetical', 'recent', 'most_played', 'recently_liked'
  final String? itemType;

  const LibrarySortRequested({
    required this.sortType,
    this.itemType,
  });

  @override
  List<Object?> get props => [sortType, itemType];
}

class LibraryPlaylistUpdateRequested extends LibraryEvent {
  final String playlistId;
  final String? name;
  final String? description;
  final bool? isPublic;

  const LibraryPlaylistUpdateRequested({
    required this.playlistId,
    this.name,
    this.description,
    this.isPublic,
  });

  @override
  List<Object?> get props => [playlistId, name, description, isPublic];
}

class LibraryItemAddToPlaylistRequested extends LibraryEvent {
  final String itemId;
  final String playlistId;
  final String itemType;

  const LibraryItemAddToPlaylistRequested({
    required this.itemId,
    required this.playlistId,
    required this.itemType,
  });

  @override
  List<Object> get props => [itemId, playlistId, itemType];
}

class LibraryBatchActionRequested extends LibraryEvent {
  final List<String> itemIds;
  final String action; // 'delete', 'download', 'add_to_playlist'
  final Map<String, dynamic>? actionData;

  const LibraryBatchActionRequested({
    required this.itemIds,
    required this.action,
    this.actionData,
  });

  @override
  List<Object?> get props => [itemIds, action, actionData];
}

class LibraryDownloadToggleRequested extends LibraryEvent {
  final String itemId;
  final String itemType;
  final String? quality;

  const LibraryDownloadToggleRequested({
    required this.itemId,
    required this.itemType,
    this.quality,
  });

  @override
  List<Object?> get props => [itemId, itemType, quality];
}

// New events for enhanced functionality
class LibraryFolderCreated extends LibraryEvent {
  final String name;
  final String? parentFolderId;
  final String? description;

  const LibraryFolderCreated({
    required this.name,
    this.parentFolderId,
    this.description,
  });

  @override
  List<Object?> get props => [name, parentFolderId, description];
}

class LibraryFolderDeleted extends LibraryEvent {
  final String folderId;

  const LibraryFolderDeleted({required this.folderId});

  @override
  List<Object> get props => [folderId];
}

class LibraryPlaylistAddedToFolder extends LibraryEvent {
  final String playlistId;
  final String folderId;

  const LibraryPlaylistAddedToFolder({
    required this.playlistId,
    required this.folderId,
  });

  @override
  List<Object> get props => [playlistId, folderId];
}

class LibraryDownloadProgressRequested extends LibraryEvent {
  final String itemId;

  const LibraryDownloadProgressRequested({required this.itemId});

  @override
  List<Object> get props => [itemId];
}

class LibraryOfflineSyncRequested extends LibraryEvent {
  const LibraryOfflineSyncRequested();
}

class LibraryRecentItemsRequested extends LibraryEvent {
  final String type; // 'played', 'added', 'liked'
  final int limit;

  const LibraryRecentItemsRequested({
    required this.type,
    this.limit = 20,
  });

  @override
  List<Object> get props => [type, limit];
}

class LibraryStatsRequested extends LibraryEvent {
  const LibraryStatsRequested();
}

class LibraryFilterApplied extends LibraryEvent {
  final String? genre;
  final String? artist;
  final String? year;
  final bool? isDownloaded;
  final String? sortBy;

  const LibraryFilterApplied({
    this.genre,
    this.artist,
    this.year,
    this.isDownloaded,
    this.sortBy,
  });

  @override
  List<Object?> get props => [genre, artist, year, isDownloaded, sortBy];
}

// Additional events for comprehensive library management
class LibraryItemMoveToFolder extends LibraryEvent {
  final List<String> itemIds;
  final String folderId;
  final String itemType;

  const LibraryItemMoveToFolder({
    required this.itemIds,
    required this.folderId,
    required this.itemType,
  });

  @override
  List<Object> get props => [itemIds, folderId, itemType];
}

class LibraryDownloadQueueRequested extends LibraryEvent {
  const LibraryDownloadQueueRequested();
}

class LibraryDownloadStatusUpdate extends LibraryEvent {
  final String itemId;
  final String status;
  final double? progress;
  final String? errorMessage;

  const LibraryDownloadStatusUpdate({
    required this.itemId,
    required this.status,
    this.progress,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [itemId, status, progress, errorMessage];
}

class LibraryOfflineModeToggled extends LibraryEvent {
  final bool enableOfflineMode;

  const LibraryOfflineModeToggled({required this.enableOfflineMode});

  @override
  List<Object> get props => [enableOfflineMode];
}

class LibraryPlaylistTracksRequested extends LibraryEvent {
  final String playlistId;
  final int? limit;
  final int? offset;

  const LibraryPlaylistTracksRequested({
    required this.playlistId,
    this.limit,
    this.offset,
  });

  @override
  List<Object?> get props => [playlistId, limit, offset];
}

class LibraryPlaylistTrackAdded extends LibraryEvent {
  final String playlistId;
  final String trackId;
  final int? position;

  const LibraryPlaylistTrackAdded({
    required this.playlistId,
    required this.trackId,
    this.position,
  });

  @override
  List<Object?> get props => [playlistId, trackId, position];
}

class LibraryPlaylistTrackRemoved extends LibraryEvent {
  final String playlistId;
  final String trackId;
  final int? position;

  const LibraryPlaylistTrackRemoved({
    required this.playlistId,
    required this.trackId,
    this.position,
  });

  @override
  List<Object?> get props => [playlistId, trackId, position];
}

class LibraryPlaylistTracksReordered extends LibraryEvent {
  final String playlistId;
  final int oldIndex;
  final int newIndex;

  const LibraryPlaylistTracksReordered({
    required this.playlistId,
    required this.oldIndex,
    required this.newIndex,
  });

  @override
  List<Object> get props => [playlistId, oldIndex, newIndex];
}

class LibrarySyncRequested extends LibraryEvent {
  final bool forceSync;
  final String? syncType; // 'full', 'playlists', 'liked', 'downloads'

  const LibrarySyncRequested({
    this.forceSync = false,
    this.syncType,
  });

  @override
  List<Object?> get props => [forceSync, syncType];
}

class LibraryPreferencesUpdated extends LibraryEvent {
  final Map<String, dynamic> preferences;

  const LibraryPreferencesUpdated({required this.preferences});

  @override
  List<Object> get props => [preferences];
}

