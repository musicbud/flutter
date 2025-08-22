import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final DateTime? birthday;
  final String? gender;
  final List<String> interests;
  final String? profilePicture;
  final String? bio;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final Map<String, bool> connectedServices;

  const UserProfile({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.birthday,
    this.gender,
    this.interests = const [],
    this.profilePicture,
    this.bio,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.connectedServices = const {},
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthday: json['birthday'] != null
          ? DateTime.tryParse(json['birthday'])
          : null,
      gender: json['gender'],
      interests: List<String>.from(json['interests'] ?? []),
      profilePicture: json['profile_picture'],
      bio: json['bio'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isActive: json['is_active'] ?? true,
      connectedServices: Map<String, bool>.from(json['connected_services'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'birthday': birthday?.toIso8601String(),
      'gender': gender,
      'interests': interests,
      'profile_picture': profilePicture,
      'bio': bio,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
      'connected_services': connectedServices,
    };
  }

  UserProfile copyWith({
    String? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    DateTime? birthday,
    String? gender,
    List<String>? interests,
    String? profilePicture,
    String? bio,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    Map<String, bool>? connectedServices,
  }) {
    return UserProfile(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      interests: interests ?? this.interests,
      profilePicture: profilePicture ?? this.profilePicture,
      bio: bio ?? this.bio,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      connectedServices: connectedServices ?? this.connectedServices,
    );
  }

  @override
  List<Object?> get props => [
    id,
    username,
    email,
    firstName,
    lastName,
    birthday,
    gender,
    interests,
    profilePicture,
    bio,
    createdAt,
    updatedAt,
    isActive,
    connectedServices,
  ];
}

class UserProfileUpdateRequest extends Equatable {
  final String? firstName;
  final String? lastName;
  final DateTime? birthday;
  final String? gender;
  final List<String>? interests;
  final String? bio;

  const UserProfileUpdateRequest({
    this.firstName,
    this.lastName,
    this.birthday,
    this.gender,
    this.interests,
    this.bio,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (birthday != null) data['birthday'] = birthday!.toIso8601String();
    if (gender != null) data['gender'] = gender;
    if (interests != null) data['interests'] = interests;
    if (bio != null) data['bio'] = bio;
    return data;
  }

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    birthday,
    gender,
    interests,
    bio,
  ];
}