import 'package:equatable/equatable.dart';

/// A model class representing a user's profile
class UserProfile extends Equatable {
  final String id;
  final String username;
  final String? email;
  final String? avatarUrl;
  final String? bio;
  final String? displayName;
  final String? location;
  final int followersCount;
  final int followingCount;
  final bool isActive;
  final bool? isAuthenticated;

  const UserProfile({
    required this.id,
    required this.username,
    this.email,
    this.avatarUrl,
    this.bio,
    this.displayName,
    this.location,
    this.followersCount = 0,
    this.followingCount = 0,
    required this.isActive,
    this.isAuthenticated,
  });

  /// Creates a [UserProfile] from a JSON map
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      email: json['email']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
      bio: json['bio']?.toString(),
      displayName: json['display_name']?.toString(),
      location: json['location'] as String?,
      followersCount: json['followers_count'] as int? ?? 0,
      followingCount: json['following_count'] as int? ?? 0,
      isActive: json['is_active'] as bool? ?? false,
      isAuthenticated: json['is_authenticated'] as bool?,
    );
  }

  /// Converts this [UserProfile] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      if (email != null) 'email': email,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (bio != null) 'bio': bio,
      if (displayName != null) 'display_name': displayName,
      'location': location,
      'followers_count': followersCount,
      'following_count': followingCount,
      'is_active': isActive,
      if (isAuthenticated != null) 'is_authenticated': isAuthenticated,
    };
  }

  /// Creates a copy of this [UserProfile] with the given fields replaced with new values
  UserProfile copyWith({
    String? id,
    String? username,
    String? email,
    String? avatarUrl,
    String? bio,
    String? displayName,
    String? location,
    int? followersCount,
    int? followingCount,
    bool? isActive,
    bool? isAuthenticated,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      displayName: displayName ?? this.displayName,
      location: location ?? this.location,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      isActive: isActive ?? this.isActive,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        avatarUrl,
        bio,
        displayName,
        location,
        followersCount,
        followingCount,
        isActive,
        isAuthenticated,
      ];
}
