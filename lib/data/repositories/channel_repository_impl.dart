import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../core/network/network_info.dart';
import '../../domain/models/channel.dart';
import '../../domain/models/channel_settings.dart';
import '../../domain/models/channel_stats.dart';
import '../../domain/repositories/channel_repository.dart';
import '../datasources/channel_remote_data_source.dart';

class ChannelRepositoryImpl implements ChannelRepository {
  final ChannelRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ChannelRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Channel>>> getChannels({int? limit, int? offset}) async {
    if (await networkInfo.isConnected) {
      try {
        final channels = await remoteDataSource.getChannels(limit: limit, offset: offset);
        return Right(channels);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Channel>> getChannelById(String id) async {
    if (await networkInfo.isConnected) {
      try {
        final channel = await remoteDataSource.getChannelById(id);
        return Right(channel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Channel>> createChannel(Channel channel) async {
    if (await networkInfo.isConnected) {
      try {
        final createdChannel = await remoteDataSource.createChannel(channel);
        return Right(createdChannel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, Channel>> updateChannel(String channelId, Channel channel) async {
    if (await networkInfo.isConnected) {
      try {
        final updatedChannel = await remoteDataSource.updateChannel(channel);
        return Right(updatedChannel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteChannel(String channelId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteChannel(channelId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> joinChannel(String channelId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.joinChannel(channelId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> leaveChannel(String channelId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.leaveChannel(channelId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getChannelMembers(String channelId) async {
    if (await networkInfo.isConnected) {
      try {
        final members = await remoteDataSource.getChannelMembers(channelId);
        return Right(members);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> addModerator(String channelId, String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addModerator(channelId, userId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> removeModerator(String channelId, String userId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.removeModerator(channelId, userId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> updateChannelSettings(String channelId, ChannelSettings settings) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.updateChannelSettings(channelId, settings);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> muteChannel(String channelId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.muteChannel(channelId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> unmuteChannel(String channelId) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.unmuteChannel(channelId);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, ChannelStats>> getChannelStats(String channelId) async {
    if (await networkInfo.isConnected) {
      try {
        final stats = await remoteDataSource.getChannelStats(channelId);
        return Right(stats);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      }
    } else {
      return const Left(NetworkFailure(message: 'No internet connection'));
    }
  }
}
