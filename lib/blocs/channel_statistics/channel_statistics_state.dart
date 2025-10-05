import 'package:equatable/equatable.dart';

abstract class ChannelStatisticsState extends Equatable {
  const ChannelStatisticsState();

  @override
  List<Object> get props => [];
}

class ChannelStatisticsInitial extends ChannelStatisticsState {}

class ChannelStatisticsLoading extends ChannelStatisticsState {}

class ChannelStatisticsLoaded extends ChannelStatisticsState {
  final Map<String, dynamic> statistics;

  const ChannelStatisticsLoaded(this.statistics);

  @override
  List<Object> get props => [statistics];
}

class ChannelStatisticsFailure extends ChannelStatisticsState {
  final String error;

  const ChannelStatisticsFailure(this.error);

  @override
  List<Object> get props => [error];
}
