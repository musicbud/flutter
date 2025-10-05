import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/error/exceptions.dart';
import '../../domain/models/admin.dart';
import '../../config/constants.dart';

abstract class AdminRemoteDataSource {
  Future<AdminStats> getAdminStats();
  Future<List<AdminAction>> getRecentActions({int limit = 10});
  Future<void> performAdminAction(AdminAction action);
  Future<void> updateSystemSettings(Map<String, dynamic> settings);
  Future<Map<String, dynamic>> getSystemSettings();
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final http.Client client;

  AdminRemoteDataSourceImpl({required this.client});

  @override
  Future<AdminStats> getAdminStats() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/admin/stats'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return AdminStats.fromJson(json.decode(response.body));
    } else {
      throw ServerException(message: 'Failed to fetch admin stats: ${response.statusCode}');
    }
  }

  @override
  Future<List<AdminAction>> getRecentActions({int limit = 10}) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/admin/actions?limit=$limit'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => AdminAction.fromJson(json)).toList();
    } else {
      throw ServerException(message: 'Failed to fetch recent admin actions: ${response.statusCode}');
    }
  }

  @override
  Future<void> performAdminAction(AdminAction action) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}/admin/actions'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(action.toJson()),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to perform admin action: ${response.statusCode}');
    }
  }

  @override
  Future<void> updateSystemSettings(Map<String, dynamic> settings) async {
    final response = await client.put(
      Uri.parse('${ApiConstants.baseUrl}/admin/settings'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(settings),
    );

    if (response.statusCode != 200) {
      throw ServerException(message: 'Failed to update system settings: ${response.statusCode}');
    }
  }

  @override
  Future<Map<String, dynamic>> getSystemSettings() async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}/admin/settings'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(json.decode(response.body));
    } else {
      throw ServerException(message: 'Failed to fetch system settings: ${response.statusCode}');
    }
  }
}
