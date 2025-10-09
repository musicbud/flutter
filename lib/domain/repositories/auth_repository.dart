import '../../models/auth_response.dart';

/// Interface for authentication-related operations
abstract class AuthRepository {
  Future<LoginResponse> login(String username, String password);
  Future<RegisterResponse> register(
      String username, String email, String password);
  Future<bool> isAuthenticated();
  // Future<ServerStatus> checkServerStatus();
  Future<TokenRefreshResponse> refreshToken();
  Future<void> logout();

  // Service connection URLs
  Future<String> getServiceAuthUrl();
  Future<String> getServiceLoginUrl(String service);

  // Service connections
  Future<void> connectSpotify(String code);
  Future<void> connectYTMusic(String code);
  Future<void> connectLastFM(String code);
  Future<void> connectMAL(String code);

  // Token refresh
  Future<void> refreshSpotifyToken();
  Future<void> refreshYTMusicToken();
}
