import 'package:flutter/foundation.dart';
import '../config/api_config.dart';

/// Utility class to validate API endpoints and identify potential mismatches
class ApiEndpointValidator {
  /// List of known valid endpoints from the backend
  static const List<String> _validEndpoints = [
    // Authentication endpoints
    '/login/',
    '/register/',
    '/chat/refresh-token/',
    '/logout/',

    // Profile endpoints
    '/me/profile',
    '/bud/profile',
    '/me/profile/set',
    '/me/likes/update',
    '/profile/services',
    '/profile/avatar',
    '/profile/top-items',

    // Bud matching endpoints
    '/bud/common/liked/artists',
    '/bud/common/liked/tracks',
    '/bud/common/liked/genres',
    '/bud/common/liked/albums',
    '/bud/common/played/tracks',
    '/bud/common/top/artists',
    '/bud/common/top/tracks',
    '/bud/common/top/genres',
    '/bud/common/top/anime',
    '/bud/common/top/manga',

    // Chat endpoints
    '/chat/login/',
    '/chat/get_channels/',
    '/chat/create_channel/',
    '/chat/get_channel_users',
    '/chat/get_channel_messages',
    '/chat/send_message/',
    '/chat/send_channel_message/',
    '/chat/send_user_message/',
    '/chat/channel',
    '/chat/join_channel/',
    '/chat/leave_channel/',
    '/chat/request_join/',

    // Service connection endpoints
    '/service/spotify/auth',
    '/service/spotify/connect',
    '/service/spotify/disconnect',
    '/service/lastfm/auth',
    '/service/lastfm/connect',
    '/service/lastfm/disconnect',
    '/service/ytmusic/auth',
    '/service/ytmusic/connect',
    '/service/ytmusic/disconnect',
    '/service/mal/auth',
    '/service/mal/connect',
    '/service/mal/disconnect',

    // User endpoints
    '/users',
    '/users/profile',
    '/users/messages',

    // Channel endpoints
    '/channels',
    '/channels/details',
    '/channels/messages',
    '/channels/users',
    '/channels/roles',
    '/channels/dashboard',
    '/channels/admin',
  ];

  /// Check if an endpoint is valid according to the backend structure
  static bool isValidEndpoint(String endpoint) {
    // Remove query parameters and fragments
    final cleanEndpoint = endpoint.split('?')[0].split('#')[0];

    // Check exact match first
    if (_validEndpoints.contains(cleanEndpoint)) {
      return true;
    }

    // Check pattern matches for dynamic endpoints
    for (final validEndpoint in _validEndpoints) {
      if (_matchesPattern(cleanEndpoint, validEndpoint)) {
        return true;
      }
    }

    return false;
  }

  /// Check if an endpoint matches a pattern (for dynamic endpoints)
  static bool _matchesPattern(String endpoint, String pattern) {
    // Handle dynamic path parameters like /channels/{id}/
    final patternParts = pattern.split('/');
    final endpointParts = endpoint.split('/');

    if (patternParts.length != endpointParts.length) {
      return false;
    }

    for (int i = 0; i < patternParts.length; i++) {
      final patternPart = patternParts[i];
      final endpointPart = endpointParts[i];

      // Skip empty parts
      if (patternPart.isEmpty && endpointPart.isEmpty) continue;

      // Check if this is a dynamic part (contains {id} or similar)
      if (patternPart.startsWith('{') && patternPart.endsWith('}')) {
        // Dynamic part - any value is valid
        continue;
      }

      // Static part must match exactly
      if (patternPart != endpointPart) {
        return false;
      }
    }

    return true;
  }

  /// Validate all endpoints used in the app
  static void validateAllEndpoints() {
    if (kDebugMode) {
      print('🔍 Validating API endpoints...');

      final endpointsToCheck = [
        ApiConfig.login,
        ApiConfig.register,
        ApiConfig.refreshToken,
        ApiConfig.logout,
        ApiConfig.myProfile,
        ApiConfig.budProfile,
        ApiConfig.updateProfile,
        ApiConfig.updateLikes,
        ApiConfig.profileServices,
        ApiConfig.profileAvatar,
        ApiConfig.topItems,
        ApiConfig.budCommonLikedArtists,
        ApiConfig.budCommonLikedTracks,
        ApiConfig.chatLogin,
        ApiConfig.chatGetChannels,
        ApiConfig.chatCreateChannel,
        ApiConfig.spotifyAuth,
        ApiConfig.spotifyConnect,
        ApiConfig.spotifyDisconnect,
      ];

      int validCount = 0;
      int invalidCount = 0;

      for (final endpoint in endpointsToCheck) {
        if (isValidEndpoint(endpoint)) {
          validCount++;
          print('✅ $endpoint');
        } else {
          invalidCount++;
          print('❌ $endpoint (INVALID)');
        }
      }

      print('\n📊 Endpoint Validation Results:');
      print('✅ Valid endpoints: $validCount');
      print('❌ Invalid endpoints: $invalidCount');

      if (invalidCount > 0) {
        print('\n🚨 Some endpoints are invalid!');
        print('💡 Check the backend repository for correct endpoints:');
        print('   https://github.com/musicbud/backend');
        print('🔧 Update ApiConfig.dart with the correct endpoints');
      }
    }
  }

  /// Get suggestions for similar endpoints when a 404 occurs
  static List<String> getSimilarEndpoints(String invalidEndpoint) {
    final suggestions = <String>[];
    final invalidParts = invalidEndpoint.toLowerCase().split('/');

    for (final validEndpoint in _validEndpoints) {
      final validParts = validEndpoint.toLowerCase().split('/');
      int similarity = 0;

      // Calculate similarity based on common parts
      for (int i = 0; i < invalidParts.length && i < validParts.length; i++) {
        if (invalidParts[i] == validParts[i]) {
          similarity++;
        }
      }

      // If similarity is high enough, add as suggestion
      if (similarity > 0 && similarity >= invalidParts.length / 2) {
        suggestions.add(validEndpoint);
      }
    }

    // Sort by similarity (most similar first)
    suggestions.sort((a, b) {
      final aSimilarity = _calculateSimilarity(invalidEndpoint, a);
      final bSimilarity = _calculateSimilarity(invalidEndpoint, b);
      return bSimilarity.compareTo(aSimilarity);
    });

    return suggestions.take(5).toList(); // Return top 5 suggestions
  }

  /// Calculate similarity between two endpoints
  static double _calculateSimilarity(String endpoint1, String endpoint2) {
    final parts1 = endpoint1.toLowerCase().split('/');
    final parts2 = endpoint2.toLowerCase().split('/');

    int commonParts = 0;
    int totalParts = parts1.length + parts2.length;

    for (final part1 in parts1) {
      if (parts2.contains(part1)) {
        commonParts++;
      }
    }

    return (2.0 * commonParts) / totalParts;
  }

  /// Log endpoint validation on app startup
  static void logEndpointValidation() {
    if (kDebugMode) {
      print('\n🚀 MusicBud Flutter App - API Endpoint Validation');
      print('🌐 Backend URL: ${ApiConfig.baseUrl}');
      print('📚 Backend Repository: https://github.com/musicbud/backend');
      print('🔍 Validating endpoints...\n');

      validateAllEndpoints();

      print('\n💡 Tips for fixing 404 errors:');
      print('   1. Check the backend repository for correct endpoints');
      print('   2. Ensure API version is correct (currently: ${ApiConfig.apiVersion})');
      print('   3. Verify the backend server is running and accessible');
      print('   4. Check if endpoints have been renamed or moved');
      print('   5. Use the getSimilarEndpoints() method for suggestions\n');
    }
  }
}