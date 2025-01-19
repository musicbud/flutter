import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/models/content_service.dart';
import '../../domain/repositories/profile_repository.dart';
import '../network/dio_client.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final DioClient _dioClient;

  ProfileRepositoryImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<UserProfile> getUserProfile() async {
    final response = await _dioClient.get('/profile');
    return UserProfile.fromJson(response.data);
  }

  @override
  Future<String> updateAvatar(XFile image) async {
    final formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(image.path),
    });
    final response = await _dioClient.post('/profile/avatar', data: formData);
    return response.data['avatar_url'];
  }

  @override
  Future<void> logout() async {
    await _dioClient.post('/auth/logout');
  }

  @override
  Future<List<ContentService>> getConnectedServices() async {
    final response = await _dioClient.get('/profile/services');
    return (response.data as List)
        .map((json) => ContentService.fromJson(json))
        .toList();
  }
}
