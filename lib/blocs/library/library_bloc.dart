import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/library_repository.dart';
import 'library_event.dart';
import 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final LibraryRepository _libraryRepository;

  LibraryBloc({
    required LibraryRepository libraryRepository,
  })  : _libraryRepository = libraryRepository,
        super(LibraryInitial()) {
    on<LibraryItemsRequested>(_onLibraryItemsRequested);
    on<LibraryItemToggleLiked>(_onLibraryItemToggleLiked);
    on<LibraryItemToggleDownload>(_onLibraryItemToggleDownload);
    on<LibraryItemPlayRequested>(_onLibraryItemPlayRequested);
    on<LibraryPlaylistCreated>(_onLibraryPlaylistCreated);
    on<LibraryPlaylistDeleted>(_onLibraryPlaylistDeleted);
    on<LibraryItemsRefreshRequested>(_onLibraryItemsRefreshRequested);
  }

  Future<void> _onLibraryItemsRequested(
    LibraryItemsRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      emit(LibraryLoading());
      final items = await _libraryRepository.getLibraryItems(
        type: event.type,
        query: event.query,
      );
      emit(LibraryLoaded(
        items: items,
        currentType: event.type,
        totalCount: items.length,
      ));
    } catch (error) {
      emit(LibraryError(error.toString()));
    }
  }

  Future<void> _onLibraryItemToggleLiked(
    LibraryItemToggleLiked event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      await _libraryRepository.toggleLiked(
        itemId: event.itemId,
        type: event.type,
      );
      emit(const LibraryActionSuccess('Item like status updated'));
      
      // Refresh the current view
      if (state is LibraryLoaded) {
        final currentState = state as LibraryLoaded;
        add(LibraryItemsRefreshRequested(type: currentState.currentType));
      }
    } catch (error) {
      emit(LibraryActionFailure(error.toString()));
    }
  }

  Future<void> _onLibraryItemToggleDownload(
    LibraryItemToggleDownload event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      await _libraryRepository.toggleDownloaded(
        itemId: event.itemId,
        type: event.type,
      );
      emit(const LibraryActionSuccess('Item download status updated'));
      
      // Refresh the current view
      if (state is LibraryLoaded) {
        final currentState = state as LibraryLoaded;
        add(LibraryItemsRefreshRequested(type: currentState.currentType));
      }
    } catch (error) {
      emit(LibraryActionFailure(error.toString()));
    }
  }

  Future<void> _onLibraryItemPlayRequested(
    LibraryItemPlayRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      await _libraryRepository.playItem(
        itemId: event.itemId,
        type: event.type,
      );
      emit(const LibraryActionSuccess('Started playing'));
    } catch (error) {
      emit(LibraryActionFailure(error.toString()));
    }
  }

  Future<void> _onLibraryPlaylistCreated(
    LibraryPlaylistCreated event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      await _libraryRepository.createPlaylist(
        name: event.name,
        description: event.description,
        isPrivate: event.isPrivate,
      );
      emit(const LibraryActionSuccess('Playlist created successfully'));
      
      // Refresh playlists
      add(const LibraryItemsRefreshRequested(type: 'playlists'));
    } catch (error) {
      emit(LibraryActionFailure(error.toString()));
    }
  }

  Future<void> _onLibraryPlaylistDeleted(
    LibraryPlaylistDeleted event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      await _libraryRepository.deletePlaylist(event.playlistId);
      emit(const LibraryActionSuccess('Playlist deleted successfully'));
      
      // Refresh playlists
      add(const LibraryItemsRefreshRequested(type: 'playlists'));
    } catch (error) {
      emit(LibraryActionFailure(error.toString()));
    }
  }

  Future<void> _onLibraryItemsRefreshRequested(
    LibraryItemsRefreshRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      emit(LibraryLoading());
      final items = await _libraryRepository.getLibraryItems(
        type: event.type,
        refresh: true,
      );
      emit(LibraryLoaded(
        items: items,
        currentType: event.type,
        totalCount: items.length,
      ));
    } catch (error) {
      emit(LibraryError(error.toString()));
    }
  }
}
