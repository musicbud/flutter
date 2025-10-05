import '../models/user_profile.dart';

abstract class UserProfileRepository {
  /// Get user profile by user ID
  Future<UserProfile> getUserProfile(String userId);

  /// Get current user's profile
  Future<UserProfile> getMyProfile();

  /// Update current user's profile
  Future<UserProfile> updateProfile(UserProfileUpdateRequest updateRequest);

  /// Update user's likes
  Future<void> updateLikes(Map<String, dynamic> likesData);

  /// Get user's liked content by type
  Future<List<dynamic>> getUserLikedContent(String contentType, String userId);

  /// Get current user's liked content by type
  Future<List<dynamic>> getMyLikedContent(String contentType);

  /// Get user's top content by type
  Future<List<dynamic>> getUserTopContent(String contentType, String userId);

  /// Get current user's top content by type
  Future<List<dynamic>> getMyTopContent(String contentType);

  /// Get user's played tracks
  Future<List<dynamic>> getUserPlayedTracks(String userId);

  /// Get current user's played tracks
  Future<List<dynamic>> getMyPlayedTracks();
}