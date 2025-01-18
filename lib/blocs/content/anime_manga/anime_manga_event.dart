import 'package:equatable/equatable.dart';

abstract class AnimeMangaEvent extends Equatable {
  const AnimeMangaEvent();

  @override
  List<Object?> get props => [];
}

// Popular content
class PopularAnimeRequested extends AnimeMangaEvent {
  final int limit;

  const PopularAnimeRequested({this.limit = 20});

  @override
  List<Object> get props => [limit];
}

class PopularMangaRequested extends AnimeMangaEvent {
  final int limit;

  const PopularMangaRequested({this.limit = 20});

  @override
  List<Object> get props => [limit];
}

// Top content
class TopAnimeRequested extends AnimeMangaEvent {}

class TopMangaRequested extends AnimeMangaEvent {}

// Like/Unlike operations
class AnimeLiked extends AnimeMangaEvent {
  final String id;

  const AnimeLiked(this.id);

  @override
  List<Object> get props => [id];
}

class MangaLiked extends AnimeMangaEvent {
  final String id;

  const MangaLiked(this.id);

  @override
  List<Object> get props => [id];
}

class AnimeUnliked extends AnimeMangaEvent {
  final String id;

  const AnimeUnliked(this.id);

  @override
  List<Object> get props => [id];
}

class MangaUnliked extends AnimeMangaEvent {
  final String id;

  const MangaUnliked(this.id);

  @override
  List<Object> get props => [id];
}

// Search operations
class AnimeSearched extends AnimeMangaEvent {
  final String query;

  const AnimeSearched(this.query);

  @override
  List<Object> get props => [query];
}

class MangaSearched extends AnimeMangaEvent {
  final String query;

  const MangaSearched(this.query);

  @override
  List<Object> get props => [query];
}
