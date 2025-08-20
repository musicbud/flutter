import 'package:equatable/equatable.dart';
import '../../../domain/models/user_profile.dart';
import '../../../domain/models/track.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_album.dart';
import '../../../domain/models/common_genre.dart';
import '../../../domain/models/common_anime.dart';
import '../../../domain/models/common_manga.dart';

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
  final List<CommonArtist> artists;

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
  final List<CommonAlbum> albums;

  const LikedAlbumsLoaded(this.albums);

  @override
  List<Object> get props => [albums];
}

class LikedGenresLoaded extends ProfileState {
  final List<CommonGenre> genres;

  const LikedGenresLoaded(this.genres);

  @override
  List<Object> get props => [genres];
}

// Top items
class TopArtistsLoaded extends ProfileState {
  final List<CommonArtist> artists;

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
  final List<CommonGenre> genres;

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
