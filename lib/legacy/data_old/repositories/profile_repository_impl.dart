import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/models/content_service.dart';
import '../../domain/repositories/profile_repository.dart';
import '../network/dio_client.dart';
import '../data_sources/remote/profile_remote_data_source.dart';
import '../../utils/json_helper.dart';
import 'dart:convert';
import '../models/user_profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final DioClient _dioClient;
  final ProfileRemoteDataSource _remoteDataSource;

  ProfileRepositoryImpl({
    required DioClient dioClient,
    required ProfileRemoteDataSource remoteDataSource,
  })  : _dioClient = dioClient,
        _remoteDataSource = remoteDataSource;

  @override
  Future<UserProfile> getMyProfile() async {
    try {
      print('ProfileRepository: Getting my profile');
      final response = await _remoteDataSource.getMyProfile();
      if (response == null) {
        throw Exception('Profile not found');
      }
      return response;
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
    // return await _remoteDataSource.updateProfile(profileData);
  }

  @override
  Future<String> updateAvatar(XFile image) async {
    final formData = FormData();
    formData.files.add(MapEntry(
      'avatar',
      await MultipartFile.fromFile(image.path),
    ));
    final response =
        await _dioClient.dio.post('/profile/avatar', data: formData);
    return response.data['avatar_url'];
  }

  @override
  Future<void> logout() async {
    await _dioClient.post('/auth/logout');
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
