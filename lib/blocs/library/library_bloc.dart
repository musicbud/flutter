import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/content_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../models/artist.dart';
import '../../models/album.dart';
import '../../models/genre.dart';
import 'library_event.dart';
import 'library_state.dart';

class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final ContentRepository _contentRepository;
  final UserRepository _userRepository;

  LibraryBloc({
    required ContentRepository contentRepository,
    required UserRepository userRepository,
  })  : _contentRepository = contentRepository,
        _userRepository = userRepository,
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
      final items = await _getLibraryItems(event.type, event.query);
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
      await _contentRepository.toggleLike(event.itemId, event.type);
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
    // TODO: Implement download functionality
    emit(const LibraryActionFailure('Download not implemented'));
  }

  Future<void> _onLibraryItemPlayRequested(
    LibraryItemPlayRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      // Assume track for now
      await _contentRepository.savePlayedTrack(event.itemId);
      emit(const LibraryActionSuccess('Started playing'));
    } catch (error) {
      emit(LibraryActionFailure(error.toString()));
    }
  }

  Future<void> _onLibraryPlaylistCreated(
    LibraryPlaylistCreated event,
    Emitter<LibraryState> emit,
  ) async {
    // TODO: Implement playlist creation
    emit(const LibraryActionFailure('Playlist creation not implemented'));
  }

  Future<void> _onLibraryPlaylistDeleted(
    LibraryPlaylistDeleted event,
    Emitter<LibraryState> emit,
  ) async {
    // TODO: Implement playlist deletion
    emit(const LibraryActionFailure('Playlist deletion not implemented'));
  }

  Future<void> _onLibraryItemsRefreshRequested(
    LibraryItemsRefreshRequested event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      emit(LibraryLoading());
      final items = await _getLibraryItems(event.type, null);
      emit(LibraryLoaded(
        items: items,
        currentType: event.type,
        totalCount: items.length,
      ));
    } catch (error) {
      emit(LibraryError(error.toString()));
    }
  }

  Future<List<dynamic>> _getLibraryItems(String type, String? query) async {
    switch (type) {
      case 'tracks':
        return await _contentRepository.getLikedTracks();
      case 'artists':
        return await _contentRepository.getLikedArtists();
      case 'albums':
        return await _contentRepository.getLikedAlbums();
      case 'genres':
        return await _contentRepository.getLikedGenres();
      default:
        return [];
    }
  }
}
