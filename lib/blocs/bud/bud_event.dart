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

class BudsRequested extends BudEvent {}

class BudMatchesRequested extends BudEvent {}

class BudRecommendationsRequested extends BudEvent {}

class BudSearchRequested extends BudEvent {
  final String query;

  const BudSearchRequested({required this.query});

  @override
  List<Object?> get props => [query];
}

class BudRequestSent extends BudEvent {
  final String userId;

  const BudRequestSent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class BudRequestAccepted extends BudEvent {
  final String userId;

  const BudRequestAccepted({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class BudRequestRejected extends BudEvent {
  final String userId;

  const BudRequestRejected({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class BudRemoved extends BudEvent {
  final String userId;

  const BudRemoved({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class CommonItemsRequested extends BudEvent {
  final String userId;
  final String category;

  const CommonItemsRequested({
    required this.userId,
    required this.category,
  });

  @override
  List<Object?> get props => [userId, category];
}
