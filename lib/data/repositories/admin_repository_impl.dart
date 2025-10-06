import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../models/admin.dart';
import '../../domain/repositories/admin_repository.dart';
import '../data_sources/remote/admin_remote_data_source.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AdminRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, AdminStats>> getAdminStats() async {
    if (await networkInfo.isConnected) {
      try {
        final stats = await remoteDataSource.getAdminStats();
        return Right(stats);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<AdminAction>>> getRecentActions({int limit = 10}) async {
    if (await networkInfo.isConnected) {
      try {
        final actions = await remoteDataSource.getRecentActions(limit: limit);
        return Right(actions);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> performAdminAction(AdminAction action) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.performAdminAction(action);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateSystemSettings(Map<String, dynamic> settings) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateSystemSettings(settings);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSystemSettings() async {
    if (await networkInfo.isConnected) {
      try {
        final settings = await remoteDataSource.getSystemSettings();
        return Right(settings);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
