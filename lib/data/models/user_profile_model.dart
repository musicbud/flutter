import '../../domain/models/user_profile.dart';

class UserProfileModel extends UserProfile {
  const UserProfileModel({
    required super.id,
    required super.username,
    super.email,
    super.avatarUrl,
    super.bio,
    super.displayName,
    required super.isActive,
    super.isAuthenticated,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      displayName: json['display_name'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      isAuthenticated: json['is_authenticated'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'avatar_url': avatarUrl,
      'bio': bio,
      'display_name': displayName,
      'is_active': isActive,
      'is_authenticated': isAuthenticated,
    };
  }
}
