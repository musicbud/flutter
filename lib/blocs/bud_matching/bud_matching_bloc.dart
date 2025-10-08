import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/bud_matching_repository.dart';
import '../../models/bud_profile.dart';
import '../../models/bud_search_result.dart';
import '../../models/bud_match.dart';

// Events
abstract class BudMatchingEvent extends Equatable {
  const BudMatchingEvent();

  @override
  List<Object?> get props => [];
}

class FetchBudProfile extends BudMatchingEvent {
  final String budId;

  const FetchBudProfile({required this.budId});

  @override
  List<Object?> get props => [budId];
}

class FindBudsByTopArtists extends BudMatchingEvent {}

class FindBudsByTopTracks extends BudMatchingEvent {}

class FindBudsByTopGenres extends BudMatchingEvent {}

class FindBudsByTopAnime extends BudMatchingEvent {}

class FindBudsByTopManga extends BudMatchingEvent {}

class FindBudsByLikedArtists extends BudMatchingEvent {}

class FindBudsByLikedTracks extends BudMatchingEvent {}

class FindBudsByLikedGenres extends BudMatchingEvent {}

class FindBudsByLikedAlbums extends BudMatchingEvent {}

class FindBudsByLikedAio extends BudMatchingEvent {}

class FindBudsByPlayedTracks extends BudMatchingEvent {}

class FindBudsByArtist extends BudMatchingEvent {
  final String artistId;

  const FindBudsByArtist({required this.artistId});

  @override
  List<Object?> get props => [artistId];
}

class FindBudsByTrack extends BudMatchingEvent {
  final String trackId;

  const FindBudsByTrack({required this.trackId});

  @override
  List<Object?> get props => [trackId];
}

class FindBudsByGenre extends BudMatchingEvent {
  final String genreId;

  const FindBudsByGenre({required this.genreId});

  @override
  List<Object?> get props => [genreId];
}

// States
abstract class BudMatchingState extends Equatable {
  const BudMatchingState();

  @override
  List<Object?> get props => [];
}

class BudMatchingInitial extends BudMatchingState {}

class BudMatchingLoading extends BudMatchingState {}

class BudProfileLoaded extends BudMatchingState {
  final BudProfile budProfile;

  const BudProfileLoaded({required this.budProfile});

  @override
  List<Object?> get props => [budProfile];
}

class BudsFound extends BudMatchingState {
  final BudSearchResult searchResult;

  const BudsFound({required this.searchResult});

  @override
  List<Object?> get props => [searchResult];
}

class BudsSearchResults extends BudMatchingState {
  final List<BudMatch> buds;
  final String query;

  const BudsSearchResults({required this.buds, required this.query});

  @override
  List<Object?> get props => [buds, query];
}

class BudMatchingError extends BudMatchingState {
  final String message;

  const BudMatchingError(this.message);

  @override
  List<Object?> get props => [message];
}

// Bloc
class BudMatchingBloc extends Bloc<BudMatchingEvent, BudMatchingState> {
  final BudMatchingRepository _budMatchingRepository;

  BudMatchingBloc({required BudMatchingRepository budMatchingRepository})
      : _budMatchingRepository = budMatchingRepository,
        super(BudMatchingInitial()) {
    on<FetchBudProfile>(_onFetchBudProfile);
    on<FindBudsByTopArtists>(_onFindBudsByTopArtists);
    on<FindBudsByTopTracks>(_onFindBudsByTopTracks);
    on<FindBudsByTopGenres>(_onFindBudsByTopGenres);
    on<FindBudsByTopAnime>(_onFindBudsByTopAnime);
    on<FindBudsByTopManga>(_onFindBudsByTopManga);
    on<FindBudsByLikedArtists>(_onFindBudsByLikedArtists);
    on<FindBudsByLikedTracks>(_onFindBudsByLikedTracks);
    on<FindBudsByLikedGenres>(_onFindBudsByLikedGenres);
    on<FindBudsByLikedAlbums>(_onFindBudsByLikedAlbums);
    on<FindBudsByLikedAio>(_onFindBudsByLikedAio);
    on<FindBudsByPlayedTracks>(_onFindBudsByPlayedTracks);
    on<FindBudsByArtist>(_onFindBudsByArtist);
    on<FindBudsByTrack>(_onFindBudsByTrack);
    on<FindBudsByGenre>(_onFindBudsByGenre);
  }

  Future<void> _onFetchBudProfile(
    FetchBudProfile event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final profile = await _budMatchingRepository.fetchBudProfile(event.budId);
      emit(BudProfileLoaded(budProfile: profile));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onFindBudsByTopArtists(
    FindBudsByTopArtists event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final result = await _budMatchingRepository.findBudsByTopArtists();
      emit(BudsFound(searchResult: result));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onFindBudsByTopTracks(
    FindBudsByTopTracks event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final result = await _budMatchingRepository.findBudsByTopTracks();
      emit(BudsFound(searchResult: result));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onFindBudsByTopGenres(
    FindBudsByTopGenres event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final result = await _budMatchingRepository.findBudsByTopGenres();
      emit(BudsFound(searchResult: result));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onFindBudsByTopAnime(
    FindBudsByTopAnime event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final result = await _budMatchingRepository.findBudsByTopAnime();
      emit(BudsFound(searchResult: result));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onFindBudsByTopManga(
    FindBudsByTopManga event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final result = await _budMatchingRepository.findBudsByTopManga();
      emit(BudsFound(searchResult: result));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onFindBudsByLikedArtists(
    FindBudsByLikedArtists event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final result = await _budMatchingRepository.findBudsByLikedArtists();
      emit(BudsFound(searchResult: result));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onFindBudsByLikedTracks(
    FindBudsByLikedTracks event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final result = await _budMatchingRepository.findBudsByLikedTracks();
      emit(BudsFound(searchResult: result));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onFindBudsByLikedGenres(
    FindBudsByLikedGenres event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final result = await _budMatchingRepository.findBudsByLikedGenres();
      emit(BudsFound(searchResult: result));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onFindBudsByLikedAlbums(
    FindBudsByLikedAlbums event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final result = await _budMatchingRepository.findBudsByLikedAlbums();
      emit(BudsFound(searchResult: result));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onFindBudsByLikedAio(
    FindBudsByLikedAio event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final result = await _budMatchingRepository.findBudsByLikedAio();
      emit(BudsFound(searchResult: result));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onFindBudsByPlayedTracks(
    FindBudsByPlayedTracks event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final result = await _budMatchingRepository.findBudsByPlayedTracks();
      emit(BudsFound(searchResult: result));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onFindBudsByArtist(
    FindBudsByArtist event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final result = await _budMatchingRepository.findBudsByArtist(event.artistId);
      emit(BudsFound(searchResult: result));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onFindBudsByTrack(
    FindBudsByTrack event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final result = await _budMatchingRepository.findBudsByTrack(event.trackId);
      emit(BudsFound(searchResult: result));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }

  Future<void> _onFindBudsByGenre(
    FindBudsByGenre event,
    Emitter<BudMatchingState> emit,
  ) async {
    try {
      emit(BudMatchingLoading());
      final result = await _budMatchingRepository.findBudsByGenre(event.genreId);
      emit(BudsFound(searchResult: result));
    } catch (e) {
      emit(BudMatchingError(e.toString()));
    }
  }
}