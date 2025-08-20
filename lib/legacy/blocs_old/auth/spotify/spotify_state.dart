import 'package:equatable/equatable.dart';

abstract class SpotifyState extends Equatable {
  const SpotifyState();

  @override
  List<Object?> get props => [];
}

class SpotifyInitial extends SpotifyState {}

class SpotifyLoading extends SpotifyState {}

class SpotifyAuthUrlLoaded extends SpotifyState {
  final String url;

  const SpotifyAuthUrlLoaded(this.url);

  @override
  List<Object> get props => [url];
}

class SpotifyConnected extends SpotifyState {}

class SpotifyDisconnected extends SpotifyState {}

class SpotifyFailure extends SpotifyState {
  final String error;

  const SpotifyFailure(this.error);

  @override
  List<Object> get props => [error];
}
