import '../../domain/repositories/bud_matching_repository.dart';
import '../data_sources/remote/bud_matching_remote_data_source.dart';

class BudMatchingRepositoryImpl implements BudMatchingRepository {
  final BudMatchingRemoteDataSource _remoteDataSource;

  BudMatchingRepositoryImpl({required BudMatchingRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<List<dynamic>> searchBuds(String query, Map<String, dynamic>? filters) async {
    try {
      final response = await _remoteDataSource.searchBuds(query, filters);
      return response['buds'] ?? [];
    } catch (e) {
      throw Exception('Failed to search buds: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getBudProfile(String budId) async {
    try {
      final response = await _remoteDataSource.getBudProfile(budId);
      return response;
    } catch (e) {
      throw Exception('Failed to get bud profile: $e');
    }
  }

  @override
  Future<List<dynamic>> getBudLikedContent(String contentType, String budId) async {
    try {
      final response = await _remoteDataSource.getBudLikedContent(contentType, budId);
      return response['content'] ?? [];
    } catch (e) {
      throw Exception('Failed to get bud liked $contentType: $e');
    }
  }

  @override
  Future<List<dynamic>> getBudTopContent(String contentType, String budId) async {
    try {
      final response = await _remoteDataSource.getBudTopContent(contentType, budId);
      return response['content'] ?? [];
    } catch (e) {
      throw Exception('Failed to get bud top $contentType: $e');
    }
  }

  @override
  Future<List<dynamic>> getBudPlayedTracks(String budId) async {
    try {
      final response = await _remoteDataSource.getBudPlayedTracks(budId);
      return response['tracks'] ?? [];
    } catch (e) {
      throw Exception('Failed to get bud played tracks: $e');
    }
  }

  @override
  Future<List<dynamic>> getBudCommonLikedContent(String contentType, String budId) async {
    try {
      final response = await _remoteDataSource.getBudCommonLikedContent(contentType, budId);
      return response['common_content'] ?? [];
    } catch (e) {
      throw Exception('Failed to get bud common liked $contentType: $e');
    }
  }

  @override
  Future<List<dynamic>> getBudCommonTopContent(String contentType, String budId) async {
    try {
      final response = await _remoteDataSource.getBudCommonTopContent(contentType, budId);
      return response['common_content'] ?? [];
    } catch (e) {
      throw Exception('Failed to get bud common top $contentType: $e');
    }
  }

  @override
  Future<List<dynamic>> getBudCommonPlayedTracks(String budId) async {
    try {
      final response = await _remoteDataSource.getBudCommonPlayedTracks(budId);
      return response['common_tracks'] ?? [];
    } catch (e) {
      throw Exception('Failed to get bud common played tracks: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getBudSpecificContent(String contentType, String contentId, String budId) async {
    try {
      final response = await _remoteDataSource.getBudSpecificContent(contentType, contentId, budId);
      return response;
    } catch (e) {
      throw Exception('Failed to get bud specific $contentType: $e');
    }
  }
}