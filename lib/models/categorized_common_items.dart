import 'common_track.dart';
import 'common_artist.dart';
import 'common_album.dart';
import 'common_genre.dart';
import 'common_anime.dart';
import 'common_manga.dart';

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
      topTracks: (json['top_tracks'] as List)
          .map((e) => CommonTrack.fromJson(e))
          .toList(),
      topArtists: (json['top_artists'] as List)
          .map((e) => CommonArtist.fromJson(e))
          .toList(),
      topGenres: (json['top_genres'] as List)
          .map((e) => CommonGenre.fromJson(e))
          .toList(),
      likedAlbums: (json['liked_albums'] as List)
          .map((e) => CommonAlbum.fromJson(e))
          .toList(),
      likedTracks: (json['liked_tracks'] as List)
          .map((e) => CommonTrack.fromJson(e))
          .toList(),
      likedArtists: (json['liked_artists'] as List)
          .map((e) => CommonArtist.fromJson(e))
          .toList(),
      likedGenres: (json['liked_genres'] as List)
          .map((e) => CommonGenre.fromJson(e))
          .toList(),
      playedTracks: (json['played_tracks'] as List)
          .map((e) => CommonTrack.fromJson(e))
          .toList(),
      topAnime: (json['top_anime'] as List)
          .map((e) => CommonAnime.fromJson(e))
          .toList(),
      topManga: (json['top_manga'] as List)
          .map((e) => CommonManga.fromJson(e))
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
}
