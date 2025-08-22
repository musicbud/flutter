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
    try {
      print('UserProfile.fromJson: Input json: $json');
      print('UserProfile.fromJson: json type: ${json.runtimeType}');

      // Handle case where API response doesn't include id field
      // Use username as id if id is missing (common in some API responses)
      final id = json['id']?.toString() ?? json['username']?.toString() ?? '';
      final username = json['username']?.toString() ?? '';
      final email = json['email']?.toString();
      final avatarUrl = json['avatar_url']?.toString();
      final bio = json['bio']?.toString();
      final displayName = json['display_name']?.toString();
      final location = json['location']?.toString();
      final followersCount = json['followers_count'] as int? ?? 0;
      final followingCount = json['following_count'] as int? ?? 0;
      final isActive = json['is_active'] as bool? ?? true;
      final isAuthenticated = json['is_authenticated'] as bool? ?? true;

      print('UserProfile.fromJson: Parsed values - id: $id, username: $username, email: $email');

      // Validate that we have at least an id or username
      if (id.isEmpty) {
        throw Exception('UserProfile.fromJson: Missing required id/username field');
      }

      return UserProfile(
        id: id,
        username: username,
        email: email,
        avatarUrl: avatarUrl,
        bio: bio,
        displayName: displayName,
        location: location,
        followersCount: followersCount,
        followingCount: followingCount,
        isActive: isActive,
        isAuthenticated: isAuthenticated,
      );
    } catch (e, stackTrace) {
      print('UserProfile.fromJson: Error parsing json: $e');
      print('UserProfile.fromJson: Stack trace: $stackTrace');
      rethrow;
    }
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

/// A model class for updating user profile information
class UserProfileUpdateRequest extends Equatable {
  final String? firstName;
  final String? lastName;
  final String? bio;
  final String? displayName;
  final String? location;

  const UserProfileUpdateRequest({
    this.firstName,
    this.lastName,
    this.bio,
    this.displayName,
    this.location,
  });

  /// Creates a [UserProfileUpdateRequest] from a JSON map
  factory UserProfileUpdateRequest.fromJson(Map<String, dynamic> json) {
    return UserProfileUpdateRequest(
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      bio: json['bio']?.toString(),
      displayName: json['display_name']?.toString(),
      location: json['location']?.toString(),
    );
  }

  /// Converts this [UserProfileUpdateRequest] to a JSON map
  Map<String, dynamic> toJson() {
    return {
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (bio != null) 'bio': bio,
      if (displayName != null) 'display_name': displayName,
      if (location != null) 'location': location,
    };
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        bio,
        displayName,
        location,
      ];
}
