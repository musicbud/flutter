import 'package:equatable/equatable.dart';

abstract class ServiceEvent extends Equatable {
  const ServiceEvent();

  @override
  List<Object?> get props => [];
}

// Spotify
class SpotifyAuthUrlRequested extends ServiceEvent {}

class SpotifyConnectRequested extends ServiceEvent {
  final String code;

  const SpotifyConnectRequested(this.code);

  @override
  List<Object> get props => [code];
}

class SpotifyDisconnectRequested extends ServiceEvent {}

// YouTube Music
class YTMusicAuthUrlRequested extends ServiceEvent {}

class YTMusicConnectRequested extends ServiceEvent {
  final String code;

  const YTMusicConnectRequested(this.code);

  @override
  List<Object> get props => [code];
}

class YTMusicDisconnectRequested extends ServiceEvent {}

// MyAnimeList
class MALAuthUrlRequested extends ServiceEvent {}

class MALConnectRequested extends ServiceEvent {
  final String code;

  const MALConnectRequested(this.code);

  @override
  List<Object> get props => [code];
}

class MALDisconnectRequested extends ServiceEvent {}

// LastFM
class LastFMAuthUrlRequested extends ServiceEvent {}

class LastFMConnectRequested extends ServiceEvent {
  final String code;

  const LastFMConnectRequested(this.code);

  @override
  List<Object> get props => [code];
}

class LastFMDisconnectRequested extends ServiceEvent {}
