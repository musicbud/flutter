import 'package:equatable/equatable.dart';

abstract class LikesState extends Equatable {
  const LikesState();

  @override
  List<Object?> get props => [];
}

class LikesInitial extends LikesState {}

class LikesUpdating extends LikesState {}

class LikesUpdateSuccess extends LikesState {
  final String message;

  const LikesUpdateSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class LikesUpdateFailure extends LikesState {
  final String error;
  final bool needsSpotifyConnection;

  const LikesUpdateFailure({
    required this.error,
    this.needsSpotifyConnection = false,
  });

  @override
  List<Object> get props => [error, needsSpotifyConnection];
}
