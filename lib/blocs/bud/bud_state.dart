import 'package:equatable/equatable.dart';
import '../../../domain/models/bud_match.dart';
import '../../../domain/models/common_track.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_genre.dart';
import '../../../domain/models/common_album.dart';
import '../../../domain/models/common_anime.dart';
import '../../../domain/models/common_manga.dart';

abstract class BudState extends Equatable {
  const BudState();

  @override
  List<Object?> get props => [];
}

class BudInitial extends BudState {
  const BudInitial();
}

class BudLoading extends BudState {
  const BudLoading();
}

class BudsLoaded extends BudState {
  final List<BudMatch> buds;
  final String category;

  const BudsLoaded({
    required this.buds,
    required this.category,
  });

  @override
  List<Object> get props => [buds, category];
}

class BudError extends BudState {
  final String message;

  const BudError(this.message);

  @override
  List<Object> get props => [message];
}

// Enhanced states from legacy
class BudsByLikedArtistsLoaded extends BudState {
  final List<BudMatch> buds;

  const BudsByLikedArtistsLoaded({required this.buds});

  @override
  List<Object> get props => [buds];
}

class BudsByLikedTracksLoaded extends BudState {
  final List<BudMatch> buds;

  const BudsByLikedTracksLoaded({required this.buds});

  @override
  List<Object> get props => [buds];
}

class BudsByLikedGenresLoaded extends BudState {
  final List<BudMatch> buds;

  const BudsByLikedGenresLoaded({required this.buds});

  @override
  List<Object> get props => [buds];
}

class BudsByLikedAlbumsLoaded extends BudState {
  final List<BudMatch> buds;

  const BudsByLikedAlbumsLoaded({required this.buds});

  @override
  List<Object> get props => [buds];
}

class BudsByTopArtistsLoaded extends BudState {
  final List<BudMatch> buds;

  const BudsByTopArtistsLoaded({required this.buds});

  @override
  List<Object> get props => [buds];
}

class BudsByTopTracksLoaded extends BudState {
  final List<BudMatch> buds;

  const BudsByTopTracksLoaded({required this.buds});

  @override
  List<Object> get props => [buds];
}

class BudsByTopGenresLoaded extends BudState {
  final List<BudMatch> buds;

  const BudsByTopGenresLoaded({required this.buds});

  @override
  List<Object> get props => [buds];
}

class BudsByTopAnimeLoaded extends BudState {
  final List<BudMatch> buds;

  const BudsByTopAnimeLoaded({required this.buds});

  @override
  List<Object> get props => [buds];
}

class BudsByTopMangaLoaded extends BudState {
  final List<BudMatch> buds;

  const BudsByTopMangaLoaded({required this.buds});

  @override
  List<Object> get props => [buds];
}

class BudsByPlayedTracksLoaded extends BudState {
  final List<BudMatch> buds;

  const BudsByPlayedTracksLoaded({required this.buds});

  @override
  List<Object> get props => [buds];
}

class BudsByArtistLoaded extends BudState {
  final List<BudMatch> buds;
  final String artistId;

  const BudsByArtistLoaded({required this.buds, required this.artistId});

  @override
  List<Object> get props => [buds, artistId];
}

class BudsByTrackLoaded extends BudState {
  final List<BudMatch> buds;
  final String trackId;

  const BudsByTrackLoaded({required this.buds, required this.trackId});

  @override
  List<Object> get props => [buds, trackId];
}

class BudsByGenreLoaded extends BudState {
  final List<BudMatch> buds;
  final String genreId;

  const BudsByGenreLoaded({required this.buds, required this.genreId});

  @override
  List<Object> get props => [buds, genreId];
}

class BudsByAlbumLoaded extends BudState {
  final List<BudMatch> buds;
  final String albumId;

  const BudsByAlbumLoaded({required this.buds, required this.albumId});

  @override
  List<Object> get props => [buds, albumId];
}

class BudsSearchLoaded extends BudState {
  final List<BudMatch> buds;
  final String query;

  const BudsSearchLoaded({required this.buds, required this.query});

  @override
  List<Object> get props => [buds, query];
}

// Common items states
class CommonLikedArtistsLoaded extends BudState {
  final List<CommonArtist> artists;
  final String budId;

  const CommonLikedArtistsLoaded({required this.artists, required this.budId});

  @override
  List<Object> get props => [artists, budId];
}

class CommonLikedTracksLoaded extends BudState {
  final List<CommonTrack> tracks;
  final String budId;

  const CommonLikedTracksLoaded({required this.tracks, required this.budId});

  @override
  List<Object> get props => [tracks, budId];
}

class CommonLikedGenresLoaded extends BudState {
  final List<CommonGenre> genres;
  final String budId;

  const CommonLikedGenresLoaded({required this.genres, required this.budId});

  @override
  List<Object> get props => [genres, budId];
}

class CommonLikedAlbumsLoaded extends BudState {
  final List<CommonAlbum> albums;
  final String budId;

  const CommonLikedAlbumsLoaded({required this.albums, required this.budId});

  @override
  List<Object> get props => [albums, budId];
}

class CommonTopArtistsLoaded extends BudState {
  final List<CommonArtist> artists;
  final String budId;

  const CommonTopArtistsLoaded({required this.artists, required this.budId});

  @override
  List<Object> get props => [artists, budId];
}

class CommonTopTracksLoaded extends BudState {
  final List<CommonTrack> tracks;
  final String budId;

  const CommonTopTracksLoaded({required this.tracks, required this.budId});

  @override
  List<Object> get props => [tracks, budId];
}

class CommonTopGenresLoaded extends BudState {
  final List<CommonGenre> genres;
  final String budId;

  const CommonTopGenresLoaded({required this.genres, required this.budId});

  @override
  List<Object> get props => [genres, budId];
}

class CommonTopAnimeLoaded extends BudState {
  final List<CommonAnime> anime;
  final String budId;

  const CommonTopAnimeLoaded({required this.anime, required this.budId});

  @override
  List<Object> get props => [anime, budId];
}

class CommonTopMangaLoaded extends BudState {
  final List<CommonManga> manga;
  final String budId;

  const CommonTopMangaLoaded({required this.manga, required this.budId});

  @override
  List<Object> get props => [manga, budId];
}

class CommonPlayedTracksLoaded extends BudState {
  final List<CommonTrack> tracks;
  final String budId;

  const CommonPlayedTracksLoaded({required this.tracks, required this.budId});

  @override
  List<Object> get props => [tracks, budId];
}
