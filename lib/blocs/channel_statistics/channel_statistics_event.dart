import 'package:equatable/equatable.dart';

abstract class ChannelStatisticsEvent extends Equatable {
  const ChannelStatisticsEvent();

  @override
  List<Object> get props => [];
}

class ChannelStatisticsRequested extends ChannelStatisticsEvent {
  final int channelId;

  const ChannelStatisticsRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChannelStatisticsRefreshRequested extends ChannelStatisticsEvent {
  final int channelId;

  const ChannelStatisticsRefreshRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}
