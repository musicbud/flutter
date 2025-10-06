import 'package:image_picker/image_picker.dart';
import '../../models/user_profile.dart';
import '../../models/content_service.dart';
import '../../domain/repositories/profile_repository.dart';
import '../network/dio_client.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final DioClient _dioClient;

  ProfileRepositoryImpl({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  @override
  Future<UserProfile> getMyProfile() async {
    try {
      // Getting my profile
      final response = await _dioClient.post('/me/profile');
      if (response.data == null) {
        throw Exception('Profile not found');
      }
      // Response data received
      return UserProfile.fromJson(response.data);
    } catch (e) {
      // Error getting profile: $e
      rethrow;
    }
  }

  @override
  Future<UserProfile> getUserProfile() async {
    return getMyProfile(); // Reuse the same implementation since they do the same thing
  }

    @override
  Future<void> updateProfile(Map<String, dynamic> profileData) async {
    final response = await _dioClient.post('/me/profile/set', data: profileData);
    if (response.statusCode != 200) {
      throw Exception('Failed to update profile');
    }
  }

  @override
  Future<String> updateAvatar(XFile image) async {
    // Avatar upload endpoint does not exist in the current backend API
    throw Exception('Avatar upload is not supported by the current API');
  }

  @override
  Future<void> logout() async {
    try {
      // Use the correct logout endpoint
      await _dioClient.get('/logout/');
    } catch (e) {
      // Logout failed: $e
      // Don't rethrow - logout should not fail the app
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    try {
      // Check authentication by trying to get profile
      // This is more reliable than a dedicated auth status endpoint
      await _dioClient.post('/me/profile');
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ContentService>> getConnectedServices() async {
    // This endpoint no longer exists in the backend API
    // Service connection is now handled by the AuthBloc
    // Return empty list to avoid breaking the app
    return [];
  }
}
