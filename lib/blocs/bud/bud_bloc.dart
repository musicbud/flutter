import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/bud_repository.dart';
import '../../../domain/repositories/common_items_repository.dart';
import 'bud_event.dart';
import 'bud_state.dart';

class BudBloc extends Bloc<BudEvent, BudState> {
  final BudRepository _budRepository;
  final CommonItemsRepository _commonItemsRepository;

  BudBloc({
    required BudRepository budRepository,
    required CommonItemsRepository commonItemsRepository,
  }) : _budRepository = budRepository,
        _commonItemsRepository = commonItemsRepository,
        super(const BudInitial()) {
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

    // Common items
    on<CommonLikedArtistsRequested>(_onCommonLikedArtistsRequested);
    on<CommonLikedTracksRequested>(_onCommonLikedTracksRequested);
    on<CommonLikedGenresRequested>(_onCommonLikedGenresRequested);
    on<CommonLikedAlbumsRequested>(_onCommonLikedAlbumsRequested);
    on<CommonTopArtistsRequested>(_onCommonTopArtistsRequested);
    on<CommonTopTracksRequested>(_onCommonTopTracksRequested);
    on<CommonTopGenresRequested>(_onCommonTopGenresRequested);
    on<CommonTopAnimeRequested>(_onCommonTopAnimeRequested);
    on<CommonTopMangaRequested>(_onCommonTopMangaRequested);
    on<CommonPlayedTracksRequested>(_onCommonPlayedTracksRequested);
  }

  // By liked items handlers
   Future<void> _onBudsByLikedArtistsRequested(
     BudsByLikedArtistsRequested event,
     Emitter<BudState> emit,
   ) async {
     emit(const BudLoading());
     try {
       final buds = await _budRepository.getBudsByLikedArtists();
       emit(BudsByLikedArtistsLoaded(buds: buds));
     } catch (e) {
       emit(BudError(e.toString()));
     }
   }

   Future<void> _onBudsByLikedTracksRequested(
     BudsByLikedTracksRequested event,
     Emitter<BudState> emit,
   ) async {
     emit(const BudLoading());
     try {
       final buds = await _budRepository.getBudsByLikedTracks();
       emit(BudsByLikedTracksLoaded(buds: buds));
     } catch (e) {
       emit(BudError(e.toString()));
     }
   }

   Future<void> _onBudsByLikedGenresRequested(
     BudsByLikedGenresRequested event,
     Emitter<BudState> emit,
   ) async {
     emit(const BudLoading());
     try {
       final buds = await _budRepository.getBudsByLikedGenres();
       emit(BudsByLikedGenresLoaded(buds: buds));
     } catch (e) {
       emit(BudError(e.toString()));
     }
   }

   Future<void> _onBudsByLikedAlbumsRequested(
     BudsByLikedAlbumsRequested event,
     Emitter<BudState> emit,
   ) async {
     emit(const BudLoading());
     try {
       final buds = await _budRepository.getBudsByLikedAlbums();
       emit(BudsByLikedAlbumsLoaded(buds: buds));
     } catch (e) {
       emit(BudError(e.toString()));
     }
   }

   Future<void> _onBudsByPlayedTracksRequested(
     BudsByPlayedTracksRequested event,
     Emitter<BudState> emit,
   ) async {
     emit(const BudLoading());
     try {
       final buds = await _budRepository.getBudsByPlayedTracks();
       emit(BudsByPlayedTracksLoaded(buds: buds));
     } catch (e) {
       emit(BudError(e.toString()));
     }
   }

