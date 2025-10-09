import '../../../models/admin.dart';
import '../../../models/health_response.dart';
import '../../network/dio_client.dart';

abstract class AdminRemoteDataSource {
  Future<AdminStats> getAdminStats();
  Future<void> banUser(String userId, {String? reason});
  Future<void> unbanUser(String userId);
  Future<void> deleteContent(String contentId, String contentType);
  Future<Map<String, dynamic>> getSystemHealth();
  Future<HealthResponse> checkHealth();
  Future<List<AdminAction>> getRecentActions({int limit = 10});
  Future<void> performAdminAction(AdminAction action);
  Future<void> updateSystemSettings(Map<String, dynamic> settings);
  Future<Map<String, dynamic>> getSystemSettings();
  Future<Map<String, dynamic>> mergeSimilars();
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final DioClient dioClient;

  AdminRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<AdminStats> getAdminStats() async {
    try {
      final response = await dioClient.get('/admin/stats');
      return AdminStats.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch admin stats: $e');
    }
  }

  @override
  Future<void> banUser(String userId, {String? reason}) async {
    try {
      await dioClient.post('/admin/users/$userId/ban', data: {
        'reason': reason,
      });
    } catch (e) {
      throw Exception('Failed to ban user: $e');
    }
  }

  @override
  Future<void> unbanUser(String userId) async {
    try {
      await dioClient.post('/admin/users/$userId/unban');
    } catch (e) {
      throw Exception('Failed to unban user: $e');
    }
  }

  @override
  Future<void> deleteContent(String contentId, String contentType) async {
    try {
      await dioClient.delete('/admin/content/$contentType/$contentId');
    } catch (e) {
      throw Exception('Failed to delete content: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getSystemHealth() async {
    try {
      final response = await dioClient.get('/admin/health');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch system health: $e');
    }
  }

  @override
  Future<HealthResponse> checkHealth() async {
    try {
      final response = await dioClient.post('/health');
      return HealthResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to check health: $e');
    }
  }

  @override
  Future<List<AdminAction>> getRecentActions({int limit = 10}) async {
    try {
      final response = await dioClient.get('/admin/actions', queryParameters: {'limit': limit});
      final List<dynamic> data = response.data['actions'] ?? [];
      return data.map((action) => AdminAction.fromJson(action)).toList();
    } catch (e) {
      throw Exception('Failed to fetch recent actions: $e');
    }
  }

  @override
  Future<void> performAdminAction(AdminAction action) async {
    try {
      await dioClient.post('/admin/actions', data: action.toJson());
    } catch (e) {
      throw Exception('Failed to perform admin action: $e');
    }
  }

  @override
  Future<void> updateSystemSettings(Map<String, dynamic> settings) async {
    try {
      await dioClient.post('/admin/settings', data: settings);
    } catch (e) {
      throw Exception('Failed to update system settings: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getSystemSettings() async {
    try {
      final response = await dioClient.get('/admin/settings');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to fetch system settings: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> mergeSimilars() async {
    try {
      final response = await dioClient.post('/merge-similars');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to merge similars: $e');
    }
  }
}
