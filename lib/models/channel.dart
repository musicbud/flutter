import 'package:equatable/equatable.dart';

/// A model class representing a chat channel
class Channel extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? avatarUrl;
  final String type; // 'public', 'private', 'direct'
  final int memberCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isJoined;
  final String? lastMessage;
  final DateTime? lastMessageAt;

  const Channel({
    required this.id,
    required this.name,
    this.description,
    this.avatarUrl,
    required this.type,
    this.memberCount = 0,
    required this.createdAt,
    required this.updatedAt,
    this.isJoined = false,
    this.lastMessage,
    this.lastMessageAt,
  });

  /// Creates a [Channel] from a JSON map
  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'].toString(),
      name: json['name'] as String,
      description: json['description'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      type: json['is_private'] == true ? 'private' : 'public',
      memberCount: json['members_count'] as int? ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isJoined: json['is_joined'] as bool? ?? false,
      lastMessage: json['last_message'] as String?,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
    );
  }

  /// Converts this [Channel] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatar_url': avatarUrl,
      'is_private': type == 'private',
      'members_count': memberCount,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_joined': isJoined,
      'last_message': lastMessage,
      'last_message_at': lastMessageAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        avatarUrl,
        type,
        memberCount,
        createdAt,
        updatedAt,
        isJoined,
        lastMessage,
        lastMessageAt,
      ];
}
