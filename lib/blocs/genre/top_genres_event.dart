import 'package:equatable/equatable.dart';

abstract class TopGenresEvent extends Equatable {
  const TopGenresEvent();

  @override
  List<Object?> get props => [];
}

class TopGenresRequested extends TopGenresEvent {
  final int page;

  const TopGenresRequested({this.page = 1});

  @override
  List<Object> get props => [page];
}

class TopGenresLoadMoreRequested extends TopGenresEvent {}

class TopGenresRefreshRequested extends TopGenresEvent {}

class TopGenreLikeToggled extends TopGenresEvent {
  final String genreId;

  const TopGenreLikeToggled(this.genreId);

  @override
  List<Object> get props => [genreId];
}

class TopGenreSelected extends TopGenresEvent {
  final String genreId;

  const TopGenreSelected(this.genreId);

  @override
  List<Object> get props => [genreId];
}
