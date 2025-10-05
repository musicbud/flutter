import 'package:equatable/equatable.dart';

abstract class GenreEvent extends Equatable {
  const GenreEvent();

  @override
  List<Object?> get props => [];
}

class GenreBudsRequested extends GenreEvent {
  final String genreId;

  const GenreBudsRequested(this.genreId);

  @override
  List<Object> get props => [genreId];
}

class GenreLikeToggled extends GenreEvent {
  final String genreId;

  const GenreLikeToggled(this.genreId);

  @override
  List<Object> get props => [genreId];
}

class GenreDetailsRequested extends GenreEvent {
  final String genreId;

  const GenreDetailsRequested(this.genreId);

  @override
  List<Object> get props => [genreId];
}
