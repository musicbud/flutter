import '../../domain/repositories/bud_matching_repository.dart';
import '../../models/bud_profile.dart';
import '../../models/bud_search_result.dart';
import '../data_sources/remote/bud_matching_remote_data_source.dart';

class BudMatchingRepositoryImpl implements BudMatchingRepository {
  final BudMatchingRemoteDataSource _remoteDataSource;

  BudMatchingRepositoryImpl({required BudMatchingRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<BudProfile> fetchBudProfile(String budId) async {
    try {
      final response = await _remoteDataSource.fetchBudProfile(budId);
      return BudProfile.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch bud profile: $e');
    }
  }

  @override
  Future<BudSearchResult> findBudsByTopArtists() async {
    try {
      final response = await _remoteDataSource.findBudsByTopArtists();
      return BudSearchResult.fromJson(response);
    } catch (e) {
      throw Exception('Failed to find buds by top artists: $e');
    }
  }

  @override
  Future<BudSearchResult> findBudsByTopTracks() async {
    try {
      final response = await _remoteDataSource.findBudsByTopTracks();
      return BudSearchResult.fromJson(response);
    } catch (e) {
      throw Exception('Failed to find buds by top tracks: $e');
    }
  }

  @override
  Future<BudSearchResult> findBudsByTopGenres() async {
    try {
      final response = await _remoteDataSource.findBudsByTopGenres();
      return BudSearchResult.fromJson(response);
    } catch (e) {
      throw Exception('Failed to find buds by top genres: $e');
    }
  }

  @override
  Future<BudSearchResult> findBudsByTopAnime() async {
    try {
      final response = await _remoteDataSource.findBudsByTopAnime();
      return BudSearchResult.fromJson(response);
    } catch (e) {
      throw Exception('Failed to find buds by top anime: $e');
    }
  }

  @override
  Future<BudSearchResult> findBudsByTopManga() async {
    try {
      final response = await _remoteDataSource.findBudsByTopManga();
      return BudSearchResult.fromJson(response);
    } catch (e) {
      throw Exception('Failed to find buds by top manga: $e');
    }
  }

  @override
  Future<BudSearchResult> findBudsByLikedArtists() async {
    try {
      final response = await _remoteDataSource.findBudsByLikedArtists();
      return BudSearchResult.fromJson(response);
    } catch (e) {
      throw Exception('Failed to find buds by liked artists: $e');
    }
  }

  @override
  Future<BudSearchResult> findBudsByLikedTracks() async {
    try {
      final response = await _remoteDataSource.findBudsByLikedTracks();
      return BudSearchResult.fromJson(response);
    } catch (e) {
      throw Exception('Failed to find buds by liked tracks: $e');
    }
  }

  @override
  Future<BudSearchResult> findBudsByLikedGenres() async {
    try {
      final response = await _remoteDataSource.findBudsByLikedGenres();
      return BudSearchResult.fromJson(response);
    } catch (e) {
      throw Exception('Failed to find buds by liked genres: $e');
    }
  }

  @override
  Future<BudSearchResult> findBudsByLikedAlbums() async {
    try {
      final response = await _remoteDataSource.findBudsByLikedAlbums();
      return BudSearchResult.fromJson(response);
    } catch (e) {
      throw Exception('Failed to find buds by liked albums: $e');
    }
  }

  @override
  Future<BudSearchResult> findBudsByLikedAio() async {
    try {
      final response = await _remoteDataSource.findBudsByLikedAio();
      return BudSearchResult.fromJson(response);
    } catch (e) {
      throw Exception('Failed to find buds by liked aio: $e');
    }
  }

  @override
  Future<BudSearchResult> findBudsByPlayedTracks() async {
    try {
      final response = await _remoteDataSource.findBudsByPlayedTracks();
      return BudSearchResult.fromJson(response);
    } catch (e) {
      throw Exception('Failed to find buds by played tracks: $e');
    }
  }

  @override
  Future<BudSearchResult> findBudsByArtist(String artistId) async {
    try {
      final response = await _remoteDataSource.findBudsByArtist(artistId);
      return BudSearchResult.fromJson(response);
    } catch (e) {
      throw Exception('Failed to find buds by artist: $e');
    }
  }

  @override
  Future<BudSearchResult> findBudsByTrack(String trackId) async {
    try {
      final response = await _remoteDataSource.findBudsByTrack(trackId);
      return BudSearchResult.fromJson(response);
    } catch (e) {
      throw Exception('Failed to find buds by track: $e');
    }
  }

  @override
  Future<BudSearchResult> findBudsByGenre(String genreId) async {
    try {
      final response = await _remoteDataSource.findBudsByGenre(genreId);
      return BudSearchResult.fromJson(response);
    } catch (e) {
      throw Exception('Failed to find buds by genre: $e');
    }
  }
}