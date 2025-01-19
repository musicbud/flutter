import 'package:equatable/equatable.dart';
import 'package:musicbud_flutter/domain/models/common_track.dart';
import 'package:musicbud_flutter/domain/models/common_artist.dart';
import 'package:musicbud_flutter/domain/models/common_album.dart';
import 'package:musicbud_flutter/domain/models/common_genre.dart';
import 'package:musicbud_flutter/domain/models/common_anime.dart';
import 'package:musicbud_flutter/domain/models/common_manga.dart';

/// A model class representing categorized common items between users
class CategorizedCommonItems extends Equatable {
  final List<CommonTrack> tracks;
  final List<CommonArtist> artists;
  final List<CommonGenre> genres;
  final List<CommonAlbum> albums;
  final List<CommonAnime> anime;
  final List<CommonManga> manga;

  const CategorizedCommonItems({
    this.tracks = const [],
    this.artists = const [],
    this.genres = const [],
    this.albums = const [],
    this.anime = const [],
    this.manga = const [],
  });

  /// Creates a [CategorizedCommonItems] from a JSON map
  factory CategorizedCommonItems.fromJson(Map<String, dynamic> json) {
    return CategorizedCommonItems(
      tracks: (json['tracks'] as List<dynamic>?)
              ?.map((e) => CommonTrack.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      artists: (json['artists'] as List<dynamic>?)
              ?.map((e) => CommonArtist.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => CommonGenre.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      albums: (json['albums'] as List<dynamic>?)
              ?.map((e) => CommonAlbum.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      anime: (json['anime'] as List<dynamic>?)
              ?.map((e) => CommonAnime.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      manga: (json['manga'] as List<dynamic>?)
              ?.map((e) => CommonManga.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Converts this [CategorizedCommonItems] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'tracks': tracks.map((e) => e.toJson()).toList(),
      'artists': artists.map((e) => e.toJson()).toList(),
      'genres': genres.map((e) => e.toJson()).toList(),
      'albums': albums.map((e) => e.toJson()).toList(),
      'anime': anime.map((e) => e.toJson()).toList(),
      'manga': manga.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [tracks, artists, genres, albums, anime, manga];
}
