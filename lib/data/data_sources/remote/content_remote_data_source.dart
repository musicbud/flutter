import 'package:dio/dio.dart';
import '../../../core/error/exceptions.dart';
import '../../network/dio_client.dart';
import '../../../domain/models/common_track.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_album.dart';
import '../../../domain/models/common_genre.dart';
import '../../../domain/models/common_anime.dart';
import '../../../domain/models/common_manga.dart';

abstract class ContentRemoteDataSource {
  // Home page
  Future<Map<String, dynamic>> getHomePageData();

  // Popular content
  Future<List<CommonTrack>> getPopularMusic({int limit = 20});
  Future<List<CommonAnime>> getPopularAnime({int limit = 20});
  Future<List<CommonManga>> getPopularManga({int limit = 20});

  // Popular content (missing methods)
  Future<List<CommonTrack>> getPopularTracks({int limit = 20});
  Future<List<CommonArtist>> getPopularArtists({int limit = 20});
  Future<List<CommonAlbum>> getPopularAlbums({int limit = 20});

  // Top content
  Future<List<CommonTrack>> getTopTracks();
  Future<List<CommonArtist>> getTopArtists();
  Future<List<CommonGenre>> getTopGenres();

  // Liked content
  Future<List<CommonTrack>> getLikedTracks();
  Future<List<CommonArtist>> getLikedArtists();
  Future<List<CommonAlbum>> getLikedAlbums();
  Future<List<CommonGenre>> getLikedGenres();

  // Played content
  Future<List<CommonTrack>> getPlayedTracks();
  Future<List<CommonTrack>> getPlayedTracksWithLocation();
  Future<List<CommonTrack>> getCurrentlyPlayedTracks();

  // Like/Unlike operations
  Future<void> like(String type, String id);
  Future<void> unlike(String type, String id);

  // Specific like/unlike methods
  Future<void> likeTrack(String trackId);
  Future<void> unlikeTrack(String trackId);
  Future<void> likeArtist(String artistId);
  Future<void> unlikeArtist(String artistId);
  Future<void> likeAlbum(String albumId);
  Future<void> unlikeAlbum(String albumId);
  Future<void> likeGenre(String genreId);
  Future<void> unlikeGenre(String genreId);
  Future<void> likeAnime(String animeId);
  Future<void> unlikeAnime(String animeId);
  Future<void> likeManga(String mangaId);
  Future<void> unlikeManga(String mangaId);

  // Toggle like methods (missing methods)
  Future<void> toggleTrackLike(String trackId);
  Future<void> toggleArtistLike(String artistId);
  Future<void> toggleAlbumLike(String albumId);
  Future<void> toggleGenreLike(String genreId);
  Future<void> toggleAnimeLike(String animeId);
  Future<void> toggleMangaLike(String mangaId);

  // Update likes method (missing method)
  Future<void> updateLikes(String type, String id, bool isLiked);

  // Search operations
  Future<List<CommonTrack>> searchTracks(String query);
  Future<List<CommonArtist>> searchArtists(String query);
  Future<List<CommonAlbum>> searchAlbums(String query);
  Future<List<CommonGenre>> searchGenres(String query);
  Future<List<CommonAnime>> searchAnime(String query);
  Future<List<CommonManga>> searchManga(String query);

  // Detail methods
  Future<CommonTrack> getTrackDetails(String trackId);
  Future<CommonArtist> getArtistDetails(String artistId);
  Future<CommonAlbum> getAlbumDetails(String albumId);
  Future<CommonGenre> getGenreDetails(String genreId);
  Future<CommonAnime> getAnimeDetails(String animeId);
  Future<CommonManga> getMangaDetails(String mangaId);

