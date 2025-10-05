import 'package:equatable/equatable.dart';

abstract class SpotifyAuthState extends Equatable {
  const SpotifyAuthState();

  @override
  List<Object?> get props => [];
}

class SpotifyAuthInitial extends SpotifyAuthState {}

class SpotifyAuthLoading extends SpotifyAuthState {}

class SpotifyAuthSuccess extends SpotifyAuthState {}

class SpotifyAuthFailure extends SpotifyAuthState {
  final String error;

  const SpotifyAuthFailure(this.error);

  @override
  List<Object?> get props => [error];
}
