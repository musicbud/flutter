import 'package:equatable/equatable.dart';
import '../../domain/models/user_profile.dart';
import '../../models/track.dart';
import '../../models/artist.dart';
import '../../models/album.dart';
import '../../models/genre.dart';
import '../../models/anime.dart';
import '../../models/manga.dart';

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
  final List<Anime> topAnime;
  final List<Manga> topManga;

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
