import '../../domain/models/common_track.dart';
import '../../domain/models/spotify_device.dart';
import '../../domain/models/common_artist.dart';
import '../../domain/models/common_genre.dart';
import '../../domain/models/common_album.dart';
import '../../domain/models/common_anime.dart';
import '../../domain/models/common_manga.dart';
import '../../domain/repositories/content_repository.dart';
import '../data_sources/remote/reference/content_remote_data_source.dart';
import '../../domain/models/track.dart';
import '../network/dio_client.dart';
import '../data_sources/remote/reference/user_remote_data_source.dart';

class ContentRepositoryImpl implements ContentRepository {
  final DioClient dioClient;
  final ContentRemoteDataSource remoteDataSource;

  ContentRepositoryImpl({
    required this.dioClient,
    required this.remoteDataSource,
  });

  @override
  Future<List<Track>> getPlayedTracks() async {
    final response = await dioClient.get('/tracks/played');
    return (response.data as List).map((json) => Track.fromJson(json)).toList();
  }

  @override
  Future<List<Track>> getPlayedTracksWithLocation() async {
    final response = await dioClient.get('/tracks/played/location');
    return (response.data as List).map((json) => Track.fromJson(json)).toList();
  }

  @override
  Future<List<SpotifyDevice>> getSpotifyDevices() async {
    final response = await dioClient.get('/spotify/devices');
    return (response.data as List)
        .map((json) => SpotifyDevice.fromJson(json))
        .toList();
  }

  @override
  Future<void> controlSpotifyPlayback(String command, String deviceId) async {
    await dioClient.post('/spotify/playback/$command', data: {
      'device_id': deviceId,
    });
  }

  @override
  Future<void> setSpotifyVolume(String deviceId, int volume) async {
    await dioClient.put('/spotify/volume', data: {
      'device_id': deviceId,
      'volume': volume,
    });
  }

