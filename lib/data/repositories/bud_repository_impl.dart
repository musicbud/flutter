import '../../domain/repositories/bud_repository.dart';
import '../../models/bud.dart';
import '../data_sources/remote/bud_remote_data_source.dart';

class BudRepositoryImpl implements BudRepository {
  final BudRemoteDataSource _remoteDataSource;

  BudRepositoryImpl({required BudRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<Bud>> getBudsByLikedArtists() async {
    return await _remoteDataSource.getBudsByLikedArtists();
  }

  @override
  Future<List<Bud>> getBudsByLikedTracks() async {
    return await _remoteDataSource.getBudsByLikedTracks();
  }

  @override
  Future<List<Bud>> getBudsByLikedGenres() async {
    return await _remoteDataSource.getBudsByLikedGenres();
  }

  @override
  Future<List<Bud>> getBudsByLikedAlbums() async {
    return await _remoteDataSource.getBudsByLikedAlbums();
  }

  @override
  Future<List<Bud>> getBudsByPlayedTracks() async {
    return await _remoteDataSource.getBudsByPlayedTracks();
  }

  @override
  Future<List<Bud>> getBudsByTopArtists() async {
    return await _remoteDataSource.getBudsByTopArtists();
  }

  @override
  Future<List<Bud>> getBudsByTopTracks() async {
    return await _remoteDataSource.getBudsByTopTracks();
  }

  @override
  Future<List<Bud>> getBudsByTopGenres() async {
    return await _remoteDataSource.getBudsByTopGenres();
  }

  @override
  Future<List<Bud>> getBudsByTopAnime() async {
    return await _remoteDataSource.getBudsByTopAnime();
  }

  @override
  Future<List<Bud>> getBudsByTopManga() async {
    return await _remoteDataSource.getBudsByTopManga();
  }

  @override
  Future<List<Bud>> getBudsByArtist(String artistId) async {
    return await _remoteDataSource.getBudsByArtist(artistId);
  }

  @override
  Future<List<Bud>> getBudsByTrack(String trackId) async {
    return await _remoteDataSource.getBudsByTrack(trackId);
  }

  @override
  Future<List<Bud>> getBudsByGenre(String genreId) async {
    return await _remoteDataSource.getBudsByGenre(genreId);
  }

  @override
  Future<List<Bud>> getBudsByAlbum(String albumId) async {
    return await _remoteDataSource.getBudsByAlbum(albumId);
  }

  @override
  Future<List<Bud>> searchBuds(String query) async {
    return await _remoteDataSource.searchBuds(query);
  }
}
