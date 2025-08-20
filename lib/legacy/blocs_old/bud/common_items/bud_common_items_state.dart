import 'package:equatable/equatable.dart';
import '../../../domain/models/common_track.dart';
import '../../../domain/models/common_artist.dart';
import '../../../domain/models/common_genre.dart';

abstract class BudCommonItemsState extends Equatable {
  const BudCommonItemsState();

  @override
  List<Object?> get props => [];
}

class BudCommonItemsInitial extends BudCommonItemsState {}

class BudCommonItemsLoading extends BudCommonItemsState {}

class BudCommonItemsLoaded extends BudCommonItemsState {
  final List<CommonTrack> commonTracks;
  final List<CommonArtist> commonArtists;
  final List<CommonGenre> commonGenres;
  final List<CommonTrack> commonPlayedTracks;

  const BudCommonItemsLoaded({
    required this.commonTracks,
    required this.commonArtists,
    required this.commonGenres,
    required this.commonPlayedTracks,
  });

  @override
  List<Object> get props => [
        commonTracks,
        commonArtists,
        commonGenres,
        commonPlayedTracks,
      ];
}

class BudCommonItemsFailure extends BudCommonItemsState {
  final String error;

  const BudCommonItemsFailure(this.error);

  @override
  List<Object> get props => [error];
}
