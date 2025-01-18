import 'package:equatable/equatable.dart';
import '../../../models/user_profile.dart';
import '../../../models/track.dart';
import '../../../models/artist.dart';
import '../../../models/album.dart';
import '../../../models/genre.dart';
import '../../../models/anime.dart';
import '../../../models/manga.dart';

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
class MyProfileLoaded extends ProfileState {
  final UserProfile profile;

  const MyProfileLoaded(this.profile);

  @override
  List<Object> get props => [profile];
}

class BudProfileLoaded extends ProfileState {
  final UserProfile profile;

  const BudProfileLoaded(this.profile);

  @override
  List<Object> get props => [profile];
}

class ProfileUpdateSuccess extends ProfileState {}

class LikesUpdateSuccess extends ProfileState {}

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
  final List<Anime> anime;

  const TopAnimeLoaded(this.anime);

  @override
  List<Object> get props => [anime];
}

class TopMangaLoaded extends ProfileState {
  final List<Manga> manga;

  const TopMangaLoaded(this.manga);

  @override
  List<Object> get props => [manga];
}
