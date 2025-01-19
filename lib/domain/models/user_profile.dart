import 'package:equatable/equatable.dart';

/// A model class representing a user's profile
class UserProfile extends Equatable {
  final String id;
  final String username;
  final String? email;
  final String? avatarUrl;
  final String? bio;
  final String? location;
  final int? followersCount;
  final int? followingCount;
  final bool isFollowing;
  final List<String> interests;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isOnline;
  final Map<String, bool> connectedServices;

  const UserProfile({
    required this.id,
    required this.username,
    this.email,
    this.avatarUrl,
    this.bio,
    this.location,
    this.followersCount,
    this.followingCount,
    this.isFollowing = false,
    this.interests = const [],
    required this.createdAt,
    required this.updatedAt,
    this.isOnline = false,
    this.connectedServices = const {},
  });

  /// Creates a [UserProfile] from a JSON map
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      followersCount: json['followers_count'] as int?,
      followingCount: json['following_count'] as int?,
      isFollowing: json['is_following'] as bool? ?? false,
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      isOnline: json['is_online'] as bool? ?? false,
      connectedServices:
          Map<String, bool>.from(json['connected_services'] as Map? ?? {}),
    );
  }

  /// Converts this [UserProfile] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar_url': avatarUrl,
      'bio': bio,
      'location': location,
      'followers_count': followersCount,
      'following_count': followingCount,
      'is_following': isFollowing,
      'interests': interests,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_online': isOnline,
      'connected_services': connectedServices,
    };
  }

  /// Creates a copy of this [UserProfile] with the given fields replaced with new values
  UserProfile copyWith({
    String? id,
    String? username,
    String? email,
    String? avatarUrl,
    String? bio,
    String? location,
    int? followersCount,
    int? followingCount,
    bool? isFollowing,
    List<String>? interests,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isOnline,
    Map<String, bool>? connectedServices,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      isFollowing: isFollowing ?? this.isFollowing,
      interests: interests ?? this.interests,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isOnline: isOnline ?? this.isOnline,
      connectedServices: connectedServices ?? this.connectedServices,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        avatarUrl,
        bio,
        location,
        followersCount,
        followingCount,
        isFollowing,
        interests,
        createdAt,
        updatedAt,
        isOnline,
        connectedServices,
      ];
}
