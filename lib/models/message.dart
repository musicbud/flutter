class Message {
  final int id;
  final String channelId;
  final String content;
  final String senderUsername;
  final String? senderDisplayName;
  final String? senderAvatarUrl;
  final DateTime createdAt;
  final DateTime? editedAt;
  final bool isDeleted;

  Message({
    required this.id,
    required this.channelId,
    required this.content,
    required this.senderUsername,
    this.senderDisplayName,
    this.senderAvatarUrl,
    required this.createdAt,
    this.editedAt,
    this.isDeleted = false,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      channelId: json['channel_id'] as String,
      content: json['content'] as String,
      senderUsername: json['sender_username'] as String,
      senderDisplayName: json['sender_display_name'] as String?,
      senderAvatarUrl: json['sender_avatar_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      editedAt: json['edited_at'] != null
          ? DateTime.parse(json['edited_at'] as String)
          : null,
      isDeleted: json['is_deleted'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel_id': channelId,
      'content': content,
      'sender_username': senderUsername,
      'sender_display_name': senderDisplayName,
      'sender_avatar_url': senderAvatarUrl,
      'created_at': createdAt.toIso8601String(),
      'edited_at': editedAt?.toIso8601String(),
      'is_deleted': isDeleted,
    };
  }
}
