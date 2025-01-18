import 'package:equatable/equatable.dart';

abstract class YTMusicState extends Equatable {
  const YTMusicState();

  @override
  List<Object?> get props => [];
}

class YTMusicInitial extends YTMusicState {}

class YTMusicLoading extends YTMusicState {}

class YTMusicAuthUrlLoaded extends YTMusicState {
  final String url;

  const YTMusicAuthUrlLoaded(this.url);

  @override
  List<Object> get props => [url];
}

class YTMusicConnected extends YTMusicState {}

class YTMusicDisconnected extends YTMusicState {}

class YTMusicFailure extends YTMusicState {
  final String error;

  const YTMusicFailure(this.error);

  @override
  List<Object> get props => [error];
}
