import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/constants/api_constants.dart';
import '../../../core/error/exceptions.dart';

abstract class NotificationRemoteDataSource {
  // Notification operations
  Future<List<Map<String, dynamic>>> getNotifications();
  Future<void> markNotificationAsRead(String notificationId);
  Future<void> markAllNotificationsAsRead();
  Future<void> deleteNotification(String notificationId);
  Future<void> deleteAllNotifications();
  Future<void> updateNotificationSettings(Map<String, dynamic> settings);
  Future<Map<String, dynamic>> getNotificationSettings();

  // Push notification operations
  Future<void> registerPushToken(String token, String deviceType);
  Future<void> unregisterPushToken(String token);
  Future<void> updatePushPreferences(Map<String, bool> preferences);
  Future<Map<String, bool>> getPushPreferences();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final http.Client client;
  final String token;

  NotificationRemoteDataSourceImpl({required this.client, required this.token});

  @override
  Future<List<Map<String, dynamic>>> getNotifications() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/notifications/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw ServerException(message: 'Failed to get notifications');
    }
  }

  @override
  Future<void> markNotificationAsRead(String notificationId) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/notifications/$notificationId/read/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to mark notification as read');
    }
  }

  @override
  Future<void> markAllNotificationsAsRead() async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/notifications/read-all/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw ServerException(
          message: 'Failed to mark all notifications as read');
    }
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    final response = await client.delete(
      Uri.parse('${ApiConstants.baseUrl}/notifications/$notificationId/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to delete notification');
    }
  }

  @override
  Future<void> deleteAllNotifications() async {
    final response = await client.delete(
      Uri.parse('${ApiConstants.baseUrl}/notifications/delete-all/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to delete all notifications');
    }
  }

  @override
  Future<void> updateNotificationSettings(Map<String, dynamic> settings) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/notifications/settings/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(settings),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to update notification settings');
    }
  }

  @override
  Future<Map<String, dynamic>> getNotificationSettings() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/notifications/settings/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw ServerException(message: 'Failed to get notification settings');
    }
  }

  @override
  Future<void> registerPushToken(String pushToken, String deviceType) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/notifications/push/register/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'token': pushToken,
        'device_type': deviceType,
      }),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to register push token');
    }
  }

  @override
  Future<void> unregisterPushToken(String pushToken) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/notifications/push/unregister/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'token': pushToken,
      }),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to unregister push token');
    }
  }

  @override
  Future<void> updatePushPreferences(Map<String, bool> preferences) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/notifications/push/preferences/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(preferences),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to update push preferences');
    }
  }

  @override
  Future<Map<String, bool>> getPushPreferences() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/notifications/push/preferences/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Map<String, bool>.from(data);
    } else {
      throw ServerException(message: 'Failed to get push preferences');
    }
  }
}
