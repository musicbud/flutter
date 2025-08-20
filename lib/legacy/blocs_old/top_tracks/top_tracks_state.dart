import 'package:equatable/equatable.dart';
import '../../domain/models/common_track.dart';

abstract class TopTracksState extends Equatable {
  const TopTracksState();

  @override
  List<Object?> get props => [];
}

class TopTracksInitial extends TopTracksState {
  const TopTracksInitial();
}

class TopTracksLoading extends TopTracksState {
  const TopTracksLoading();
}

class TopTracksLoadingMore extends TopTracksState {
  final List<CommonTrack> currentTracks;

  const TopTracksLoadingMore(this.currentTracks);

  @override
  List<Object> get props => [currentTracks];
}

class TopTracksLoaded extends TopTracksState {
  final List<CommonTrack> tracks;
  final bool hasReachedEnd;
  final int currentPage;

  const TopTracksLoaded({
    required this.tracks,
    this.hasReachedEnd = false,
    this.currentPage = 1,
  });

  @override
  List<Object> get props => [tracks, hasReachedEnd, currentPage];

  TopTracksLoaded copyWith({
    List<CommonTrack>? tracks,
    bool? hasReachedEnd,
    int? currentPage,
  }) {
    return TopTracksLoaded(
      tracks: tracks ?? this.tracks,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class TopTrackLikeStatusChanged extends TopTracksState {
  final bool isLiked;

  const TopTrackLikeStatusChanged(this.isLiked);

  @override
  List<Object> get props => [isLiked];
}

class TopTrackPlaybackStarted extends TopTracksState {
  const TopTrackPlaybackStarted();
}

class TopTracksFailure extends TopTracksState {
  final String error;

  const TopTracksFailure(this.error);

  @override
  List<Object> get props => [error];
}
