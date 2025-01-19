import '../../domain/repositories/auth_repository.dart';
import '../network/dio_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  final DioClient _dioClient;

  AuthRepositoryImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await _dioClient.post('/auth/login', data: {
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

  @override
  Future<bool> checkServerStatus() async {
    try {
      await _dioClient.get('/health');
      return true;
    } catch (e) {
      return false;
    }
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
  Future<String> connectSpotify(String code) async {
    final response = await _dioClient.post('/auth/spotify/connect', data: {
      'code': code,
    });
    return response.data['auth_url'];
  }

  @override
  Future<String> connectYTMusic(String code) async {
    final response = await _dioClient.post('/auth/ytmusic/connect', data: {
      'code': code,
    });
    return response.data['auth_url'];
  }

  @override
  Future<String> connectLastFM(String code) async {
    final response = await _dioClient.post('/auth/lastfm/connect', data: {
      'code': code,
    });
    return response.data['auth_url'];
  }

  @override
  Future<String> connectMAL(String code) async {
    final response = await _dioClient.post('/auth/mal/connect', data: {
      'code': code,
    });
    return response.data['auth_url'];
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
