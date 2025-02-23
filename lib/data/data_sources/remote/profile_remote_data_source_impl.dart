import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../../../domain/models/user_profile.dart';
import 'profile_remote_data_source.dart';
import '../../network/dio_client.dart';

Map<String, dynamic> _cleanJson(String jsonString) {
  // Add quotes around unquoted property names
  final fixedJson = jsonString.replaceAllMapped(
    RegExp(r'(?<=\{|\,|\s)(\w+)(?=:)'),
    (Match m) => '"${m.group(1)}"',
  );
  return jsonDecode(fixedJson);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final DioClient _dioClient;
  final Logger logger = Logger();

  ProfileRemoteDataSourceImpl({required DioClient dioClient}) : _dioClient = dioClient;

  @override
  Future<UserProfile?> getMyProfile() async {
    try {
      final response = await _dioClient.get('/me/profile');
      final cleanedData = _cleanJson(response.data.toString());
      return UserProfile.fromJson(cleanedData);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        logger.w('Profile not found');
        return null;
      }
      logger.e('Error fetching profile', e);
      return null;
    }
  }

  @override
  Future<void> deleteAvatar() async {
    try {
      await _dioClient.delete('/profile/avatar');
    } on DioException catch (e) {
      // Log the error or handle it as needed
      logger.e('Error deleting avatar', e);
      // Consider re-throwing the exception or handling it in a specific way
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getConnectedServices() async {
    final response = await _dioClient.get('/profile/services');
    return List<Map<String, dynamic>>.from(response.data);
  }

  @override
  Future<List<Map<String, dynamic>>> getTopItems(String category) async {
    final response = await _dioClient.get('/profile/top-items/$category');
    return List<Map<String, dynamic>>.from(response.data);
  }

  @override
  Future<String> updateAvatar(XFile imageFile) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(imageFile.path),
    });
    final response = await _dioClient.dio.post('/profile/avatar', data: formData);
    return response.data['avatar_url'];
  }

  @override
  Future<void> updatePreferences(Map<String, dynamic> preferences) async {
    await _dioClient.put('/profile/preferences', data: preferences);
  }

  @override
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await _dioClient.put('/profile', data: data);
    return response.data;
  }
}

// iconButton = IconButton(
//   icon: const Icon(Icons.settings, color: Colors.white),
//   onPressed: () {
//     Navigator.pushNamed(context, '/profile');
//   }
