import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/bud_repository.dart';
// import '../../domain/models/bud_match.dart';
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

    // General bud operations
    on<BudsRequested>(_onBudsRequested);
    on<BudMatchesRequested>(_onBudMatchesRequested);
    on<BudRecommendationsRequested>(_onBudRecommendationsRequested);
    on<BudRequestSent>(_onBudRequestSent);
    on<BudRequestAccepted>(_onBudRequestAccepted);
    on<BudRequestRejected>(_onBudRequestRejected);
    on<BudRemoved>(_onBudRemoved);
    on<CommonItemsRequested>(_onCommonItemsRequested);
  }

  Future<void> _onBudsByLikedArtistsRequested(
    BudsByLikedArtistsRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      final buds = await _budRepository.getBudsByLikedArtists();
      emit(BudsLoaded(buds: buds));
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
      emit(BudsLoaded(buds: buds));
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
      emit(BudsLoaded(buds: buds));
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
      emit(BudsLoaded(buds: buds));
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
      emit(BudsLoaded(buds: buds));
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
      emit(BudsLoaded(buds: buds));
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
      emit(BudsLoaded(buds: buds));
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
      emit(BudsLoaded(buds: buds));
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
      emit(BudsLoaded(buds: buds));
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
      emit(BudsLoaded(buds: buds));
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
      emit(BudsLoaded(buds: buds));
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
      emit(BudsLoaded(buds: buds));
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
      emit(BudsLoaded(buds: buds));
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
      emit(BudsLoaded(buds: buds));
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
      final results = await _budRepository.searchBuds(event.query);
      emit(BudSearchResultsLoaded(results: results, query: event.query));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudsRequested(
    BudsRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      // Get all types of buds
      final likedBuds = await _budRepository.getBudsByLikedArtists();
      final topBuds = await _budRepository.getBudsByTopArtists();
      final allBuds = [...likedBuds, ...topBuds];
      emit(BudsLoaded(buds: allBuds));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudMatchesRequested(
    BudMatchesRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      final matches = await _budRepository.getBudMatches();
      emit(BudMatchesLoaded(matches: matches));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudRecommendationsRequested(
    BudRecommendationsRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      // Use existing top items methods for recommendations
      final recommendations = await _budRepository.getBudsByTopArtists();
      emit(BudRecommendationsLoaded(recommendations: recommendations));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudRequestSent(
    BudRequestSent event,
    Emitter<BudState> emit,
  ) async {
    try {
      await _budRepository.sendBudRequest(event.userId);
      emit(BudRequestSentSuccess(userId: event.userId));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudRequestAccepted(
    BudRequestAccepted event,
    Emitter<BudState> emit,
  ) async {
    try {
      await _budRepository.acceptBudRequest(event.userId);
      emit(BudRequestAcceptedSuccess(userId: event.userId));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudRequestRejected(
    BudRequestRejected event,
    Emitter<BudState> emit,
  ) async {
    try {
      await _budRepository.rejectBudRequest(event.userId);
      emit(BudRequestRejectedSuccess(userId: event.userId));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onBudRemoved(
    BudRemoved event,
    Emitter<BudState> emit,
  ) async {
    try {
      await _budRepository.removeBud(event.userId);
      emit(BudRemovedSuccess(userId: event.userId));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }

  Future<void> _onCommonItemsRequested(
    CommonItemsRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(BudLoading());
    try {
      List<dynamic> items;
      switch (event.category) {
        case 'tracks':
          items = await _budRepository.getCommonTracks(event.userId);
          break;
        case 'artists':
          items = await _budRepository.getCommonArtists(event.userId);
          break;
        case 'genres':
          items = await _budRepository.getCommonGenres(event.userId);
          break;
        case 'played_tracks':
          items = await _budRepository.getCommonPlayedTracks(event.userId);
          break;
        default:
          items = [];
      }
      emit(CommonItemsLoaded(
        items: items,
        category: event.category,
        userId: event.userId,
      ));
    } catch (e) {
      emit(BudFailure(e.toString()));
    }
  }
}
