import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String username, String password);
  Future<Map<String, dynamic>> register(
      String username, String email, String password);
  Future<String> refreshToken(String refreshToken);
  Future<void> logout();

  // Service connections
  Future<void> connectSpotify();
  Future<void> spotifyCallback(String code);
  Future<void> connectYtmusic();
  Future<void> ytmusicCallback(String code);
  Future<void> connectLastfm();
  Future<void> lastfmCallback(String code);
  Future<void> connectMal();
  Future<void> malCallback(String code);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/service/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ServerException(message: 'Failed to login');
    }
  }

  @override
  Future<Map<String, dynamic>> register(
      String username, String email, String password) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/register/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ServerException(message: 'Failed to register');
    }
  }

  @override
  Future<String> refreshToken(String refreshToken) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/token/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'refresh_token': refreshToken,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['access_token'];
    } else {
      throw ServerException(message: 'Failed to refresh token');
    }
  }

  @override
  Future<void> logout() async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/logout/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to logout');
    }
  }

  @override
  Future<void> connectSpotify() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/spotify/connect'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect Spotify');
    }
  }

  @override
  Future<void> spotifyCallback(String code) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/spotify/callback?code=$code'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to handle Spotify callback');
    }
  }

  @override
  Future<void> connectYtmusic() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/ytmusic/connect'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect YouTube Music');
    }
  }

  @override
  Future<void> ytmusicCallback(String code) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/ytmusic/callback?code=$code'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to handle YouTube Music callback');
    }
  }

  @override
  Future<void> connectLastfm() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/lastfm/connect'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect Last.fm');
    }
  }

  @override
  Future<void> lastfmCallback(String code) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/lastfm/callback?code=$code'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to handle Last.fm callback');
    }
  }

  @override
  Future<void> connectMal() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/mal/connect'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to connect MyAnimeList');
    }
  }

  @override
  Future<void> malCallback(String code) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/mal/callback?code=$code'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to handle MyAnimeList callback');
    }
  }
}
