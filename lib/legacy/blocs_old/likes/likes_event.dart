import 'package:equatable/equatable.dart';

abstract class LikesEvent extends Equatable {
  const LikesEvent();

  @override
  List<Object?> get props => [];
}

class LikesUpdateRequested extends LikesEvent {
  final String channelId;

  const LikesUpdateRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class LikesUpdateCancelled extends LikesEvent {}

class SpotifyConnectionRequested extends LikesEvent {}
