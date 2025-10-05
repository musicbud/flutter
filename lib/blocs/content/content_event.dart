import 'package:equatable/equatable.dart';

abstract class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object?> get props => [];
}

class LoadTopContent extends ContentEvent {}

class LoadLikedContent extends ContentEvent {}

class LoadPlayedTracks extends ContentEvent {}

class LikeItem extends ContentEvent {
  final String type;
  final String id;

  const LikeItem({required this.type, required this.id});

  @override
  List<Object?> get props => [type, id];
}

class UnlikeItem extends ContentEvent {
  final String type;
  final String id;

  const UnlikeItem({required this.type, required this.id});

  @override
  List<Object?> get props => [type, id];
}

class SearchContent extends ContentEvent {
  final String query;
  final String type;

  const SearchContent({required this.query, required this.type});

  @override
  List<Object?> get props => [query, type];
}

class ContentPlayRequested extends ContentEvent {
  final String trackId;
  final String? deviceId;

  const ContentPlayRequested({required this.trackId, this.deviceId});

  @override
  List<Object?> get props => [trackId, deviceId];
}

class ContentPlayedTracksRequested extends ContentEvent {}

// Enhanced events from legacy
class LoadTopTracks extends ContentEvent {}

class LoadTopArtists extends ContentEvent {}

class LoadTopGenres extends ContentEvent {}

class LoadTopAnime extends ContentEvent {}

class LoadTopManga extends ContentEvent {}

class LoadLikedTracks extends ContentEvent {}

class LoadLikedArtists extends ContentEvent {}

class LoadLikedGenres extends ContentEvent {}

class LoadLikedAlbums extends ContentEvent {}
