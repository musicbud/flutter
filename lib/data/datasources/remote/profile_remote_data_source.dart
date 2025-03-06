import '../../../domain/models/user_profile.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfile?> getMyProfile();
  Future<UserProfile> getUserProfile();
  Future<void> updateProfile(Map<String, dynamic> data);
  // Add other profile-related methods
} 