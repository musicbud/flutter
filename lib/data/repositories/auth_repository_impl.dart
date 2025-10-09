import '../../domain/repositories/auth_repository.dart';
import '../../models/auth_response.dart';
import '../data_sources/remote/auth_remote_data_source.dart';
import '../providers/token_provider.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _authRemoteDataSource;
  final TokenProvider _tokenProvider;

  AuthRepositoryImpl({
    required AuthRemoteDataSource authRemoteDataSource,
    required TokenProvider tokenProvider,
  }) : _authRemoteDataSource = authRemoteDataSource,
       _tokenProvider = tokenProvider;

  @override
  Future<LoginResponse> login(String username, String password) async {
    final result = await _authRemoteDataSource.login(username, password);
    return LoginResponse.fromJson(result);
  }

  @override
  Future<RegisterResponse> register(
      String username, String email, String password) async {
    final result = await _authRemoteDataSource.register(username, email, password);
    return RegisterResponse.fromJson(result);
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      // Try to make a request to check if the user is authenticated
      await _authRemoteDataSource.getServiceAuthUrl();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<TokenRefreshResponse> refreshToken() async {
    final refreshToken = _tokenProvider.refreshToken;
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }
    final result = await _authRemoteDataSource.refreshToken(refreshToken);
    return TokenRefreshResponse.fromJson(result);
  }

  @override
  Future<void> logout() async {
    await _authRemoteDataSource.logout();
  }

  @override
  Future<String> getServiceAuthUrl() async {
    return await _authRemoteDataSource.getServiceAuthUrl();
  }

  @override
  Future<String> getServiceLoginUrl(String service) async {
    return await _authRemoteDataSource.getServiceLoginUrl(service);
  }

  @override
  Future<void> connectSpotify(String code) async {
    await _authRemoteDataSource.connectSpotify(code);
  }

  @override
  Future<void> connectYTMusic(String code) async {
    await _authRemoteDataSource.connectYTMusic(code);
  }

  @override
  Future<void> connectLastFM(String code) async {
    await _authRemoteDataSource.connectLastFM(code);
  }

  @override
  Future<void> connectMAL(String code) async {
    await _authRemoteDataSource.connectMAL(code);
  }

  @override
  Future<void> refreshSpotifyToken() async {
    await _authRemoteDataSource.refreshSpotifyToken();
  }

  @override
  Future<void> refreshYTMusicToken() async {
    await _authRemoteDataSource.refreshYTMusicToken();
  }
}
