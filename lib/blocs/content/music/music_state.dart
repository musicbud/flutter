import 'package:equatable/equatable.dart';
import '../../../models/common_track.dart';
import '../../../models/artist.dart';
import '../../../models/album.dart';
import '../../../models/spotify_device.dart';

abstract class MusicState extends Equatable {
  const MusicState();

  @override
  List<Object?> get props => [];
}

class MusicInitial extends MusicState {}

class MusicLoading extends MusicState {}

class MusicFailure extends MusicState {
  final String error;

  const MusicFailure(this.error);

  @override
  List<Object> get props => [error];
}

// Popular content
class PopularTracksLoaded extends MusicState {
  final List<CommonTrack> tracks;

  const PopularTracksLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

class PopularArtistsLoaded extends MusicState {
  final List<Artist> artists;

  const PopularArtistsLoaded(this.artists);

  @override
  List<Object> get props => [artists];
}

class PopularAlbumsLoaded extends MusicState {
  final List<Album> albums;

  const PopularAlbumsLoaded(this.albums);

  @override
  List<Object> get props => [albums];
}

// Top content
class TopTracksLoaded extends MusicState {
  final List<CommonTrack> tracks;

  const TopTracksLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

class TopArtistsLoaded extends MusicState {
  final List<Artist> artists;

  const TopArtistsLoaded(this.artists);

  @override
  List<Object> get props => [artists];
}

// Liked content
class LikedTracksLoaded extends MusicState {
  final List<CommonTrack> tracks;

  const LikedTracksLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

class LikedArtistsLoaded extends MusicState {
  final List<Artist> artists;

  const LikedArtistsLoaded(this.artists);

  @override
  List<Object> get props => [artists];
}

class LikedAlbumsLoaded extends MusicState {
  final List<Album> albums;

  const LikedAlbumsLoaded(this.albums);

  @override
  List<Object> get props => [albums];
}

// Like/Unlike operations
class TrackLikeSuccess extends MusicState {}

class TrackUnlikeSuccess extends MusicState {}

class ArtistLikeSuccess extends MusicState {}

class ArtistUnlikeSuccess extends MusicState {}

class AlbumLikeSuccess extends MusicState {}

class AlbumUnlikeSuccess extends MusicState {}

// Search operations
class TracksSearchResultLoaded extends MusicState {
  final List<CommonTrack> tracks;

  const TracksSearchResultLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

class ArtistsSearchResultLoaded extends MusicState {
  final List<Artist> artists;

  const ArtistsSearchResultLoaded(this.artists);

  @override
  List<Object> get props => [artists];
}

class AlbumsSearchResultLoaded extends MusicState {
  final List<Album> albums;

  const AlbumsSearchResultLoaded(this.albums);

  @override
  List<Object> get props => [albums];
}

// Playback operations
class SpotifyDevicesLoaded extends MusicState {
  final List<SpotifyDevice> devices;

  const SpotifyDevicesLoaded(this.devices);

  @override
  List<Object> get props => [devices];
}

class TrackPlaySuccess extends MusicState {}

class TrackPlayWithLocationSuccess extends MusicState {}

class PlayedTrackSaveSuccess extends MusicState {}
