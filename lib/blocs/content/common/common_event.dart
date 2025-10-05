import 'package:equatable/equatable.dart';

abstract class CommonEvent extends Equatable {
  const CommonEvent();

  @override
  List<Object?> get props => [];
}

class CommonLikedTracksRequested extends CommonEvent {
  final String username;

  const CommonLikedTracksRequested(this.username);

  @override
  List<Object> get props => [username];
}

class CommonLikedArtistsRequested extends CommonEvent {
  final String username;

  const CommonLikedArtistsRequested(this.username);

  @override
  List<Object> get props => [username];
}

class CommonLikedAlbumsRequested extends CommonEvent {
  final String username;

  const CommonLikedAlbumsRequested(this.username);

  @override
  List<Object> get props => [username];
}

class CommonPlayedTracksRequested extends CommonEvent {
  final String identifier;
  final int page;

  const CommonPlayedTracksRequested(this.identifier, {this.page = 1});

  @override
  List<Object> get props => [identifier, page];
}

class CommonTopArtistsRequested extends CommonEvent {
  final String username;

  const CommonTopArtistsRequested(this.username);

  @override
  List<Object> get props => [username];
}

class CommonTopGenresRequested extends CommonEvent {
  final String username;

  const CommonTopGenresRequested(this.username);

  @override
  List<Object> get props => [username];
}

class CommonTopAnimeRequested extends CommonEvent {
  final String username;

  const CommonTopAnimeRequested(this.username);

  @override
  List<Object> get props => [username];
}

class CommonTopMangaRequested extends CommonEvent {
  final String username;

  const CommonTopMangaRequested(this.username);

  @override
  List<Object> get props => [username];
}

class CommonTracksRequested extends CommonEvent {
  final String budUid;

  const CommonTracksRequested(this.budUid);

  @override
  List<Object> get props => [budUid];
}

class CommonArtistsRequested extends CommonEvent {
  final String budUid;

  const CommonArtistsRequested(this.budUid);

  @override
  List<Object> get props => [budUid];
}

class CommonGenresRequested extends CommonEvent {
  final String budUid;

  const CommonGenresRequested(this.budUid);

  @override
  List<Object> get props => [budUid];
}

class CategorizedCommonItemsRequested extends CommonEvent {
  final String username;

  const CategorizedCommonItemsRequested(this.username);

  @override
  List<Object> get props => [username];
}
