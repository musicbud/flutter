import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/discover_repository.dart';
import 'discover_event.dart';
import 'discover_state.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final DiscoverRepository repository;

  DiscoverBloc({required this.repository}) : super(const DiscoverInitial()) {
    on<DiscoverPageLoaded>(_onPageLoaded);
    on<DiscoverCategorySelected>(_onCategorySelected);
    on<DiscoverRefreshRequested>(_onRefreshRequested);
    on<DiscoverItemInteracted>(_onItemInteracted);
    on<FetchTopTracks>(_onFetchTopTracks);
    on<FetchTopArtists>(_onFetchTopArtists);
    on<FetchTopGenres>(_onFetchTopGenres);
    on<FetchTopAnime>(_onFetchTopAnime);
    on<FetchTopManga>(_onFetchTopManga);
    on<FetchLikedTracks>(_onFetchLikedTracks);
    on<FetchLikedArtists>(_onFetchLikedArtists);
    on<FetchLikedGenres>(_onFetchLikedGenres);
    on<FetchLikedAlbums>(_onFetchLikedAlbums);
    on<FetchPlayedTracks>(_onFetchPlayedTracks);
    on<FetchTrendingTracks>(_onFetchTrendingTracks);
    on<FetchFeaturedArtists>(_onFetchFeaturedArtists);
    on<FetchNewReleases>(_onFetchNewReleases);
  }

  Future<void> _onPageLoaded(
    DiscoverPageLoaded event,
    Emitter<DiscoverState> emit,
  ) async {
    try {
      emit(const DiscoverLoading());
      
      final categories = await repository.getCategories();
      if (categories.isEmpty) {
        emit(const DiscoverError('No categories available'));
        return;
      }

      final items = await repository.getDiscoverItems(categories.first);
      
      emit(DiscoverLoaded(
        items: items,
        categories: categories,
        selectedCategory: categories.first,
      ));
    } catch (e) {
      emit(DiscoverError(e.toString()));
    }
  }

  Future<void> _onCategorySelected(
    DiscoverCategorySelected event,
    Emitter<DiscoverState> emit,
  ) async {
    if (state is! DiscoverLoaded) return;
    final currentState = state as DiscoverLoaded;

    try {
      emit(currentState.copyWith(isRefreshing: true));
      
      final items = await repository.getDiscoverItems(event.categoryId);
      
      emit(currentState.copyWith(
        items: items,
        selectedCategory: event.categoryId,
        isRefreshing: false,
      ));
    } catch (e) {
      emit(DiscoverError(e.toString()));
    }
  }

  Future<void> _onRefreshRequested(
    DiscoverRefreshRequested event,
    Emitter<DiscoverState> emit,
  ) async {
    if (state is! DiscoverLoaded) return;
    final currentState = state as DiscoverLoaded;

    try {
      emit(currentState.copyWith(isRefreshing: true));
      
      final items = await repository.getDiscoverItems(currentState.selectedCategory);
      
      emit(currentState.copyWith(
        items: items,
        isRefreshing: false,
      ));
    } catch (e) {
      emit(DiscoverError(e.toString()));
    }
  }

  Future<void> _onItemInteracted(
    DiscoverItemInteracted event,
    Emitter<DiscoverState> emit,
  ) async {
    try {
      await repository.trackInteraction(
        itemId: event.itemId,
        type: event.type,
        action: event.action,
      );
    } catch (e) {
      // Silently handle interaction tracking errors
      debugPrint('Failed to track interaction: ${e.toString()}');
    }
  }

  Future<void> _onFetchTopTracks(
    FetchTopTracks event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(const TopTracksLoading());
    try {
      final tracks = await repository.getTopTracks();
      emit(TopTracksLoaded(tracks));
    } catch (e) {
      emit(TopTracksError(e.toString()));
    }
  }

  Future<void> _onFetchTopArtists(
    FetchTopArtists event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(const TopArtistsLoading());
    try {
      final artists = await repository.getTopArtists();
      emit(TopArtistsLoaded(artists));
    } catch (e) {
      emit(TopArtistsError(e.toString()));
    }
  }

  Future<void> _onFetchTopGenres(
    FetchTopGenres event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(const TopGenresLoading());
    try {
      final genres = await repository.getTopGenres();
      emit(TopGenresLoaded(genres));
    } catch (e) {
      emit(TopGenresError(e.toString()));
    }
  }

  Future<void> _onFetchTopAnime(
    FetchTopAnime event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(const TopAnimeLoading());
    try {
      final anime = await repository.getTopAnime();
      emit(TopAnimeLoaded(anime));
    } catch (e) {
      emit(TopAnimeError(e.toString()));
    }
  }

  Future<void> _onFetchTopManga(
    FetchTopManga event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(const TopMangaLoading());
    try {
      final manga = await repository.getTopManga();
      emit(TopMangaLoaded(manga));
    } catch (e) {
      emit(TopMangaError(e.toString()));
    }
  }

  Future<void> _onFetchLikedTracks(
    FetchLikedTracks event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(const LikedTracksLoading());
    try {
      final tracks = await repository.getLikedTracks();
      emit(LikedTracksLoaded(tracks));
    } catch (e) {
      emit(LikedTracksError(e.toString()));
    }
  }

  Future<void> _onFetchLikedArtists(
    FetchLikedArtists event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(const LikedArtistsLoading());
    try {
      final artists = await repository.getLikedArtists();
      emit(LikedArtistsLoaded(artists));
    } catch (e) {
      emit(LikedArtistsError(e.toString()));
    }
  }

  Future<void> _onFetchLikedGenres(
    FetchLikedGenres event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(const LikedGenresLoading());
    try {
      final genres = await repository.getLikedGenres();
      emit(LikedGenresLoaded(genres));
    } catch (e) {
      emit(LikedGenresError(e.toString()));
    }
  }

  Future<void> _onFetchLikedAlbums(
    FetchLikedAlbums event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(const LikedAlbumsLoading());
    try {
      final albums = await repository.getLikedAlbums();
      emit(LikedAlbumsLoaded(albums));
    } catch (e) {
      emit(LikedAlbumsError(e.toString()));
    }
  }

  Future<void> _onFetchPlayedTracks(
    FetchPlayedTracks event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(const PlayedTracksLoading());
    try {
      final tracks = await repository.getPlayedTracks();
      emit(PlayedTracksLoaded(tracks));
    } catch (e) {
      emit(PlayedTracksError(e.toString()));
    }
  }

  Future<void> _onFetchTrendingTracks(
    FetchTrendingTracks event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(const TrendingTracksLoading());
    try {
      final tracks = await repository.getTrendingTracks();
      emit(TrendingTracksLoaded(tracks));
    } catch (e) {
      emit(TrendingTracksError(e.toString()));
    }
  }

  Future<void> _onFetchFeaturedArtists(
    FetchFeaturedArtists event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(const FeaturedArtistsLoading());
    try {
      final artists = await repository.getFeaturedArtists();
      emit(FeaturedArtistsLoaded(artists));
    } catch (e) {
      emit(FeaturedArtistsError(e.toString()));
    }
  }

  Future<void> _onFetchNewReleases(
    FetchNewReleases event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(const NewReleasesLoading());
    try {
      final releases = await repository.getNewReleases();
      emit(NewReleasesLoaded(releases));
    } catch (e) {
      emit(NewReleasesError(e.toString()));
    }
  }
}
