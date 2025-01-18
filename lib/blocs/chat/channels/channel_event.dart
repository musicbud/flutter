import 'package:equatable/equatable.dart';

abstract class ChannelEvent extends Equatable {
  const ChannelEvent();

  @override
  List<Object?> get props => [];
}

class ChannelListRequested extends ChannelEvent {}

class ChannelCreated extends ChannelEvent {
  final Map<String, dynamic> channelData;

  const ChannelCreated(this.channelData);

  @override
  List<Object> get props => [channelData];
}

class ChannelJoined extends ChannelEvent {
  final String channelId;

  const ChannelJoined(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChannelJoinRequested extends ChannelEvent {
  final int channelId;

  const ChannelJoinRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChannelDetailsRequested extends ChannelEvent {
  final int channelId;

  const ChannelDetailsRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChannelDashboardRequested extends ChannelEvent {
  final int channelId;

  const ChannelDashboardRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}
