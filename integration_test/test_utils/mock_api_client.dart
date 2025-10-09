import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

// Mock HTTP client for API testing
class MockHttpClient extends Mock implements http.Client {}

// Mock API responses for different endpoints
class MockApiResponses {
  // User Profile API responses
  static const String userProfileResponse = '''
  {
    "id": "test_user_123",
    "username": "testuser",
    "email": "test@example.com",
    "displayName": "Test User",
    "bio": "Music lover and anime fan",
    "avatarUrl": "https://example.com/avatar.jpg",
    "location": "Test City",
    "followersCount": 150,
    "followingCount": 75,
    "isActive": true,
    "isAuthenticated": true,
    "isAdmin": false
  }
  ''';

  static const String userTopTracksResponse = '''
  [
    {
      "id": "track_1",
      "name": "Bohemian Rhapsody",
      "artistName": "Queen",
      "albumName": "A Night at the Opera",
      "duration": 355,
      "imageUrl": "https://example.com/track1.jpg",
      "previewUrl": "https://example.com/preview1.mp3"
    },
    {
      "id": "track_2",
      "name": "Stairway to Heaven",
      "artistName": "Led Zeppelin",
      "albumName": "Led Zeppelin IV",
      "duration": 482,
      "imageUrl": "https://example.com/track2.jpg",
      "previewUrl": "https://example.com/preview2.mp3"
    }
  ]
  ''';

  static const String userTopArtistsResponse = '''
  [
    {
      "id": "artist_1",
      "name": "Queen",
      "imageUrl": "https://example.com/queen.jpg",
      "genres": ["rock", "classic rock"],
      "popularity": 85
    },
    {
      "id": "artist_2",
      "name": "Led Zeppelin",
      "imageUrl": "https://example.com/ledzep.jpg",
      "genres": ["rock", "hard rock"],
      "popularity": 82
    }
  ]
  ''';

  // Discover API responses
  static const String topTracksResponse = '''
  [
    {
      "id": "discover_track_1",
      "name": "Blinding Lights",
      "artistName": "The Weeknd",
      "albumName": "After Hours",
      "duration": 200,
      "imageUrl": "https://example.com/blinding.jpg",
      "previewUrl": "https://example.com/blinding_preview.mp3"
    },
    {
      "id": "discover_track_2",
      "name": "Watermelon Sugar",
      "artistName": "Harry Styles",
      "albumName": "Fine Line",
      "duration": 174,
      "imageUrl": "https://example.com/watermelon.jpg",
      "previewUrl": "https://example.com/watermelon_preview.mp3"
    }
  ]
  ''';

  static const String topArtistsResponse = '''
  [
    {
      "id": "discover_artist_1",
      "name": "The Weeknd",
      "imageUrl": "https://example.com/weeknd.jpg",
      "genres": ["pop", "r&b"],
      "popularity": 95
    },
    {
      "id": "discover_artist_2",
      "name": "Harry Styles",
      "imageUrl": "https://example.com/harry.jpg",
      "genres": ["pop", "rock"],
      "popularity": 90
    }
  ]
  ''';

  static const String topGenresResponse = '''
  [
    {"name": "Pop", "count": 150},
    {"name": "Rock", "count": 120},
    {"name": "Hip Hop", "count": 100}
  ]
  ''';

  // Search API responses
  static const String searchResultsResponse = '''
  {
    "items": [
      {
        "id": "search_track_1",
        "type": "track",
        "name": "Test Track",
        "artistName": "Test Artist",
        "albumName": "Test Album",
        "imageUrl": "https://example.com/search_track.jpg"
      },
      {
        "id": "search_artist_1",
        "type": "artist",
        "name": "Test Artist",
        "imageUrl": "https://example.com/search_artist.jpg",
        "genres": ["pop"]
      }
    ],
    "metadata": {
      "total": 2,
      "currentPage": 1,
      "pageSize": 20,
      "hasMore": false
    }
  }
  ''';

  static const String searchSuggestionsResponse = '''
  ["test suggestion 1", "test suggestion 2", "test suggestion 3"]
  ''';

  // Error responses
  static const String errorResponse = '''
  {
    "error": "Internal Server Error",
    "message": "Something went wrong",
    "statusCode": 500
  }
  ''';

  static const String networkErrorResponse = '''
  {
    "error": "Network Error",
    "message": "Unable to connect to server",
    "statusCode": 0
  }
  ''';
}

// Mock API client that returns predefined responses
class MockApiClient {
  final Map<String, String> _mockResponses = {};

  MockApiClient() {
    _initializeMockResponses();
  }

  void _initializeMockResponses() {
    // User Profile endpoints
    _mockResponses['GET_/api/user/profile'] = MockApiResponses.userProfileResponse;
    _mockResponses['GET_/api/user/top/tracks'] = MockApiResponses.userTopTracksResponse;
    _mockResponses['GET_/api/user/top/artists'] = MockApiResponses.userTopArtistsResponse;
    _mockResponses['GET_/api/user/liked/tracks'] = MockApiResponses.userTopTracksResponse;
    _mockResponses['GET_/api/user/liked/artists'] = MockApiResponses.userTopArtistsResponse;

    // Discover endpoints
    _mockResponses['GET_/api/discover/top/tracks'] = MockApiResponses.topTracksResponse;
    _mockResponses['GET_/api/discover/top/artists'] = MockApiResponses.topArtistsResponse;
    _mockResponses['GET_/api/discover/top/genres'] = MockApiResponses.topGenresResponse;
    _mockResponses['GET_/api/discover/top/anime'] = '[]';
    _mockResponses['GET_/api/discover/top/manga'] = '[]';
    _mockResponses['GET_/api/discover/liked/albums'] = '[]';

    // Search endpoints
    _mockResponses['GET_/api/search'] = MockApiResponses.searchResultsResponse;
    _mockResponses['GET_/api/search/suggestions'] = MockApiResponses.searchSuggestionsResponse;
    _mockResponses['GET_/api/search/recent'] = MockApiResponses.searchSuggestionsResponse;
    _mockResponses['GET_/api/search/trending'] = MockApiResponses.searchSuggestionsResponse;
  }

  String? getMockResponse(String method, String endpoint) {
    final key = '$method$endpoint';
    return _mockResponses[key];
  }

  void setMockResponse(String method, String endpoint, String response) {
    final key = '$method$endpoint';
    _mockResponses[key] = response;
  }

  void setErrorResponse(String method, String endpoint) {
    final key = '$method$endpoint';
    _mockResponses[key] = MockApiResponses.errorResponse;
  }

  void setNetworkError(String method, String endpoint) {
    final key = '$method$endpoint';
    _mockResponses.remove('$method$endpoint');
  }
}