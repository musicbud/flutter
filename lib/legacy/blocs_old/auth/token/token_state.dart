import 'package:equatable/equatable.dart';

abstract class TokenState extends Equatable {
  const TokenState();

  @override
  List<Object?> get props => [];
}

class TokenInitial extends TokenState {}

class TokenRefreshing extends TokenState {}

class TokenRefreshSuccess extends TokenState {
  final Map<String, dynamic> data;

  const TokenRefreshSuccess(this.data);

  @override
  List<Object> get props => [data];
}

class TokenRefreshFailure extends TokenState {
  final String error;

  const TokenRefreshFailure(this.error);

  @override
  List<Object> get props => [error];
}
