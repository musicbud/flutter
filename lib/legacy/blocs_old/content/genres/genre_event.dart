import 'package:equatable/equatable.dart';

abstract class GenreEvent extends Equatable {
  const GenreEvent();

  @override
  List<Object?> get props => [];
}

// Top content
class TopGenresRequested extends GenreEvent {}

// Liked content
class LikedGenresRequested extends GenreEvent {}

// Like/Unlike operations
class GenreLiked extends GenreEvent {
  final String id;

  const GenreLiked(this.id);

  @override
  List<Object> get props => [id];
}

class GenreUnliked extends GenreEvent {
  final String id;

  const GenreUnliked(this.id);

  @override
  List<Object> get props => [id];
}

// Search operations
class GenresSearched extends GenreEvent {
  final String query;

  const GenresSearched(this.query);

  @override
  List<Object> get props => [query];
}
