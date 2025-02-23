import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../config/api_config.dart';
import '../../../domain/models/user_profile.dart';
import '../../../utils/http_utils.dart';

class ProfileRemoteDataSource {
  final http.Client _client;
  final String _baseUrl;

  ProfileRemoteDataSource({
    required http.Client client,
    String? baseUrl,
  })  : _client = client,
        _baseUrl = baseUrl ?? ApiConfig.baseUrl;

  Future<UserProfile?> getMyProfile() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/me/profile'),
      headers: await HttpUtils.getAuthHeaders(),

    );

    if (response.statusCode == 200) {
      return UserProfile.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception('Failed to get profile: ${response.body}');
    }

  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/profile'),
      headers: await HttpUtils.getAuthHeaders(),
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to update profile: ${response.body}');
    }
  }

  Future<String> updateAvatar(XFile imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final uri = Uri.parse('$_baseUrl/profile/avatar');

    final request = http.MultipartRequest('PUT', uri)
      ..files.add(http.MultipartFile.fromBytes(
        'avatar',
        bytes,
        filename: imageFile.name,
      ));

    final headers = await HttpUtils.getAuthHeaders();
    request.headers.addAll(headers);

    final streamedResponse = await _client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return data['avatar_url'] as String;
    } else {
      throw Exception('Failed to update avatar: ${response.body}');
    }
  }

  Future<void> deleteAvatar() async {
    final response = await _client.delete(
      Uri.parse('$_baseUrl/profile/avatar'),
      headers: await HttpUtils.getAuthHeaders(),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to delete avatar: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getTopItems(String category) async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/profile/top/$category'),
      headers: await HttpUtils.getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get top items: ${response.body}');
    }
  }

  Future<void> updatePreferences(Map<String, dynamic> preferences) async {
    final response = await _client.put(
      Uri.parse('$_baseUrl/profile/preferences'),
      headers: await HttpUtils.getAuthHeaders(),
      body: json.encode(preferences),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update preferences: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> getConnectedServices() async {
    final response = await _client.post(
      Uri.parse('$_baseUrl/profile/services'),
      headers: await HttpUtils.getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body) as List<dynamic>;
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to get connected services: ${response.body}');
    }
  }
}
