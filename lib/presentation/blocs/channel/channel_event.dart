import 'package:equatable/equatable.dart';
import '../../../models/channel.dart';
import '../../../models/channel_settings.dart';

abstract class ChannelEvent extends Equatable {
  const ChannelEvent();

  @override
  List<Object?> get props => [];
}

class GetChannelsEvent extends ChannelEvent {
  final int? limit;
  final int? offset;

  const GetChannelsEvent({this.limit, this.offset});

  @override
  List<Object?> get props => [limit, offset];
}

class GetChannelByIdEvent extends ChannelEvent {
  final String id;

  const GetChannelByIdEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateChannelEvent extends ChannelEvent {
  final Channel channel;

  const CreateChannelEvent(this.channel);

  @override
  List<Object?> get props => [channel];
}

class UpdateChannelEvent extends ChannelEvent {
  final Channel channel;

  const UpdateChannelEvent(this.channel);

  @override
  List<Object?> get props => [channel];
}

class DeleteChannelEvent extends ChannelEvent {
  final String id;

  const DeleteChannelEvent(this.id);

  @override
  List<Object?> get props => [id];
}

class JoinChannelEvent extends ChannelEvent {
  final String channelId;

  const JoinChannelEvent(this.channelId);

  @override
  List<Object?> get props => [channelId];
}

class LeaveChannelEvent extends ChannelEvent {
  final String channelId;

  const LeaveChannelEvent(this.channelId);

  @override
  List<Object?> get props => [channelId];
}

class GetChannelMembersEvent extends ChannelEvent {
  final String channelId;

  const GetChannelMembersEvent(this.channelId);

  @override
  List<Object?> get props => [channelId];
}

class AddModeratorEvent extends ChannelEvent {
  final String channelId;
  final String userId;

  const AddModeratorEvent(this.channelId, this.userId);

  @override
  List<Object?> get props => [channelId, userId];
}

class RemoveModeratorEvent extends ChannelEvent {
  final String channelId;
  final String userId;

  const RemoveModeratorEvent(this.channelId, this.userId);

  @override
  List<Object?> get props => [channelId, userId];
}

class UpdateChannelSettingsEvent extends ChannelEvent {
  final String channelId;
  final ChannelSettings settings;

  const UpdateChannelSettingsEvent(this.channelId, this.settings);

  @override
  List<Object?> get props => [channelId, settings];
}

class MuteChannelEvent extends ChannelEvent {
  final String channelId;

  const MuteChannelEvent(this.channelId);

  @override
  List<Object?> get props => [channelId];
}

class UnmuteChannelEvent extends ChannelEvent {
  final String channelId;

  const UnmuteChannelEvent(this.channelId);

  @override
  List<Object?> get props => [channelId];
}

class GetChannelStatsEvent extends ChannelEvent {
  final String channelId;

  const GetChannelStatsEvent(this.channelId);

  @override
  List<Object?> get props => [channelId];
}
