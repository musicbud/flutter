import 'package:equatable/equatable.dart';

abstract class SpotifyEvent extends Equatable {
  const SpotifyEvent();

  @override
  List<Object?> get props => [];
}

class SpotifyAuthUrlRequested extends SpotifyEvent {}

class SpotifyConnectRequested extends SpotifyEvent {
  final String code;

  const SpotifyConnectRequested(this.code);

  @override
  List<Object> get props => [code];
}

class SpotifyDisconnectRequested extends SpotifyEvent {}
