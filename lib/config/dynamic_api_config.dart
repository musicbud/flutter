import 'package:flutter/foundation.dart';

/// Dynamic API configuration based on Postman collection
class DynamicApiConfig {
  // Base configuration
  static const String baseUrl = 'http://84.235.170.234';
  static const String localBaseUrl = 'http://127.0.0.1:8000';

  // API Version prefix
  static const String apiVersion = '/v1';

  // Current base URL (can be switched dynamically)
  // Use local for development, remote for production
  static String get currentBaseUrl => localBaseUrl;

  // Bud/Matching Endpoints
  static const Map<String, String> budEndpoints = {
    'profile': '/v1/bud/profile',
    'topArtists': '/v1/bud/top/artists',
    'topTracks': '/v1/bud/top/tracks',
    'topGenres': '/v1/bud/top/genres',
    'topAnime': '/v1/bud/top/anime',
    'topManga': '/v1/bud/top/manga',
    'likedArtists': '/v1/bud/liked/artists',
    'likedTracks': '/v1/bud/liked/tracks',
    'likedGenres': '/v1/bud/liked/genres',
    'likedAlbums': '/v1/bud/liked/albums',
    'likedAio': '/v1/bud/liked/aio',
    'playedTracks': '/v1/bud/played/tracks',
    'byTrack': '/v1/bud/artist',
    'byArtist': '/v1/bud/artist',
    'byGenre': '/v1/bud/genre',
  };

  // Common Bud Endpoints
  static const Map<String, String> commonBudEndpoints = {
    'commonTopArtists': '/v1/bud/common/top/artists',
    'commonTopTracks': '/v1/bud/common/top/tracks',
    'commonTopGenres': '/v1/bud/common/top/genres',
    'commonTopAnime': '/v1/bud/common/top/anime',
    'commonTopManga': '/v1/bud/common/top/manga',
    'commonLikedArtists': '/v1/bud/common/liked/artists',
    'commonLikedTracks': '/v1/bud/common/liked/tracks',
    'commonLikedGenres': '/v1/bud/common/liked/genres',
    'commonLikedAlbums': '/v1/bud/common/liked/albums',
    'commonPlayedTracks': '/v1/bud/common/played/tracks',
  };

  // Auth Endpoints
  static const Map<String, String> authEndpoints = {
    'login': '/v1/login/',
    'register': '/v1/register/',
    'serviceLogin': '/v1/service/login',
    'spotifyConnect': '/v1/spotify/connect',
    'ytmusicConnect': '/v1/ytmusic/connect',
    'lastfmConnect': '/v1/lastfm/connect',
    'malConnect': '/v1/mal/connect',
    'spotifyRefreshToken': '/v1/spotify/token/refresh',
  };

  // User Profile Endpoints
  static const Map<String, String> userEndpoints = {
    'myProfile': '/v1/me/profile',
    'getProfile': '/v1/me/profile',
  };

  // Service Endpoints
  static const Map<String, String> serviceEndpoints = {
    'spotify': '/v1/service/login?service=spotify',
    'lastfm': '/v1/service/login?service=lastfm',
    'ytmusic': '/v1/service/login?service=ytmusic',
    'mal': '/v1/service/login?service=mal',
  };

  // Common Content Endpoints
  static const Map<String, String> contentEndpoints = {
    'topArtists': '/v1/bud/common/top/artists',
    'topTracks': '/v1/bud/common/top/tracks',
    'topGenres': '/v1/bud/common/top/genres',
    'topAnime': '/v1/bud/common/top/anime',
    'topManga': '/v1/bud/common/top/manga',
    'likedArtists': '/v1/bud/common/liked/artists',
    'likedTracks': '/v1/bud/common/liked/tracks',
    'likedGenres': '/v1/bud/common/liked/genres',
    'likedAlbums': '/v1/bud/common/liked/albums',
    'playedTracks': '/v1/bud/common/played/tracks',
  };

  /// Get full URL for an endpoint
  static String getEndpointUrl(String endpoint) {
    // Backend doesn't use /v1 prefix
    return '$currentBaseUrl$endpoint';
  }

