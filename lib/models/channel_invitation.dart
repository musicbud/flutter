import 'package:equatable/equatable.dart';
import 'channel.dart';
import 'user_profile.dart';

class ChannelInvitation extends Equatable {
  final String id;
  final Channel channel;
  final UserProfile inviter;
  final UserProfile invitee;
  final String status;
  final DateTime createdAt;
  final DateTime? respondedAt;

  const ChannelInvitation({
    required this.id,
    required this.channel,
    required this.inviter,
    required this.invitee,
    required this.status,
    required this.createdAt,
    this.respondedAt,
  });

  factory ChannelInvitation.fromJson(Map<String, dynamic> json) {
    return ChannelInvitation(
      id: json['id'] as String,
      channel: Channel.fromJson(json['channel'] as Map<String, dynamic>),
      inviter: UserProfile.fromJson(json['inviter'] as Map<String, dynamic>),
      invitee: UserProfile.fromJson(json['invitee'] as Map<String, dynamic>),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      respondedAt: json['respondedAt'] != null
          ? DateTime.parse(json['respondedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'channel': channel.toJson(),
        'inviter': inviter.toJson(),
        'invitee': invitee.toJson(),
        'status': status,
        'createdAt': createdAt.toIso8601String(),
        'respondedAt': respondedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [
        id,
        channel,
        inviter,
        invitee,
        status,
        createdAt,
        respondedAt,
      ];
}
