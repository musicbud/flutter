import 'package:musicbud_flutter/data/models/common_artist_model.dart';
import 'package:musicbud_flutter/data/models/common_track_model.dart';
import 'package:musicbud_flutter/data/models/user_profile_model.dart';

// Mock Users
class MockUsers {
  static const UserProfileModel user1 = UserProfileModel(
    id: 'user1',
    username: 'john_doe',
    email: 'john@example.com',
    avatarUrl: 'https://example.com/avatar1.jpg',
    bio: 'Music lover and developer',
    displayName: 'John Doe',
    isActive: true,
    isAuthenticated: true,
  );

  static const UserProfileModel user2 = UserProfileModel(
    id: 'user2',
    username: 'jane_smith',
    email: 'jane@example.com',
    avatarUrl: 'https://example.com/avatar2.jpg',
    bio: 'Jazz enthusiast',
    displayName: 'Jane Smith',
    isActive: true,
    isAuthenticated: true,
  );

  static const UserProfileModel user3 = UserProfileModel(
    id: 'user3',
    username: 'bob_wilson',
    email: 'bob@example.com',
    avatarUrl: 'https://example.com/avatar3.jpg',
    bio: 'Rock music fan',
    displayName: 'Bob Wilson',
    isActive: false,
    isAuthenticated: false,
  );

  static List<UserProfileModel> get allUsers => [user1, user2, user3];
}

// Mock Tracks
class MockTracks {
  static CommonTrackModel track1 = CommonTrackModel(
    id: 'track1',
    name: 'Bohemian Rhapsody',
    artistName: 'Queen',
    imageUrl: 'https://example.com/track1.jpg',
    imageUrls: ['https://example.com/track1.jpg'],
    durationMs: 355000,
    albumName: 'A Night at the Opera',
    source: 'spotify',
    spotifyId: '4uLU6hMCjMI75M1A2tKUQC',
    popularity: 85,
    isLiked: true,
    playedAt: DateTime.now().subtract(const Duration(hours: 2)),
  );

  static CommonTrackModel track2 = CommonTrackModel(
    id: 'track2',
    name: 'Stairway to Heaven',
    artistName: 'Led Zeppelin',
    imageUrl: 'https://example.com/track2.jpg',
    imageUrls: ['https://example.com/track2.jpg'],
    durationMs: 482000,
    albumName: 'Led Zeppelin IV',
    source: 'spotify',
    spotifyId: '5CQ30WqJwcep0pYcV4AMNc',
    popularity: 90,
    isLiked: false,
    playedAt: DateTime.now().subtract(const Duration(hours: 1)),
  );

  static CommonTrackModel track3 = CommonTrackModel(
    id: 'track3',
    name: 'Hotel California',
    artistName: 'Eagles',
    imageUrl: 'https://example.com/track3.jpg',
    imageUrls: ['https://example.com/track3.jpg'],
    durationMs: 391000,
    albumName: 'Hotel California',
    source: 'spotify',
    spotifyId: '40riOy7x9W7GXjyGp4pjAv',
    popularity: 88,
    isLiked: true,
  );

  static List<CommonTrackModel> get allTracks => [track1, track2, track3];

  static List<CommonTrackModel> get likedTracks =>
      allTracks.where((track) => track.isLiked).toList();
}

// Mock Artists
class MockArtists {
  static CommonArtistModel artist1 = CommonArtistModel(
    id: 'artist1',
    name: 'Queen',
    source: 'spotify',
    spotifyId: '1dfeR4HaWDbWqFHLkxsg1d',
    popularity: 92,
    isLiked: true,
    imageUrl: 'https://example.com/artist1.jpg',
    imageUrls: ['https://example.com/artist1.jpg'],
    followers: 50000000,
    genres: ['rock', 'classic rock'],
  );

  static CommonArtistModel artist2 = CommonArtistModel(
    id: 'artist2',
    name: 'Led Zeppelin',
    source: 'spotify',
    spotifyId: '36QJpDe2go2KgaRleHCDTp',
    popularity: 89,
    isLiked: false,
    imageUrl: 'https://example.com/artist2.jpg',
    imageUrls: ['https://example.com/artist2.jpg'],
    followers: 45000000,
    genres: ['rock', 'hard rock'],
  );

  static CommonArtistModel artist3 = CommonArtistModel(
    id: 'artist3',
    name: 'Miles Davis',
    source: 'spotify',
    spotifyId: '0kbYTNQb4Pb1rPbbaF0pT4',
    popularity: 75,
    isLiked: true,
    imageUrl: 'https://example.com/artist3.jpg',
    imageUrls: ['https://example.com/artist3.jpg'],
    followers: 2000000,
    genres: ['jazz', 'bebop'],
  );

  static List<CommonArtistModel> get allArtists => [artist1, artist2, artist3];

  static List<CommonArtistModel> get likedArtists =>
      allArtists.where((artist) => artist.isLiked).toList();
}

// Mock Playlists (Simple structure since no model exists)
class MockPlaylists {
  static const Map<String, dynamic> playlist1 = {
    'id': 'playlist1',
    'name': 'My Favorite Rock Songs',
    'description': 'A collection of classic rock tracks',
    'owner': 'john_doe',
    'imageUrl': 'https://example.com/playlist1.jpg',
    'trackCount': 25,
    'isPublic': true,
    'tracks': ['track1', 'track2'], // Track IDs
  };

  static const Map<String, dynamic> playlist2 = {
    'id': 'playlist2',
    'name': 'Jazz Classics',
    'description': 'Timeless jazz pieces',
    'owner': 'jane_smith',
    'imageUrl': 'https://example.com/playlist2.jpg',
    'trackCount': 15,
    'isPublic': false,
    'tracks': ['track3'], // Track IDs
  };

  static List<Map<String, dynamic>> get allPlaylists => [playlist1, playlist2];
}

// Convenience getters
List<UserProfileModel> get mockUsers => MockUsers.allUsers;
List<CommonTrackModel> get mockTracks => MockTracks.allTracks;
List<CommonArtistModel> get mockArtists => MockArtists.allArtists;
List<Map<String, dynamic>> get mockPlaylists => MockPlaylists.allPlaylists;