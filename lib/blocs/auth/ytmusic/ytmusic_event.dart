import 'package:equatable/equatable.dart';

abstract class YTMusicEvent extends Equatable {
  const YTMusicEvent();

  @override
  List<Object?> get props => [];
}

class YTMusicAuthUrlRequested extends YTMusicEvent {}

class YTMusicConnectRequested extends YTMusicEvent {
  final String code;

  const YTMusicConnectRequested(this.code);

  @override
  List<Object> get props => [code];
}

class YTMusicDisconnectRequested extends YTMusicEvent {}
