import '../../domain/repositories/content_repository.dart';
import '../../domain/models/common_track.dart';
import '../../domain/models/common_artist.dart';
import '../../domain/models/common_album.dart';
import '../../domain/models/common_genre.dart';
import '../../domain/models/common_anime.dart';
import '../../domain/models/common_manga.dart';
import '../data_sources/remote/content_remote_data_source.dart';

class ContentRepositoryImpl implements ContentRepository {
  final ContentRemoteDataSource _remoteDataSource;

  ContentRepositoryImpl({required ContentRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Map<String, dynamic>> getHomePageData() {
    return _remoteDataSource.getHomePageData();
  }

  @override
  Future<List<CommonTrack>> getPopularTracks({int limit = 20}) {
    return _remoteDataSource.getPopularTracks(limit: limit);
  }

  @override
  Future<List<CommonArtist>> getPopularArtists({int limit = 20}) {
    return _remoteDataSource.getPopularArtists(limit: limit);
  }

  @override
  Future<List<CommonAlbum>> getPopularAlbums({int limit = 20}) {
    return _remoteDataSource.getPopularAlbums(limit: limit);
  }

  @override
  Future<List<CommonAnime>> getPopularAnime({int limit = 20}) {
    return _remoteDataSource.getPopularAnime(limit: limit);
  }

  @override
  Future<List<CommonManga>> getPopularManga({int limit = 20}) {
    return _remoteDataSource.getPopularManga(limit: limit);
  }

  @override
  Future<List<CommonTrack>> getTopTracks() {
    return _remoteDataSource.getTopTracks();
  }

  @override
  Future<List<CommonArtist>> getTopArtists() {
    return _remoteDataSource.getTopArtists();
  }

  @override
  Future<List<CommonGenre>> getTopGenres() {
    return _remoteDataSource.getTopGenres();
  }

  @override
  Future<List<CommonAnime>> getTopAnime() {
    return _remoteDataSource.getTopAnime();
  }

  @override
  Future<List<CommonManga>> getTopManga() {
    return _remoteDataSource.getTopManga();
  }

  @override
  Future<List<CommonTrack>> getLikedTracks() {
    return _remoteDataSource.getLikedTracks();
  }

  @override
  Future<List<CommonArtist>> getLikedArtists() {
    return _remoteDataSource.getLikedArtists();
  }

  @override
  Future<List<CommonAlbum>> getLikedAlbums() {
    return _remoteDataSource.getLikedAlbums();
  }

  @override
  Future<List<CommonGenre>> getLikedGenres() {
    return _remoteDataSource.getLikedGenres();
  }

  @override
  Future<List<CommonTrack>> getPlayedTracks() {
    return _remoteDataSource.getPlayedTracks();
  }

  @override
  Future<List<CommonTrack>> getPlayedTracksWithLocation() {
    return _remoteDataSource.getPlayedTracksWithLocation();
  }

  @override
  Future<List<CommonTrack>> getCurrentlyPlayedTracks() {
    return _remoteDataSource.getCurrentlyPlayedTracks();
  }

  @override
  Future<bool> likeTrack(String id) {
    return _remoteDataSource.likeTrack(id);
  }

  @override
  Future<bool> likeArtist(String id) {
    return _remoteDataSource.likeArtist(id);
  }

  @override
  Future<bool> likeAlbum(String id) {
    return _remoteDataSource.likeAlbum(id);
  }

  @override
  Future<bool> likeGenre(String id) {
    return _remoteDataSource.likeGenre(id);
  }

  @override
  Future<bool> likeAnime(String id) {
    return _remoteDataSource.likeAnime(id);
  }

  @override
  Future<bool> likeManga(String id) {
    return _remoteDataSource.likeManga(id);
  }

  @override
  Future<bool> unlikeTrack(String id) {
    return _remoteDataSource.unlikeTrack(id);
  }

  @override
  Future<bool> unlikeArtist(String id) {
    return _remoteDataSource.unlikeArtist(id);
  }

  @override
  Future<bool> unlikeAlbum(String id) {
    return _remoteDataSource.unlikeAlbum(id);
  }

  @override
  Future<bool> unlikeGenre(String id) {
    return _remoteDataSource.unlikeGenre(id);
  }

  @override
  Future<bool> unlikeAnime(String id) {
    return _remoteDataSource.unlikeAnime(id);
  }

  @override
  Future<bool> unlikeManga(String id) {
    return _remoteDataSource.unlikeManga(id);
  }

  @override
  Future<List<CommonTrack>> searchTracks(String query) {
    return _remoteDataSource.searchTracks(query);
  }

  @override
  Future<List<CommonArtist>> searchArtists(String query) {
    return _remoteDataSource.searchArtists(query);
  }

  @override
  Future<List<CommonAlbum>> searchAlbums(String query) {
    return _remoteDataSource.searchAlbums(query);
  }

  @override
  Future<List<CommonGenre>> searchGenres(String query) {
    return _remoteDataSource.searchGenres(query);
  }

  @override
  Future<List<CommonAnime>> searchAnime(String query) {
    return _remoteDataSource.searchAnime(query);
  }

  @override
  Future<List<CommonManga>> searchManga(String query) {
    return _remoteDataSource.searchManga(query);
  }

  @override
  Future<List<String>> getSpotifyDevices() {
    return _remoteDataSource.getSpotifyDevices();
  }

  @override
  Future<void> playTrack(String trackId, {String? deviceId}) {
    return _remoteDataSource.playTrack(trackId, deviceId: deviceId);
  }

  @override
  Future<void> playTrackWithLocation(
      String trackId, double latitude, double longitude) {
    return _remoteDataSource.playTrackWithLocation(
        trackId, latitude, longitude);
  }

  @override
  Future<void> savePlayedTrack(
      String trackId, double latitude, double longitude) {
    return _remoteDataSource.savePlayedTrack(trackId, latitude, longitude);
  }
}
