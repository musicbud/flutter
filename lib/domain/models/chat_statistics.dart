class ChatStatistics {
  final String chatId;
  final int totalMessages;
  final int totalParticipants;
  final int activeParticipants;
  final DateTime lastActivityAt;
  final Map<String, int> messagesByUser;
  final Map<String, DateTime> lastActivityByUser;

  ChatStatistics({
    required this.chatId,
    required this.totalMessages,
    required this.totalParticipants,
    required this.activeParticipants,
    required this.lastActivityAt,
    required this.messagesByUser,
    required this.lastActivityByUser,
  });

  factory ChatStatistics.fromJson(Map<String, dynamic> json) {
    return ChatStatistics(
      chatId: json['chat_id'] as String,
      totalMessages: json['total_messages'] as int,
      totalParticipants: json['total_participants'] as int,
      activeParticipants: json['active_participants'] as int,
      lastActivityAt: DateTime.parse(json['last_activity_at'] as String),
      messagesByUser: Map<String, int>.from(json['messages_by_user'] as Map),
      lastActivityByUser:
          (json['last_activity_by_user'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, DateTime.parse(value as String)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chat_id': chatId,
      'total_messages': totalMessages,
      'total_participants': totalParticipants,
      'active_participants': activeParticipants,
      'last_activity_at': lastActivityAt.toIso8601String(),
      'messages_by_user': messagesByUser,
      'last_activity_by_user': lastActivityByUser.map(
        (key, value) => MapEntry(key, value.toIso8601String()),
      ),
    };
  }

  ChatStatistics copyWith({
    String? chatId,
    int? totalMessages,
    int? totalParticipants,
    int? activeParticipants,
    DateTime? lastActivityAt,
    Map<String, int>? messagesByUser,
    Map<String, DateTime>? lastActivityByUser,
  }) {
    return ChatStatistics(
      chatId: chatId ?? this.chatId,
      totalMessages: totalMessages ?? this.totalMessages,
      totalParticipants: totalParticipants ?? this.totalParticipants,
      activeParticipants: activeParticipants ?? this.activeParticipants,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      messagesByUser: messagesByUser ?? this.messagesByUser,
      lastActivityByUser: lastActivityByUser ?? this.lastActivityByUser,
    );
  }
}
