import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/bud_repository.dart';
import '../../domain/models/bud_match.dart';
import 'bud_event.dart';
import 'bud_state.dart';

class BudBloc extends Bloc<BudEvent, BudState> {
  final BudRepository _budRepository;

  BudBloc({required BudRepository budRepository})
      : _budRepository = budRepository,
        super(BudInitial()) {
    // By liked items
    on<BudsByLikedArtistsRequested>(_onBudsByLikedArtistsRequested);
    on<BudsByLikedTracksRequested>(_onBudsByLikedTracksRequested);
    on<BudsByLikedGenresRequested>(_onBudsByLikedGenresRequested);
    on<BudsByLikedAlbumsRequested>(_onBudsByLikedAlbumsRequested);
    on<BudsByPlayedTracksRequested>(_onBudsByPlayedTracksRequested);

    // By top items
    on<BudsByTopArtistsRequested>(_onBudsByTopArtistsRequested);
    on<BudsByTopTracksRequested>(_onBudsByTopTracksRequested);
    on<BudsByTopGenresRequested>(_onBudsByTopGenresRequested);
    on<BudsByTopAnimeRequested>(_onBudsByTopAnimeRequested);
    on<BudsByTopMangaRequested>(_onBudsByTopMangaRequested);

    // By specific item
    on<BudsByArtistRequested>(_onBudsByArtistRequested);
    on<BudsByTrackRequested>(_onBudsByTrackRequested);
    on<BudsByGenreRequested>(_onBudsByGenreRequested);
    on<BudsByAlbumRequested>(_onBudsByAlbumRequested);

    // Search
    on<BudsSearchRequested>(_onBudsSearchRequested);
  }

  Future<void> _onBudsByLikedArtistsRequested(
    BudsByLikedArtistsRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      final buds = await _budRepository.getBudsByLikedArtists();
      emit(BudsLoaded(buds));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudsByLikedTracksRequested(
    BudsByLikedTracksRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      final buds = await _budRepository.getBudsByLikedTracks();
      emit(BudsLoaded(buds));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudsByLikedGenresRequested(
    BudsByLikedGenresRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      final buds = await _budRepository.getBudsByLikedGenres();
      emit(BudsLoaded(buds));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudsByLikedAlbumsRequested(
    BudsByLikedAlbumsRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      final buds = await _budRepository.getBudsByLikedAlbums();
      emit(BudsLoaded(buds));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudsByPlayedTracksRequested(
    BudsByPlayedTracksRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      final buds = await _budRepository.getBudsByPlayedTracks();
      emit(BudsLoaded(buds));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudsByTopArtistsRequested(
    BudsByTopArtistsRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      final buds = await _budRepository.getBudsByTopArtists();
      emit(BudsLoaded(buds));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudsByTopTracksRequested(
    BudsByTopTracksRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      final buds = await _budRepository.getBudsByTopTracks();
      emit(BudsLoaded(buds));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudsByTopGenresRequested(
    BudsByTopGenresRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      final buds = await _budRepository.getBudsByTopGenres();
      emit(BudsLoaded(buds));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudsByTopAnimeRequested(
    BudsByTopAnimeRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      final buds = await _budRepository.getBudsByTopAnime();
      emit(BudsLoaded(buds));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudsByTopMangaRequested(
    BudsByTopMangaRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      final buds = await _budRepository.getBudsByTopManga();
      emit(BudsLoaded(buds));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudsByArtistRequested(
    BudsByArtistRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      final buds = await _budRepository.getBudsByArtist(event.artistId);
      emit(BudsLoaded(buds));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudsByTrackRequested(
    BudsByTrackRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      final buds = await _budRepository.getBudsByTrack(event.trackId);
      emit(BudsLoaded(buds));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudsByGenreRequested(
    BudsByGenreRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      final buds = await _budRepository.getBudsByGenre(event.genreId);
      emit(BudsLoaded(buds));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudsByAlbumRequested(
    BudsByAlbumRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      final buds = await _budRepository.getBudsByAlbum(event.albumId);
      emit(BudsLoaded(buds));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudsSearchRequested(
    BudsSearchRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      final buds = await _budRepository.searchBuds(event.query);
      emit(BudsLoaded(buds));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }
}
