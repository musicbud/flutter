import 'package:equatable/equatable.dart';
import '../../../../domain/models/common_genre.dart';

abstract class GenreState extends Equatable {
  const GenreState();

  @override
  List<Object?> get props => [];
}

class GenreInitial extends GenreState {}

class GenreLoading extends GenreState {}

class GenreFailure extends GenreState {
  final String error;

  const GenreFailure(this.error);

  @override
  List<Object> get props => [error];
}

class CommonTopGenresLoaded extends GenreState {
  final List<CommonGenre> genres;

  const CommonTopGenresLoaded(this.genres);

  @override
  List<Object> get props => [genres];
}

class CommonGenresLoaded extends GenreState {
  final List<CommonGenre> genres;

  const CommonGenresLoaded(this.genres);

  @override
  List<Object> get props => [genres];
}
