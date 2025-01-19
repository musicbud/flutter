import 'package:equatable/equatable.dart';
import 'channel.dart';
import 'channel_user.dart';

class ChannelDetails extends Equatable {
  final Channel channel;
  final List<ChannelUser> members;
  final List<ChannelUser> moderators;
  final List<ChannelUser> admins;
  final int totalMessages;
  final int activeMembers;

  const ChannelDetails({
    required this.channel,
    required this.members,
    required this.moderators,
    required this.admins,
    required this.totalMessages,
    required this.activeMembers,
  });

  factory ChannelDetails.fromJson(Map<String, dynamic> json) {
    return ChannelDetails(
      channel: Channel.fromJson(json['channel'] as Map<String, dynamic>),
      members: (json['members'] as List<dynamic>)
          .map((e) => ChannelUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      moderators: (json['moderators'] as List<dynamic>)
          .map((e) => ChannelUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      admins: (json['admins'] as List<dynamic>)
          .map((e) => ChannelUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalMessages: json['totalMessages'] as int,
      activeMembers: json['activeMembers'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'channel': channel.toJson(),
        'members': members.map((e) => e.toJson()).toList(),
        'moderators': moderators.map((e) => e.toJson()).toList(),
        'admins': admins.map((e) => e.toJson()).toList(),
        'totalMessages': totalMessages,
        'activeMembers': activeMembers,
      };

  @override
  List<Object?> get props => [
        channel,
        members,
        moderators,
        admins,
        totalMessages,
        activeMembers,
      ];
}
