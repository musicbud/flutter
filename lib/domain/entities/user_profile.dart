import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String uid;
  final String username;
  final String email;
  final String? photoUrl;

  const UserProfile({
    required this.uid,
    required this.username,
    required this.email,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [uid, username, email, photoUrl];
}
