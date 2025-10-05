import 'package:equatable/equatable.dart';

abstract class BudEvent extends Equatable {
  const BudEvent();

  @override
  List<Object?> get props => [];
}

// By liked items
class BudsByLikedArtistsRequested extends BudEvent {}

class BudsByLikedTracksRequested extends BudEvent {}

class BudsByLikedGenresRequested extends BudEvent {}

class BudsByLikedAlbumsRequested extends BudEvent {}

class BudsByPlayedTracksRequested extends BudEvent {}

// By top items
class BudsByTopArtistsRequested extends BudEvent {}

class BudsByTopTracksRequested extends BudEvent {}

class BudsByTopGenresRequested extends BudEvent {}

class BudsByTopAnimeRequested extends BudEvent {}

class BudsByTopMangaRequested extends BudEvent {}

// By specific item
class BudsByArtistRequested extends BudEvent {
  final String artistId;

  const BudsByArtistRequested(this.artistId);

  @override
  List<Object> get props => [artistId];
}

class BudsByTrackRequested extends BudEvent {
  final String trackId;

  const BudsByTrackRequested(this.trackId);

  @override
  List<Object> get props => [trackId];
}

class BudsByGenreRequested extends BudEvent {
  final String genreId;

  const BudsByGenreRequested(this.genreId);

  @override
  List<Object> get props => [genreId];
}

class BudsByAlbumRequested extends BudEvent {
  final String albumId;

  const BudsByAlbumRequested(this.albumId);

  @override
  List<Object> get props => [albumId];
}

// Search
class BudsSearchRequested extends BudEvent {
  final String query;

  const BudsSearchRequested(this.query);

  @override
  List<Object> get props => [query];
}

// Common items with specific bud
class CommonLikedArtistsRequested extends BudEvent {
  final String budId;

  const CommonLikedArtistsRequested(this.budId);

  @override
  List<Object> get props => [budId];
}

class CommonLikedTracksRequested extends BudEvent {
  final String budId;

  const CommonLikedTracksRequested(this.budId);

  @override
  List<Object> get props => [budId];
}

class CommonLikedGenresRequested extends BudEvent {
  final String budId;

  const CommonLikedGenresRequested(this.budId);

  @override
  List<Object> get props => [budId];
}

class CommonLikedAlbumsRequested extends BudEvent {
  final String budId;

  const CommonLikedAlbumsRequested(this.budId);

  @override
  List<Object> get props => [budId];
}

class CommonTopArtistsRequested extends BudEvent {
  final String budId;

  const CommonTopArtistsRequested(this.budId);

  @override
  List<Object> get props => [budId];
}

class CommonTopTracksRequested extends BudEvent {
  final String budId;

  const CommonTopTracksRequested(this.budId);

  @override
  List<Object> get props => [budId];
}

class CommonTopGenresRequested extends BudEvent {
  final String budId;

  const CommonTopGenresRequested(this.budId);

  @override
  List<Object> get props => [budId];
}

class CommonTopAnimeRequested extends BudEvent {
  final String budId;

  const CommonTopAnimeRequested(this.budId);

  @override
  List<Object> get props => [budId];
}

class CommonTopMangaRequested extends BudEvent {
  final String budId;

  const CommonTopMangaRequested(this.budId);

  @override
  List<Object> get props => [budId];
}

class CommonPlayedTracksRequested extends BudEvent {
  final String budId;

  const CommonPlayedTracksRequested(this.budId);

  @override
  List<Object> get props => [budId];
}
