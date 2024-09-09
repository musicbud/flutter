import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChatService {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  ChatService(String baseUrl)
      : _dio = Dio(BaseOptions(
          baseUrl: baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          connectTimeout: Duration(seconds: 5),
          receiveTimeout: Duration(seconds: 3),
        )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // Append access token to every request
        final String? accessToken = await _secureStorage.read(key: 'access_token');
        if (accessToken != null) {
          options.headers['Authorization'] = 'Bearer $accessToken';
        }
        print('Request URL: ${options.baseUrl}${options.path}');
        print('Request Method: ${options.method}');
        print('Request Headers: ${options.headers}');
        print('Request Data: ${options.data}');
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('Response Status Code: ${response.statusCode}');
        print('Response Data: ${response.data}');
        return handler.next(response);
      },
      onError: (DioError e, handler) async {
        print('Error: ${e.error}');
        print('Error Type: ${e.type}');
        print('Error Message: ${e.message}');
        if (e.response != null) {
          print('Error Response Status: ${e.response?.statusCode}');
          print('Error Response Data: ${e.response?.data}');
        }
        // If the error is 401 Unauthorized, try to refresh the token
        if (e.response?.statusCode == 401) {
          if (await _refreshToken()) {
            // Retry the original request
            return handler.resolve(await _retry(e.requestOptions));
          }
        }
        return handler.next(e);
      },
    ));
  }

  Future<Response> login(String username, String password) async {
    try {
      print('Attempting login for user: $username');
      final response = await _dio.post('/chat/login/', data: {'username': username, 'password': password});
      print('Login response received');
      
      // Store tokens in secure storage
      if (response.data['tokens'] != null) {
        await _secureStorage.write(key: 'access_token', value: response.data['tokens']['access']);
        await _secureStorage.write(key: 'refresh_token', value: response.data['tokens']['refresh']);
      }
      
      return response;
    } catch (e) {
      print('Exception caught in login method:');
      if (e is DioError) {
        print('DioError details:');
        print('  Type: ${e.type}');
        print('  Message: ${e.message}');
        if (e.response != null) {
          print('  Response status: ${e.response?.statusCode}');
          print('  Response data: ${e.response?.data}');
        }
        print('  Request details:');
        print('    URL: ${e.requestOptions.baseUrl}${e.requestOptions.path}');
        print('    Method: ${e.requestOptions.method}');
        print('    Headers: ${e.requestOptions.headers}');
        print('    Data: ${e.requestOptions.data}');
      } else {
        print('Non-DioError exception: $e');
      }
      rethrow;
    }
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.read(key: 'refresh_token');
      if (refreshToken == null) {
        return false;
      }
      final response = await _dio.post('/chat/refresh-token/', data: {'refresh': refreshToken});
      if (response.statusCode == 200 && response.data['access'] != null) {
        await _secureStorage.write(key: 'access_token', value: response.data['access']);
        return true;
      }
    } catch (e) {
      print('Error refreshing token: $e');
    }
    return false;
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<Response> getChannelList() async {
    return await _dio.get('/chat/get_channels/');
  }

  Future<Response> joinChannel(String channelId) async {
    return await _dio.post('/chat/channels/$channelId/join');
  }

  Future<Response> sendMessageData(Map<String, dynamic> messageData) async {
    return await _dio.post('/chat/send_message/', data: messageData);
  }

  Future<Response> performAction(String action, String channelId, String userId) async {
    return await _dio.post('/chat/channel/$channelId/$action/$userId/');
  }

  Future<Response> createChannel(Map<String, dynamic> channelData) async {
    return await _dio.post('/chat/channels', data: channelData);
  }

  Future<Response> refreshToken(String refreshToken) async {
    return await _dio.post('/chat/refresh-token/', data: {'refresh_token': refreshToken});
  }

  Future<Response> register(Map<String, dynamic> data) async {
    return await _dio.post('/chat/register/', data: data);
  }

  Future<Response> getChannelDetails(String channelId) async {
    return await _dio.get('/chat/channel/$channelId/');
  }

  Future<Response> requestJoinChannel(String channelId) async {
    return await _dio.post('/chat/channel/$channelId/request_join/');
  }

  Future<Response> getChannelStatistics(String channelId) async {
    return await _dio.get('/chat/channel/$channelId/statistics/');
  }

  Future<Response> getChannelMessages(String channelId) async {
    return await _dio.get('/chat/get_channel_messages/$channelId/');
  }

  Future<Response> getUserMessages(String userUsername, String otherUsername) async {
    return await _dio.get('/chat/get_user_messages/$userUsername/$otherUsername/');
  }

  Future<Response> addChannelMember(String channelId, String username) async {
    return await _dio.post('/chat/add_channel_member/$channelId/', data: {'username': username});
  }

  Future<Response> getUsers() async {
    return await _dio.get('/chat/get_users/');
  }

  Future<Response> getUserChannels(String userId) async {
    return await _dio.get('/chat/get_user_channels/$userId/');
  }

  Future<Response> getChannelUsers(String channelId) async {
    return await _dio.get('/chat/get_channel_users/$channelId/');
  }

  Future<Response> getChannelInvitations(String channelId) async {
    return await _dio.get('/chat/get_channel_invitations/$channelId/');
  }

  Future<Response> getUserInvitations(String userId) async {
    return await _dio.get('/chat/get_user_invitations/$userId/');
  }

  Future<Response> getChannelBlockedUsers(String channelId) async {
    return await _dio.get('/chat/get_channel_blocked_users/$channelId/');
  }

  Future<Response> makeAdmin(String channelId, String userId) async {
    return await _dio.post('/chat/channel/$channelId/make_admin/$userId/');
  }

  Future<Response> removeAdmin(String channelId, String userId) async {
    return await _dio.post('/chat/channel/$channelId/remove_admin/$userId/');
  }

  Future<Response> addModerator(String channelId, String userId) async {
    return await _dio.post('/chat/channel/$channelId/add_moderator/$userId/');
  }

  Future<Response> removeModerator(String channelId, String userId) async {
    return await _dio.post('/chat/channel/$channelId/remove_moderator/$userId/');
  }

  Future<Response> blockUser(String channelId, String userId) async {
    return await _dio.post('/chat/channel/$channelId/block/$userId/');
  }

  Future<Response> unblockUser(String channelId, String userId) async {
    return await _dio.post('/chat/channel/$channelId/unblock/$userId/');
  }

  Future<Response> acceptUser(String channelId, String userId) async {
    return await _dio.post('/chat/channel/$channelId/accept_user/$userId/');
  }

  Future<Response> kickUser(String channelId, String userId) async {
    return await _dio.post('/chat/channel/$channelId/kick/$userId/');
  }

  Future<Response> handleInvitation(String invitationId, String action) async {
    return await _dio.post('/chat/handle_invitation/$invitationId/$action/');
  }

  Future<Response> getMessages(String roomName) async {
    return await _dio.get('/chat/get_messages/$roomName/');
  }

  Future<Response> sendUserMessage(Map<String, dynamic> data) async {
    return await _dio.post('/chat/send_user_message/', data: data);
  }

  Future<Response> performChannelAction(String channelId, String action, String userId) async {
    return await _dio.post('/chat/channel/$channelId/$action/$userId/');
  }
}
