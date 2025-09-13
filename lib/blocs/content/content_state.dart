import 'package:equatable/equatable.dart';
import '../../domain/models/common_track.dart';
import '../../domain/models/common_artist.dart';
import '../../domain/models/common_album.dart';
import '../../domain/models/common_genre.dart';
import '../../domain/models/common_anime.dart';
import '../../domain/models/common_manga.dart';
import '../../domain/models/categorized_common_items.dart';

abstract class ContentState extends Equatable {
  const ContentState();

  @override
  List<Object?> get props => [];
}

class ContentInitial extends ContentState {}

class ContentLoading extends ContentState {
  const ContentLoading();
}

class ContentLoaded extends ContentState {
  final List<CommonTrack> topTracks;
  final List<CommonArtist> topArtists;
  final List<CommonGenre> topGenres;
  final List<CommonAlbum>? likedAlbums;
  final List<CommonTrack>? likedTracks;
  final List<CommonArtist>? likedArtists;
  final List<CommonGenre>? likedGenres;
  final List<CommonTrack>? playedTracks;
  final List<CommonAnime> topAnime;
  final List<CommonManga> topManga;
  final CategorizedCommonItems? categorizedItems;

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
    this.categorizedItems,
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
        categorizedItems,
      ];

  ContentLoaded copyWith({
    List<CommonTrack>? topTracks,
    List<CommonArtist>? topArtists,
    List<CommonGenre>? topGenres,
    List<CommonAlbum>? likedAlbums,
    List<CommonTrack>? likedTracks,
    List<CommonArtist>? likedArtists,
    List<CommonGenre>? likedGenres,
    List<CommonTrack>? playedTracks,
    List<CommonAnime>? topAnime,
    List<CommonManga>? topManga,
    CategorizedCommonItems? categorizedItems,
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
      categorizedItems: categorizedItems ?? this.categorizedItems,
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
  final CommonTrack track;

  const ContentPlaybackStarted(this.track);

  @override
  List<Object> get props => [track];
}
