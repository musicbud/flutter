import 'package:equatable/equatable.dart';
import '../../../models/user_profile.dart';
import '../../../models/track.dart';
import '../../../models/artist.dart';
import '../../../models/album.dart';
import '../../../models/genre.dart';
import '../../../models/common_anime.dart';
import '../../../models/common_manga.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileFailure extends ProfileState {
  final String error;

  const ProfileFailure(this.error);

  @override
  List<Object> get props => [error];
}

// Profile operations
class ProfileLoaded extends ProfileState {
  final UserProfile profile;

  const ProfileLoaded(this.profile);

  @override
  List<Object> get props => [profile];
}

class ProfileError extends ProfileState {
  final String error;

  const ProfileError(this.error);

  @override
  List<Object> get props => [error];
}

class BudProfileLoaded extends ProfileState {
  final UserProfile profile;

  const BudProfileLoaded(this.profile);

  @override
  List<Object> get props => [profile];
}

class ProfileUpdated extends ProfileState {
  final UserProfile profile;

  const ProfileUpdated(this.profile);

  @override
  List<Object> get props => [profile];
}

class ProfileUpdateError extends ProfileState {
  final String error;

  const ProfileUpdateError(this.error);

  @override
  List<Object> get props => [error];
}

class LikesSynced extends ProfileState {}

class LikesSyncError extends ProfileState {
  final String error;

  const LikesSyncError(this.error);

  @override
  List<Object> get props => [error];
}

// Liked items
class LikedArtistsLoaded extends ProfileState {
  final List<Artist> artists;

  const LikedArtistsLoaded(this.artists);

  @override
  List<Object> get props => [artists];
}

class LikedTracksLoaded extends ProfileState {
  final List<Track> tracks;

  const LikedTracksLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

class LikedAlbumsLoaded extends ProfileState {
  final List<Album> albums;

  const LikedAlbumsLoaded(this.albums);

  @override
  List<Object> get props => [albums];
}

class LikedGenresLoaded extends ProfileState {
  final List<Genre> genres;

  const LikedGenresLoaded(this.genres);

  @override
  List<Object> get props => [genres];
}

// Top items
class TopArtistsLoaded extends ProfileState {
  final List<Artist> artists;

  const TopArtistsLoaded(this.artists);

  @override
  List<Object> get props => [artists];
}

class TopTracksLoaded extends ProfileState {
  final List<Track> tracks;

  const TopTracksLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

class TopGenresLoaded extends ProfileState {
  final List<Genre> genres;

  const TopGenresLoaded(this.genres);

  @override
  List<Object> get props => [genres];
}

class TopAnimeLoaded extends ProfileState {
  final List<CommonAnime> anime;

  const TopAnimeLoaded(this.anime);

  @override
  List<Object> get props => [anime];
}

class TopMangaLoaded extends ProfileState {
  final List<CommonManga> manga;

  const TopMangaLoaded(this.manga);

  @override
  List<Object> get props => [manga];
}