  // Playback operations
  Future<List<Map<String, dynamic>>> getSpotifyDevices();
  Future<void> playTrackOnSpotify(String trackId, String deviceId);
  Future<void> savePlayedTrack(
      String trackId, double latitude, double longitude);
}

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  final DioClient _dioClient;

  ContentRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<Map<String, dynamic>> getHomePageData() async {
    try {
      final response = await _dioClient.get('/home');
      return response.data;
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get home page data');
    }
  }

  @override
  Future<List<CommonTrack>> getPopularMusic({int limit = 20}) async {
    try {
      final response = await _dioClient
          .get('/popular/music', queryParameters: {'limit': limit});
      return (response.data as List)
          .map((track) => CommonTrack.fromJson(track))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular music');
    }
  }

  @override
  Future<List<CommonAnime>> getPopularAnime({int limit = 20}) async {
    try {
      final response = await _dioClient
          .get('/popular/anime', queryParameters: {'limit': limit});
      return (response.data as List)
          .map((anime) => CommonAnime.fromJson(anime))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular anime');
    }
  }

  @override
  Future<List<CommonManga>> getPopularManga({int limit = 20}) async {
    try {
      final response = await _dioClient
          .get('/popular/manga', queryParameters: {'limit': limit});
      return (response.data as List)
          .map((manga) => CommonManga.fromJson(manga))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular manga');
    }
  }

  @override
  Future<List<CommonTrack>> getPopularTracks({int limit = 20}) async {
    try {
      final response = await _dioClient
          .get('/popular/tracks', queryParameters: {'limit': limit});
      return (response.data as List)
          .map((track) => CommonTrack.fromJson(track))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getPopularArtists({int limit = 20}) async {
    try {
      final response = await _dioClient
          .get('/popular/artists', queryParameters: {'limit': limit});
      return (response.data as List)
          .map((artist) => CommonArtist.fromJson(artist))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular artists');
    }
  }

  @override
  Future<List<CommonAlbum>> getPopularAlbums({int limit = 20}) async {
    try {
      final response = await _dioClient
          .get('/popular/albums', queryParameters: {'limit': limit});
      return (response.data as List)
          .map((album) => CommonAlbum.fromJson(album))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get popular albums');
    }
  }

  @override
  Future<List<CommonTrack>> getTopTracks() async {
    try {
      final response = await _dioClient.get('/top/tracks');
      return (response.data as List)
          .map((track) => CommonTrack.fromJson(track))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getTopArtists() async {
    try {
      final response = await _dioClient.get('/top/artists');
      return (response.data as List)
          .map((artist) => CommonArtist.fromJson(artist))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top artists');
    }
  }

  @override
  Future<List<CommonGenre>> getTopGenres() async {
    try {
      final response = await _dioClient.get('/top/genres');
      return (response.data as List)
          .map((genre) => CommonGenre.fromJson(genre))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get top genres');
    }
  }

  @override
  Future<List<CommonTrack>> getLikedTracks() async {
    try {
      final response = await _dioClient.get('/liked/tracks');
      return (response.data as List)
          .map((track) => CommonTrack.fromJson(track))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked tracks');
    }
  }

  @override
  Future<List<CommonArtist>> getLikedArtists() async {
    try {
      final response = await _dioClient.get('/liked/artists');
      return (response.data as List)
          .map((artist) => CommonArtist.fromJson(artist))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get liked artists');
    }
  }

  @override
  Future<List<CommonAlbum>> getLikedAlbums() async {
    try {
      final response = await _dioClient.get('/liked/albums');
      return (response.data as List)
          .map((album) => CommonAlbum.fromJson(album))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked albums');
    }
  }

  @override
  Future<List<CommonGenre>> getLikedGenres() async {
    try {
      final response = await _dioClient.get('/liked/genres');
      return (response.data as List)
          .map((genre) => CommonGenre.fromJson(genre))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get liked genres');
    }
  }

  @override
  Future<List<CommonTrack>> getPlayedTracks() async {
    try {
      final response = await _dioClient.get('/played/tracks');
      return (response.data as List)
          .map((track) => CommonTrack.fromJson(track))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get played tracks');
    }
  }

  @override
  Future<List<CommonTrack>> getPlayedTracksWithLocation() async {
    try {
      final response =
          await _dioClient.get('/spotify/played-tracks-with-location');
      return (response.data as List)
          .map((track) => CommonTrack.fromJson(track))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get played tracks with location');
    }
  }

  @override
  Future<List<CommonTrack>> getCurrentlyPlayedTracks() async {
    try {
      final response = await _dioClient.get('/played/tracks/current');
      return (response.data as List)
          .map((track) => CommonTrack.fromJson(track))
          .toList();
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get currently played tracks');
    }
  }

  @override
  Future<void> like(String type, String id) async {
    try {
      await _dioClient.post('/like', data: {
        'type': type,
        'id': id,
      });
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to like item');
    }
  }

  @override
  Future<void> unlike(String type, String id) async {
    try {
      await _dioClient.post('/unlike', data: {
        'type': type,
        'id': id,
      });
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to unlike item');
    }
  }

  @override
  Future<void> likeTrack(String trackId) async {
    try {
      await _dioClient.post('/like/track', data: {'track_id': trackId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to like track');
    }
  }

  @override
  Future<void> unlikeTrack(String trackId) async {
    try {
      await _dioClient.post('/unlike/track', data: {'track_id': trackId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to unlike track');
    }
  }

  @override
  Future<void> likeArtist(String artistId) async {
    try {
      await _dioClient.post('/like/artist', data: {'artist_id': artistId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to like artist');
    }
  }

  @override
  Future<void> unlikeArtist(String artistId) async {
    try {
      await _dioClient.post('/unlike/artist', data: {'artist_id': artistId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to unlike artist');
    }
  }

  @override
  Future<void> likeAlbum(String albumId) async {
    try {
      await _dioClient.post('/like/album', data: {'album_id': albumId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to like album');
    }
  }

  @override
  Future<void> unlikeAlbum(String albumId) async {
    try {
      await _dioClient.post('/unlike/album', data: {'album_id': albumId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to unlike album');
    }
  }

  @override
  Future<void> likeGenre(String genreId) async {
    try {
      await _dioClient.post('/like/genre', data: {'genre_id': genreId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to like genre');
    }
  }

  @override
  Future<void> unlikeGenre(String genreId) async {
    try {
      await _dioClient.post('/unlike/genre', data: {'genre_id': genreId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to unlike genre');
    }
  }

  @override
  Future<void> likeAnime(String animeId) async {
    try {
      await _dioClient.post('/like/anime', data: {'anime_id': animeId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to like anime');
    }
  }

  @override
  Future<void> unlikeAnime(String animeId) async {
    try {
      await _dioClient.post('/unlike/anime', data: {'anime_id': animeId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to unlike anime');
    }
  }

  @override
  Future<void> likeManga(String mangaId) async {
    try {
      await _dioClient.post('/like/manga', data: {'manga_id': mangaId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to like manga');
    }
  }

  @override
  Future<void> unlikeManga(String mangaId) async {
    try {
      await _dioClient.post('/unlike/manga', data: {'manga_id': mangaId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to unlike manga');
    }
  }

  @override
  Future<void> toggleTrackLike(String trackId) async {
    try {
      await _dioClient.post('/toggle/track/like', data: {'track_id': trackId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to toggle track like');
    }
  }

  @override
  Future<void> toggleArtistLike(String artistId) async {
    try {
      await _dioClient.post('/toggle/artist/like', data: {'artist_id': artistId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to toggle artist like');
    }
  }

  @override
  Future<void> toggleAlbumLike(String albumId) async {
    try {
      await _dioClient.post('/toggle/album/like', data: {'album_id': albumId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to toggle album like');
    }
  }

  @override
  Future<void> toggleGenreLike(String genreId) async {
    try {
      await _dioClient.post('/toggle/genre/like', data: {'genre_id': genreId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to toggle genre like');
    }
  }

  @override
  Future<void> toggleAnimeLike(String animeId) async {
    try {
      await _dioClient.post('/toggle/anime/like', data: {'anime_id': animeId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to toggle anime like');
    }
  }

  @override
  Future<void> toggleMangaLike(String mangaId) async {
    try {
      await _dioClient.post('/toggle/manga/like', data: {'manga_id': mangaId});
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to toggle manga like');
    }
  }

  @override
  Future<void> updateLikes(String type, String id, bool isLiked) async {
    try {
      await _dioClient.post('/update/likes', data: {
        'type': type,
        'id': id,
        'is_liked': isLiked,
      });
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to update likes');
    }
  }

  @override
  Future<List<CommonTrack>> searchTracks(String query) async {
    try {
      final response =
          await _dioClient.get('/search/tracks', queryParameters: {'q': query});
      return (response.data as List)
          .map((track) => CommonTrack.fromJson(track))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to search tracks');
    }
  }

  @override
  Future<List<CommonArtist>> searchArtists(String query) async {
    try {
      final response = await _dioClient
          .get('/search/artists', queryParameters: {'q': query});
      return (response.data as List)
          .map((artist) => CommonArtist.fromJson(artist))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to search artists');
    }
  }

  @override
  Future<List<CommonAlbum>> searchAlbums(String query) async {
    try {
      final response =
          await _dioClient.get('/search/albums', queryParameters: {'q': query});
      return (response.data as List)
          .map((album) => CommonAlbum.fromJson(album))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to search albums');
    }
  }

  @override
  Future<List<CommonGenre>> searchGenres(String query) async {
    try {
      final response =
          await _dioClient.get('/search/genres', queryParameters: {'q': query});
      return (response.data as List)
          .map((genre) => CommonGenre.fromJson(genre))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to search genres');
    }
  }

  @override
  Future<List<CommonAnime>> searchAnime(String query) async {
    try {
      final response =
          await _dioClient.get('/search/anime', queryParameters: {'q': query});
      return (response.data as List)
          .map((anime) => CommonAnime.fromJson(anime))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to search anime');
    }
  }

  @override
  Future<List<CommonManga>> searchManga(String query) async {
    try {
      final response =
          await _dioClient.get('/search/manga', queryParameters: {'q': query});
      return (response.data as List)
          .map((manga) => CommonManga.fromJson(manga))
          .toList();
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to search manga');
    }
  }

  @override
  Future<CommonTrack> getTrackDetails(String trackId) async {
    try {
      final response = await _dioClient.get('/tracks/$trackId');
      return CommonTrack.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get track details');
    }
  }

  @override
  Future<CommonArtist> getArtistDetails(String artistId) async {
    try {
      final response = await _dioClient.get('/artists/$artistId');
      return CommonArtist.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get artist details');
    }
  }

  @override
  Future<CommonAlbum> getAlbumDetails(String albumId) async {
    try {
      final response = await _dioClient.get('/albums/$albumId');
      return CommonAlbum.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get album details');
    }
  }

  @override
  Future<CommonGenre> getGenreDetails(String genreId) async {
    try {
      final response = await _dioClient.get('/genres/$genreId');
      return CommonGenre.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get genre details');
    }
  }

  @override
  Future<CommonAnime> getAnimeDetails(String animeId) async {
    try {
      final response = await _dioClient.get('/anime/$animeId');
      return CommonAnime.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get anime details');
    }
  }

  @override
  Future<CommonManga> getMangaDetails(String mangaId) async {
    try {
      final response = await _dioClient.get('/manga/$mangaId');
      return CommonManga.fromJson(response.data);
    } on DioException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to get manga details');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getSpotifyDevices() async {
    try {
      final response = await _dioClient.get('/spotify/devices');
      return List<Map<String, dynamic>>.from(response.data['devices']);
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to get Spotify devices');
    }
  }

  @override
  Future<void> playTrackOnSpotify(String trackId, String deviceId) async {
    try {
      await _dioClient.post('/spotify/play', data: {
        'track_id': trackId,
        'device_id': deviceId,
      });
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to play track on Spotify');
    }
  }

  @override
  Future<void> savePlayedTrack(
      String trackId, double latitude, double longitude) async {
    try {
      await _dioClient.post('/played/tracks', data: {
        'track_id': trackId,
        'latitude': latitude,
        'longitude': longitude,
      });
    } on DioException catch (e) {
      throw ServerException(
          message: e.message ?? 'Failed to save played track');
    }
  }
}
