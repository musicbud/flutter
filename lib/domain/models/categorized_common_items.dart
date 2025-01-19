import 'package:musicbud_flutter/domain/models/common_track.dart';
import 'package:musicbud_flutter/domain/models/common_artist.dart';
import 'package:musicbud_flutter/domain/models/common_album.dart';
import 'package:musicbud_flutter/domain/models/common_genre.dart';
import 'package:musicbud_flutter/domain/models/common_anime.dart';
import 'package:musicbud_flutter/domain/models/common_manga.dart';

class CategorizedCommonItems {
  final List<CommonTrack>? topTracks;
  final List<CommonArtist>? topArtists;
  final List<CommonGenre>? topGenres;
  final List<CommonAlbum>? likedAlbums;
  final List<CommonTrack>? likedTracks;
  final List<CommonArtist>? likedArtists;
  final List<CommonGenre>? likedGenres;
  final List<CommonTrack>? playedTracks;
  final List<CommonAnime>? topAnime;
  final List<CommonManga>? topManga;

  CategorizedCommonItems({
    this.topTracks,
    this.topArtists,
    this.topGenres,
    this.likedAlbums,
    this.likedTracks,
    this.likedArtists,
    this.likedGenres,
    this.playedTracks,
    this.topAnime,
    this.topManga,
  });

  factory CategorizedCommonItems.fromJson(Map<String, dynamic> json) {
    return CategorizedCommonItems(
      topTracks: (json['top_tracks'] as List<dynamic>?)
          ?.map((e) => CommonTrack.fromJson(e as Map<String, dynamic>))
          .toList(),
      topArtists: (json['top_artists'] as List<dynamic>?)
          ?.map((e) => CommonArtist.fromJson(e as Map<String, dynamic>))
          .toList(),
      topGenres: (json['top_genres'] as List<dynamic>?)
          ?.map((e) => CommonGenre.fromJson(e as Map<String, dynamic>))
          .toList(),
      likedAlbums: (json['liked_albums'] as List<dynamic>?)
          ?.map((e) => CommonAlbum.fromJson(e as Map<String, dynamic>))
          .toList(),
      likedTracks: (json['liked_tracks'] as List<dynamic>?)
          ?.map((e) => CommonTrack.fromJson(e as Map<String, dynamic>))
          .toList(),
      likedArtists: (json['liked_artists'] as List<dynamic>?)
          ?.map((e) => CommonArtist.fromJson(e as Map<String, dynamic>))
          .toList(),
      likedGenres: (json['liked_genres'] as List<dynamic>?)
          ?.map((e) => CommonGenre.fromJson(e as Map<String, dynamic>))
          .toList(),
      playedTracks: (json['played_tracks'] as List<dynamic>?)
          ?.map((e) => CommonTrack.fromJson(e as Map<String, dynamic>))
          .toList(),
      topAnime: (json['top_anime'] as List<dynamic>?)
          ?.map((e) => CommonAnime.fromJson(e as Map<String, dynamic>))
          .toList(),
      topManga: (json['top_manga'] as List<dynamic>?)
          ?.map((e) => CommonManga.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'top_tracks': topTracks?.map((e) => e.toJson()).toList(),
      'top_artists': topArtists?.map((e) => e.toJson()).toList(),
      'top_genres': topGenres?.map((e) => e.toJson()).toList(),
      'liked_albums': likedAlbums?.map((e) => e.toJson()).toList(),
      'liked_tracks': likedTracks?.map((e) => e.toJson()).toList(),
      'liked_artists': likedArtists?.map((e) => e.toJson()).toList(),
      'liked_genres': likedGenres?.map((e) => e.toJson()).toList(),
      'played_tracks': playedTracks?.map((e) => e.toJson()).toList(),
      'top_anime': topAnime?.map((e) => e.toJson()).toList(),
      'top_manga': topManga?.map((e) => e.toJson()).toList(),
    };
  }

  CategorizedCommonItems copyWith({
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
  }) {
    return CategorizedCommonItems(
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
