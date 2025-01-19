abstract class AuthRepository {
  Future<Map<String, dynamic>> login(String username, String password);
  Future<Map<String, dynamic>> register(
      String username, String email, String password);
  Future<bool> isAuthenticated();
  Future<bool> checkServerStatus();
  Future<String> refreshToken();
  Future<String> getSpotifyAuthUrl();
  Future<String> getYTMusicAuthUrl();
  Future<String> getLastFMAuthUrl();
  Future<String> getMALAuthUrl();
  Future<String> connectSpotify(String code);
  Future<String> connectYTMusic(String code);
  Future<String> connectLastFM(String code);
  Future<String> connectMAL(String code);
}
