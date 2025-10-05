import 'package:equatable/equatable.dart';
import '../../domain/models/common_artist.dart';

abstract class TopArtistsState extends Equatable {
  const TopArtistsState();

  @override
  List<Object?> get props => [];
}

class TopArtistsInitial extends TopArtistsState {}

class TopArtistsLoading extends TopArtistsState {}

class TopArtistsLoadingMore extends TopArtistsState {
  final List<CommonArtist> currentArtists;

  const TopArtistsLoadingMore(this.currentArtists);

  @override
  List<Object> get props => [currentArtists];
}

class TopArtistsLoaded extends TopArtistsState {
  final List<CommonArtist> artists;
  final bool hasReachedEnd;
  final int currentPage;

  const TopArtistsLoaded({
    required this.artists,
    this.hasReachedEnd = false,
    this.currentPage = 1,
  });

  @override
  List<Object> get props => [artists, hasReachedEnd, currentPage];

  TopArtistsLoaded copyWith({
    List<CommonArtist>? artists,
    bool? hasReachedEnd,
    int? currentPage,
  }) {
    return TopArtistsLoaded(
      artists: artists ?? this.artists,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class TopArtistsFailure extends TopArtistsState {
  final String error;

  const TopArtistsFailure(this.error);

  @override
  List<Object> get props => [error];
}
