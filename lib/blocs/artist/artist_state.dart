import 'package:equatable/equatable.dart';
import '../../models/artist.dart';
import '../../models/bud_match.dart';

abstract class ArtistState extends Equatable {
  const ArtistState();

  @override
  List<Object?> get props => [];
}

class ArtistInitial extends ArtistState {}

class ArtistLoading extends ArtistState {}

class ArtistDetailsLoaded extends ArtistState {
  final Artist artist;
  final List<BudMatch> buds;

  const ArtistDetailsLoaded({
    required this.artist,
    required this.buds,
  });

  @override
  List<Object> get props => [artist, buds];
}

class ArtistLikeStatusChanged extends ArtistState {
  final bool isLiked;

  const ArtistLikeStatusChanged(this.isLiked);

  @override
  List<Object> get props => [isLiked];
}

class ArtistFailure extends ArtistState {
  final String error;

  const ArtistFailure(this.error);

  @override
  List<Object> get props => [error];
}
