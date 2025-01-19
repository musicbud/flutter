import 'package:equatable/equatable.dart';

abstract class ContentEvent extends Equatable {
  const ContentEvent();

  @override
  List<Object?> get props => [];
}

class ContentRequested extends ContentEvent {}

class ContentRefreshRequested extends ContentEvent {}

class ContentLikeRequested extends ContentEvent {
  final String id;
  final String type;

  const ContentLikeRequested({required this.id, required this.type});

  @override
  List<Object> get props => [id, type];
}

class ContentUnlikeRequested extends ContentEvent {
  final String id;
  final String type;

  const ContentUnlikeRequested({required this.id, required this.type});

  @override
  List<Object> get props => [id, type];
}

class ContentSearchRequested extends ContentEvent {
  final String query;
  final String type;

  const ContentSearchRequested({required this.query, required this.type});

  @override
  List<Object> get props => [query, type];
}

class ContentPlayRequested extends ContentEvent {
  final String trackId;
  final String? deviceId;

  const ContentPlayRequested({required this.trackId, this.deviceId});

  @override
  List<Object?> get props => [trackId, deviceId];
}

class ContentPlayedTracksRequested extends ContentEvent {}
