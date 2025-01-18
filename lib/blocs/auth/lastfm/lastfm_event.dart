import 'package:equatable/equatable.dart';

abstract class LastFMEvent extends Equatable {
  const LastFMEvent();

  @override
  List<Object?> get props => [];
}

class LastFMAuthUrlRequested extends LastFMEvent {}

class LastFMConnectRequested extends LastFMEvent {
  final String code;

  const LastFMConnectRequested(this.code);

  @override
  List<Object> get props => [code];
}

class LastFMDisconnectRequested extends LastFMEvent {}
