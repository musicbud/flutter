import 'package:equatable/equatable.dart';

abstract class SpotifyAuthEvent extends Equatable {
  const SpotifyAuthEvent();

  @override
  List<Object?> get props => [];
}

class SpotifyAuthCodeReceived extends SpotifyAuthEvent {
  final String code;

  const SpotifyAuthCodeReceived(this.code);

  @override
  List<Object?> get props => [code];
}

class SpotifyAuthCompleted extends SpotifyAuthEvent {}

class SpotifyAuthFailed extends SpotifyAuthEvent {
  final String error;

  const SpotifyAuthFailed(this.error);

  @override
  List<Object?> get props => [error];
}
