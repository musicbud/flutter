import '../../domain/models/discover_item.dart';

abstract class DiscoverRepository {
  /// Get available discovery categories
  Future<List<String>> getCategories();

  /// Get discover items for a specific category
  Future<List<DiscoverItem>> getDiscoverItems(String category);

  /// Track user interaction with discover items
  Future<void> trackInteraction({
    required String itemId,
    required String type,
    required String action,
  });
}
