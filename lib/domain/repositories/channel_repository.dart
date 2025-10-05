import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../models/channel.dart';
import '../models/channel_settings.dart';
import '../models/channel_stats.dart';

abstract class ChannelRepository {
  // Channel CRUD operations
  Future<Either<Failure, List<Channel>>> getChannels({int? limit, int? offset});
  Future<Either<Failure, Channel>> getChannelById(String id);
  Future<Either<Failure, Channel>> createChannel(Channel channel);
  Future<Either<Failure, Channel>> updateChannel(String channelId, Channel channel);
  Future<Either<Failure, void>> deleteChannel(String id);

  // Channel membership operations
  Future<Either<Failure, void>> joinChannel(String channelId);
  Future<Either<Failure, void>> leaveChannel(String channelId);
  Future<Either<Failure, List<String>>> getChannelMembers(String channelId);
  
  // Channel moderation operations
  Future<Either<Failure, void>> addModerator(String channelId, String userId);
  Future<Either<Failure, void>> removeModerator(String channelId, String userId);
  Future<Either<Failure, void>> updateChannelSettings(String channelId, ChannelSettings settings);
  
  // Channel content operations
  Future<Either<Failure, void>> muteChannel(String channelId);
  Future<Either<Failure, void>> unmuteChannel(String channelId);
  Future<Either<Failure, ChannelStats>> getChannelStats(String channelId);
}