  // By top items handlers
  Future<void> _onBudsByTopArtistsRequested(
    BudsByTopArtistsRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final buds = await _budRepository.getBudsByTopArtists();
      emit(BudsByTopArtistsLoaded(buds: buds));
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  Future<void> _onBudsByTopTracksRequested(
    BudsByTopTracksRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final buds = await _budRepository.getBudsByTopTracks();
      emit(BudsByTopTracksLoaded(buds: buds));
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  Future<void> _onBudsByTopGenresRequested(
    BudsByTopGenresRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final buds = await _budRepository.getBudsByTopGenres();
      emit(BudsByTopGenresLoaded(buds: buds));
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  Future<void> _onBudsByTopAnimeRequested(
    BudsByTopAnimeRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final buds = await _budRepository.getBudsByTopAnime();
      emit(BudsByTopAnimeLoaded(buds: buds));
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  Future<void> _onBudsByTopMangaRequested(
    BudsByTopMangaRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final buds = await _budRepository.getBudsByTopManga();
      emit(BudsByTopMangaLoaded(buds: buds));
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  // By specific item handlers
  Future<void> _onBudsByArtistRequested(
    BudsByArtistRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final buds = await _budRepository.getBudsByArtist(event.artistId);
      emit(BudsByArtistLoaded(buds: buds, artistId: event.artistId));
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  Future<void> _onBudsByTrackRequested(
    BudsByTrackRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final buds = await _budRepository.getBudsByTrack(event.trackId);
      emit(BudsByTrackLoaded(buds: buds, trackId: event.trackId));
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  Future<void> _onBudsByGenreRequested(
    BudsByGenreRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final buds = await _budRepository.getBudsByGenre(event.genreId);
      emit(BudsByGenreLoaded(buds: buds, genreId: event.genreId));
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  Future<void> _onBudsByAlbumRequested(
    BudsByAlbumRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final buds = await _budRepository.getBudsByAlbum(event.albumId);
      emit(BudsByAlbumLoaded(buds: buds, albumId: event.albumId));
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  // Search handler
  Future<void> _onBudsSearchRequested(
    BudsSearchRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final buds = await _budRepository.searchBuds(event.query);
      emit(BudsSearchLoaded(buds: buds, query: event.query));
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  // Common items handlers
  Future<void> _onCommonLikedArtistsRequested(
    CommonLikedArtistsRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final result = await _commonItemsRepository.getCommonLikedArtists(event.budId);
      result.fold(
        (failure) => emit(BudError(failure.message)),
        (artists) => emit(CommonLikedArtistsLoaded(artists: artists, budId: event.budId)),
      );
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  Future<void> _onCommonLikedTracksRequested(
    CommonLikedTracksRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final result = await _commonItemsRepository.getCommonLikedTracks(event.budId);
      result.fold(
        (failure) => emit(BudError(failure.message)),
        (tracks) => emit(CommonLikedTracksLoaded(tracks: tracks, budId: event.budId)),
      );
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  Future<void> _onCommonLikedGenresRequested(
    CommonLikedGenresRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final result = await _commonItemsRepository.getCommonTopGenres(event.budId);
      result.fold(
        (failure) => emit(BudError(failure.message)),
        (genres) => emit(CommonLikedGenresLoaded(genres: genres, budId: event.budId)),
      );
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  Future<void> _onCommonLikedAlbumsRequested(
    CommonLikedAlbumsRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final result = await _commonItemsRepository.getCommonLikedAlbums(event.budId);
      result.fold(
        (failure) => emit(BudError(failure.message)),
        (albums) => emit(CommonLikedAlbumsLoaded(albums: albums, budId: event.budId)),
      );
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  Future<void> _onCommonTopArtistsRequested(
    CommonTopArtistsRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final result = await _commonItemsRepository.getCommonTopArtists(event.budId);
      result.fold(
        (failure) => emit(BudError(failure.message)),
        (artists) => emit(CommonTopArtistsLoaded(artists: artists, budId: event.budId)),
      );
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  Future<void> _onCommonTopTracksRequested(
    CommonTopTracksRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final result = await _commonItemsRepository.getCommonTracks(event.budId);
      result.fold(
        (failure) => emit(BudError(failure.message)),
        (tracks) => emit(CommonTopTracksLoaded(tracks: tracks, budId: event.budId)),
      );
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  Future<void> _onCommonTopGenresRequested(
    CommonTopGenresRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final result = await _commonItemsRepository.getCommonTopGenres(event.budId);
      result.fold(
        (failure) => emit(BudError(failure.message)),
        (genres) => emit(CommonTopGenresLoaded(genres: genres, budId: event.budId)),
      );
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  Future<void> _onCommonTopAnimeRequested(
    CommonTopAnimeRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final result = await _commonItemsRepository.getCommonTopAnime(event.budId);
      result.fold(
        (failure) => emit(BudError(failure.message)),
        (anime) => emit(CommonTopAnimeLoaded(anime: anime, budId: event.budId)),
      );
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  Future<void> _onCommonTopMangaRequested(
    CommonTopMangaRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final result = await _commonItemsRepository.getCommonTopManga(event.budId);
      result.fold(
        (failure) => emit(BudError(failure.message)),
        (manga) => emit(CommonTopMangaLoaded(manga: manga, budId: event.budId)),
      );
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }

  Future<void> _onCommonPlayedTracksRequested(
    CommonPlayedTracksRequested event,
    Emitter<BudState> emit,
  ) async {
    emit(const BudLoading());
    try {
      final result = await _commonItemsRepository.getCommonPlayedTracks(event.budId);
      result.fold(
        (failure) => emit(BudError(failure.message)),
        (tracks) => emit(CommonPlayedTracksLoaded(tracks: tracks, budId: event.budId)),
      );
    } catch (e) {
      emit(BudError(e.toString()));
    }
  }
}
