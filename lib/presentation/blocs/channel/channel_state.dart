import 'package:equatable/equatable.dart';
import '../../../models/channel.dart';
import '../../../models/channel_stats.dart';
import '../../../models/channel_user.dart';

abstract class ChannelState extends Equatable {
  const ChannelState();

  @override
  List<Object?> get props => [];
}

class ChannelInitial extends ChannelState {}

class ChannelLoading extends ChannelState {}

class ChannelsLoaded extends ChannelState {
  final List<Channel> channels;

  const ChannelsLoaded(this.channels);

  @override
  List<Object?> get props => [channels];
}

class SingleChannelLoaded extends ChannelState {
  final Channel channel;

  const SingleChannelLoaded(this.channel);

  @override
  List<Object?> get props => [channel];
}

class ChannelMembersLoaded extends ChannelState {
  final List<ChannelUser> members;

  const ChannelMembersLoaded(this.members);

  @override
  List<Object?> get props => [members];
}

class ChannelStatsLoaded extends ChannelState {
  final ChannelStats stats;

  const ChannelStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class ChannelOperationSuccess extends ChannelState {
  final String message;

  const ChannelOperationSuccess([this.message = 'Operation completed successfully']);

  @override
  List<Object?> get props => [message];
}

class ChannelError extends ChannelState {
  final String message;

  const ChannelError(this.message);

  @override
  List<Object?> get props => [message];
}
