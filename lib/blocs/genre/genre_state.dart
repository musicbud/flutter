import 'package:equatable/equatable.dart';
import '../../models/genre.dart';
import '../../models/bud_match.dart';

abstract class GenreState extends Equatable {
  const GenreState();

  @override
  List<Object?> get props => [];
}

class GenreInitial extends GenreState {}

class GenreLoading extends GenreState {}

class GenreDetailsLoaded extends GenreState {
  final Genre genre;
  final List<BudMatch> buds;

  const GenreDetailsLoaded({
    required this.genre,
    required this.buds,
  });

  @override
  List<Object> get props => [genre, buds];
}

class GenreLikeStatusChanged extends GenreState {
  final bool isLiked;

  const GenreLikeStatusChanged(this.isLiked);

  @override
  List<Object> get props => [isLiked];
}

class GenreFailure extends GenreState {
  final String error;

  const GenreFailure(this.error);

  @override
  List<Object> get props => [error];
}
