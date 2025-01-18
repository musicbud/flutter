import 'package:equatable/equatable.dart';

abstract class MusicEvent extends Equatable {
  const MusicEvent();

  @override
  List<Object?> get props => [];
}

class CommonLikedTracksRequested extends MusicEvent {
  final String username;

  const CommonLikedTracksRequested(this.username);

  @override
  List<Object> get props => [username];
}

class CommonLikedArtistsRequested extends MusicEvent {
  final String username;

  const CommonLikedArtistsRequested(this.username);

  @override
  List<Object> get props => [username];
}

class CommonLikedAlbumsRequested extends MusicEvent {
  final String username;

  const CommonLikedAlbumsRequested(this.username);

  @override
  List<Object> get props => [username];
}

class CommonPlayedTracksRequested extends MusicEvent {
  final String identifier;
  final int page;

  const CommonPlayedTracksRequested(this.identifier, {this.page = 1});

  @override
  List<Object> get props => [identifier, page];
}

class CommonTopArtistsRequested extends MusicEvent {
  final String username;

  const CommonTopArtistsRequested(this.username);

  @override
  List<Object> get props => [username];
}

class CommonTracksRequested extends MusicEvent {
  final String budUid;

  const CommonTracksRequested(this.budUid);

  @override
  List<Object> get props => [budUid];
}

class CommonArtistsRequested extends MusicEvent {
  final String budUid;

  const CommonArtistsRequested(this.budUid);

  @override
  List<Object> get props => [budUid];
}
