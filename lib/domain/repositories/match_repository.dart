import '../../models/match_profile.dart';

abstract class MatchRepository {
  /// Get recommended matches based on user preferences
  Future<List<MatchProfile>> getMatches({
    int page = 1,
    int limit = 20,
    Map<String, dynamic>? filters,
  });

  /// Get detailed match profile
  Future<MatchProfile> getMatchProfile(String matchId);

  /// Update user match preferences
  Future<void> updatePreferences(Map<String, dynamic> preferences);

  /// Send match request to another user
  Future<void> sendMatchRequest(String matchId);

  /// Handle incoming match request
  Future<void> handleMatchRequest(String requestId, bool accept);

  /// Get match suggestions based on current activity
  Future<List<MatchProfile>> getSuggestions();

  /// Block a match
  Future<void> blockMatch(String matchId, {String? reason});

  /// Report inappropriate behavior
  Future<void> reportMatch(String matchId, String reason);

  /// Get online status updates for matches
  Stream<List<String>> get onlineMatches;

  /// Get match request updates
  Stream<Map<String, dynamic>> get matchRequests;
}
