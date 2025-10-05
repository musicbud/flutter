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
