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
  final bool isAdmin;

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
    this.isAdmin = false,
  });

  /// Creates a [UserProfile] from a JSON map
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    try {
      // Handle case where API response doesn't include id field
      // Use username as id if id is missing (common in some API responses)
      final id = json['id']?.toString() ?? json['username']?.toString() ?? '';
      final username = json['username']?.toString() ?? '';

      // Handle backend response structure - backend returns first_name and last_name
      final firstName = json['first_name']?.toString();
      final lastName = json['last_name']?.toString();
      final displayName = firstName != null && lastName != null
          ? '$firstName $lastName'
          : firstName ?? lastName ?? username;

      final email = json['email']?.toString();
      final avatarUrl = json['avatar_url']?.toString();
      final bio = json['bio']?.toString();
      final location = json['location']?.toString();
      final followersCount = _parseInt(json['followers_count']) ?? 0;
      final followingCount = _parseInt(json['following_count']) ?? 0;
      final isActive = _parseBool(json['is_active']) ?? true;
      final isAuthenticated = _parseBool(json['is_authenticated']) ?? true;

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
    } catch (e) {
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

  /// Helper method to safely parse integers from JSON
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      final parsed = int.tryParse(value);
      return parsed;
    }
    if (value is double) return value.toInt();
    return null;
  }

  /// Helper method to safely parse booleans from JSON
  static bool? _parseBool(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) {
      final lower = value.toLowerCase();
      if (lower == 'true') return true;
      if (lower == 'false') return false;
    }
    if (value is int) {
      if (value == 1) return true;
      if (value == 0) return false;
    }
    return null;
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
  final DateTime? birthday;
  final String? gender;
  final List<String>? interests;
  final String? bio;
  final String? displayName;
  final String? location;

  const UserProfileUpdateRequest({
    this.firstName,
    this.lastName,
    this.birthday,
    this.gender,
    this.interests,
    this.bio,
    this.displayName,
    this.location,
  });

  /// Creates a [UserProfileUpdateRequest] from a JSON map
  factory UserProfileUpdateRequest.fromJson(Map<String, dynamic> json) {
    return UserProfileUpdateRequest(
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      birthday: json['birthday'] != null ? DateTime.tryParse(json['birthday']) : null,
      gender: json['gender']?.toString(),
      interests: json['interests'] != null ? List<String>.from(json['interests']) : null,
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
      if (birthday != null) 'birthday': birthday!.toIso8601String(),
      if (gender != null) 'gender': gender,
      if (interests != null) 'interests': interests,
      if (bio != null) 'bio': bio,
      if (displayName != null) 'display_name': displayName,
      if (location != null) 'location': location,
    };
  }

  @override
  List<Object?> get props => [
        firstName,
        lastName,
        birthday,
        gender,
        interests,
        bio,
        displayName,
        location,
      ];
}
