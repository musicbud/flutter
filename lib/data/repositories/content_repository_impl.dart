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

class ContentRepositoryImpl implements ContentRepository {
  final ContentRemoteDataSource _remoteDataSource;
  final DioClient _dioClient;

  ContentRepositoryImpl(
      {required ContentRemoteDataSource remoteDataSource,
      required DioClient dioClient})
      : _remoteDataSource = remoteDataSource,
        _dioClient = dioClient;

  @override
  Future<List<Track>> getPlayedTracks() async {
    final response = await _dioClient.get('/tracks/played');
    return (response.data as List).map((json) => Track.fromJson(json)).toList();
  }

  @override
  Future<List<Track>> getPlayedTracksWithLocation() async {
    final response = await _dioClient.get('/tracks/played/location');
    return (response.data as List).map((json) => Track.fromJson(json)).toList();
  }

  @override
  Future<List<SpotifyDevice>> getSpotifyDevices() async {
    final response = await _dioClient.get('/spotify/devices');
    return (response.data as List)
        .map((json) => SpotifyDevice.fromJson(json))
        .toList();
  }

  @override
  Future<void> controlSpotifyPlayback(String command, String deviceId) async {
    await _dioClient.post('/spotify/playback/$command', data: {
      'device_id': deviceId,
    });
  }

  @override
  Future<void> setSpotifyVolume(String deviceId, int volume) async {
    await _dioClient.put('/spotify/volume', data: {
      'device_id': deviceId,
      'volume': volume,
    });
  }

