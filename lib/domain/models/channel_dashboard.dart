import 'package:equatable/equatable.dart';
import 'message.dart';
import 'channel_user.dart';

class ChannelDashboard extends Equatable {
  final List<Message> recentMessages;
  final List<ChannelUser> activeUsers;
  final Map<String, int> messageStats;
  final Map<String, int> userStats;

  const ChannelDashboard({
    required this.recentMessages,
    required this.activeUsers,
    required this.messageStats,
    required this.userStats,
  });

  factory ChannelDashboard.fromJson(Map<String, dynamic> json) {
    return ChannelDashboard(
      recentMessages: (json['recentMessages'] as List<dynamic>)
          .map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
      activeUsers: (json['activeUsers'] as List<dynamic>)
          .map((e) => ChannelUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      messageStats: Map<String, int>.from(json['messageStats'] as Map),
      userStats: Map<String, int>.from(json['userStats'] as Map),
    );
  }

  Map<String, dynamic> toJson() => {
        'recentMessages': recentMessages.map((e) => e.toJson()).toList(),
        'activeUsers': activeUsers.map((e) => e.toJson()).toList(),
        'messageStats': messageStats,
        'userStats': userStats,
      };

  @override
  List<Object?> get props => [
        recentMessages,
        activeUsers,
        messageStats,
        userStats,
      ];
}
