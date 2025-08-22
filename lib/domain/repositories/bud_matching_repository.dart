abstract class BudMatchingRepository {
  /// Search for buds based on query and filters
  Future<List<dynamic>> searchBuds(String query, Map<String, dynamic>? filters);

  /// Get bud profile by bud ID
  Future<Map<String, dynamic>> getBudProfile(String budId);

  /// Get bud's liked content by type
  Future<List<dynamic>> getBudLikedContent(String contentType, String budId);

  /// Get bud's top content by type
  Future<List<dynamic>> getBudTopContent(String contentType, String budId);

  /// Get bud's played tracks
  Future<List<dynamic>> getBudPlayedTracks(String budId);

  /// Get common liked content between current user and bud
  Future<List<dynamic>> getBudCommonLikedContent(String contentType, String budId);

  /// Get common top content between current user and bud
  Future<List<dynamic>> getBudCommonTopContent(String contentType, String budId);

  /// Get common played tracks between current user and bud
  Future<List<dynamic>> getBudCommonPlayedTracks(String budId);

  /// Get specific content from bud (artist, track, genre, album)
  Future<Map<String, dynamic>> getBudSpecificContent(String contentType, String contentId, String budId);
}