import 'package:equatable/equatable.dart';
import '../../../domain/models/channel.dart';

abstract class ChannelState extends Equatable {
  const ChannelState();

  @override
  List<Object?> get props => [];
}

class ChannelInitial extends ChannelState {}

class ChannelLoading extends ChannelState {}

class ChannelFailure extends ChannelState {
  final String error;

  const ChannelFailure(this.error);

  @override
  List<Object> get props => [error];
}

class ChannelListLoaded extends ChannelState {
  final List<Channel> channels;

  const ChannelListLoaded(this.channels);

  @override
  List<Object> get props => [channels];
}

class ChannelCreatedSuccess extends ChannelState {
  final Channel channel;

  const ChannelCreatedSuccess(this.channel);

  @override
  List<Object> get props => [channel];
}

class ChannelJoinedSuccess extends ChannelState {}

class ChannelJoinRequestedSuccess extends ChannelState {}

class ChannelDetailsLoaded extends ChannelState {
  final Channel details;

  const ChannelDetailsLoaded(this.details);

  @override
  List<Object> get props => [details];
}

class ChannelDashboardLoaded extends ChannelState {
  final Map<String, dynamic> dashboard;

  const ChannelDashboardLoaded(this.dashboard);

  @override
  List<Object> get props => [dashboard];
}
