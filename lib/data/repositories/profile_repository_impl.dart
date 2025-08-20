import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/models/content_service.dart';
import '../../domain/repositories/profile_repository.dart';
import '../network/dio_client.dart';
import '../../utils/json_helper.dart';
import 'dart:convert';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final DioClient _dioClient;

  ProfileRepositoryImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  @override
  Future<UserProfile> getMyProfile() async {
    try {
      print('ProfileRepository: Getting my profile');
      final response = await _dioClient.post('/me/profile');
      if (response.data == null) {
        throw Exception('Profile not found');
      }
      print('ProfileRepository: Response data: ${response.data}');
      print('ProfileRepository: Response data type: ${response.data.runtimeType}');
      print('ProfileRepository: Response data keys: ${response.data.keys.toList()}');
      return UserProfile.fromJson(response.data);
    } catch (e, stackTrace) {
      print('ProfileRepository: Error getting profile: $e');
      print('ProfileRepository: Stack trace: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<UserProfile> getUserProfile() async {
    return getMyProfile(); // Reuse the same implementation since they do the same thing
  }

  @override
  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    final response = await _dioClient.put('/profile/me', data: profileData);
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

  @override
  Future<String> updateAvatar(XFile image) async {
    try {
      final formData = FormData();
      formData.files.add(MapEntry(
        'avatar',
        await MultipartFile.fromFile(image.path),
      ));

      // Use post method directly with FormData
      final response = await _dioClient.post('/profile/avatar', data: formData);

      if (response.data != null && response.data['avatar_url'] != null) {
        return response.data['avatar_url'];
      } else {
        throw Exception('Avatar URL not found in response');
      }
    } catch (e) {
      print('ProfileRepository: Error updating avatar: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      // Try POST first, if it fails, try GET
      try {
        await _dioClient.post('/auth/logout');
      } catch (e) {
        if (e.toString().contains('405')) {
          // If POST fails with 405, try GET
          await _dioClient.get('/auth/logout');
        } else {
          rethrow;
        }
      }
    } catch (e) {
      print('ProfileRepository: Logout failed: $e');
      // Don't rethrow - logout should not fail the app
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      // await _dioClient.get('/auth/status');
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ContentService>> getConnectedServices() async {
    final response = await _dioClient.get('/profile/services');
    return (response.data as List)
        .map((json) => ContentService.fromJson(json))
        .toList();
  }
}
