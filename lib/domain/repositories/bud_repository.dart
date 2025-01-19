import '../models/bud_match.dart';

abstract class BudRepository {
  Future<List<BudMatch>> getBudMatches();
  Future<void> sendBudRequest(String userId);
  Future<void> acceptBudRequest(String userId);
  Future<void> rejectBudRequest(String userId);
  Future<List<BudMatch>> getCommonTracks(String userId);
  Future<List<BudMatch>> getCommonArtists(String userId);
  Future<List<BudMatch>> getCommonGenres(String userId);
  Future<List<BudMatch>> getCommonPlayedTracks(String userId);
}
