import 'package:equatable/equatable.dart';

abstract class TopTracksEvent extends Equatable {
  const TopTracksEvent();

  @override
  List<Object?> get props => [];
}

class TopTracksRequested extends TopTracksEvent {
  final String artistId;
  final int page;

  const TopTracksRequested({
    required this.artistId,
    this.page = 1,
  });

  @override
  List<Object> get props => [artistId, page];
}

class TopTracksLoadMoreRequested extends TopTracksEvent {
  final String artistId;

  const TopTracksLoadMoreRequested(this.artistId);

  @override
  List<Object> get props => [artistId];
}

class TopTracksRefreshRequested extends TopTracksEvent {
  final String artistId;

  const TopTracksRefreshRequested(this.artistId);

  @override
  List<Object> get props => [artistId];
}

class TopTrackLikeToggled extends TopTracksEvent {
  final String trackId;

  const TopTrackLikeToggled(this.trackId);

  @override
  List<Object> get props => [trackId];
}

class TopTrackPlayRequested extends TopTracksEvent {
  final String trackId;
  final String? deviceId;

  const TopTrackPlayRequested({
    required this.trackId,
    this.deviceId,
  });

  @override
  List<Object?> get props => [trackId, deviceId];
}
