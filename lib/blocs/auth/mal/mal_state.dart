import 'package:equatable/equatable.dart';

abstract class MALState extends Equatable {
  const MALState();

  @override
  List<Object?> get props => [];
}

class MALInitial extends MALState {}

class MALLoading extends MALState {}

class MALAuthUrlLoaded extends MALState {
  final String url;

  const MALAuthUrlLoaded(this.url);

  @override
  List<Object> get props => [url];
}

class MALConnected extends MALState {}

class MALDisconnected extends MALState {}

class MALFailure extends MALState {
  final String error;

  const MALFailure(this.error);

  @override
  List<Object> get props => [error];
}
