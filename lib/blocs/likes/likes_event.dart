import 'package:equatable/equatable.dart';

abstract class LikesEvent extends Equatable {
  const LikesEvent();

  @override
  List<Object?> get props => [];
}

class LikesUpdateRequested extends LikesEvent {
  final String channelId;

  const LikesUpdateRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class LikesUpdateCancelled extends LikesEvent {}

class SpotifyConnectionRequested extends LikesEvent {}

/// Event to like an artist
class ArtistLikeRequested extends LikesEvent {
  final String artistId;
  final bool isLiked;

  const ArtistLikeRequested({
    required this.artistId,
    this.isLiked = true,
  });

  @override
  List<Object> get props => [artistId, isLiked];
}

/// Event to like a track
class TrackLikeRequested extends LikesEvent {
  final String trackId;
  final bool isLiked;

  const TrackLikeRequested({
    required this.trackId,
    this.isLiked = true,
  });

  @override
  List<Object> get props => [trackId, isLiked];
}

/// Event to like an album
class AlbumLikeRequested extends LikesEvent {
  final String albumId;
  final bool isLiked;

  const AlbumLikeRequested({
    required this.albumId,
    this.isLiked = true,
  });

  @override
  List<Object> get props => [albumId, isLiked];
}

/// Event to like a genre
class GenreLikeRequested extends LikesEvent {
  final String genreId;
  final bool isLiked;

  const GenreLikeRequested({
    required this.genreId,
    this.isLiked = true,
  });

  @override
  List<Object> get props => [genreId, isLiked];
}
