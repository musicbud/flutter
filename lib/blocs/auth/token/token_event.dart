import 'package:equatable/equatable.dart';

abstract class TokenEvent extends Equatable {
  const TokenEvent();

  @override
  List<Object?> get props => [];
}

class TokenRefreshRequested extends TokenEvent {
  final String refreshToken;

  const TokenRefreshRequested(this.refreshToken);

  @override
  List<Object> get props => [refreshToken];
}
