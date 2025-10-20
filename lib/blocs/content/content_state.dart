import 'package:equatable/equatable.dart';
import '../../../models/track.dart';
import '../../../models/artist.dart';
import '../../../models/genre.dart';
import '../../../models/album.dart';
import '../../../models/common_anime.dart';
import '../../../models/common_manga.dart';

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object?> get props => [];
}

class ContentInitial extends ContentState {}

class ContentLoading extends ContentState {}

class ContentLoaded extends ContentState {
   final List<Track> topTracks;
   final List<Artist> topArtists;
   final List<Genre> topGenres;
   final List<Album>? likedAlbums;
   final List<Track>? likedTracks;
   final List<Artist>? likedArtists;
   final List<Genre>? likedGenres;
   final List<Track>? playedTracks;
   final List<CommonAnime> topAnime;
   final List<CommonManga> topManga;

  const ContentLoaded({
    required this.topTracks,
    required this.topArtists,
    required this.topGenres,
    this.likedAlbums,
    this.likedTracks,
    this.likedArtists,
    this.likedGenres,
    this.playedTracks,
    required this.topAnime,
    required this.topManga,
  });

  @override
  List<Object?> get props => [
        topTracks,
        topArtists,
        topGenres,
        likedAlbums,
        likedTracks,
        likedArtists,
        likedGenres,
        playedTracks,
        topAnime,
        topManga,
      ];

  ContentLoaded copyWith({
    List<Track>? topTracks,
    List<Artist>? topArtists,
    List<Genre>? topGenres,
    List<Album>? likedAlbums,
    List<Track>? likedTracks,
    List<Artist>? likedArtists,
    List<Genre>? likedGenres,
    List<Track>? playedTracks,
    List<CommonAnime>? topAnime,
    List<CommonManga>? topManga,
  }) {
    return ContentLoaded(
      topTracks: topTracks ?? this.topTracks,
      topArtists: topArtists ?? this.topArtists,
      topGenres: topGenres ?? this.topGenres,
      likedAlbums: likedAlbums ?? this.likedAlbums,
      likedTracks: likedTracks ?? this.likedTracks,
      likedArtists: likedArtists ?? this.likedArtists,
      likedGenres: likedGenres ?? this.likedGenres,
      playedTracks: playedTracks ?? this.playedTracks,
      topAnime: topAnime ?? this.topAnime,
      topManga: topManga ?? this.topManga,
    );
  }
}

class ContentError extends ContentState {
  final String message;

  const ContentError(this.message);

  @override
  List<Object?> get props => [message];
}

class ContentSuccess extends ContentState {
  const ContentSuccess();

  @override
  List<Object?> get props => [];
}

class ContentLikeStatusChanged extends ContentState {
  final String id;
  final String type;
  final bool isLiked;

  const ContentLikeStatusChanged({
    required this.id,
    required this.type,
    required this.isLiked,
  });

  @override
  List<Object> get props => [id, type, isLiked];
}

class ContentPlaybackStarted extends ContentState {
  final Track track;

  const ContentPlaybackStarted(this.track);

  @override
  List<Object> get props => [track];
}

// Enhanced states from legacy
class ContentTopTracksLoaded extends ContentState {
  final List<Track> tracks;

  const ContentTopTracksLoaded({required this.tracks});

  @override
  List<Object> get props => [tracks];
}

class ContentTopArtistsLoaded extends ContentState {
  final List<Artist> artists;

  const ContentTopArtistsLoaded({required this.artists});

  @override
  List<Object> get props => [artists];
}

class ContentTopGenresLoaded extends ContentState {
  final List<Genre> genres;

  const ContentTopGenresLoaded({required this.genres});

  @override
  List<Object> get props => [genres];
}

class ContentLikedTracksLoaded extends ContentState {
  final List<Track> tracks;

  const ContentLikedTracksLoaded({required this.tracks});

  @override
  List<Object> get props => [tracks];
}

class ContentLikedArtistsLoaded extends ContentState {
  final List<Artist> artists;

  const ContentLikedArtistsLoaded({required this.artists});

  @override
  List<Object> get props => [artists];
}

class ContentLikedGenresLoaded extends ContentState {
  final List<Genre> genres;

  const ContentLikedGenresLoaded({required this.genres});

  @override
  List<Object> get props => [genres];
}

class ContentLikedAlbumsLoaded extends ContentState {
  final List<Album> albums;

  const ContentLikedAlbumsLoaded({required this.albums});

  @override
  List<Object> get props => [albums];
}

// Tracking states
class ContentPlayedTracksLoaded extends ContentState {
  final List<Track> tracks;

  const ContentPlayedTracksLoaded({required this.tracks});

  @override
  List<Object> get props => [tracks];
}

class ContentPlayedTracksWithLocationLoaded extends ContentState {
  final List<Track> tracks;

  const ContentPlayedTracksWithLocationLoaded({required this.tracks});

  @override
  List<Object> get props => [tracks];
}

class ContentTrackSaved extends ContentState {
  final String trackId;

  const ContentTrackSaved({required this.trackId});

  @override
  List<Object> get props => [trackId];
}

class ContentTrackLocationSaved extends ContentState {
  final String trackId;
  final double latitude;
  final double longitude;

  const ContentTrackLocationSaved({
    required this.trackId,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object> get props => [trackId, latitude, longitude];
}
