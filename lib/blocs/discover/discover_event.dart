import 'package:equatable/equatable.dart';

abstract class DiscoverEvent extends Equatable {
  const DiscoverEvent();

  @override
  List<Object?> get props => [];
}

class DiscoverPageLoaded extends DiscoverEvent {
  const DiscoverPageLoaded();
}

class DiscoverCategorySelected extends DiscoverEvent {
  final String categoryId;

  const DiscoverCategorySelected(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class DiscoverRefreshRequested extends DiscoverEvent {
  const DiscoverRefreshRequested();
}

class DiscoverItemInteracted extends DiscoverEvent {
  final String itemId;
  final String type;
  final String action;

  const DiscoverItemInteracted({
    required this.itemId,
    required this.type,
    required this.action,
  });

  @override
  List<Object?> get props => [itemId, type, action];
}

// New events for fetching specific content types
class FetchTopTracks extends DiscoverEvent {
  const FetchTopTracks();
}

class FetchTopArtists extends DiscoverEvent {
  const FetchTopArtists();
}

class FetchTopGenres extends DiscoverEvent {
  const FetchTopGenres();
}

class FetchTopAnime extends DiscoverEvent {
  const FetchTopAnime();
}

class FetchTopManga extends DiscoverEvent {
  const FetchTopManga();
}

class FetchLikedTracks extends DiscoverEvent {
  const FetchLikedTracks();
}

class FetchLikedArtists extends DiscoverEvent {
  const FetchLikedArtists();
}

class FetchLikedGenres extends DiscoverEvent {
  const FetchLikedGenres();
}

class FetchLikedAlbums extends DiscoverEvent {
  const FetchLikedAlbums();
}

class FetchPlayedTracks extends DiscoverEvent {
  const FetchPlayedTracks();
}
