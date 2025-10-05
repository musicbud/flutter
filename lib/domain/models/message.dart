import 'package:equatable/equatable.dart';

/// A model class representing a chat message
class Message extends Equatable {
  final String id;
  final String channelId;
  final String senderId;
  final String senderUsername;
  final String? senderAvatarUrl;
  final String content;
  final String type; // 'text', 'image', 'audio', etc.
  final DateTime createdAt;
  final DateTime? editedAt;
  final bool isEdited;
  final bool isDeleted;
  final Map<String, dynamic>? metadata;

  const Message({
    required this.id,
    required this.channelId,
    required this.senderId,
    required this.senderUsername,
    this.senderAvatarUrl,
    required this.content,
    required this.type,
    required this.createdAt,
    this.editedAt,
    this.isEdited = false,
    this.isDeleted = false,
    this.metadata,
  });

  /// Creates a [Message] from a JSON map
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      channelId: json['channel_id'] as String,
      senderId: json['sender_id'] as String,
      senderUsername: json['sender_username'] as String,
      senderAvatarUrl: json['sender_avatar_url'] as String?,
      content: json['content'] as String,
      type: json['type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      editedAt: json['edited_at'] != null
          ? DateTime.parse(json['edited_at'] as String)
          : null,
      isEdited: json['is_edited'] as bool? ?? false,
      isDeleted: json['is_deleted'] as bool? ?? false,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Converts this [Message] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel_id': channelId,
      'sender_id': senderId,
      'sender_username': senderUsername,
      'sender_avatar_url': senderAvatarUrl,
      'content': content,
      'type': type,
      'created_at': createdAt.toIso8601String(),
      'edited_at': editedAt?.toIso8601String(),
      'is_edited': isEdited,
      'is_deleted': isDeleted,
      'metadata': metadata,
    };
  }

  @override
  List<Object?> get props => [
        id,
        channelId,
        senderId,
        senderUsername,
        senderAvatarUrl,
        content,
        type,
        createdAt,
        editedAt,
        isEdited,
        isDeleted,
        metadata,
      ];
}
