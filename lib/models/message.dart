import 'package:equatable/equatable.dart';

/// A model class representing a chat message
class Message extends Equatable {
  final int id;
  final String channelId;
  final String userId;
  final String content;
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.channelId,
    required this.userId,
    required this.content,
    required this.timestamp,
  });

  DateTime get createdAt => timestamp;

  /// Creates a [Message] from a JSON map
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      channelId: json['channel_id'] as String,
      userId: json['user_id'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Converts this [Message] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'channel_id': channelId,
      'user_id': userId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Creates a copy of this [Message] with the given fields replaced with new values
  Message copyWith({
    int? id,
    String? channelId,
    String? userId,
    String? content,
    DateTime? timestamp,
  }) {
    return Message(
      id: id ?? this.id,
      channelId: channelId ?? this.channelId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [
         id,
         channelId,
         userId,
         content,
         timestamp,
       ];
}
