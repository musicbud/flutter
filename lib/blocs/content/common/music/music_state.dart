import 'package:equatable/equatable.dart';
import '../../../../models/common_track.dart';
import '../../../../models/common_artist.dart';
import '../../../../models/common_album.dart';

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

class CommonLikedTracksLoaded extends MusicState {
  final List<CommonTrack> tracks;

  const CommonLikedTracksLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

class CommonLikedArtistsLoaded extends MusicState {
  final List<CommonArtist> artists;

  const CommonLikedArtistsLoaded(this.artists);

  @override
  List<Object> get props => [artists];
}

class CommonLikedAlbumsLoaded extends MusicState {
  final List<CommonAlbum> albums;

  const CommonLikedAlbumsLoaded(this.albums);

  @override
  List<Object> get props => [albums];
}

class CommonPlayedTracksLoaded extends MusicState {
  final List<CommonTrack> tracks;

  const CommonPlayedTracksLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

class CommonTopArtistsLoaded extends MusicState {
  final List<CommonArtist> artists;

  const CommonTopArtistsLoaded(this.artists);

  @override
  List<Object> get props => [artists];
}

class CommonTracksLoaded extends MusicState {
  final List<CommonTrack> tracks;

  const CommonTracksLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

class CommonArtistsLoaded extends MusicState {
  final List<CommonArtist> artists;

  const CommonArtistsLoaded(this.artists);

  @override
  List<Object> get props => [artists];
}
