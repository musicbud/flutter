import '../../domain/repositories/content_repository.dart';
import '../../models/track.dart';
import '../../models/artist.dart';
import '../../models/album.dart';
import '../../models/genre.dart';
import '../../models/common_anime.dart';
import '../../models/common_manga.dart';
import '../data_sources/remote/content_remote_data_source.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';

class ContentRepositoryImpl implements ContentRepository {
  final ContentRemoteDataSource _remoteDataSource;

  ContentRepositoryImpl({required ContentRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  Future<List<Track>> getMyLikedTracks() async {
    try {
      return await _remoteDataSource.getMyLikedTracks();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  Future<List<Artist>> getMyLikedArtists() async {
    try {
      return await _remoteDataSource.getMyLikedArtists();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  Future<List<Genre>> getMyLikedGenres() async {
    try {
      return await _remoteDataSource.getMyLikedGenres();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  Future<List<Album>> getMyLikedAlbums() async {
    try {
      return await _remoteDataSource.getMyLikedAlbums();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  Future<List<Track>> getMyTopTracks() async {
    try {
      return await _remoteDataSource.getMyTopTracks();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  Future<List<Artist>> getMyTopArtists() async {
    try {
      return await _remoteDataSource.getMyTopArtists();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  Future<List<Genre>> getMyTopGenres() async {
    try {
      return await _remoteDataSource.getMyTopGenres();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  Future<List<CommonAnime>> getMyTopAnime() async {
    try {
      final data = await _remoteDataSource.getMyTopAnime();
      return data.map((json) => CommonAnime.fromJson(json)).toList();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  Future<List<CommonManga>> getMyTopManga() async {
    try {
      final data = await _remoteDataSource.getMyTopManga();
      return data.map((json) => CommonManga.fromJson(json)).toList();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  Future<List<Track>> getMyPlayedTracks() async {
    try {
      return await _remoteDataSource.getMyPlayedTracks();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  @override
  Future<void> likeTrack(String trackId) async {
    try {
      await _remoteDataSource.toggleLike(trackId, 'track');
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  @override
  Future<void> likeArtist(String artistId) async {
    try {
      await _remoteDataSource.toggleLike(artistId, 'artist');
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  @override
  Future<void> likeGenre(String genreId) async {
    try {
      await _remoteDataSource.toggleLike(genreId, 'genre');
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  @override
  Future<void> likeAlbum(String albumId) async {
    try {
      await _remoteDataSource.toggleLike(albumId, 'album');
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  @override
  Future<void> likeAnime(String animeId) async {
    // TODO: Implement when ContentRemoteDataSource supports anime
  }


  @override
  Future<void> likeManga(String mangaId) async {
    // TODO: Implement when ContentRemoteDataSource supports manga
  }

  // Placeholder implementations for missing methods

  @override
  Future<List<Track>> getPlayedTracks() async {
    try {
      return await _remoteDataSource.getPlayedTracks();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  @override
  Future<List<Track>> getPlayedTracksWithLocation() async {
    try {
      final data = await _remoteDataSource.getPlayedTracksWithLocation();
      return data.map((json) => Track.fromJson(json)).toList();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }




  @override
  Future<void> controlSpotifyPlayback(String command, String deviceId) async {
    try {
      await _remoteDataSource.controlSpotifyPlayback(command, deviceId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  @override
  Future<void> setSpotifyVolume(String deviceId, int volume) async {
    try {
      await _remoteDataSource.setSpotifyVolume(deviceId, volume);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  @override
  Future<void> saveTrackLocation(String trackId, double latitude, double longitude) async {
    // TODO: Implement actual logic
  }


  @override
  Future<void> playTrack(String trackId, String? deviceId) async {
    try {
      await _remoteDataSource.playTrack(trackId, deviceId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  @override
  Future<void> playTrackWithLocation(String trackId, String trackName, double latitude, double longitude, [String? deviceId]) async {
    try {
      await _remoteDataSource.playTrackWithLocation(trackId, trackName, latitude, longitude, deviceId);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  @override
  Future<void> savePlayedTrack(String trackId) async {
    // TODO: Implement actual logic
  }


  @override
  Future<List<Track>> getPopularTracks() async {
    try {
      return await _remoteDataSource.getPopularTracks();
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }


  @override
  Future<List<Artist>> getPopularArtists() async {
    // TODO: Implement actual logic
    return [];
  }


  @override
  Future<List<Album>> getPopularAlbums() async {
    // TODO: Implement actual logic
    return [];
  }


  @override
  Future<List<CommonAnime>> getPopularAnime() async {
    // TODO: Implement actual logic
    return [];
  }


  @override
  Future<List<CommonManga>> getPopularManga() async {
    // TODO: Implement actual logic
    return [];
  }


  @override
  Future<List<Track>> getTopTracks() async {
    return await getMyTopTracks();
  }


  @override
  Future<List<Artist>> getTopArtists() async {
    return await getMyTopArtists();
  }


  @override
  Future<List<Genre>> getTopGenres() async {
    return await getMyTopGenres();
  }


  @override
  Future<List<CommonAnime>> getTopAnime() async {
    return await getMyTopAnime();
  }


  @override
  Future<List<CommonManga>> getTopManga() async {
    return await getMyTopManga();
  }


  @override
  Future<List<Track>> getLikedTracks() async {
    return await getMyLikedTracks();
  }


  @override
  Future<List<Artist>> getLikedArtists() async {
    return await getMyLikedArtists();
  }


  @override
  Future<List<Genre>> getLikedGenres() async {
    return await getMyLikedGenres();
  }


  @override
  Future<List<Album>> getLikedAlbums() async {
    return await getMyLikedAlbums();
  }


  @override
  Future<void> unlikeTrack(String trackId) async {
    // TODO: Implement actual unlike logic
    await likeTrack(trackId);
  }


  @override
  Future<void> unlikeArtist(String artistId) async {
    // TODO: Implement actual unlike logic
    await likeArtist(artistId);
  }


  @override
  Future<void> unlikeGenre(String genreId) async {
    // TODO: Implement actual unlike logic
    await likeGenre(genreId);
  }


  @override
  Future<void> unlikeAlbum(String albumId) async {
    // TODO: Implement actual unlike logic
    await likeAlbum(albumId);
  }


  @override
  Future<void> unlikeAnime(String animeId) async {
    // TODO: Implement actual unlike logic
    await likeAnime(animeId);
  }


  @override
  Future<void> unlikeManga(String mangaId) async {
    // TODO: Implement actual unlike logic
    await likeManga(mangaId);
  }


  @override
  Future<Track> getTrackDetails(String trackId) async {
    // TODO: Implement actual logic
    throw UnimplementedError();
  }


  @override
  Future<Artist> getArtistDetails(String artistId) async {
    // TODO: Implement actual logic
    throw UnimplementedError();
  }


  @override
  Future<Album> getAlbumDetails(String albumId) async {
    // TODO: Implement actual logic
    throw UnimplementedError();
  }


  @override
  Future<Genre> getGenreDetails(String genreId) async {
    // TODO: Implement actual logic
    throw UnimplementedError();
  }


  @override
  Future<CommonAnime> getAnimeDetails(String animeId) async {
    // TODO: Implement actual logic
    throw UnimplementedError();
  }


  @override
  Future<CommonManga> getMangaDetails(String mangaId) async {
    // TODO: Implement actual logic
    throw UnimplementedError();
  }


  @override
  Future<List<Track>> searchTracks(String query) async {
    // TODO: Implement actual logic
    return [];
  }


  @override
  Future<List<Artist>> searchArtists(String query) async {
    // TODO: Implement actual logic
    return [];
  }


  @override
  Future<List<Album>> searchAlbums(String query) async {
    // TODO: Implement actual logic
    return [];
  }


  @override
  Future<List<Genre>> searchGenres(String query) async {
    // TODO: Implement actual logic
    return [];
  }


  @override
  Future<List<CommonAnime>> searchAnime(String query) async {
    // TODO: Implement actual logic
    return [];
  }


  @override
  Future<List<CommonManga>> searchManga(String query) async {
    // TODO: Implement actual logic
    return [];
  }


  @override
  Future<List<dynamic>> getTopItems(String category) async {
    // TODO: Implement actual logic
    return [];
  }


  @override
  Future<List<dynamic>> getLikedItems(String category) async {
    // TODO: Implement actual logic
    return [];
  }


  @override
  Future<void> toggleAnimeLike(String animeId) async {
    // TODO: Implement actual logic
  }


  @override
  Future<void> toggleMangaLike(String mangaId) async {
    // TODO: Implement actual logic
  }


  @override
  Future<void> updateLikes(String type, String id, bool isLiked) async {
    // TODO: Implement actual logic
  }

  // Toggle methods implementation

  @override
  Future<void> toggleTrackLike(String trackId) async {
    await likeTrack(trackId);
  }


  @override
  Future<void> toggleArtistLike(String artistId) async {
    await likeArtist(artistId);
  }


  @override
  Future<void> toggleAlbumLike(String albumId) async {
    await likeAlbum(albumId);
  }


  @override
  Future<void> toggleGenreLike(String genreId) async {
    await likeGenre(genreId);
  }


  @override
  Future<void> toggleLike(String id, String type) async {
    switch (type.toLowerCase()) {
      case 'track':
        await toggleTrackLike(id);
        break;
      case 'artist':
        await toggleArtistLike(id);
        break;
      case 'album':
        await toggleAlbumLike(id);
        break;
      case 'genre':
        await toggleGenreLike(id);
        break;
      case 'anime':
        await toggleAnimeLike(id);
        break;
      case 'manga':
        await toggleMangaLike(id);
        break;
      default:
        throw ArgumentError('Unsupported content type: $type');
    }
  }

  @override
  Future<void> playTrackOnService(String trackIdentifier, {String? service}) async {
    try {
      await _remoteDataSource.playTrackOnService(trackIdentifier, service: service);
    } on ServerException catch (e) {
      throw ServerFailure(message: e.message);
    } catch (e) {
      throw ServerFailure(message: e.toString());
    }
  }
}
