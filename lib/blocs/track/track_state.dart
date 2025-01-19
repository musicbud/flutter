import 'package:equatable/equatable.dart';
import '../../domain/models/common_track.dart';
import '../../domain/models/bud_match.dart';

abstract class TrackState extends Equatable {
  const TrackState();

  @override
  List<Object?> get props => [];
}

class TrackInitial extends TrackState {}

class TrackLoading extends TrackState {}

class TrackBudsLoaded extends TrackState {
  final List<BudMatch> buds;

  const TrackBudsLoaded(this.buds);

  @override
  List<Object> get props => [buds];
}

class TrackLikeStatusChanged extends TrackState {
  final bool isLiked;

  const TrackLikeStatusChanged(this.isLiked);

  @override
  List<Object> get props => [isLiked];
}

class TrackPlayStarted extends TrackState {
  final CommonTrack track;

  const TrackPlayStarted(this.track);

  @override
  List<Object> get props => [track];
}

class TrackFailure extends TrackState {
  final String error;

  const TrackFailure(this.error);

  @override
  List<Object> get props => [error];
}
