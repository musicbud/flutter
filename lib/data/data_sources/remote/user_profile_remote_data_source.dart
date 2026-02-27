import '../../network/dio_client.dart';
import '../../../config/api_config.dart';

abstract class UserProfileRemoteDataSource {
  Future<Map<String, dynamic>> getUserProfile(String userId);
  Future<Map<String, dynamic>> getMyProfile({String? service, String? token});
  Future<Map<String, dynamic>> updateProfile({
    String? bio,
    String? displayName,
    String? firstName,
    String? lastName,
    String? birthday,
    String? gender,
    List<String>? interests,
  });
  Future<void> updateLikes(Map<String, dynamic> likesData);
  Future<Map<String, dynamic>> getUserLikedContent(
      String contentType, String userId);
  Future<Map<String, dynamic>> getMyLikedContent(String contentType);
  Future<Map<String, dynamic>> getUserTopContent(
      String contentType, String userId);
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
      // Handle the special case where userId is 'me' - use the correct endpoint
      if (userId == 'me') {
        final response = await _dioClient.post(ApiConfig.myProfile);
        return response.data as Map<String, dynamic>;
      } else {
        final response = await _dioClient.get('/users/$userId');
        return response.data as Map<String, dynamic>;
      }
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getMyProfile(
      {String? service, String? token}) async {
    try {
      // FastAPI v1 uses GET for profile retrieval
      final response = await _dioClient.get(ApiConfig.myProfile);
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get my profile: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateProfile({
    String? bio,
    String? displayName,
    String? firstName,
    String? lastName,
    String? birthday,
    String? gender,
    List<String>? interests,
  }) async {
    try {
      final data = <String, dynamic>{};
      if (bio != null) data['bio'] = bio;
      if (displayName != null) data['display_name'] = displayName;
      if (firstName != null) data['first_name'] = firstName;
      if (lastName != null) data['last_name'] = lastName;
      if (birthday != null) data['birthday'] = birthday;
      if (gender != null) data['gender'] = gender;
      if (interests != null) data['interests'] = interests;

      // FastAPI v1 uses PUT for profile updates
      final response = await _dioClient.put(
        ApiConfig.updateProfile,
        data: data,
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  @override
  Future<void> updateLikes(Map<String, dynamic> likesData) async {
    try {
      // FastAPI v1 uses PUT for preferences updates
      await _dioClient.put(
        ApiConfig.updatePreferences,
        data: likesData,
      );
    } catch (e) {
      throw Exception('Failed to update likes: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserLikedContent(
      String contentType, String userId) async {
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
      final response = await _dioClient.post(
        '${ApiConfig.apiUrl}/me/liked/$contentType/',
      );

      final responseData = response.data as Map<String, dynamic>;

      if (responseData.containsKey('results')) {
        return {
          'content': responseData['results'] ?? [],
          'pagination': {
            'count': responseData['count'],
            'next': responseData['next'],
            'previous': responseData['previous'],
          }
        };
      } else {
        return {'content': responseData['data'] ?? []};
      }
    } catch (e) {
      throw Exception('Failed to get my liked $contentType: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserTopContent(
      String contentType, String userId) async {
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

      final response = await _dioClient.post(endpoint);
      // Backend returns paginated response with 'results' field
      final responseData = response.data;
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('results')) {
        return {
          'content': responseData['results'],
          'pagination': {
            'count': responseData['count'],
            'next': responseData['next'],
            'previous': responseData['previous'],
          }
        };
      } else if (responseData is List) {
        // Fallback for direct array response
        return {'content': responseData};
      } else {
        return {'content': []};
      }
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
      final response = await _dioClient.post(ApiConfig.myPlayedTracks);
      // Backend returns paginated response with 'results' field
      final responseData = response.data;
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('results')) {
        return {
          'tracks': responseData['results'],
          'pagination': {
            'count': responseData['count'],
            'next': responseData['next'],
            'previous': responseData['previous'],
          }
        };
      } else if (responseData is List) {
        // Fallback for direct array response
        return {'tracks': responseData};
      } else {
        return {'tracks': []};
      }
    } catch (e) {
      throw Exception('Failed to get my played tracks: $e');
    }
  }
}
