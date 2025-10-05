import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/content_repository.dart';
import 'top_artists_event.dart';
import 'top_artists_state.dart';

class TopArtistsBloc extends Bloc<TopArtistsEvent, TopArtistsState> {
  final ContentRepository _contentRepository;
  static const int _pageSize = 20;

  TopArtistsBloc({
    required ContentRepository contentRepository,
  })  : _contentRepository = contentRepository,
        super(TopArtistsInitial()) {
    on<TopArtistsRequested>(_onTopArtistsRequested);
    on<TopArtistsLoadMoreRequested>(_onTopArtistsLoadMoreRequested);
    on<TopArtistsRefreshRequested>(_onTopArtistsRefreshRequested);
  }

  Future<void> _onTopArtistsRequested(
    TopArtistsRequested event,
    Emitter<TopArtistsState> emit,
  ) async {
    emit(TopArtistsLoading());
    try {
      final artists = await _contentRepository.getTopArtists();
      final hasReachedEnd = artists.length < _pageSize;
      emit(TopArtistsLoaded(
        artists: artists,
        hasReachedEnd: hasReachedEnd,
        currentPage: event.page,
      ));
    } catch (e) {
      emit(TopArtistsFailure(e.toString()));
    }
  }

  Future<void> _onTopArtistsLoadMoreRequested(
    TopArtistsLoadMoreRequested event,
    Emitter<TopArtistsState> emit,
  ) async {
    if (state is TopArtistsLoaded) {
      final currentState = state as TopArtistsLoaded;
      if (currentState.hasReachedEnd) return;

      emit(TopArtistsLoadingMore(currentState.artists));
      try {
        final nextPage = currentState.currentPage + 1;
        final moreArtists = await _contentRepository.getTopArtists();
        final hasReachedEnd = moreArtists.length < _pageSize;

        emit(TopArtistsLoaded(
          artists: [...currentState.artists, ...moreArtists],
          hasReachedEnd: hasReachedEnd,
          currentPage: nextPage,
        ));
      } catch (e) {
        emit(TopArtistsFailure(e.toString()));
      }
    }
  }

  Future<void> _onTopArtistsRefreshRequested(
    TopArtistsRefreshRequested event,
    Emitter<TopArtistsState> emit,
  ) async {
    try {
      final artists = await _contentRepository.getTopArtists();
      final hasReachedEnd = artists.length < _pageSize;
      emit(TopArtistsLoaded(
        artists: artists,
        hasReachedEnd: hasReachedEnd,
        currentPage: 1,
      ));
    } catch (e) {
      emit(TopArtistsFailure(e.toString()));
    }
  }
}
