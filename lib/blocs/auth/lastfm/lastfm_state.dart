import 'package:equatable/equatable.dart';

abstract class LastFMState extends Equatable {
  const LastFMState();

  @override
  List<Object?> get props => [];
}

class LastFMInitial extends LastFMState {}

class LastFMLoading extends LastFMState {}

class LastFMAuthUrlLoaded extends LastFMState {
  final String url;

  const LastFMAuthUrlLoaded(this.url);

  @override
  List<Object> get props => [url];
}

class LastFMConnected extends LastFMState {}

class LastFMDisconnected extends LastFMState {}

class LastFMFailure extends LastFMState {
  final String error;

  const LastFMFailure(this.error);

  @override
  List<Object> get props => [error];
}
