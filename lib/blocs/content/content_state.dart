import 'package:equatable/equatable.dart';
import '../../domain/models/common_track.dart';
import '../../domain/models/common_artist.dart';
import '../../domain/models/common_album.dart';
import '../../domain/models/common_genre.dart';
import '../../domain/models/common_anime.dart';
import '../../domain/models/common_manga.dart';

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object?> get props => [];
}

class ContentInitial extends ContentState {}

class ContentLoading extends ContentState {}

class ContentLoaded extends ContentState {
  final List<CommonTrack> topTracks;
  final List<CommonArtist> topArtists;
  final List<CommonGenre> topGenres;
  final List<CommonAlbum> topAlbums;
  final List<CommonAnime> topAnime;
  final List<CommonManga> topManga;
  final List<CommonTrack> playedTracks;

  const ContentLoaded({
    this.topTracks = const [],
    this.topArtists = const [],
    this.topGenres = const [],
    this.topAlbums = const [],
    this.topAnime = const [],
    this.topManga = const [],
    this.playedTracks = const [],
  });

  @override
  List<Object> get props => [
        topTracks,
        topArtists,
        topGenres,
        topAlbums,
        topAnime,
        topManga,
        playedTracks,
      ];

  ContentLoaded copyWith({
    List<CommonTrack>? topTracks,
    List<CommonArtist>? topArtists,
    List<CommonGenre>? topGenres,
    List<CommonAlbum>? topAlbums,
    List<CommonAnime>? topAnime,
    List<CommonManga>? topManga,
    List<CommonTrack>? playedTracks,
  }) {
    return ContentLoaded(
      topTracks: topTracks ?? this.topTracks,
      topArtists: topArtists ?? this.topArtists,
      topGenres: topGenres ?? this.topGenres,
      topAlbums: topAlbums ?? this.topAlbums,
      topAnime: topAnime ?? this.topAnime,
      topManga: topManga ?? this.topManga,
      playedTracks: playedTracks ?? this.playedTracks,
    );
  }
}

class ContentFailure extends ContentState {
  final String error;

  const ContentFailure(this.error);

  @override
  List<Object> get props => [error];
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
  final CommonTrack track;

  const ContentPlaybackStarted(this.track);

  @override
  List<Object> get props => [track];
}
