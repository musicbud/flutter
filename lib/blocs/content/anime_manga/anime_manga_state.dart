import 'package:equatable/equatable.dart';
import '../../../models/common_anime.dart';
import '../../../models/common_manga.dart';

abstract class AnimeMangaState extends Equatable {
  const AnimeMangaState();

  @override
  List<Object?> get props => [];
}

class AnimeMangaInitial extends AnimeMangaState {}

class AnimeMangaLoading extends AnimeMangaState {}

class AnimeMangaFailure extends AnimeMangaState {
  final String error;

  const AnimeMangaFailure(this.error);

  @override
  List<Object> get props => [error];
}

// Popular content
class PopularAnimeLoaded extends AnimeMangaState {
  final List<CommonAnime> anime;

  const PopularAnimeLoaded(this.anime);

  @override
  List<Object> get props => [anime];
}

class PopularMangaLoaded extends AnimeMangaState {
  final List<CommonManga> manga;

  const PopularMangaLoaded(this.manga);

  @override
  List<Object> get props => [manga];
}

// Top content
class TopAnimeLoaded extends AnimeMangaState {
  final List<CommonAnime> anime;

  const TopAnimeLoaded(this.anime);

  @override
  List<Object> get props => [anime];
}

class TopMangaLoaded extends AnimeMangaState {
  final List<CommonManga> manga;

  const TopMangaLoaded(this.manga);

  @override
  List<Object> get props => [manga];
}

// Like/Unlike operations
class AnimeLikeSuccess extends AnimeMangaState {}

class AnimeUnlikeSuccess extends AnimeMangaState {}

class MangaLikeSuccess extends AnimeMangaState {}

class MangaUnlikeSuccess extends AnimeMangaState {}

// Search operations
class AnimeSearchResultLoaded extends AnimeMangaState {
  final List<CommonAnime> anime;

  const AnimeSearchResultLoaded(this.anime);

  @override
  List<Object> get props => [anime];
}

class MangaSearchResultLoaded extends AnimeMangaState {
  final List<CommonManga> manga;

  const MangaSearchResultLoaded(this.manga);

  @override
  List<Object> get props => [manga];
}
