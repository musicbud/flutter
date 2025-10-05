import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/repositories/common_items_repository.dart';
import 'music_event.dart';
import 'music_state.dart';

class CommonMusicBloc extends Bloc<MusicEvent, MusicState> {
  final CommonItemsRepository _repository;

  CommonMusicBloc({required CommonItemsRepository repository})
      : _repository = repository,
        super(MusicInitial()) {
    on<CommonLikedTracksRequested>(_onCommonLikedTracksRequested);
    on<CommonLikedArtistsRequested>(_onCommonLikedArtistsRequested);
    on<CommonLikedAlbumsRequested>(_onCommonLikedAlbumsRequested);
    on<CommonPlayedTracksRequested>(_onCommonPlayedTracksRequested);
    on<CommonTopArtistsRequested>(_onCommonTopArtistsRequested);
    on<CommonTracksRequested>(_onCommonTracksRequested);
    on<CommonArtistsRequested>(_onCommonArtistsRequested);
  }

  Future<void> _onCommonLikedTracksRequested(
    CommonLikedTracksRequested event,
    Emitter<MusicState> emit,
  ) async {
    emit(MusicLoading());
    final result = await _repository.getCommonLikedTracks(event.username);
    result.fold(
      (failure) => emit(MusicFailure(failure.message)),
      (tracks) => emit(CommonLikedTracksLoaded(tracks)),
    );
  }

  Future<void> _onCommonLikedArtistsRequested(
    CommonLikedArtistsRequested event,
    Emitter<MusicState> emit,
  ) async {
    emit(MusicLoading());
    final result = await _repository.getCommonLikedArtists(event.username);
    result.fold(
      (failure) => emit(MusicFailure(failure.message)),
      (artists) => emit(CommonLikedArtistsLoaded(artists)),
    );
  }

  Future<void> _onCommonLikedAlbumsRequested(
    CommonLikedAlbumsRequested event,
    Emitter<MusicState> emit,
  ) async {
    emit(MusicLoading());
    final result = await _repository.getCommonLikedAlbums(event.username);
    result.fold(
      (failure) => emit(MusicFailure(failure.message)),
      (albums) => emit(CommonLikedAlbumsLoaded(albums)),
    );
  }

  Future<void> _onCommonPlayedTracksRequested(
    CommonPlayedTracksRequested event,
    Emitter<MusicState> emit,
  ) async {
    emit(MusicLoading());
    final result = await _repository.getCommonPlayedTracks(event.identifier,
        page: event.page);
    result.fold(
      (failure) => emit(MusicFailure(failure.message)),
      (tracks) => emit(CommonPlayedTracksLoaded(tracks)),
    );
  }

  Future<void> _onCommonTopArtistsRequested(
    CommonTopArtistsRequested event,
    Emitter<MusicState> emit,
  ) async {
    emit(MusicLoading());
    final result = await _repository.getCommonTopArtists(event.username);
    result.fold(
      (failure) => emit(MusicFailure(failure.message)),
      (artists) => emit(CommonTopArtistsLoaded(artists)),
    );
  }

  Future<void> _onCommonTracksRequested(
    CommonTracksRequested event,
    Emitter<MusicState> emit,
  ) async {
    emit(MusicLoading());
    final result = await _repository.getCommonTracks(event.budUid);
    result.fold(
      (failure) => emit(MusicFailure(failure.message)),
      (tracks) => emit(CommonTracksLoaded(tracks)),
    );
  }

  Future<void> _onCommonArtistsRequested(
    CommonArtistsRequested event,
    Emitter<MusicState> emit,
  ) async {
    emit(MusicLoading());
    final result = await _repository.getCommonArtists(event.budUid);
    result.fold(
      (failure) => emit(MusicFailure(failure.message)),
      (artists) => emit(CommonArtistsLoaded(artists)),
    );
  }
}
