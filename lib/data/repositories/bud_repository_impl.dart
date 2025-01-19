import '../../domain/models/common_track.dart';
import '../../domain/models/common_artist.dart';
import '../../domain/models/common_genre.dart';
import '../../domain/models/bud_match.dart';
import '../../domain/repositories/bud_repository.dart';
import '../network/dio_client.dart';

class BudRepositoryImpl implements BudRepository {
  final DioClient _dioClient;

  BudRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<List<BudMatch>> getCommonTracks(String userId) async {
    final response = await _dioClient.get('/buds/$userId/common/tracks');
    return (response.data as List)
        .map((json) => BudMatch.fromJson(json))
        .toList();
  }

  @override
  Future<List<BudMatch>> getCommonArtists(String userId) async {
    final response = await _dioClient.get('/buds/$userId/common/artists');
    return (response.data as List)
        .map((json) => BudMatch.fromJson(json))
        .toList();
  }

  @override
  Future<List<BudMatch>> getCommonGenres(String userId) async {
    final response = await _dioClient.get('/buds/$userId/common/genres');
    return (response.data as List)
        .map((json) => BudMatch.fromJson(json))
        .toList();
  }

  @override
  Future<List<CommonTrack>> getCommonPlayedTracks(String userId) async {
    final response = await _dioClient.get('/buds/$userId/common/played');
    return (response.data as List)
        .map((json) => CommonTrack.fromJson(json))
        .toList();
  }

  @override
  Future<List<BudMatch>> getBudMatches() async {
    final response = await _dioClient.get('/buds/matches');
    return (response.data as List)
        .map((json) => BudMatch.fromJson(json))
        .toList();
  }

  @override
  Future<void> sendBudRequest(String userId) async {
    await _dioClient.post('/buds/requests', data: {
      'user_id': userId,
    });
  }

  @override
  Future<void> acceptBudRequest(String userId) async {
    await _dioClient.post('/buds/requests/$userId/accept');
  }

  @override
  Future<void> rejectBudRequest(String userId) async {
    await _dioClient.post('/buds/requests/$userId/reject');
  }

  @override
  Future<void> removeBud(String userId) async {
    await _dioClient.delete('/buds/$userId');
  }
}
