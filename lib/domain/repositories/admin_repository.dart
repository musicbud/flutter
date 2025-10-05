import 'package:dartz/dartz.dart';
import '../models/admin.dart';
import '../../core/error/failures.dart';

abstract class AdminRepository {
  Future<Either<Failure, AdminStats>> getAdminStats();
  Future<Either<Failure, List<AdminAction>>> getRecentActions({int limit = 10});
  Future<Either<Failure, void>> performAdminAction(AdminAction action);
  Future<Either<Failure, void>> updateSystemSettings(Map<String, dynamic> settings);
  Future<Either<Failure, Map<String, dynamic>>> getSystemSettings();
}
