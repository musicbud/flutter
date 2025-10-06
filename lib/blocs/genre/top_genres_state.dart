import 'package:equatable/equatable.dart';
import '../../models/genre.dart';

abstract class TopGenresState extends Equatable {
  const TopGenresState();

  @override
  List<Object?> get props => [];
}

class TopGenresInitial extends TopGenresState {}

class TopGenresLoading extends TopGenresState {}

class TopGenresLoadingMore extends TopGenresState {
  final List<Genre> currentGenres;

  const TopGenresLoadingMore(this.currentGenres);

  @override
  List<Object> get props => [currentGenres];
}

class TopGenresLoaded extends TopGenresState {
  final List<Genre> genres;
  final bool hasReachedEnd;
  final int currentPage;
  final String? selectedGenreId;

  const TopGenresLoaded({
    required this.genres,
    this.hasReachedEnd = false,
    this.currentPage = 1,
    this.selectedGenreId,
  });

  @override
  List<Object?> get props =>
      [genres, hasReachedEnd, currentPage, selectedGenreId];

  TopGenresLoaded copyWith({
    List<Genre>? genres,
    bool? hasReachedEnd,
    int? currentPage,
    String? selectedGenreId,
  }) {
    return TopGenresLoaded(
      genres: genres ?? this.genres,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
      selectedGenreId: selectedGenreId ?? this.selectedGenreId,
    );
  }
}

class TopGenreLikeStatusChanged extends TopGenresState {
  final String genreId;
  final bool isLiked;

  const TopGenreLikeStatusChanged({
    required this.genreId,
    required this.isLiked,
  });

  @override
  List<Object> get props => [genreId, isLiked];
}

class TopGenresFailure extends TopGenresState {
  final String error;

  const TopGenresFailure(this.error);

  @override
  List<Object> get props => [error];
}
