import '../../network/dio_client.dart';
import '../../../models/admin.dart';

/// Remote data source for admin operations
abstract class AdminRemoteDataSource {
  Future<List<Admin>> getAdmins();
  Future<Admin> createAdmin(Admin admin);
  Future<Admin> updateAdmin(String id, Admin admin);
  Future<void> deleteAdmin(String id);
  Future<Admin> getAdminById(String id);
  Future<AdminStats> getAdminStats();
  Future<List<AdminAction>> getRecentActions({int limit = 10});
  Future<void> performAdminAction(String action);
  Future<void> updateSystemSettings(Map<String, dynamic> settings);
  Future<Map<String, dynamic>> getSystemSettings();
  Future<Map<String, dynamic>> mergeSimilars();
  Future<Map<String, dynamic>> checkHealth();
}

/// Implementation of AdminRemoteDataSource
class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final DioClient dioClient;

  AdminRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<Admin>> getAdmins() async {
    try {
      final response = await dioClient.get('/admins');
      return (response.data as List)
          .map((json) => Admin.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch admins: $e');
    }
  }

  @override
  Future<Admin> createAdmin(Admin admin) async {
    try {
      final response = await dioClient.post(
        '/admins',
        data: admin.toJson(),
      );
      return Admin.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create admin: $e');
    }
  }

  @override
  Future<Admin> updateAdmin(String id, Admin admin) async {
    try {
      final response = await dioClient.put(
        '/admins/$id',
        data: admin.toJson(),
      );
      return Admin.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to update admin: $e');
    }
  }

  @override
  Future<void> deleteAdmin(String id) async {
    try {
      await dioClient.delete('/admins/$id');
    } catch (e) {
      throw Exception('Failed to delete admin: $e');
    }
  }

  @override
  Future<Admin> getAdminById(String id) async {
    try {
      final response = await dioClient.get('/admins/$id');
      return Admin.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch admin: $e');
    }
  }

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
  Future<List<AdminAction>> getRecentActions({int limit = 10}) async {
    try {
      final response = await dioClient.get('/admin/actions', queryParameters: {
        'limit': limit,
      });
      return (response.data as List)
          .map((json) => AdminAction.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch recent actions: $e');
    }
  }

  @override
  Future<void> performAdminAction(String action) async {
    try {
      await dioClient.post('/admin/actions', data: {
        'action': action,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to perform admin action: $e');
    }
  }

  @override
  Future<void> updateSystemSettings(Map<String, dynamic> settings) async {
    try {
      await dioClient.put('/admin/settings', data: settings);
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
      throw Exception('Failed to get system settings: $e');
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

  @override
  Future<Map<String, dynamic>> checkHealth() async {
    try {
      final response = await dioClient.get('/health');
      return response.data as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to check health: $e');
    }
  }
}