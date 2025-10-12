import 'package:equatable/equatable.dart';
import '../../models/user_profile.dart';
import '../../models/track.dart';
import '../../models/artist.dart';
import '../../models/album.dart';
import '../../models/genre.dart';
import '../../models/common_anime.dart';
import '../../models/common_manga.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class ProfileLoaded extends UserState {
  final UserProfile profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

// Alias for backwards compatibility
class UserProfileLoaded extends ProfileLoaded {
  const UserProfileLoaded(UserProfile profile) : super(profile);
}

class LikedItemsLoaded extends UserState {
  final List<Artist> likedArtists;
  final List<Track> likedTracks;
  final List<Album> likedAlbums;
  final List<Genre> likedGenres;

  const LikedItemsLoaded({
    required this.likedArtists,
    required this.likedTracks,
    required this.likedAlbums,
    required this.likedGenres,
  });

  @override
  List<Object?> get props => [
        likedArtists,
        likedTracks,
        likedAlbums,
        likedGenres,
      ];
}

class TopItemsLoaded extends UserState {
  final List<Artist> topArtists;
  final List<Track> topTracks;
  final List<Genre> topGenres;
  final List<CommonAnime> topAnime;
  final List<CommonManga> topManga;

  const TopItemsLoaded({
    required this.topArtists,
    required this.topTracks,
    required this.topGenres,
    required this.topAnime,
    required this.topManga,
  });

  @override
  List<Object?> get props => [
        topArtists,
        topTracks,
        topGenres,
        topAnime,
        topManga,
      ];
}

class PlayedTracksLoaded extends UserState {
  final List<Track> playedTracks;

  const PlayedTracksLoaded(this.playedTracks);

  @override
  List<Object?> get props => [playedTracks];
}

class UserError extends UserState {
  final String message;

  const UserError(this.message);

  @override
  List<Object?> get props => [message];
}

// Authentication States
class LoginSuccess extends UserState {}

class LoginFailure extends UserState {
  final String error;

  const LoginFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class RegisterSuccess extends UserState {}

class RegisterFailure extends UserState {
  final String error;

  const RegisterFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class ServiceLoginUrlReceived extends UserState {
  final String url;

  const ServiceLoginUrlReceived(this.url);

  @override
  List<Object?> get props => [url];
}

class ServiceLoginUrlError extends UserState {
  final String error;

  const ServiceLoginUrlError(this.error);

  @override
  List<Object?> get props => [error];
}

class ServiceConnected extends UserState {
  final String service;

  const ServiceConnected(this.service);

  @override
  List<Object?> get props => [service];
}

class ServiceConnectionError extends UserState {
  final String service;
  final String error;

  const ServiceConnectionError(this.service, this.error);

  @override
  List<Object?> get props => [service, error];
}

class SpotifyTokenRefreshed extends UserState {}

class SpotifyTokenRefreshError extends UserState {
  final String error;

  const SpotifyTokenRefreshError(this.error);

  @override
  List<Object?> get props => [error];
}
