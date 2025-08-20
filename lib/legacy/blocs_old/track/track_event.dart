import 'package:equatable/equatable.dart';

abstract class TrackEvent extends Equatable {
  const TrackEvent();

  @override
  List<Object?> get props => [];
}

class TrackBudsRequested extends TrackEvent {
  final String trackId;

  const TrackBudsRequested(this.trackId);

  @override
  List<Object> get props => [trackId];
}

class TrackLikeToggled extends TrackEvent {
  final String trackId;

  const TrackLikeToggled(this.trackId);

  @override
  List<Object> get props => [trackId];
}

class TrackPlayRequested extends TrackEvent {
  final String trackId;
  final String? deviceId;

  const TrackPlayRequested({
    required this.trackId,
    this.deviceId,
  });

  @override
  List<Object?> get props => [trackId, deviceId];
}
