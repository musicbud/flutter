import 'package:image_picker/image_picker.dart';
import '../models/user_profile.dart';
import '../models/content_service.dart';

abstract class ProfileRepository {
  Future<UserProfile> getUserProfile();
  Future<String> updateAvatar(XFile image);
  Future<void> logout();
  Future<List<ContentService>> getConnectedServices();
}
