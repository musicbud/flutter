import 'package:equatable/equatable.dart';

abstract class YtMusicState extends Equatable {
  const YtMusicState();

  @override
  List<Object?> get props => [];
}

class YtMusicInitial extends YtMusicState {
  const YtMusicInitial();
}

class YtMusicLoading extends YtMusicState {
  const YtMusicLoading();
}

class YtMusicAuthUrlLoaded extends YtMusicState {
  final String url;

  const YtMusicAuthUrlLoaded(this.url);

  @override
  List<Object?> get props => [url];
}

class YtMusicConnected extends YtMusicState {
  const YtMusicConnected();
}

class YtMusicDisconnected extends YtMusicState {
  const YtMusicDisconnected();
}

class YtMusicFailure extends YtMusicState {
  final String message;

  const YtMusicFailure(this.message);

  @override
  List<Object?> get props => [message];
}
