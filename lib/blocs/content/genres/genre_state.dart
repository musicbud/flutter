import 'package:equatable/equatable.dart';
import '../../../domain/models/common_genre.dart';

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

// Top content
class TopGenresLoaded extends GenreState {
  final List<CommonGenre> genres;

  const TopGenresLoaded(this.genres);

  @override
  List<Object> get props => [genres];
}

// Liked content
class LikedGenresLoaded extends GenreState {
  final List<CommonGenre> genres;

  const LikedGenresLoaded(this.genres);

  @override
  List<Object> get props => [genres];
}

// Like/Unlike operations
class GenreLikeSuccess extends GenreState {}

class GenreUnlikeSuccess extends GenreState {}

// Search operations
class GenresSearchResultLoaded extends GenreState {
  final List<CommonGenre> genres;

  const GenresSearchResultLoaded(this.genres);

  @override
  List<Object> get props => [genres];
}
