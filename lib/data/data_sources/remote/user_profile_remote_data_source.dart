import '../../network/dio_client.dart';
import '../../../domain/models/user_profile.dart';
import '../../../config/api_config.dart';

abstract class UserProfileRemoteDataSource {
  Future<Map<String, dynamic>> getUserProfile(String userId);
  Future<Map<String, dynamic>> getMyProfile();
  Future<Map<String, dynamic>> updateProfile(UserProfileUpdateRequest updateRequest);
  Future<void> updateLikes(Map<String, dynamic> likesData);
  Future<Map<String, dynamic>> getUserLikedContent(String contentType, String userId);
  Future<Map<String, dynamic>> getMyLikedContent(String contentType);
  Future<Map<String, dynamic>> getUserTopContent(String contentType, String userId);
  Future<Map<String, dynamic>> getMyTopContent(String contentType);
  Future<Map<String, dynamic>> getUserPlayedTracks(String userId);
  Future<Map<String, dynamic>> getMyPlayedTracks();
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final DioClient _dioClient;

  UserProfileRemoteDataSourceImpl({required DioClient dioClient})
      : _dioClient = dioClient;

  @override
  Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final response = await _dioClient.get('/users/$userId');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getMyProfile() async {
    try {
      final response = await _dioClient.get(ApiConfig.myProfile);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get my profile: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateProfile(UserProfileUpdateRequest updateRequest) async {
    try {
      final response = await _dioClient.post(
        ApiConfig.updateProfile,
        data: updateRequest.toJson(),
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> updateLikes(Map<String, dynamic> likesData) async {
    try {
      await _dioClient.post(
        ApiConfig.updateLikes,
        data: likesData,
      );
    } catch (e) {
      throw Exception('Failed to update likes: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserLikedContent(String contentType, String userId) async {
    try {
      String endpoint;
      switch (contentType) {
        case 'artists':
          endpoint = '/users/$userId/liked/artists';
          break;
        case 'tracks':
          endpoint = '/users/$userId/liked/tracks';
          break;
        case 'genres':
          endpoint = '/users/$userId/liked/genres';
          break;
        case 'albums':
          endpoint = '/users/$userId/liked/albums';
          break;
        default:
          throw Exception('Unsupported content type: $contentType');
      }

      final response = await _dioClient.get(endpoint);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get user liked $contentType: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getMyLikedContent(String contentType) async {
    try {
      String endpoint;
      switch (contentType) {
        case 'artists':
          endpoint = ApiConfig.myLikedArtists;
          break;
        case 'tracks':
          endpoint = ApiConfig.myLikedTracks;
          break;
        case 'genres':
          endpoint = ApiConfig.myLikedGenres;
          break;
        case 'albums':
          endpoint = ApiConfig.myLikedAlbums;
          break;
        default:
          throw Exception('Unsupported content type: $contentType');
      }

      final response = await _dioClient.get(endpoint);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get my liked $contentType: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserTopContent(String contentType, String userId) async {
    try {
      String endpoint;
      switch (contentType) {
        case 'artists':
          endpoint = '/users/$userId/top/artists';
          break;
        case 'tracks':
          endpoint = '/users/$userId/top/tracks';
          break;
        case 'genres':
          endpoint = '/users/$userId/top/genres';
          break;
        case 'anime':
          endpoint = '/users/$userId/top/anime';
          break;
        case 'manga':
          endpoint = '/users/$userId/top/manga';
          break;
        default:
          throw Exception('Unsupported content type: $contentType');
      }

      final response = await _dioClient.get(endpoint);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get user top $contentType: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getMyTopContent(String contentType) async {
    try {
      String endpoint;
      switch (contentType) {
        case 'artists':
          endpoint = ApiConfig.myTopArtists;
          break;
        case 'tracks':
          endpoint = ApiConfig.myTopTracks;
          break;
        case 'genres':
          endpoint = ApiConfig.myTopGenres;
          break;
        case 'anime':
          endpoint = ApiConfig.myTopAnime;
          break;
        case 'manga':
          endpoint = ApiConfig.myTopManga;
          break;
        default:
          throw Exception('Unsupported content type: $contentType');
      }

      final response = await _dioClient.get(endpoint);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get my top $contentType: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserPlayedTracks(String userId) async {
    try {
      final response = await _dioClient.get('/users/$userId/played/tracks');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get user played tracks: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getMyPlayedTracks() async {
    try {
      final response = await _dioClient.get(ApiConfig.myPlayedTracks);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get my played tracks: $e');
    }
  }
}