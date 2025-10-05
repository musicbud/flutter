class Chat {
  final String userId;
  final String username;
  final String lastMessage;
  final DateTime lastMessageTimestamp;
  final bool isRead;
  final bool isArchived;
  final String? avatarUrl;

  const Chat({
    required this.userId,
    required this.username,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    this.isRead = false,
    this.isArchived = false,
    this.avatarUrl,
  });

  Chat copyWith({
    String? userId,
    String? username,
    String? lastMessage,
    DateTime? lastMessageTimestamp,
    bool? isRead,
    bool? isArchived,
    String? avatarUrl,
  }) {
    return Chat(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTimestamp: lastMessageTimestamp ?? this.lastMessageTimestamp,
      isRead: isRead ?? this.isRead,
      isArchived: isArchived ?? this.isArchived,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      userId: json['user_id'] as String,
      username: json['username'] as String,
      lastMessage: json['last_message'] as String,
      lastMessageTimestamp:
          DateTime.parse(json['last_message_timestamp'] as String),
      isRead: json['is_read'] as bool? ?? false,
      isArchived: json['is_archived'] as bool? ?? false,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'last_message': lastMessage,
      'last_message_timestamp': lastMessageTimestamp.toIso8601String(),
      'is_read': isRead,
      'is_archived': isArchived,
      'avatar_url': avatarUrl,
    };
  }
}
