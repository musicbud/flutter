import 'package:equatable/equatable.dart';

abstract class ChannelStatisticsEvent extends Equatable {
  const ChannelStatisticsEvent();

  @override
  List<Object> get props => [];
}

class ChannelStatisticsRequested extends ChannelStatisticsEvent {
  final String channelId;

  const ChannelStatisticsRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChannelStatisticsRefreshRequested extends ChannelStatisticsEvent {
  final String channelId;

  const ChannelStatisticsRefreshRequested(this.channelId);

  @override
  List<Object> get props => [channelId];
}

class ChannelStatisticsRefreshed extends ChannelStatisticsEvent {
  final String channelId;

  const ChannelStatisticsRefreshed(this.channelId);

  @override
  List<Object> get props => [channelId];
}
