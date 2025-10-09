import '../../../domain/repositories/discover_repository.dart';

class DiscoverContentManager {
  final DiscoverRepository _repository;

  DiscoverContentManager({required DiscoverRepository repository})
      : _repository = repository;

  Future<List<String>> getCategories() async {
    try {
      return await _repository.getDiscoverCategories();
    } catch (e) {
      // Fallback to default categories if API fails
      return ['All', 'Pop', 'Rock', 'Hip Hop', 'Electronic', 'Jazz', 'Classical', 'Country'];
    }
  }

  Future<List<Map<String, dynamic>>> getFeaturedArtists() async {
    try {
      final data = await _repository.getFeaturedArtists();
      return data.map((item) => _transformFeaturedArtist(item)).toList();
    } catch (e) {
      // Fallback to empty list if API fails
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getTrendingTracks() async {
    try {
      final data = await _repository.getTrendingTracks();
      return data.map((item) => _transformTrendingTrack(item)).toList();
    } catch (e) {
      // Fallback to empty list if API fails
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getNewReleases() async {
    try {
      final data = await _repository.getNewReleases();
      return data.map((item) => _transformNewRelease(item)).toList();
    } catch (e) {
      // Fallback to empty list if API fails
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getDiscoverActions() async {
    try {
      final data = await _repository.getDiscoverActions();
      return data.map((item) => _transformDiscoverAction(item)).toList();
    } catch (e) {
      // Fallback to default actions if API fails
      return [
        {
          'title': 'Create Playlist',
          'subtitle': 'Build your perfect mix',
          'icon': 'playlist_add',
          'accentColor': 0xFF4CAF50, // Green
        },
        {
          'title': 'Follow Artists',
          'subtitle': 'Stay updated with favorites',
          'icon': 'person_add',
          'accentColor': 0xFFFF9800, // Orange
        },
      ];
    }
  }

  // Filter content based on selected category
  List<Map<String, dynamic>> filterByCategory(
    List<Map<String, dynamic>> content,
    String category,
  ) {
    if (category == 'All') return content;
    return content.where((item) => item['genre'] == category).toList();
  }

  // Helper methods to transform API data to the expected format
  Map<String, dynamic> _transformFeaturedArtist(Map<String, dynamic> data) {
    return {
      'name': data['name'] ?? 'Unknown Artist',
      'genre': data['genre'] ?? 'Unknown',
      'imageUrl': data['image_url'],
      'accentColor': _parseColor(data['accent_color']),
    };
  }

  Map<String, dynamic> _transformTrendingTrack(Map<String, dynamic> data) {
    return {
      'title': data['title'] ?? 'Unknown Track',
      'artist': data['artist'] ?? 'Unknown Artist',
      'genre': data['genre'] ?? 'Unknown',
      'imageUrl': data['image_url'],
      'icon': _parseIconData(data['icon']),
      'accentColor': _parseColor(data['accent_color']),
    };
  }

  Map<String, dynamic> _transformNewRelease(Map<String, dynamic> data) {
    return {
      'title': data['title'] ?? 'Unknown Release',
      'artist': data['artist'] ?? 'Unknown Artist',
      'type': data['type'] ?? 'Release',
      'imageUrl': data['image_url'],
      'icon': _parseIconData(data['icon']),
      'accentColor': _parseColor(data['accent_color']),
    };
  }

  Map<String, dynamic> _transformDiscoverAction(Map<String, dynamic> data) {
    return {
      'title': data['title'] ?? 'Action',
      'subtitle': data['subtitle'] ?? '',
      'icon': _parseIconData(data['icon']),
      'accentColor': _parseColor(data['accent_color']),
    };
  }

  dynamic _parseIconData(String? iconString) {
    if (iconString == null) return null;

    switch (iconString) {
      case 'playlist_add':
        return 'playlist_add';
      case 'person_add':
        return 'person_add';
      case 'music_note':
        return 'music_note';
      case 'album':
        return 'album';
      case 'audiotrack':
        return 'audiotrack';
      default:
        return 'music_note';
    }
  }

  dynamic _parseColor(String? colorString) {
    if (colorString == null) return null;

    try {
      if (colorString.startsWith('#')) {
        return int.parse(colorString.substring(1), radix: 16) + 0xFF000000;
      }
      return int.parse(colorString, radix: 16) + 0xFF000000;
    } catch (e) {
      return 0xFF2196F3; // Default blue color
    }
  }
}