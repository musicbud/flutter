import '../../models/bud_match.dart';
import '../../models/common_track.dart';
import '../../models/common_artist.dart';
import '../../models/common_genre.dart';
import '../../domain/repositories/bud_repository.dart';
import '../data_sources/remote/bud_remote_data_source.dart';

/// Implementation of the BudRepository interface.
class BudRepositoryImpl implements BudRepository {
  final BudRemoteDataSource _budRemoteDataSource;

  BudRepositoryImpl({required BudRemoteDataSource budRemoteDataSource})
      : _budRemoteDataSource = budRemoteDataSource;

  @override
  Future<List<BudMatch>> getBudMatches() async {
    return await _budRemoteDataSource.getBudMatches();
  }

  @override
  Future<void> sendBudRequest(String userId) async {
    await _budRemoteDataSource.sendBudRequest(userId);
  }

  @override
  Future<void> acceptBudRequest(String userId) async {
    await _budRemoteDataSource.acceptBudRequest(userId);
  }

  @override
  Future<void> rejectBudRequest(String userId) async {
    await _budRemoteDataSource.rejectBudRequest(userId);
  }

  @override
  Future<List<CommonTrack>> getCommonTracks(String userId) async {
    return await _budRemoteDataSource.getCommonTracks(userId);
  }

  @override
  Future<List<CommonArtist>> getCommonArtists(String userId) async {
    return await _budRemoteDataSource.getCommonArtists(userId);
  }

  @override
  Future<List<CommonGenre>> getCommonGenres(String userId) async {
    return await _budRemoteDataSource.getCommonGenres(userId);
  }

  @override
  Future<List<CommonTrack>> getCommonPlayedTracks(String userId) async {
    return await _budRemoteDataSource.getCommonPlayedTracks(userId);
  }

  @override
  Future<void> removeBud(String userId) async {
    await _budRemoteDataSource.removeBud(userId);
  }

  @override
  Future<List<BudMatch>> getBudsByLikedArtists() async {
    return await _budRemoteDataSource.getBudsByLikedArtists();
  }

  @override
  Future<List<BudMatch>> getBudsByLikedTracks() async {
    return await _budRemoteDataSource.getBudsByLikedTracks();
  }

  @override
  Future<List<BudMatch>> getBudsByLikedGenres() async {
    return await _budRemoteDataSource.getBudsByLikedGenres();
  }

  @override
  Future<List<BudMatch>> getBudsByLikedAlbums() async {
    return await _budRemoteDataSource.getBudsByLikedAlbums();
  }

  @override
  Future<List<BudMatch>> getBudsByPlayedTracks() async {
    return await _budRemoteDataSource.getBudsByPlayedTracks();
  }

  @override
  Future<List<BudMatch>> getBudsByTopArtists() async {
    return await _budRemoteDataSource.getBudsByTopArtists();
  }

  @override
  Future<List<BudMatch>> getBudsByTopTracks() async {
    return await _budRemoteDataSource.getBudsByTopTracks();
  }

  @override
  Future<List<BudMatch>> getBudsByTopGenres() async {
    return await _budRemoteDataSource.getBudsByTopGenres();
  }

  @override
  Future<List<BudMatch>> getBudsByTopAnime() async {
    return await _budRemoteDataSource.getBudsByTopAnime();
  }

  @override
  Future<List<BudMatch>> getBudsByTopManga() async {
    return await _budRemoteDataSource.getBudsByTopManga();
  }

  @override
  Future<List<BudMatch>> getBudsByArtist(String artistId) async {
    return await _budRemoteDataSource.getBudsByArtist(artistId);
  }

  @override
  Future<List<BudMatch>> getBudsByTrack(String trackId) async {
    return await _budRemoteDataSource.getBudsByTrack(trackId);
  }

  @override
  Future<List<BudMatch>> getBudsByGenre(String genreId) async {
    return await _budRemoteDataSource.getBudsByGenre(genreId);
  }

  @override
  Future<List<BudMatch>> getBudsByAlbum(String albumId) async {
    return await _budRemoteDataSource.getBudsByAlbum(albumId);
  }

  @override
  Future<List<BudMatch>> searchBuds(String query) async {
    return await _budRemoteDataSource.searchBuds(query);
  }
}
