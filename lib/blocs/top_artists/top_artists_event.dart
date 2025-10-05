import 'package:equatable/equatable.dart';

abstract class TopArtistsEvent extends Equatable {
  const TopArtistsEvent();

  @override
  List<Object?> get props => [];
}

class TopArtistsRequested extends TopArtistsEvent {
  final int page;

  const TopArtistsRequested({this.page = 1});

  @override
  List<Object> get props => [page];
}

class TopArtistsLoadMoreRequested extends TopArtistsEvent {
  const TopArtistsLoadMoreRequested();
}

class TopArtistsRefreshRequested extends TopArtistsEvent {
  const TopArtistsRefreshRequested();
}