  @override
  Future<void> saveTrackLocation(
      String trackId, double latitude, double longitude) async {
    await dioClient.post('/tracks/$trackId/location', data: {
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  @override
  Future<void> playTrack(String trackId, String deviceId) async {
    await dioClient.post('/spotify/play', data: {
      'track_id': trackId,
      'device_id': deviceId,
    });
  }

  @override
  Future<void> playTrackWithLocation(String trackId, String deviceId,
      double latitude, double longitude) async {
    await dioClient.post('/spotify/play', data: {
      'track_id': trackId,
      'device_id': deviceId,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  @override
  Future<void> savePlayedTrack(String trackId) async {
    await dioClient.post('/tracks/$trackId/played');
  }

  @override
  Future<List<CommonTrack>> getTopTracks() async {
    final response = await dioClient.get('/tracks/top');
    return (response.data as List)
        .map((json) => CommonTrack.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonArtist>> getTopArtists() async {
    final response = await dioClient.get('/artists/top');
    return (response.data as List)
        .map((json) => CommonArtist.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonGenre>> getTopGenres() async {
    final response = await dioClient.get('/genres/top');
    return (response.data as List)
        .map((json) => CommonGenre.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonAnime>> getTopAnime() async {
    final response = await dioClient.get('/anime/top');
    return (response.data as List)
        .map((json) => CommonAnime.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonManga>> getTopManga() async {
    final response = await dioClient.get('/manga/top');
    return (response.data as List)
        .map((json) => CommonManga.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonTrack>> getLikedTracks() async {
    return await remoteDataSource.getLikedTracks();
  }

  @override
  Future<List<CommonArtist>> getLikedArtists() async {
    return await remoteDataSource.getLikedArtists();
  }

  @override
  Future<List<CommonAlbum>> getLikedAlbums() async {
    return await remoteDataSource.getLikedAlbums();
  }

  @override
  Future<List<CommonGenre>> getLikedGenres() async {
    return await remoteDataSource.getLikedGenres();
  }

  @override
  Future<void> likeTrack(String trackId) async {
    await remoteDataSource.likeTrack(trackId);
  }

  @override
  Future<void> unlikeTrack(String trackId) async {
    await remoteDataSource.unlikeTrack(trackId);
  }

  @override
  Future<void> likeArtist(String artistId) async {
    await remoteDataSource.likeArtist(artistId);
  }

  @override
  Future<void> unlikeArtist(String artistId) async {
    await remoteDataSource.unlikeArtist(artistId);
  }

  @override
  Future<void> likeAlbum(String albumId) async {
    await remoteDataSource.likeAlbum(albumId);
  }

  @override
  Future<void> unlikeAlbum(String albumId) async {
    await remoteDataSource.unlikeAlbum(albumId);
  }

  @override
  Future<void> likeGenre(String genreId) async {
    await remoteDataSource.likeGenre(genreId);
  }

  @override
  Future<void> unlikeGenre(String genreId) async {
    await remoteDataSource.unlikeGenre(genreId);
  }

  @override
  Future<void> likeAnime(String animeId) async {
    await remoteDataSource.likeAnime(animeId);
  }

  @override
  Future<void> unlikeAnime(String animeId) async {
    await remoteDataSource.unlikeAnime(animeId);
  }

  @override
  Future<void> likeManga(String mangaId) async {
    await remoteDataSource.likeManga(mangaId);
  }

  @override
  Future<void> unlikeManga(String mangaId) async {
    await remoteDataSource.unlikeManga(mangaId);
  }

  @override
  Future<List<CommonTrack>> searchTracks(String query) async {
    return await remoteDataSource.searchTracks(query);
  }

  @override
  Future<List<CommonArtist>> searchArtists(String query) async {
    return await remoteDataSource.searchArtists(query);
  }

  @override
  Future<List<CommonAlbum>> searchAlbums(String query) async {
    return await remoteDataSource.searchAlbums(query);
  }

  @override
  Future<List<CommonGenre>> searchGenres(String query) async {
    return await remoteDataSource.searchGenres(query);
  }

  @override
  Future<List<CommonAnime>> searchAnime(String query) async {
    return await remoteDataSource.searchAnime(query);
  }

  @override
  Future<List<CommonManga>> searchManga(String query) async {
    return await remoteDataSource.searchManga(query);
  }

  @override
  Future<CommonTrack> getTrackDetails(String trackId) async {
    return await remoteDataSource.getTrackDetails(trackId);
  }

  @override
  Future<CommonArtist> getArtistDetails(String artistId) async {
    return await remoteDataSource.getArtistDetails(artistId);
  }

  @override
  Future<CommonAlbum> getAlbumDetails(String albumId) async {
    return await remoteDataSource.getAlbumDetails(albumId);
  }

  @override
  Future<CommonGenre> getGenreDetails(String genreId) async {
    return await remoteDataSource.getGenreDetails(genreId);
  }

  @override
  Future<CommonAnime> getAnimeDetails(String animeId) async {
    return await remoteDataSource.getAnimeDetails(animeId);
  }

  @override
  Future<CommonManga> getMangaDetails(String mangaId) async {
    return await remoteDataSource.getMangaDetails(mangaId);
  }

  @override
  Future<List<dynamic>> getTopItems(String category) async {
    switch (category) {
      case 'tracks':
        return await getTopTracks();
      case 'artists':
        return await getTopArtists();
      case 'genres':
        return await getTopGenres();
      case 'anime':
        return await getTopAnime();
      case 'manga':
        return await getTopManga();
      default:
        throw Exception('Invalid category: $category');
    }
  }

  @override
  Future<List<dynamic>> getLikedItems(String category) async {
    switch (category) {
      case 'tracks':
        return await getLikedTracks();
      case 'artists':
        return await getLikedArtists();
      case 'albums':
        return await getLikedAlbums();
      case 'genres':
        return await getLikedGenres();
      default:
        throw Exception('Invalid category: $category');
    }
  }

  @override
  Future<List<CommonTrack>> getPopularTracks() async {
    return await remoteDataSource.getPopularTracks();
  }

  @override
  Future<List<CommonArtist>> getPopularArtists() async {
    return await remoteDataSource.getPopularArtists();
  }

  @override
  Future<List<CommonAlbum>> getPopularAlbums() async {
    return await remoteDataSource.getPopularAlbums();
  }

  @override
  Future<List<CommonAnime>> getPopularAnime() async {
    return await remoteDataSource.getPopularAnime();
  }

  @override
  Future<List<CommonManga>> getPopularManga() async {
    return await remoteDataSource.getPopularManga();
  }

  @override
  Future<void> toggleTrackLike(String trackId) async {
    await remoteDataSource.toggleTrackLike(trackId);
  }

  @override
  Future<void> toggleArtistLike(String artistId) async {
    await remoteDataSource.toggleArtistLike(artistId);
  }

  @override
  Future<void> toggleAlbumLike(String albumId) async {
    await remoteDataSource.toggleAlbumLike(albumId);
  }

  @override
  Future<void> toggleGenreLike(String genreId) async {
    await remoteDataSource.toggleGenreLike(genreId);
  }

  @override
  Future<void> toggleAnimeLike(String animeId) async {
    await remoteDataSource.toggleAnimeLike(animeId);
  }

  @override
  Future<void> toggleMangaLike(String mangaId) async {
    await remoteDataSource.toggleMangaLike(mangaId);
  }

  @override
  Future<void> updateLikes() async {
    await remoteDataSource.updateLikes();
  }
}
