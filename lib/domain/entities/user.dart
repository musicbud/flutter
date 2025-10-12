import 'package:equatable/equatable.dart';

/// User entity representing user data
class User extends Equatable {
  final String id;
  final String displayName;
  final String email;
  final int followers;
  final int following;
  final bool isPublic;
  final List<UserImage> images;

  const User({
    required this.id,
    required this.displayName,
    required this.email,
    required this.followers,
    required this.following,
    required this.isPublic,
    required this.images,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] ?? '').toString(),
      displayName: json['display_name'] ?? json['displayName'] ?? '',
      email: json['email'] ?? '',
      followers: (json['followers'] ?? 0) is int ? json['followers'] ?? 0 : int.tryParse(json['followers']?.toString() ?? '0') ?? 0,
      following: (json['following'] ?? 0) is int ? json['following'] ?? 0 : int.tryParse(json['following']?.toString() ?? '0') ?? 0,
      isPublic: json['is_public'] ?? json['isPublic'] ?? true,
      images: (json['images'] as List<dynamic>?)
          ?.map((img) => UserImage.fromJson(img))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': displayName,
      'email': email,
      'followers': followers,
      'following': following,
      'is_public': isPublic,
      'images': images.map((img) => img.toJson()).toList(),
    };
  }

  User copyWith({
    String? id,
    String? displayName,
    String? email,
    int? followers,
    int? following,
    bool? isPublic,
    List<UserImage>? images,
  }) {
    return User(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      isPublic: isPublic ?? this.isPublic,
      images: images ?? this.images,
    );
  }

  @override
  List<Object?> get props => [
        id,
        displayName,
        email,
        followers,
        following,
        isPublic,
        images,
      ];

  @override
  String toString() {
    return 'User(id: $id, displayName: $displayName, email: $email)';
  }
}

/// User image entity
class UserImage extends Equatable {
  final String url;
  final int? height;
  final int? width;

  const UserImage({
    required this.url,
    this.height,
    this.width,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      url: json['url'] ?? '',
      height: json['height'],
      width: json['width'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'height': height,
      'width': width,
    };
  }

  @override
  List<Object?> get props => [url, height, width];
}
