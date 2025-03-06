import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../domain/models/user_profile.dart';
import '../../providers/token_provider.dart';
import 'profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client _client;
  final TokenProvider _tokenProvider;
  final String _baseUrl = 'http://84.235.170.234';

  ProfileRemoteDataSourceImpl({
    required http.Client client,
    required TokenProvider tokenProvider,
  })  : _client = client,
        _tokenProvider = tokenProvider;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${_tokenProvider.token}',
      };

  @override
  Future<UserProfile?> getMyProfile() async {
    try {
      final response = await _client.post(
        Uri.parse('$_baseUrl/me/profile'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return UserProfile.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to get profile: ${response.body}');
      }
    } catch (e) {
      print('Error in getMyProfile: $e');
      rethrow;
    }
  }

  @override
  Future<UserProfile> getUserProfile() async {
    final response = await _client.get(
      Uri.parse('$_baseUrl/profile'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get profile: ${response.body}');
    }
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> data) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/profile'),
      headers: _headers,
      body: json.encode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }
} 