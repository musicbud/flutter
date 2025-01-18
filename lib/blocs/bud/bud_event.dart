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
