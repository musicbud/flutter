import '../../models/library_item.dart';

abstract class LibraryRepository {
  Future<List<LibraryItem>> getLibraryItems({
    required String type,
    String? query,
    bool refresh = false,
  });
  
  Future<void> toggleLiked({
    required String itemId,
    required String type,
  });
  
  Future<void> toggleDownloaded({
    required String itemId,
    required String type,
  });
  
  Future<void> playItem({
    required String itemId,
    required String type,
  });
  
  Future<void> createPlaylist({
    required String name,
    String? description,
    bool isPrivate = false,
  });
  
  Future<void> deletePlaylist(String playlistId);
}
