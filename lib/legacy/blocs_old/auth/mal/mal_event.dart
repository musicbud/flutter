import 'package:equatable/equatable.dart';

abstract class MALEvent extends Equatable {
  const MALEvent();

  @override
  List<Object?> get props => [];
}

class MALAuthUrlRequested extends MALEvent {}

class MALConnectRequested extends MALEvent {
  final String code;

  const MALConnectRequested(this.code);

  @override
  List<Object> get props => [code];
}

class MALDisconnectRequested extends MALEvent {}
