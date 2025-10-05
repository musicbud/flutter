import '../../../domain/models/admin.dart';
import '../../network/dio_client.dart';

abstract class AdminRemoteDataSource {
  Future<AdminStats> getAdminStats();
  Future<void> banUser(String userId, {String? reason});
  Future<void> unbanUser(String userId);
  Future<void> deleteContent(String contentId, String contentType);
  Future<Map<String, dynamic>> getSystemHealth();
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
}
