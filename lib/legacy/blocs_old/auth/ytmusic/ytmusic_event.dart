import 'package:equatable/equatable.dart';

abstract class YtMusicEvent extends Equatable {
  const YtMusicEvent();

  @override
  List<Object?> get props => [];
}

class YtMusicAuthUrlRequested extends YtMusicEvent {
  const YtMusicAuthUrlRequested();
}

class YtMusicConnectRequested extends YtMusicEvent {
  final String code;

  const YtMusicConnectRequested(this.code);

  @override
  List<Object?> get props => [code];
}

class YtMusicDisconnectRequested extends YtMusicEvent {
  const YtMusicDisconnectRequested();
}
