import 'package:equatable/equatable.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/models/track.dart';
import '../../domain/models/common_artist.dart';
import '../../domain/models/common_album.dart';
import '../../domain/models/common_genre.dart';
import '../../domain/models/common_anime.dart';
import '../../domain/models/common_manga.dart';

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
  final List<CommonArtist> likedArtists;
  final List<Track> likedTracks;
  final List<CommonAlbum> likedAlbums;
  final List<CommonGenre> likedGenres;

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
  final List<CommonArtist> topArtists;
  final List<Track> topTracks;
  final List<CommonGenre> topGenres;
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
