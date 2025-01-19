import 'package:equatable/equatable.dart';

abstract class LastFmState extends Equatable {
  const LastFmState();

  @override
  List<Object?> get props => [];
}

class LastFmInitial extends LastFmState {
  const LastFmInitial();
}

class LastFmLoading extends LastFmState {
  const LastFmLoading();
}

class LastFmAuthUrlLoaded extends LastFmState {
  final String url;

  const LastFmAuthUrlLoaded(this.url);

  @override
  List<Object?> get props => [url];
}

class LastFmConnected extends LastFmState {
  const LastFmConnected();
}

class LastFmDisconnected extends LastFmState {
  const LastFmDisconnected();
}

class LastFmFailure extends LastFmState {
  final String message;

  const LastFmFailure(this.message);

  @override
  List<Object?> get props => [message];
}
