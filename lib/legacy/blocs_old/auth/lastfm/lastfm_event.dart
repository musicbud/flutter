import 'package:equatable/equatable.dart';

abstract class LastFmEvent extends Equatable {
  const LastFmEvent();

  @override
  List<Object?> get props => [];
}

class LastFmAuthUrlRequested extends LastFmEvent {
  const LastFmAuthUrlRequested();
}

class LastFmConnectRequested extends LastFmEvent {
  final String code;

  const LastFmConnectRequested(this.code);

  @override
  List<Object?> get props => [code];
}

class LastFmDisconnectRequested extends LastFmEvent {
  const LastFmDisconnectRequested();
}
