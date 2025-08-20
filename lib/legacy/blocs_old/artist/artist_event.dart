import 'package:equatable/equatable.dart';

abstract class ArtistEvent extends Equatable {
  const ArtistEvent();

  @override
  List<Object?> get props => [];
}

class ArtistBudsRequested extends ArtistEvent {
  final String artistId;

  const ArtistBudsRequested(this.artistId);

  @override
  List<Object> get props => [artistId];
}

class ArtistLikeToggled extends ArtistEvent {
  final String artistId;

  const ArtistLikeToggled(this.artistId);

  @override
  List<Object> get props => [artistId];
}

class ArtistDetailsRequested extends ArtistEvent {
  final String artistId;

  const ArtistDetailsRequested(this.artistId);

  @override
  List<Object> get props => [artistId];
}
