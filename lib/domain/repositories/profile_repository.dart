import 'package:image_picker/image_picker.dart';
import '../../models/user_profile.dart';
import '../../models/content_service.dart';

abstract class ProfileRepository {
  Future<UserProfile> getUserProfile();
  Future<UserProfile> getMyProfile();
  Future<void> updateProfile(Map<String, dynamic> profileData);
  Future<String> updateAvatar(XFile image);
  Future<void> logout();
  Future<bool> isAuthenticated();
  Future<List<ContentService>> getConnectedServices();
}
