import '../../domain/repositories/user_profile_repository.dart';
import '../../domain/models/user_profile.dart';
import '../data_sources/remote/user_profile_remote_data_source.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource _remoteDataSource;

  UserProfileRepositoryImpl({required UserProfileRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<UserProfile> getUserProfile(String userId) async {
    try {
      final response = await _remoteDataSource.getUserProfile(userId);
      return UserProfile.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<UserProfile> getMyProfile() async {
    try {
      final response = await _remoteDataSource.getMyProfile();
      return UserProfile.fromJson(response);
    } catch (e) {
      throw Exception('Failed to get my profile: $e');
    }
  }

  @override
  Future<UserProfile> updateProfile(UserProfileUpdateRequest updateRequest) async {
    try {
      final response = await _remoteDataSource.updateProfile(updateRequest);
      return UserProfile.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> updateLikes(Map<String, dynamic> likesData) async {
    try {
      await _remoteDataSource.updateLikes(likesData);
    } catch (e) {
      throw Exception('Failed to update likes: $e');
    }
  }

  @override
  Future<List<dynamic>> getUserLikedContent(String contentType, String userId) async {
    try {
      final response = await _remoteDataSource.getUserLikedContent(contentType, userId);
      return response['content'] ?? [];
    } catch (e) {
      throw Exception('Failed to get user liked $contentType: $e');
    }
  }

  @override
  Future<List<dynamic>> getMyLikedContent(String contentType) async {
    try {
      final response = await _remoteDataSource.getMyLikedContent(contentType);
      return response['content'] ?? [];
    } catch (e) {
      throw Exception('Failed to get my liked $contentType: $e');
    }
  }

  @override
  Future<List<dynamic>> getUserTopContent(String contentType, String userId) async {
    try {
      final response = await _remoteDataSource.getUserTopContent(contentType, userId);
      return response['content'] ?? [];
    } catch (e) {
      throw Exception('Failed to get user top $contentType: $e');
    }
  }

  @override
  Future<List<dynamic>> getMyTopContent(String contentType) async {
    try {
      final response = await _remoteDataSource.getMyTopContent(contentType);
      return response['content'] ?? [];
    } catch (e) {
      throw Exception('Failed to get my top $contentType: $e');
    }
  }

  @override
  Future<List<dynamic>> getUserPlayedTracks(String userId) async {
    try {
      final response = await _remoteDataSource.getUserPlayedTracks(userId);
      return response['tracks'] ?? [];
    } catch (e) {
      throw Exception('Failed to get user played tracks: $e');
    }
  }

  @override
  Future<List<dynamic>> getMyPlayedTracks() async {
    try {
      final response = await _remoteDataSource.getMyPlayedTracks();
      return response['tracks'] ?? [];
    } catch (e) {
      throw Exception('Failed to get my played tracks: $e');
    }
  }
}