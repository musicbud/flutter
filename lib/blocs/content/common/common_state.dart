import 'package:equatable/equatable.dart';
import '../../../domain/models/common_track.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_album.dart';
import '../../../domain/models/common_genre.dart';
import '../../../domain/models/common_anime.dart';
import '../../../domain/models/common_manga.dart';
import '../../../domain/models/categorized_common_items.dart';

abstract class CommonState extends Equatable {
  const CommonState();

  @override
  List<Object?> get props => [];
}

class CommonInitial extends CommonState {}

class CommonLoading extends CommonState {}

class CommonFailure extends CommonState {
  final String error;

  const CommonFailure(this.error);

  @override
  List<Object> get props => [error];
}

class CommonLikedTracksLoaded extends CommonState {
  final List<CommonTrack> tracks;

  const CommonLikedTracksLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

class CommonLikedArtistsLoaded extends CommonState {
  final List<CommonArtist> artists;

  const CommonLikedArtistsLoaded(this.artists);

  @override
  List<Object> get props => [artists];
}

class CommonLikedAlbumsLoaded extends CommonState {
  final List<CommonAlbum> albums;

  const CommonLikedAlbumsLoaded(this.albums);

  @override
  List<Object> get props => [albums];
}

class CommonPlayedTracksLoaded extends CommonState {
  final List<CommonTrack> tracks;

  const CommonPlayedTracksLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

class CommonTopArtistsLoaded extends CommonState {
  final List<CommonArtist> artists;

  const CommonTopArtistsLoaded(this.artists);

  @override
  List<Object> get props => [artists];
}

class CommonTopGenresLoaded extends CommonState {
  final List<CommonGenre> genres;

  const CommonTopGenresLoaded(this.genres);

  @override
  List<Object> get props => [genres];
}

class CommonTopAnimeLoaded extends CommonState {
  final List<CommonAnime> anime;

  const CommonTopAnimeLoaded(this.anime);

  @override
  List<Object> get props => [anime];
}

class CommonTopMangaLoaded extends CommonState {
  final List<CommonManga> manga;

  const CommonTopMangaLoaded(this.manga);

  @override
  List<Object> get props => [manga];
}

class CommonTracksLoaded extends CommonState {
  final List<CommonTrack> tracks;

  const CommonTracksLoaded(this.tracks);

  @override
  List<Object> get props => [tracks];
}

class CommonArtistsLoaded extends CommonState {
  final List<CommonArtist> artists;

  const CommonArtistsLoaded(this.artists);

  @override
  List<Object> get props => [artists];
}

class CommonGenresLoaded extends CommonState {
  final List<CommonGenre> genres;

  const CommonGenresLoaded(this.genres);

  @override
  List<Object> get props => [genres];
}

class CategorizedCommonItemsLoaded extends CommonState {
  final CategorizedCommonItems items;

  const CategorizedCommonItemsLoaded(this.items);

  @override
  List<Object> get props => [items];
}
