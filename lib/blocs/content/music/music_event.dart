import 'package:equatable/equatable.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();

  @override
  List<Object?> get props => [];
}

// Popular content
class PopularTracksRequested extends MusicEvent {
  final int limit;

  const PopularTracksRequested({this.limit = 20});

  @override
  List<Object> get props => [limit];
}

class PopularArtistsRequested extends MusicEvent {
  final int limit;

  const PopularArtistsRequested({this.limit = 20});

  @override
  List<Object> get props => [limit];
}

class PopularAlbumsRequested extends MusicEvent {
  final int limit;

  const PopularAlbumsRequested({this.limit = 20});

  @override
  List<Object> get props => [limit];
}

// Top content
class TopTracksRequested extends MusicEvent {}

class TopArtistsRequested extends MusicEvent {}

// Liked content
class LikedTracksRequested extends MusicEvent {}

class LikedArtistsRequested extends MusicEvent {}

class LikedAlbumsRequested extends MusicEvent {}

// Like/Unlike operations
class TrackLiked extends MusicEvent {
  final String id;

  const TrackLiked(this.id);

  @override
  List<Object> get props => [id];
}

class ArtistLiked extends MusicEvent {
  final String id;

  const ArtistLiked(this.id);

  @override
  List<Object> get props => [id];
}

class AlbumLiked extends MusicEvent {
  final String id;

  const AlbumLiked(this.id);

  @override
  List<Object> get props => [id];
}

class TrackUnliked extends MusicEvent {
  final String id;

  const TrackUnliked(this.id);

  @override
  List<Object> get props => [id];
}

class ArtistUnliked extends MusicEvent {
  final String id;

  const ArtistUnliked(this.id);

  @override
  List<Object> get props => [id];
}

class AlbumUnliked extends MusicEvent {
  final String id;

  const AlbumUnliked(this.id);

  @override
  List<Object> get props => [id];
}

// Search operations
class TracksSearched extends MusicEvent {
  final String query;

  const TracksSearched(this.query);

  @override
  List<Object> get props => [query];
}

class ArtistsSearched extends MusicEvent {
  final String query;

  const ArtistsSearched(this.query);

  @override
  List<Object> get props => [query];
}

class AlbumsSearched extends MusicEvent {
  final String query;

  const AlbumsSearched(this.query);

  @override
  List<Object> get props => [query];
}

// Playback operations
class SpotifyDevicesRequested extends MusicEvent {}

class TrackPlayRequested extends MusicEvent {
  final String trackId;
  final String? deviceId;

  const TrackPlayRequested(this.trackId, {this.deviceId});

  @override
  List<Object?> get props => [trackId, deviceId];
}

class TrackPlayWithLocationRequested extends MusicEvent {
  final String trackId;
  final double latitude;
  final double longitude;

  const TrackPlayWithLocationRequested(
    this.trackId,
    this.latitude,
    this.longitude,
  );

  @override
  List<Object> get props => [trackId, latitude, longitude];
}

class PlayedTrackSaved extends MusicEvent {
  final String trackId;
  final double latitude;
  final double longitude;

  const PlayedTrackSaved(
    this.trackId,
    this.latitude,
    this.longitude,
  );

  @override
  List<Object> get props => [trackId, latitude, longitude];
}
