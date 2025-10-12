import 'package:equatable/equatable.dart';

/// Model representing a conversation/chat
class Conversation extends Equatable {
  final String id;
  final String otherUserName;
  final String? otherUserAvatar;
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;
  final bool isOtherUserOnline;
  final String? lastMessageSender;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Conversation({
    required this.id,
    required this.otherUserName,
    this.otherUserAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isOtherUserOnline = false,
    this.lastMessageSender,
    this.createdAt,
    this.updatedAt,
  });

  /// Create from JSON
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      otherUserName: json['otherUserName'] as String,
      otherUserAvatar: json['otherUserAvatar'] as String?,
      lastMessage: json['lastMessage'] as String,
      lastMessageTime: json['lastMessageTime'] as String,
      unreadCount: json['unreadCount'] as int? ?? 0,
      isOtherUserOnline: json['isOtherUserOnline'] as bool? ?? false,
      lastMessageSender: json['lastMessageSender'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'otherUserName': otherUserName,
      'otherUserAvatar': otherUserAvatar,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
      'unreadCount': unreadCount,
      'isOtherUserOnline': isOtherUserOnline,
      'lastMessageSender': lastMessageSender,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  /// Copy with method for immutability
  Conversation copyWith({
    String? id,
    String? otherUserName,
    String? otherUserAvatar,
    String? lastMessage,
    String? lastMessageTime,
    int? unreadCount,
    bool? isOtherUserOnline,
    String? lastMessageSender,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id ?? this.id,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserAvatar: otherUserAvatar ?? this.otherUserAvatar,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      isOtherUserOnline: isOtherUserOnline ?? this.isOtherUserOnline,
      lastMessageSender: lastMessageSender ?? this.lastMessageSender,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        otherUserName,
        otherUserAvatar,
        lastMessage,
        lastMessageTime,
        unreadCount,
        isOtherUserOnline,
        lastMessageSender,
        createdAt,
        updatedAt,
      ];

  @override
  String toString() {
    return 'Conversation(id: $id, otherUserName: $otherUserName, lastMessage: $lastMessage, unreadCount: $unreadCount)';
  }
}
