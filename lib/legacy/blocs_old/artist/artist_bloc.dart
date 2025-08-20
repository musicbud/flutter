import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/repositories/bud_repository.dart';
import 'artist_event.dart';
import 'artist_state.dart';

class ArtistBloc extends Bloc<ArtistEvent, ArtistState> {
  final ContentRepository _contentRepository;
  final BudRepository _budRepository;

  ArtistBloc({
    required ContentRepository contentRepository,
    required BudRepository budRepository,
  })  : _contentRepository = contentRepository,
        _budRepository = budRepository,
        super(ArtistInitial()) {
    on<ArtistDetailsRequested>(_onArtistDetailsRequested);
    on<ArtistBudsRequested>(_onArtistBudsRequested);
    on<ArtistLikeToggled>(_onArtistLikeToggled);
  }

  Future<void> _onArtistDetailsRequested(
    ArtistDetailsRequested event,
    Emitter<ArtistState> emit,
  ) async {
    emit(ArtistLoading());
    try {
      final artist = await _contentRepository.getArtistDetails(event.artistId);
      final buds = await _budRepository.getBudsByArtist(event.artistId);
      emit(ArtistDetailsLoaded(artist: artist, buds: buds));
    } catch (e) {
      emit(ArtistFailure(e.toString()));
    }
  }

  Future<void> _onArtistBudsRequested(
    ArtistBudsRequested event,
    Emitter<ArtistState> emit,
  ) async {
    emit(ArtistLoading());
    try {
      final buds = await _budRepository.getBudsByArtist(event.artistId);
      if (state is ArtistDetailsLoaded) {
        final currentState = state as ArtistDetailsLoaded;
        emit(ArtistDetailsLoaded(artist: currentState.artist, buds: buds));
      }
    } catch (e) {
      emit(ArtistFailure(e.toString()));
    }
  }

  Future<void> _onArtistLikeToggled(
    ArtistLikeToggled event,
    Emitter<ArtistState> emit,
  ) async {
    try {
      if (state is ArtistDetailsLoaded) {
        final currentState = state as ArtistDetailsLoaded;
        final isCurrentlyLiked = currentState.artist.isLiked;

        if (isCurrentlyLiked) {
          await _contentRepository.unlikeArtist(event.artistId);
        } else {
          await _contentRepository.likeArtist(event.artistId);
        }

        emit(ArtistLikeStatusChanged(!isCurrentlyLiked));

        final updatedArtist = currentState.artist.copyWith(
          isLiked: !isCurrentlyLiked,
        );
        emit(ArtistDetailsLoaded(
          artist: updatedArtist,
          buds: currentState.buds,
        ));
      }
    } catch (e) {
      emit(ArtistFailure(e.toString()));
    }
  }
}
