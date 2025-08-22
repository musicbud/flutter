// import '../models/server_status.dart';

/// Interface for authentication-related operations
abstract class AuthRepository {
  Future<Map<String, dynamic>> login(String username, String password);
  Future<Map<String, dynamic>> register(
      String username, String email, String password);
  Future<bool> isAuthenticated();
  // Future<ServerStatus> checkServerStatus();
  Future<String> refreshToken();
  Future<void> logout();

  // Service connection URLs
  Future<String> getServiceAuthUrl();

  // Service connections
  Future<void> connectSpotify(String code);
  Future<void> connectYTMusic(String code);
  Future<void> connectLastFM(String code);
  Future<void> connectMAL(String code);

  // Token refresh
  Future<void> refreshSpotifyToken();
  Future<void> refreshYTMusicToken();
}