  @override
  Future<void> saveTrackLocation(
      String trackId, double latitude, double longitude) async {
    await _dioClient.post('/tracks/$trackId/location', data: {
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  @override
  Future<void> playTrack(String trackId, String deviceId) async {
    await _dioClient.post('/spotify/play', data: {
      'track_id': trackId,
      'device_id': deviceId,
    });
  }

  @override
  Future<void> playTrackWithLocation(String trackId, String deviceId,
      double latitude, double longitude) async {
    await _dioClient.post('/spotify/play', data: {
      'track_id': trackId,
      'device_id': deviceId,
      'latitude': latitude,
      'longitude': longitude,
    });
  }

  @override
  Future<void> savePlayedTrack(String trackId) async {
    await _dioClient.post('/tracks/$trackId/played');
  }

  @override
  Future<List<CommonTrack>> getTopTracks() async {
    final response = await _dioClient.get('/tracks/top');
    return (response.data as List)
        .map((json) => CommonTrack.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonArtist>> getTopArtists() async {
    final response = await _dioClient.get('/artists/top');
    return (response.data as List)
        .map((json) => CommonArtist.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonGenre>> getTopGenres() async {
    final response = await _dioClient.get('/genres/top');
    return (response.data as List)
        .map((json) => CommonGenre.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonAnime>> getTopAnime() async {
    final response = await _dioClient.get('/anime/top');
    return (response.data as List)
        .map((json) => CommonAnime.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonManga>> getTopManga() async {
    final response = await _dioClient.get('/manga/top');
    return (response.data as List)
        .map((json) => CommonManga.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonTrack>> getLikedTracks() async {
    return await _remoteDataSource.getLikedTracks();
  }

  @override
  Future<List<CommonArtist>> getLikedArtists() async {
    return await _remoteDataSource.getLikedArtists();
  }

  @override
  Future<List<CommonAlbum>> getLikedAlbums() async {
    return await _remoteDataSource.getLikedAlbums();
  }

  @override
  Future<List<CommonGenre>> getLikedGenres() async {
    return await _remoteDataSource.getLikedGenres();
  }

  @override
  Future<void> likeTrack(String trackId) async {
    await _remoteDataSource.likeTrack(trackId);
  }

  @override
  Future<void> unlikeTrack(String trackId) async {
    await _remoteDataSource.unlikeTrack(trackId);
  }

  @override
  Future<void> likeArtist(String artistId) async {
    await _remoteDataSource.likeArtist(artistId);
  }

  @override
  Future<void> unlikeArtist(String artistId) async {
    await _remoteDataSource.unlikeArtist(artistId);
  }

  @override
  Future<void> likeAlbum(String albumId) async {
    await _remoteDataSource.likeAlbum(albumId);
  }

  @override
  Future<void> unlikeAlbum(String albumId) async {
    await _remoteDataSource.unlikeAlbum(albumId);
  }

  @override
  Future<void> likeGenre(String genreId) async {
    await _remoteDataSource.likeGenre(genreId);
  }

  @override
  Future<void> unlikeGenre(String genreId) async {
    await _remoteDataSource.unlikeGenre(genreId);
  }

  @override
  Future<void> likeAnime(String animeId) async {
    await _remoteDataSource.likeAnime(animeId);
  }

  @override
  Future<void> unlikeAnime(String animeId) async {
    await _remoteDataSource.unlikeAnime(animeId);
  }

  @override
  Future<void> likeManga(String mangaId) async {
    await _remoteDataSource.likeManga(mangaId);
  }

  @override
  Future<void> unlikeManga(String mangaId) async {
    await _remoteDataSource.unlikeManga(mangaId);
  }

  @override
  Future<List<CommonTrack>> searchTracks(String query) async {
    return await _remoteDataSource.searchTracks(query);
  }

  @override
  Future<List<CommonArtist>> searchArtists(String query) async {
    return await _remoteDataSource.searchArtists(query);
  }

  @override
  Future<List<CommonAlbum>> searchAlbums(String query) async {
    return await _remoteDataSource.searchAlbums(query);
  }

  @override
  Future<List<CommonGenre>> searchGenres(String query) async {
    return await _remoteDataSource.searchGenres(query);
  }

  @override
  Future<List<CommonAnime>> searchAnime(String query) async {
    return await _remoteDataSource.searchAnime(query);
  }

  @override
  Future<List<CommonManga>> searchManga(String query) async {
    return await _remoteDataSource.searchManga(query);
  }

  @override
  Future<CommonTrack> getTrackDetails(String trackId) async {
    return await _remoteDataSource.getTrackDetails(trackId);
  }

  @override
  Future<CommonArtist> getArtistDetails(String artistId) async {
    return await _remoteDataSource.getArtistDetails(artistId);
  }

  @override
  Future<CommonAlbum> getAlbumDetails(String albumId) async {
    return await _remoteDataSource.getAlbumDetails(albumId);
  }

  @override
  Future<CommonGenre> getGenreDetails(String genreId) async {
    return await _remoteDataSource.getGenreDetails(genreId);
  }

  @override
  Future<CommonAnime> getAnimeDetails(String animeId) async {
    return await _remoteDataSource.getAnimeDetails(animeId);
  }

  @override
  Future<CommonManga> getMangaDetails(String mangaId) async {
    return await _remoteDataSource.getMangaDetails(mangaId);
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
    return await _remoteDataSource.getPopularTracks();
  }

  @override
  Future<List<CommonArtist>> getPopularArtists() async {
    return await _remoteDataSource.getPopularArtists();
  }

  @override
  Future<List<CommonAlbum>> getPopularAlbums() async {
    return await _remoteDataSource.getPopularAlbums();
  }

  @override
  Future<List<CommonAnime>> getPopularAnime() async {
    return await _remoteDataSource.getPopularAnime();
  }

  @override
  Future<List<CommonManga>> getPopularManga() async {
    return await _remoteDataSource.getPopularManga();
  }

  @override
  Future<void> toggleTrackLike(String trackId) async {
    await _remoteDataSource.toggleTrackLike(trackId);
  }

  @override
  Future<void> toggleArtistLike(String artistId) async {
    await _remoteDataSource.toggleArtistLike(artistId);
  }

  @override
  Future<void> toggleAlbumLike(String albumId) async {
    await _remoteDataSource.toggleAlbumLike(albumId);
  }

  @override
  Future<void> toggleGenreLike(String genreId) async {
    await _remoteDataSource.toggleGenreLike(genreId);
  }

  @override
  Future<void> toggleAnimeLike(String animeId) async {
    await _remoteDataSource.toggleAnimeLike(animeId);
  }

  @override
  Future<void> toggleMangaLike(String mangaId) async {
    await _remoteDataSource.toggleMangaLike(mangaId);
  }

  @override
  Future<void> updateLikes() async {
    await _remoteDataSource.updateLikes();
  }
}
