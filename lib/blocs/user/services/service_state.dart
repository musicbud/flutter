import 'package:equatable/equatable.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object?> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceFailure extends ServiceState {
  final String error;

  const ServiceFailure(this.error);

  @override
  List<Object> get props => [error];
}

// Spotify
class SpotifyAuthUrlLoaded extends ServiceState {
  final String url;

  const SpotifyAuthUrlLoaded(this.url);

  @override
  List<Object> get props => [url];
}

class SpotifyConnected extends ServiceState {}

class SpotifyDisconnected extends ServiceState {}

// YouTube Music
class YTMusicAuthUrlLoaded extends ServiceState {
  final String url;

  const YTMusicAuthUrlLoaded(this.url);

  @override
  List<Object> get props => [url];
}

class YTMusicConnected extends ServiceState {}

class YTMusicDisconnected extends ServiceState {}

// MyAnimeList
class MALAuthUrlLoaded extends ServiceState {
  final String url;

  const MALAuthUrlLoaded(this.url);

  @override
  List<Object> get props => [url];
}

class MALConnected extends ServiceState {}

class MALDisconnected extends ServiceState {}

// LastFM
class LastFMAuthUrlLoaded extends ServiceState {
  final String url;

  const LastFMAuthUrlLoaded(this.url);

  @override
  List<Object> get props => [url];
}

class LastFMConnected extends ServiceState {}

class LastFMDisconnected extends ServiceState {}