  /// Get bud endpoint URL
  static String getBudEndpoint(String key) {
    return getEndpointUrl(budEndpoints[key] ?? '');
  }

  /// Get common bud endpoint URL
  static String getCommonBudEndpoint(String key) {
    return getEndpointUrl(commonBudEndpoints[key] ?? '');
  }

  /// Get auth endpoint URL
  static String getAuthEndpoint(String key) {
    return getEndpointUrl(authEndpoints[key] ?? '');
  }

  /// Get service endpoint URL
  static String getServiceEndpoint(String key) {
    return getEndpointUrl(serviceEndpoints[key] ?? '');
  }

  /// Get content endpoint URL
  static String getContentEndpoint(String key) {
    return getEndpointUrl(contentEndpoints[key] ?? '');
  }

  /// Get all available bud matching types
  static List<String> getBudMatchingTypes() {
    return [
      'topArtists',
      'topTracks',
      'topGenres',
      'topAnime',
      'topManga',
      'likedArtists',
      'likedTracks',
      'likedGenres',
      'likedAlbums',
      'likedAio',
      'playedTracks',
    ];
  }

  /// Get all available services
  static List<String> getAvailableServices() {
    return ['spotify', 'lastfm', 'ytmusic', 'mal'];
  }

  /// Get all available content types
  static List<String> getContentTypes() {
    return [
      'artists',
      'tracks',
      'genres',
      'anime',
      'manga',
      'albums',
    ];
  }

  /// Check if endpoint exists
  static bool hasEndpoint(String category, String key) {
    switch (category) {
      case 'bud':
        return budEndpoints.containsKey(key);
      case 'commonBud':
        return commonBudEndpoints.containsKey(key);
      case 'auth':
        return authEndpoints.containsKey(key);
      case 'service':
        return serviceEndpoints.containsKey(key);
      case 'content':
        return contentEndpoints.containsKey(key);
      default:
        return false;
    }
  }

  /// Get endpoint configuration
  static Map<String, dynamic> getEndpointConfig(String category, String key) {
    if (!hasEndpoint(category, key)) {
      return {};
    }

    String endpoint = '';
    switch (category) {
      case 'bud':
        endpoint = budEndpoints[key]!;
        break;
      case 'commonBud':
        endpoint = commonBudEndpoints[key]!;
        break;
      case 'auth':
        endpoint = authEndpoints[key]!;
        break;
      case 'service':
        endpoint = serviceEndpoints[key]!;
        break;
      case 'content':
        endpoint = contentEndpoints[key]!;
        break;
    }

    return {
      'url': getEndpointUrl(endpoint),
      'method': 'POST', // Most endpoints use POST
      'category': category,
      'key': key,
    };
  }

  /// Get all endpoints for a category
  static Map<String, String> getEndpointsForCategory(String category) {
    switch (category) {
      case 'bud':
        return Map.from(budEndpoints);
      case 'commonBud':
        return Map.from(commonBudEndpoints);
      case 'auth':
        return Map.from(authEndpoints);
      case 'service':
        return Map.from(serviceEndpoints);
      case 'content':
        return Map.from(contentEndpoints);
      default:
        return {};
    }
  }

  /// Debug method to log all available endpoints
  static void logAllEndpoints() {
    debugPrint('🔧 Dynamic API Configuration:');
    debugPrint('Base URL: $currentBaseUrl');
    debugPrint('Available Categories: bud, commonBud, auth, service, content');

    for (final category in ['bud', 'commonBud', 'auth', 'service', 'content']) {
      debugPrint('$category Endpoints:');
      final endpoints = getEndpointsForCategory(category);
      endpoints.forEach((key, endpoint) {
        debugPrint('  $key: $endpoint');
      });
    }
  }

  /// Switch base URL (for testing or different environments)
  static void switchBaseUrl(String newBaseUrl) {
    // This would be implemented to switch between different environments
    debugPrint('Switching base URL to: $newBaseUrl');
  }
}
