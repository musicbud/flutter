import 'package:equatable/equatable.dart';
import '../../../../models/common_anime.dart';
import '../../../../models/common_manga.dart';

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

class CommonTopAnimeLoaded extends AnimeMangaState {
  final List<CommonAnime> anime;

  const CommonTopAnimeLoaded(this.anime);

  @override
  List<Object> get props => [anime];
}

class CommonTopMangaLoaded extends AnimeMangaState {
  final List<CommonManga> manga;

  const CommonTopMangaLoaded(this.manga);

  @override
  List<Object> get props => [manga];
}
