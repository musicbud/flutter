import 'package:equatable/equatable.dart';

abstract class AnimeMangaEvent extends Equatable {
  const AnimeMangaEvent();

  @override
  List<Object?> get props => [];
}

class CommonTopAnimeRequested extends AnimeMangaEvent {
  final String username;

  const CommonTopAnimeRequested(this.username);

  @override
  List<Object> get props => [username];
}

class CommonTopMangaRequested extends AnimeMangaEvent {
  final String username;

  const CommonTopMangaRequested(this.username);

  @override
  List<Object> get props => [username];
}
