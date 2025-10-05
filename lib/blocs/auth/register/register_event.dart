import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

class RegisterConnectivityChecked extends RegisterEvent {}

class RegisterServerStatusChecked extends RegisterEvent {}

class RegisterSubmitted extends RegisterEvent {
  final String username;
  final String email;
  final String password;

  const RegisterSubmitted({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [username, email, password];
}
