import 'package:flutter/foundation.dart';

/// Dynamic API configuration based on Postman collection
class DynamicApiConfig {
  // Base configuration
  static const String baseUrl = 'http://84.235.170.234';
  static const String localBaseUrl = 'http://127.0.0.1:8000';

  // API Version prefix
  static const String apiVersion = '';

  // Current base URL (can be switched dynamically)
  // Use local for development, remote for production
  static String get currentBaseUrl => baseUrl;

  // Bud/Matching Endpoints
  static const Map<String, String> budEndpoints = {
    'profile': '/bud/profile',
    'topArtists': '/bud/top/artists',
    'topTracks': '/bud/top/tracks',
    'topGenres': '/bud/top/genres',
    'topAnime': '/bud/top/anime',
    'topManga': '/bud/top/manga',
    'likedArtists': '/bud/liked/artists',
    'likedTracks': '/bud/liked/tracks',
    'likedGenres': '/bud/liked/genres',
    'likedAlbums': '/bud/liked/albums',
    'likedAio': '/bud/liked/aio',
    'playedTracks': '/bud/played/tracks',
    'byTrack': '/bud/track',
    'byArtist': '/bud/artist',
    'byGenre': '/bud/genre',
    'byAlbum': '/bud/album/',
  };

  // Common Bud Endpoints
  static const Map<String, String> commonBudEndpoints = {
    'commonTopArtists': '/bud/common/top/artists',
    'commonTopTracks': '/bud/common/top/tracks',
    'commonTopGenres': '/bud/common/top/genres',
    'commonTopAnime': '/bud/common/top/anime',
    'commonTopManga': '/bud/common/top/manga',
    'commonLikedArtists': '/bud/common/liked/artists',
    'commonLikedTracks': '/bud/common/liked/tracks',
    'commonLikedGenres': '/bud/common/liked/genres',
    'commonLikedAlbums': '/bud/common/liked/albums',
    'commonPlayedTracks': '/bud/common/played/tracks',
  };

  // Auth Endpoints
  static const Map<String, String> authEndpoints = {
    'login': '/login/',
    'register': '/register/',
    'logout': '/logout/',
    'tokenRefresh': '/token/refresh',
    'serviceLogin': '/service/login',
    'spotifyConnect': '/spotify/connect',
    'ytmusicConnect': '/ytmusic/connect',
    'lastfmConnect': '/lastfm/connect',
    'malConnect': '/mal/connect',
    'spotifyRefreshToken': '/spotify/token/refresh',
    'ytmusicRefreshToken': '/ytmusic/token/refresh',
  };

  // User Profile Endpoints
  static const Map<String, String> userEndpoints = {
    'myProfile': '/me/profile',
    'setMyProfile': '/me/profile/set',
    'updateMyLikes': '/me/likes/update',
  };

  // Service Endpoints
  static const Map<String, String> serviceEndpoints = {
    'spotify': '/service/login?service=spotify',
    'lastfm': '/service/login?service=lastfm',
    'ytmusic': '/service/login?service=ytmusic',
    'mal': '/service/login?service=mal',
    'spotifyCallback': '/spotify/callback',
    'ytmusicCallback': '/ytmusic/callback',
    'lastfmCallback': '/lastfm/callback',
    'malCallback': '/mal/callback',
  };

  // Common Content Endpoints
  static const Map<String, String> contentEndpoints = {
    'likedArtists': '/me/liked/artists',
    'likedTracks': '/me/liked/tracks',
    'likedGenres': '/me/liked/genres',
    'likedAlbums': '/me/liked/albums',
    'playedTracks': '/me/played/tracks',
    'topArtists': '/me/top/artists',
    'topTracks': '/me/top/tracks',
    'topGenres': '/me/top/genres',
    'topAnime': '/me/top/anime',
    'topManga': '/me/top/manga',
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
