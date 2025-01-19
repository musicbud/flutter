import '../../domain/repositories/auth_repository.dart';
// import '../../domain/models/server_status.dart';
import '../network/dio_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _dioClient;

  AuthRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _dioClient.post('/chat/login/', data: {
      'username': username,
      'password': password,
    });
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password,
  ) async {
    final response = await _dioClient.post('/auth/register', data: {
      'username': username,
      'email': email,
      'password': password,
    });
    return response.data;
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      await _dioClient.get('/auth/status');
      return true;
    } catch (e) {
      return false;
    }
  }

  // @override
  // Future<ServerStatus> checkServerStatus() async {
  //   try {
  //     final response = await _dioClient.get('/health');
  //     return ServerStatus(
  //       isReachable: true,
  //       message: response.data['message'],
  //     );
  //   } catch (e) {
  //     return ServerStatus(
  //       isReachable: false,
  //       error: e.toString(),
  //     );
  //   }
  // }

  @override
  Future<String> refreshToken() async {
    final response = await _dioClient.post('/auth/refresh');
    return response.data['token'];
  }

  @override
  Future<String> getSpotifyAuthUrl() async {
    final response = await _dioClient.get('/auth/spotify/url');
    return response.data['auth_url'];
  }

  @override
  Future<String> getYTMusicAuthUrl() async {
    final response = await _dioClient.get('/auth/ytmusic/url');
    return response.data['auth_url'];
  }

  @override
  Future<String> getLastFMAuthUrl() async {
    final response = await _dioClient.get('/auth/lastfm/url');
    return response.data['auth_url'];
  }

  @override
  Future<String> getMALAuthUrl() async {
    final response = await _dioClient.get('/auth/mal/url');
    return response.data['auth_url'];
  }

  @override
  Future<void> connectSpotify(String code) async {
    await _dioClient.post('/auth/spotify/connect', data: {
      'code': code,
    });
  }

  @override
  Future<void> connectYTMusic(String code) async {
    await _dioClient.post('/auth/ytmusic/connect', data: {
      'code': code,
    });
  }

  @override
  Future<void> connectLastFM(String code) async {
    await _dioClient.post('/auth/lastfm/connect', data: {
      'code': code,
    });
  }

  @override
  Future<void> connectMAL(String code) async {
    await _dioClient.post('/auth/mal/connect', data: {
      'code': code,
    });
  }

  @override
  Future<void> logout() async {
    await _dioClient.post('/auth/logout');
  }

  @override
  Future<List<Map<String, dynamic>>> getConnectedServices() async {
    final response = await _dioClient.get('/auth/services');
    return List<Map<String, dynamic>>.from(response.data);
  }

  @override
  Future<void> disconnectSpotify() async {
    await _dioClient.post('/auth/spotify/disconnect');
  }

  @override
  Future<void> disconnectYTMusic() async {
    await _dioClient.post('/auth/ytmusic/disconnect');
  }

  @override
  Future<void> disconnectLastFM() async {
    await _dioClient.post('/auth/lastfm/disconnect');
  }

  @override
  Future<void> disconnectMAL() async {
    await _dioClient.post('/auth/mal/disconnect');
  }
}
