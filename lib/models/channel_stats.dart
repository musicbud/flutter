import 'package:equatable/equatable.dart';

/// Channel statistics model
class ChannelStats extends Equatable {
  final String channelId;
  final int memberCount;
  final int messageCount;
  final int activeUsers;
  final DateTime? lastActivityAt;
  final Map<String, int> messagesByDay;
  final List<TopContributor> topContributors;

  const ChannelStats({
    required this.channelId,
    required this.memberCount,
    required this.messageCount,
    required this.activeUsers,
    this.lastActivityAt,
    this.messagesByDay = const {},
    this.topContributors = const [],
  });

  factory ChannelStats.fromJson(Map<String, dynamic> json) {
    return ChannelStats(
      channelId: json['channel_id'] as String,
      memberCount: json['member_count'] as int? ?? 0,
      messageCount: json['message_count'] as int? ?? 0,
      activeUsers: json['active_users'] as int? ?? 0,
      lastActivityAt: json['last_activity_at'] != null
          ? DateTime.parse(json['last_activity_at'] as String)
          : null,
      messagesByDay: (json['messages_by_day'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, value as int)) ??
          const {},
      topContributors: (json['top_contributors'] as List<dynamic>?)
              ?.map((e) => TopContributor.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'channel_id': channelId,
      'member_count': memberCount,
      'message_count': messageCount,
      'active_users': activeUsers,
      if (lastActivityAt != null) 'last_activity_at': lastActivityAt!.toIso8601String(),
      'messages_by_day': messagesByDay,
      'top_contributors': topContributors.map((e) => e.toJson()).toList(),
    };
  }

  // Getter for totalParticipants (alias for memberCount for compatibility)
  int get totalParticipants => memberCount;

  // Getter for metrics (for compatibility with existing code)
  Map<String, dynamic> get metrics => {
        'memberCount': memberCount,
        'messageCount': messageCount,
        'activeUsers': activeUsers,
        'messagesByDay': messagesByDay,
      };

  /// Creates a copy of this [ChannelStats] with the given fields replaced with new values
  ChannelStats copyWith({
    String? channelId,
    int? memberCount,
    int? messageCount,
    int? activeUsers,
    DateTime? lastActivityAt,
    Map<String, int>? messagesByDay,
    List<TopContributor>? topContributors,
  }) {
    return ChannelStats(
      channelId: channelId ?? this.channelId,
      memberCount: memberCount ?? this.memberCount,
      messageCount: messageCount ?? this.messageCount,
      activeUsers: activeUsers ?? this.activeUsers,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      messagesByDay: messagesByDay ?? this.messagesByDay,
      topContributors: topContributors ?? this.topContributors,
    );
  }

  @override
  List<Object?> get props => [
         channelId,
         memberCount,
         messageCount,
         activeUsers,
         lastActivityAt,
         messagesByDay,
         topContributors,
       ];
}

class TopContributor extends Equatable {
  final String userId;
  final String username;
  final int messageCount;
  final String? avatarUrl;

  const TopContributor({
    required this.userId,
    required this.username,
    required this.messageCount,
    this.avatarUrl,
  });

  factory TopContributor.fromJson(Map<String, dynamic> json) {
    return TopContributor(
      userId: json['user_id'] as String,
      username: json['username'] as String,
      messageCount: json['message_count'] as int? ?? 0,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'message_count': messageCount,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    };
  }

  @override
  List<Object?> get props => [userId, username, messageCount, avatarUrl];
}
