import 'dart:async';
import 'dart:math' as math;
import 'package:dio/dio.dart';
import 'mock_data_service.dart';

/// Enhanced Mock Backend Service
/// Provides API-compatible responses for development and testing
class EnhancedMockBackend {
  static final EnhancedMockBackend _instance = EnhancedMockBackend._internal();
  factory EnhancedMockBackend() => _instance;
  EnhancedMockBackend._internal();

  static EnhancedMockBackend get instance => _instance;

  final math.Random _random = math.Random();
  final Map<String, dynamic> _cache = {};
  
  // Mock authentication state
  bool _isAuthenticated = false;
  Map<String, dynamic>? _currentUser;
  String? _accessToken;

  /// Initialize mock backend
  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _generateInitialData();
  }

  void _generateInitialData() {
    // Generate current user
    _currentUser = MockDataService.generateUserProfile(userId: 'current_user');
    
    // Cache common data
    _cache['top_artists'] = MockDataService.generateTopArtists(count: 50);
    _cache['top_tracks'] = MockDataService.generateTopTracks(count: 100);
    _cache['buds'] = MockDataService.generateBudRecommendations(count: 30);
    _cache['chats'] = MockDataService.generateChats(count: 15);
    _cache['activity'] = MockDataService.generateRecentActivity(count: 50);
  }

  /// Mock API response wrapper
  Map<String, dynamic> _wrapResponse({
    required dynamic data,
    bool success = true,
    String? message,
    Map<String, dynamic>? error,
  }) {
    if (success) {
      return {
        'success': true,
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
      };
    } else {
      return {
        'success': false,
        'error': error ?? {
          'code': 'UNKNOWN_ERROR',
          'message': message ?? 'An error occurred',
        },
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Simulate network delay
  Future<void> _simulateDelay([int? milliseconds]) async {
    final delay = milliseconds ?? (_random.nextInt(500) + 100);
    await Future.delayed(Duration(milliseconds: delay));
  }

  /// Simulate random errors for testing
  void _simulateRandomError() {
    if (_random.nextDouble() < 0.05) { // 5% chance of error
      throw DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
        message: 'Mock network error',
      );
    }
  }

  // ========================================================================
  // AUTHENTICATION ENDPOINTS
  // ========================================================================

  /// POST /auth/login
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    await _simulateDelay(800);
    _simulateRandomError();

    // Simple mock validation
    if (username.isEmpty || password.isEmpty) {
      return _wrapResponse(
        success: false,
        error: {
          'code': 'VALIDATION_ERROR',
          'message': 'Username and password are required',
        },
        data: null,
      );
    }

    if (password.length < 6) {
      return _wrapResponse(
        success: false,
        error: {
          'code': 'INVALID_CREDENTIALS',
          'message': 'Invalid username or password',
        },
        data: null,
      );
    }

    // Generate mock tokens
    _accessToken = 'mock_access_token_${_random.nextInt(100000)}';
    _isAuthenticated = true;
    
    final user = MockDataService.generateUserProfile(userId: 'current_user');
    user['username'] = username;
    _currentUser = user;

    return _wrapResponse(data: {
      'user': user,
      'tokens': {
        'accessToken': _accessToken,
        'refreshToken': 'mock_refresh_token_${_random.nextInt(100000)}',
        'expiresAt': DateTime.now().add(const Duration(hours: 24)).toIso8601String(),
      },
    });
  }

  /// POST /auth/register
  Future<Map<String, dynamic>> register({
    required String username,
    required String email,
    required String password,
    required String displayName,
  }) async {
    await _simulateDelay(1000);
    _simulateRandomError();

    // Mock validation
    if (username.length < 3) {
      return _wrapResponse(
        success: false,
        error: {
          'code': 'VALIDATION_ERROR',
          'message': 'Username must be at least 3 characters',
        },
        data: null,
      );
    }

    return login(username: username, password: password);
  }

  /// POST /auth/logout
  Future<Map<String, dynamic>> logout() async {
    await _simulateDelay(200);
    
    _isAuthenticated = false;
    _currentUser = null;
    _accessToken = null;

    return _wrapResponse(data: {'message': 'Successfully logged out'});
  }

  // ========================================================================
  // USER PROFILE ENDPOINTS
  // ========================================================================

  /// GET /users/me/profile
  Future<Map<String, dynamic>> getCurrentUserProfile() async {
    await _simulateDelay();
    _simulateRandomError();

    if (!_isAuthenticated) {
      return _wrapResponse(
        success: false,
        error: {
          'code': 'UNAUTHORIZED',
          'message': 'Authentication required',
        },
        data: null,
      );
    }

    return _wrapResponse(data: _currentUser);
  }

  /// GET /users/me/stats
  Future<Map<String, dynamic>> getUserStats() async {
    await _simulateDelay();
    _simulateRandomError();

    if (!_isAuthenticated) {
      return _wrapResponse(
        success: false,
        error: {'code': 'UNAUTHORIZED', 'message': 'Authentication required'},
        data: null,
      );
    }

    final stats = {
      'listening': {
        'totalMinutes': _random.nextInt(10000) + 1000,
        'topGenres': [
          {'name': 'Pop', 'percentage': 35 + _random.nextInt(20)},
          {'name': 'Rock', 'percentage': 20 + _random.nextInt(15)},
          {'name': 'Hip-Hop', 'percentage': 15 + _random.nextInt(10)},
        ],
        'topArtists': (_cache['top_artists'] as List).take(5).map((artist) => {
          'name': artist['name'],
          'plays': artist['playCount'],
        }).toList(),
        'topTracks': (_cache['top_tracks'] as List).take(5).map((track) => {
          'name': track['name'],
          'plays': track['playCount'],
        }).toList(),
      },
      'social': {
        'buddies': _random.nextInt(50) + 10,
        'conversations': (_cache['chats'] as List).length,
        'matches': _random.nextInt(100) + 20,
      },
      'activity': {
        'sessionsThisWeek': _random.nextInt(20) + 5,
        'averageSessionLength': _random.nextInt(60) + 30,
        'lastActivity': DateTime.now().subtract(
          Duration(minutes: _random.nextInt(120))
        ).toIso8601String(),
      },
    };

    return _wrapResponse(data: stats);
  }

  // ========================================================================
  // HOME FEED ENDPOINTS
  // ========================================================================

  /// GET /home/feed
  Future<Map<String, dynamic>> getHomeFeed({
    int page = 1,
    int limit = 20,
    String? category,
  }) async {
    await _simulateDelay();
    _simulateRandomError();

    final allItems = <Map<String, dynamic>>[];
    
    // Add recommendations
    final artists = (_cache['top_artists'] as List).take(10);
    for (final artist in artists) {
      allItems.add({
        'id': 'rec_${artist['id']}',
        'type': 'recommendation',
        'title': 'Discover ${artist['name']}',
        'subtitle': 'Based on your listening history',
        'imageUrl': artist['imageUrl'],
        'actionUrl': '/artist/${artist['id']}',
        'metadata': {'artistId': artist['id'], 'type': 'artist'},
        'timestamp': DateTime.now().subtract(
          Duration(hours: _random.nextInt(24))
        ).toIso8601String(),
      });
    }

    // Add activity items
    final activities = (_cache['activity'] as List).take(10);
    for (final activity in activities) {
      allItems.add({
        'id': 'act_${_random.nextInt(10000)}',
        'type': 'activity',
        'title': activity['description'],
        'subtitle': 'Recent activity',
        'imageUrl': activity['imageUrl'],
        'actionUrl': activity['actionUrl'],
        'metadata': activity,
        'timestamp': activity['timestamp'],
      });
    }

    // Add trending items
    final tracks = (_cache['top_tracks'] as List).take(5);
    for (final track in tracks) {
      allItems.add({
        'id': 'trend_${track['id']}',
        'type': 'trending',
        'title': '${track['name']} by ${track['artist']}',
        'subtitle': 'Trending now',
        'imageUrl': track['imageUrl'],
        'actionUrl': '/track/${track['id']}',
        'metadata': {'trackId': track['id'], 'type': 'track'},
        'timestamp': DateTime.now().subtract(
          Duration(minutes: _random.nextInt(360))
        ).toIso8601String(),
      });
    }

    // Shuffle and paginate
    allItems.shuffle(_random);
    final startIndex = (page - 1) * limit;
    final endIndex = math.min(startIndex + limit, allItems.length);
    final paginatedItems = allItems.sublist(startIndex, endIndex);

    return _wrapResponse(data: {
      'items': paginatedItems,
      'pagination': {
        'page': page,
        'limit': limit,
        'total': allItems.length,
        'hasMore': endIndex < allItems.length,
      },
    });
  }

  /// GET /home/recommendations
  Future<Map<String, dynamic>> getRecommendations() async {
    await _simulateDelay();
    _simulateRandomError();

    final recommendations = {
      'artists': (_cache['top_artists'] as List).take(10).map((artist) => {
        ...artist,
        'matchScore': 0.7 + (_random.nextDouble() * 0.3), // 0.7-1.0
      }).toList(),
      'tracks': (_cache['top_tracks'] as List).take(15).map((track) => {
        ...track,
        'matchScore': 0.6 + (_random.nextDouble() * 0.4), // 0.6-1.0
      }).toList(),
      'genres': [
        {
          'name': 'Electronic',
          'matchScore': 0.85 + (_random.nextDouble() * 0.15),
          'topArtists': ['Daft Punk', 'Deadmau5', 'Calvin Harris'],
        },
        {
          'name': 'Indie Rock',
          'matchScore': 0.75 + (_random.nextDouble() * 0.25),
          'topArtists': ['Arctic Monkeys', 'The Strokes', 'Vampire Weekend'],
        },
      ],
    };

    return _wrapResponse(data: recommendations);
  }

  /// GET /home/activity
  Future<Map<String, dynamic>> getActivity() async {
    await _simulateDelay();
    _simulateRandomError();

    return _wrapResponse(data: {
      'activities': _cache['activity'],
    });
  }

  // ========================================================================
  // BUDS/MATCHING ENDPOINTS
  // ========================================================================

  /// GET /buds/matches
  Future<Map<String, dynamic>> getBudMatches({
    String type = 'all',
    int limit = 20,
    int? distance,
  }) async {
    await _simulateDelay(600);
    _simulateRandomError();

    if (!_isAuthenticated) {
      return _wrapResponse(
        success: false,
        error: {'code': 'UNAUTHORIZED', 'message': 'Authentication required'},
        data: null,
      );
    }

    final matches = (_cache['buds'] as List).take(limit).map((bud) => {
      'user': {
        'id': bud['id'],
        'displayName': bud['displayName'],
        'profileImageUrl': bud['profileImageUrl'],
        'location': 'San Francisco, CA', // Mock location
        'bio': bud['bio'],
        'isOnline': bud['isOnline'],
        'lastSeen': bud['lastSeen'],
      },
      'compatibility': {
        'overall': (bud['matchPercentage'] as int) / 100.0,
        'artists': 0.8 + (_random.nextDouble() * 0.2),
        'tracks': 0.75 + (_random.nextDouble() * 0.25),
        'genres': 0.7 + (_random.nextDouble() * 0.3),
      },
      'commonItems': {
        'artists': bud['commonArtists'] ?? [],
        'tracks': ['Song 1', 'Song 2'], // Mock common tracks
        'genres': bud['commonGenres'] ?? [],
      },
      'distance': bud['distance'],
    }).toList();

    return _wrapResponse(data: {'matches': matches});
  }

  // ========================================================================
  // CHAT ENDPOINTS
  // ========================================================================

  /// GET /chat/conversations
  Future<Map<String, dynamic>> getConversations() async {
    await _simulateDelay();
    _simulateRandomError();

    if (!_isAuthenticated) {
      return _wrapResponse(
        success: false,
        error: {'code': 'UNAUTHORIZED', 'message': 'Authentication required'},
        data: null,
      );
    }

    final conversations = (_cache['chats'] as List).map((chat) => {
      'id': chat['id'],
      'type': 'direct',
      'participants': [
        {
          'id': 'other_user_${_random.nextInt(1000)}',
          'displayName': chat['name'],
          'profileImageUrl': chat['profileImageUrl'],
          'isOnline': chat['isOnline'],
        }
      ],
      'lastMessage': {
        'id': 'msg_${_random.nextInt(10000)}',
        'content': chat['lastMessage']['content'],
        'sender': chat['lastMessage']['senderId'],
        'timestamp': chat['lastMessageAt'],
      },
      'unreadCount': chat['unreadCount'],
      'isPinned': false,
      'updatedAt': chat['lastMessageAt'],
    }).toList();

    return _wrapResponse(data: {'conversations': conversations});
  }

  // ========================================================================
  // CONTENT ENDPOINTS
  // ========================================================================

  /// GET /content/top-artists
  Future<Map<String, dynamic>> getTopArtists({
    String timeframe = 'month',
    String? genre,
    int limit = 20,
  }) async {
    await _simulateDelay();
    _simulateRandomError();

    final artists = (_cache['top_artists'] as List)
        .take(limit)
        .map((artist) => {
              ...artist,
              'followers': artist['followers'],
              'popularity': artist['popularity'],
            })
        .toList();

    return _wrapResponse(data: {'artists': artists});
  }

  /// GET /content/top-tracks
  Future<Map<String, dynamic>> getTopTracks({
    String timeframe = 'month',
    String? genre,
    int limit = 50,
  }) async {
    await _simulateDelay();
    _simulateRandomError();

    final tracks = (_cache['top_tracks'] as List)
        .take(limit)
        .map((track) => {
              'id': track['id'],
              'title': track['name'],
              'artist': track['artist'],
              'album': track['album'],
              'imageUrl': track['imageUrl'],
              'previewUrl': track['previewUrl'],
              'duration': track['duration'] * 1000, // Convert to milliseconds
              'popularity': track['popularity'],
            })
        .toList();

    return _wrapResponse(data: {'tracks': tracks});
  }

  // ========================================================================
  // UTILITY METHODS
  // ========================================================================

  /// Check if user is authenticated
  bool get isAuthenticated => _isAuthenticated;

  /// Get current user
  Map<String, dynamic>? get currentUser => _currentUser;

  /// Clear all cached data
  void clearCache() {
    _cache.clear();
    _generateInitialData();
  }

  /// Simulate going offline
  void simulateOffline() {
    // All requests will throw connection errors
  }

  /// Get mock WebSocket events
  Stream<Map<String, dynamic>> getWebSocketEvents() async* {
    while (_isAuthenticated) {
      await Future.delayed(Duration(seconds: 5 + _random.nextInt(25)));
      
      final events = [
        {
          'type': 'user_online',
          'data': {'userId': 'user_${_random.nextInt(1000)}'},
        },
        {
          'type': 'message_received',
          'data': {
            'conversationId': 'chat_${_random.nextInt(100)}',
            'message': 'Hey! How are you?',
            'sender': 'user_${_random.nextInt(1000)}',
          },
        },
        {
          'type': 'match_found',
          'data': {
            'matchId': 'match_${_random.nextInt(1000)}',
            'compatibility': _random.nextDouble(),
          },
        },
      ];
      
      yield events[_random.nextInt(events.length)];
    }
  }
}