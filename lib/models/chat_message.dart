class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String senderUsername;
  final String? senderAvatarUrl;
  final String content;
  final bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderUsername,
    this.senderAvatarUrl,
    required this.content,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      chatId: json['chat_id'] as String,
      senderId: json['sender_id'] as String,
      senderUsername: json['sender_username'] as String,
      senderAvatarUrl: json['sender_avatar_url'] as String?,
      content: json['content'] as String,
      isRead: json['is_read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'sender_username': senderUsername,
      if (senderAvatarUrl != null) 'sender_avatar_url': senderAvatarUrl,
      'content': content,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  ChatMessage copyWith({
    String? id,
    String? chatId,
    String? senderId,
    String? senderUsername,
    String? senderAvatarUrl,
    String? content,
    bool? isRead,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      senderId: senderId ?? this.senderId,
      senderUsername: senderUsername ?? this.senderUsername,
      senderAvatarUrl: senderAvatarUrl ?? this.senderAvatarUrl,
      content: content ?? this.content,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
