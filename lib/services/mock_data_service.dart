import 'dart:math' as math;
import 'dart:math' show Random;

/// Mock data service for offline development and testing
/// Provides realistic sample data when backend is not available
class MockDataService {
  static const List<String> _artistNames = [
    'Taylor Swift', 'Ed Sheeran', 'Billie Eilish', 'Drake', 'Ariana Grande',
    'The Weeknd', 'Dua Lipa', 'Post Malone', 'Olivia Rodrigo', 'Bad Bunny',
    'BTS', 'Adele', 'Justin Bieber', 'Harry Styles', 'Doja Cat',
    'Lil Nas X', 'SZA', 'Travis Scott', 'Beyoncé', 'Kendrick Lamar'
  ];

  static const List<String> _trackNames = [
    'Anti-Hero', 'As It Was', 'Heat Waves', 'Stay', 'Industry Baby',
    'Good 4 U', 'Levitating', 'Blinding Lights', 'Watermelon Sugar',
    'drivers license', 'Peaches', 'Montero', 'Kiss Me More', 'Save Your Tears',
    'Positions', 'Mood', 'Rockstar', 'Circles', 'Someone You Loved',
    'Don\'t Start Now', 'Bad Habits', 'Shivers', 'Ghost', 'Easy On Me'
  ];

  static const List<String> _genreNames = [
    'Pop', 'Hip-Hop', 'Rock', 'Electronic', 'R&B', 'Country', 'Jazz',
    'Classical', 'Indie', 'Alternative', 'Reggae', 'Blues', 'Folk',
    'Punk', 'Metal', 'Funk', 'Soul', 'Latin', 'World', 'Ambient'
  ];

  static const List<String> _userNames = [
    'Alex Johnson', 'Sam Chen', 'Jordan Taylor', 'Casey Williams',
    'Riley Martinez', 'Morgan Davis', 'Avery Brown', 'Parker Wilson',
    'Quinn Anderson', 'Emery Thompson', 'Sage Garcia', 'River Lee',
    'Phoenix Clark', 'Rowan Hall', 'Skylar Lewis', 'Cameron Young',
    'Blake Rodriguez', 'Drew Walker', 'Lane Martinez', 'Reese Johnson'
  ];

  static final Random _random = Random();

  /// Generate mock user profile data
  static Map<String, dynamic> generateUserProfile({String? userId}) {
    final name = _userNames[_random.nextInt(_userNames.length)];
    final username = name.toLowerCase().replaceAll(' ', '_') + 
                    (_random.nextInt(999) + 1).toString();

    return {
      'id': userId ?? 'user_${_random.nextInt(10000)}',
      'username': username,
      'displayName': name,
      'email': '$username@musicbud.app',
      'profileImageUrl': 'https://api.dicebear.com/7.x/avataaars/svg?seed=$username',
      'bio': _generateBio(),
      'followerCount': _random.nextInt(500) + 10,
      'followingCount': _random.nextInt(200) + 5,
      'isPublic': _random.nextBool(),
      'showActivity': _random.nextBool(),
      'joinedAt': DateTime.now().subtract(
        Duration(days: _random.nextInt(365))
      ).toIso8601String(),
      'lastActiveAt': DateTime.now().subtract(
        Duration(minutes: _random.nextInt(1440))
      ).toIso8601String(),
      'preferences': {
        'genrePreferences': _generateGenrePreferences(),
        'privacySettings': {
          'showTopTracks': true,
          'showTopArtists': true,
          'showActivity': _random.nextBool(),
        }
      }
    };
  }

  /// Generate mock artist data
  static List<Map<String, dynamic>> generateTopArtists({int count = 20}) {
    final artists = <Map<String, dynamic>>[];
    final shuffled = List<String>.from(_artistNames)..shuffle(_random);

    for (int i = 0; i < math.min(count, shuffled.length); i++) {
      artists.add({
        'id': 'artist_${_random.nextInt(100000)}',
        'name': shuffled[i],
        'imageUrl': 'https://picsum.photos/300/300?random=${_random.nextInt(1000)}',
        'genres': _generateRandomGenres(2, 4),
        'playCount': _random.nextInt(1000) + 50,
        'popularity': _random.nextDouble() * 100,
        'followers': _random.nextInt(10000000) + 1000,
        'isVerified': _random.nextDouble() > 0.3,
        'monthlyListeners': _random.nextInt(5000000) + 100000,
      });
    }

    return artists..sort((a, b) => (b['playCount'] as int).compareTo(a['playCount'] as int));
  }

  /// Generate mock track data
  static List<Map<String, dynamic>> generateTopTracks({int count = 50}) {
    final tracks = <Map<String, dynamic>>[];
    final shuffledTracks = List<String>.from(_trackNames)..shuffle(_random);
    final shuffledArtists = List<String>.from(_artistNames)..shuffle(_random);

    for (int i = 0; i < math.min(count, shuffledTracks.length); i++) {
      final artistIndex = i % shuffledArtists.length;
      tracks.add({
        'id': 'track_${_random.nextInt(100000)}',
        'name': shuffledTracks[i],
        'artist': shuffledArtists[artistIndex],
        'artistId': 'artist_${_random.nextInt(10000)}',
        'album': _generateAlbumName(),
        'albumId': 'album_${_random.nextInt(10000)}',
        'duration': _random.nextInt(300) + 120, // 2-7 minutes in seconds
        'imageUrl': 'https://picsum.photos/400/400?random=${_random.nextInt(1000)}',
        'playCount': _random.nextInt(500) + 10,
        'isLiked': _random.nextDouble() > 0.7,
        'addedAt': DateTime.now().subtract(
          Duration(days: _random.nextInt(90))
        ).toIso8601String(),
        'popularity': _random.nextDouble() * 100,
        'explicit': _random.nextDouble() > 0.8,
        'previewUrl': null, // Would be audio preview URL
      });
    }

    return tracks..sort((a, b) => (b['playCount'] as int).compareTo(a['playCount'] as int));
  }

  /// Generate mock bud/friend recommendations
  static List<Map<String, dynamic>> generateBudRecommendations({int count = 15}) {
    final buds = <Map<String, dynamic>>[];
    final shuffledNames = List<String>.from(_userNames)..shuffle(_random);

    for (int i = 0; i < math.min(count, shuffledNames.length); i++) {
      final name = shuffledNames[i];
      final username = name.toLowerCase().replaceAll(' ', '_') + 
                      (_random.nextInt(999) + 1).toString();
      
      final commonArtists = _generateCommonArtists();
      final matchPercentage = _calculateMatchPercentage(commonArtists.length);

      buds.add({
        'id': 'user_${_random.nextInt(10000)}',
        'username': username,
        'displayName': name,
        'profileImageUrl': 'https://api.dicebear.com/7.x/avataaars/svg?seed=$username',
        'bio': _generateBio(),
        'matchPercentage': matchPercentage,
        'commonArtists': commonArtists,
        'commonGenres': _generateRandomGenres(1, 3),
        'distance': _random.nextInt(50) + 1, // km
        'isOnline': _random.nextDouble() > 0.5,
        'lastSeen': DateTime.now().subtract(
          Duration(minutes: _random.nextInt(1440))
        ).toIso8601String(),
        'mutualFriends': _random.nextInt(5),
        'topTrack': {
          'name': _trackNames[_random.nextInt(_trackNames.length)],
          'artist': _artistNames[_random.nextInt(_artistNames.length)],
        }
      });
    }

    return buds..sort((a, b) => (b['matchPercentage'] as int).compareTo(a['matchPercentage'] as int));
  }

  /// Generate mock chat/conversation data
  static List<Map<String, dynamic>> generateChats({int count = 10}) {
    final chats = <Map<String, dynamic>>[];
    final shuffledNames = List<String>.from(_userNames)..shuffle(_random);

    for (int i = 0; i < math.min(count, shuffledNames.length); i++) {
      final name = shuffledNames[i];
      final lastMessage = _generateLastMessage();

      chats.add({
        'id': 'chat_${_random.nextInt(10000)}',
        'name': name,
        'isGroup': false,
        'participantCount': 2,
        'profileImageUrl': 'https://api.dicebear.com/7.x/avataaars/svg?seed=${name.toLowerCase()}',
        'lastMessage': lastMessage,
        'lastMessageAt': DateTime.now().subtract(
          Duration(minutes: _random.nextInt(2880))
        ).toIso8601String(),
        'unreadCount': _random.nextBool() ? _random.nextInt(5) + 1 : 0,
        'isOnline': _random.nextDouble() > 0.6,
        'type': 'direct'
      });
    }

    return chats..sort((a, b) => 
      DateTime.parse(b['lastMessageAt']).compareTo(DateTime.parse(a['lastMessageAt']))
    );
  }

  /// Generate mock activity/listening history
  static List<Map<String, dynamic>> generateRecentActivity({int count = 20}) {
    final activities = <Map<String, dynamic>>[];
    final activityTypes = ['played', 'liked', 'added_to_playlist', 'shared'];

    for (int i = 0; i < count; i++) {
      final type = activityTypes[_random.nextInt(activityTypes.length)];
      activities.add({
        'id': 'activity_${_random.nextInt(10000)}',
        'type': type,
        'timestamp': DateTime.now().subtract(
          Duration(hours: _random.nextInt(72))
        ).toIso8601String(),
        'track': {
          'name': _trackNames[_random.nextInt(_trackNames.length)],
          'artist': _artistNames[_random.nextInt(_artistNames.length)],
          'imageUrl': 'https://picsum.photos/100/100?random=${_random.nextInt(1000)}',
        },
        'context': _generateActivityContext(type),
      });
    }

    return activities..sort((a, b) => 
      DateTime.parse(b['timestamp']).compareTo(DateTime.parse(a['timestamp']))
    );
  }

  // Helper methods
  static String _generateBio() {
    final bios = [
      '🎵 Music lover | Currently obsessed with indie rock',
      '🎸 Guitar player | Always discovering new artists',
      '🎤 Singer-songwriter | Love collaborating!',
      '🎧 Audiophile | Vinyl collector | Jazz enthusiast',
      '🎹 Producer | Electronic music | Available for collabs',
      '🥁 Drummer | Rock & metal | Let\'s jam!',
      '🎺 Jazz musician | Classical trained | Open to fusion',
      '🎼 Composer | Soundtrack lover | Film music geek',
    ];
    return bios[_random.nextInt(bios.length)];
  }

  static List<String> _generateGenrePreferences() {
    final count = _random.nextInt(3) + 2; // 2-4 genres
    return _generateRandomGenres(count, count);
  }

  static List<String> _generateRandomGenres(int min, int max) {
    final count = min + _random.nextInt(max - min + 1);
    final shuffled = List<String>.from(_genreNames)..shuffle(_random);
    return shuffled.take(count.toInt()).toList();
  }

  static String _generateAlbumName() {
    final albumPrefixes = ['The', 'My', 'Your', 'Our', 'This', 'That', 'A', 'An'];
    final albumWords = ['Sound', 'Journey', 'Dream', 'Story', 'Life', 'Heart', 
                       'Soul', 'Mind', 'World', 'Time', 'Love', 'Hope', 'Light'];
    final albumSuffixes = ['Collection', 'Experience', 'Sessions', 'Files', 'Tapes'];
    
    if (_random.nextBool()) {
      final prefix = albumPrefixes[_random.nextInt(albumPrefixes.length)];
      final word = albumWords[_random.nextInt(albumWords.length)];
      return '$prefix $word';
    } else {
      final word = albumWords[_random.nextInt(albumWords.length)];
      final suffix = albumSuffixes[_random.nextInt(albumSuffixes.length)];
      return '$word $suffix';
    }
  }

  static List<String> _generateCommonArtists() {
    final count = _random.nextInt(5) + 1; // 1-5 common artists
    final shuffled = List<String>.from(_artistNames)..shuffle(_random);
    return shuffled.take(count).toList();
  }

  static int _calculateMatchPercentage(int commonArtistsCount) {
    final base = commonArtistsCount * 15; // 15% per common artist
    final bonus = _random.nextInt(20); // Random bonus up to 20%
    return math.min(95, math.max(20, (base + bonus).toInt()));
  }

  static String _generateLastMessage() {
    final messages = [
      'Hey! Just discovered this amazing artist',
      'That playlist you shared is incredible! 🎵',
      'Want to go to the concert next week?',
      'Check out this song, it\'s so good',
      'Thanks for the music recommendation!',
      'Are you going to the music festival?',
      'This album is on repeat today',
      'Found a new coffee shop with great music',
      'That live session was amazing',
      'Your taste in music is spot on! 👌'
    ];
    return messages[_random.nextInt(messages.length)];
  }

  static String _generateActivityContext(String type) {
    switch (type) {
      case 'played':
        return 'via Spotify';
      case 'liked':
        return 'added to Favorites';
      case 'added_to_playlist':
        return 'added to My Playlist';
      case 'shared':
        return 'shared with friends';
      default:
        return 'music activity';
    }
  }

  /// Generate mock playlists for library
  static List<Map<String, dynamic>> generatePlaylists({int count = 15}) {
    final playlists = <Map<String, dynamic>>[];
    final playlistNames = [
      'My Favorites', 'Chill Vibes', 'Workout Mix', 'Road Trip',
      'Study Music', 'Party Hits', 'Throwback Thursday', 'Late Night',
      'Morning Coffee', 'Weekend Vibes', 'Summer 2024', 'Indie Discoveries',
      'Electronic Feels', 'Rock Classics', 'R&B Smooth', 'Pop Perfection'
    ];

    final descriptions = [
      'My all-time favorite songs',
      'Perfect for relaxing moments',
      'High-energy tracks for the gym',
      'Songs for long drives',
      'Focus music for productivity',
      'Dance hits for celebrations',
      'Classic tracks from the past',
      'Mellow tunes for nighttime',
      'Upbeat songs to start the day',
      'Feel-good weekend music',
      'The soundtrack of summer',
      'Hidden gems from indie artists',
      'Electronic beats and rhythms',
      'Timeless rock anthems',
      'Smooth R&B vibes',
      'The best of pop music'
    ];

    for (int i = 0; i < math.min(count, playlistNames.length); i++) {
      final trackCount = _random.nextInt(50) + 5; // 5-54 tracks
      final isPublic = _random.nextDouble() > 0.6;
      
      playlists.add({
        'id': 'playlist_${_random.nextInt(100000)}',
        'name': playlistNames[i],
        'description': descriptions[i],
        'trackCount': trackCount,
        'duration': trackCount * (_random.nextInt(240) + 120), // Average 2-6 min per track
        'isPublic': isPublic,
        'isOwned': true,
        'imageUrl': 'https://picsum.photos/300/300?random=${_random.nextInt(1000)}',
        'createdAt': DateTime.now().subtract(
          Duration(days: _random.nextInt(365))
        ).toIso8601String(),
        'updatedAt': DateTime.now().subtract(
          Duration(days: _random.nextInt(30))
        ).toIso8601String(),
        'playCount': _random.nextInt(100) + 5,
        'followerCount': isPublic ? _random.nextInt(500) + 10 : 0,
        'tags': _generateRandomGenres(1, 3),
        'collaborative': _random.nextDouble() > 0.8,
      });
    }

    return playlists..sort((a, b) => 
      DateTime.parse(b['updatedAt']).compareTo(DateTime.parse(a['updatedAt']))
    );
  }

  /// Generate mock downloaded tracks
  static List<Map<String, dynamic>> generateDownloads({int count = 25}) {
    final downloads = <Map<String, dynamic>>[];
    final qualities = ['High', 'Medium', 'Low'];
    final statuses = ['completed', 'downloading', 'paused', 'failed'];
    final shuffledTracks = List<String>.from(_trackNames)..shuffle(_random);
    final shuffledArtists = List<String>.from(_artistNames)..shuffle(_random);

    for (int i = 0; i < math.min(count, shuffledTracks.length); i++) {
      final status = statuses[_random.nextInt(statuses.length)];
      final quality = qualities[_random.nextInt(qualities.length)];
      final fileSize = _random.nextInt(10) + 3; // 3-12 MB
      
      downloads.add({
        'id': 'download_${_random.nextInt(100000)}',
        'trackId': 'track_${_random.nextInt(10000)}',
        'title': shuffledTracks[i],
        'artist': shuffledArtists[i % shuffledArtists.length],
        'album': _generateAlbumName(),
        'duration': _random.nextInt(300) + 120,
        'quality': quality,
        'fileSize': fileSize, // MB
        'status': status,
        'progress': status == 'downloading' ? _random.nextDouble() * 100 : 
                    status == 'completed' ? 100.0 : 0.0,
        'downloadedAt': status == 'completed' ? DateTime.now().subtract(
          Duration(days: _random.nextInt(30))
        ).toIso8601String() : null,
        'imageUrl': 'https://picsum.photos/200/200?random=${_random.nextInt(1000)}',
        'localPath': status == 'completed' ? '/storage/music/${shuffledTracks[i]}.mp3' : null,
        'canPlay': status == 'completed',
      });
    }

    return downloads..sort((a, b) {
      if (a['status'] == 'downloading' && b['status'] != 'downloading') return -1;
      if (a['status'] != 'downloading' && b['status'] == 'downloading') return 1;
      if (a['downloadedAt'] != null && b['downloadedAt'] != null) {
        return DateTime.parse(b['downloadedAt']).compareTo(DateTime.parse(a['downloadedAt']));
      }
      return 0;
    });
  }

  /// Generate mock library items (liked songs, albums, etc.)
  static List<Map<String, dynamic>> generateLibraryItems({
    required String type,
    int count = 20,
  }) {
    switch (type) {
      case 'tracks':
      case 'liked':
        return generateTopTracks(count: count).map((track) => {
          ...track,
          'likedAt': DateTime.now().subtract(
            Duration(days: _random.nextInt(180))
          ).toIso8601String(),
          'type': 'track',
        }).toList();
      case 'artists':
        return generateTopArtists(count: count).map((artist) => {
          ...artist,
          'followedAt': DateTime.now().subtract(
            Duration(days: _random.nextInt(180))
          ).toIso8601String(),
          'type': 'artist',
        }).toList();
      case 'albums':
        return _generateAlbums(count: count);
      case 'playlists':
        return generatePlaylists(count: count).map((playlist) => {
          ...playlist,
          'type': 'playlist',
        }).toList();
      case 'downloads':
        return generateDownloads(count: count).map((download) => {
          ...download,
          'type': 'download',
        }).toList();
      default:
        return [];
    }
  }

  /// Generate mock albums
  static List<Map<String, dynamic>> _generateAlbums({int count = 15}) {
    final albums = <Map<String, dynamic>>[];
    final shuffledArtists = List<String>.from(_artistNames)..shuffle(_random);

    for (int i = 0; i < count; i++) {
      final trackCount = _random.nextInt(15) + 8; // 8-22 tracks
      final releaseYear = 2024 - _random.nextInt(10); // 2014-2024
      
      albums.add({
        'id': 'album_${_random.nextInt(100000)}',
        'name': _generateAlbumName(),
        'artist': shuffledArtists[i % shuffledArtists.length],
        'artistId': 'artist_${_random.nextInt(10000)}',
        'trackCount': trackCount,
        'duration': trackCount * (_random.nextInt(240) + 120), // Total duration
        'releaseYear': releaseYear,
        'imageUrl': 'https://picsum.photos/400/400?random=${_random.nextInt(1000)}',
        'genres': _generateRandomGenres(1, 3),
        'isLiked': _random.nextDouble() > 0.7,
        'likedAt': DateTime.now().subtract(
          Duration(days: _random.nextInt(180))
        ).toIso8601String(),
        'type': 'album',
        'label': _generateRecordLabel(),
        'explicit': _random.nextDouble() > 0.8,
      });
    }

    return albums..sort((a, b) => 
      DateTime.parse(b['likedAt']).compareTo(DateTime.parse(a['likedAt']))
    );
  }

  /// Generate record label names
  static String _generateRecordLabel() {
    final labels = [
      'Atlantic Records', 'Sony Music', 'Universal Music', 'Warner Records',
      'Capitol Records', 'Republic Records', 'RCA Records', 'Interscope',
      'Epic Records', 'Columbia Records', 'Def Jam', 'Island Records'
    ];
    return labels[_random.nextInt(labels.length)];
  }

  /// Generate mock download queue for offline management
  static List<Map<String, dynamic>> generateDownloadQueue({int count = 10}) {
    final downloads = <Map<String, dynamic>>[];
    final statuses = ['downloading', 'completed', 'paused', 'failed', 'queued'];
    final shuffledTracks = List<String>.from(_trackNames)..shuffle(_random);
    final shuffledArtists = List<String>.from(_artistNames)..shuffle(_random);

    for (int i = 0; i < math.min(count, shuffledTracks.length); i++) {
      final status = statuses[_random.nextInt(statuses.length)];
      final fileSize = _random.nextInt(8) + 2; // 2-10 MB
      
      downloads.add({
        'id': 'download_${_random.nextInt(100000)}',
        'trackId': 'track_${_random.nextInt(10000)}',
        'title': shuffledTracks[i],
        'artist': shuffledArtists[i % shuffledArtists.length],
        'album': _generateAlbumName(),
        'duration': _random.nextInt(300) + 120,
        'quality': ['High', 'Medium', 'Low'][_random.nextInt(3)],
        'fileSize': fileSize,
        'status': status,
        'progress': status == 'downloading' ? _random.nextDouble() * 100 : 
                    status == 'completed' ? 100.0 : 0.0,
        'queuedAt': DateTime.now().subtract(
          Duration(minutes: _random.nextInt(1440))
        ).toIso8601String(),
        'completedAt': status == 'completed' ? DateTime.now().subtract(
          Duration(hours: _random.nextInt(72))
        ).toIso8601String() : null,
        'imageUrl': 'https://picsum.photos/200/200?random=${_random.nextInt(1000)}',
        'type': 'download',
      });
    }

    return downloads..sort((a, b) {
      // Prioritize by status: downloading > queued > paused > failed > completed
      final statusPriority = {
        'downloading': 0,
        'queued': 1,
        'paused': 2,
        'failed': 3,
        'completed': 4,
      };
      final priorityA = statusPriority[a['status']] ?? 5;
      final priorityB = statusPriority[b['status']] ?? 5;
      return priorityA.compareTo(priorityB);
    });
  }

  /// Generate mock offline library items for offline mode
  static List<Map<String, dynamic>> generateOfflineLibraryItems({int count = 30}) {
    final offlineItems = <Map<String, dynamic>>[];
    final itemTypes = ['track', 'album', 'playlist'];
    
    for (int i = 0; i < count; i++) {
      final type = itemTypes[_random.nextInt(itemTypes.length)];
      
      switch (type) {
        case 'track':
          offlineItems.add({
            ...generateTopTracks(count: 1)[0],
            'type': 'track',
            'isOffline': true,
            'downloadedAt': DateTime.now().subtract(
              Duration(days: _random.nextInt(30))
            ).toIso8601String(),
            'localPath': '/storage/offline/tracks/track_$i.mp3',
            'fileSize': _random.nextInt(8) + 2, // 2-10 MB
          });
          break;
        case 'album':
          offlineItems.add({
            ..._generateAlbums(count: 1)[0],
            'type': 'album',
            'isOffline': true,
            'downloadedAt': DateTime.now().subtract(
              Duration(days: _random.nextInt(30))
            ).toIso8601String(),
            'localPath': '/storage/offline/albums/album_$i/',
            'fileSize': _random.nextInt(100) + 50, // 50-150 MB
          });
          break;
        case 'playlist':
          offlineItems.add({
            ...generatePlaylists(count: 1)[0],
            'type': 'playlist',
            'isOffline': true,
            'downloadedAt': DateTime.now().subtract(
              Duration(days: _random.nextInt(30))
            ).toIso8601String(),
            'localPath': '/storage/offline/playlists/playlist_$i/',
            'fileSize': _random.nextInt(200) + 100, // 100-300 MB
          });
          break;
      }
    }

    return offlineItems..sort((a, b) => 
      DateTime.parse(b['downloadedAt']).compareTo(DateTime.parse(a['downloadedAt']))
    );
  }

  /// Generate mock playlist tracks for a specific playlist
  static List<Map<String, dynamic>> generatePlaylistTracks(String playlistId, {int count = 15}) {
    final tracks = <Map<String, dynamic>>[];
    final shuffledTracks = List<String>.from(_trackNames)..shuffle(_random);
    final shuffledArtists = List<String>.from(_artistNames)..shuffle(_random);

    for (int i = 0; i < math.min(count, shuffledTracks.length); i++) {
      tracks.add({
        'id': 'track_${_random.nextInt(100000)}',
        'name': shuffledTracks[i],
        'artist': shuffledArtists[i % shuffledArtists.length],
        'artistId': 'artist_${_random.nextInt(10000)}',
        'album': _generateAlbumName(),
        'albumId': 'album_${_random.nextInt(10000)}',
        'duration': _random.nextInt(300) + 120,
        'imageUrl': 'https://picsum.photos/300/300?random=${_random.nextInt(1000)}',
        'playCount': _random.nextInt(50) + 5,
        'isLiked': _random.nextDouble() > 0.7,
        'addedAt': DateTime.now().subtract(
          Duration(days: _random.nextInt(60))
        ).toIso8601String(),
        'addedBy': 'You',
        'playlistId': playlistId,
        'position': i + 1,
        'explicit': _random.nextDouble() > 0.8,
        'isDownloaded': _random.nextDouble() > 0.6,
        'type': 'track',
      });
    }

    return tracks; // Keep original order for playlist
  }

  /// Generate mock conversations for chat screen
  static List<Map<String, dynamic>> generateMockConversations({int count = 15}) {
    final conversations = <Map<String, dynamic>>[];
    final shuffledNames = List<String>.from(_userNames)..shuffle(_random);

    for (int i = 0; i < math.min(count, shuffledNames.length); i++) {
      final name = shuffledNames[i];
      final username = name.toLowerCase().replaceAll(' ', '_');
      final lastMessage = _generateLastMessage();
      final minutesAgo = _random.nextInt(2880); // Up to 48 hours
      
      conversations.add({
        'id': 'conversation_${_random.nextInt(100000)}',
        'username': name,
        'lastMessage': lastMessage,
        'timestamp': _formatTimestamp(minutesAgo),
        'unreadCount': _random.nextBool() ? _random.nextInt(10) + 1 : 0,
        'imageUrl': 'https://api.dicebear.com/7.x/avataaars/svg?seed=$username',
        'isOnline': _random.nextDouble() > 0.5,
      });
    }

    return conversations..sort((a, b) {
      // Sort by most recent first
      return _parseTimestampForSort(b['timestamp'])
          .compareTo(_parseTimestampForSort(a['timestamp']));
    });
  }

  /// Generate mock users for active friends section
  static List<Map<String, dynamic>> generateMockUsers({int count = 10}) {
    final users = <Map<String, dynamic>>[];
    final shuffledNames = List<String>.from(_userNames)..shuffle(_random);

    for (int i = 0; i < math.min(count, shuffledNames.length); i++) {
      final name = shuffledNames[i];
      final username = name.toLowerCase().replaceAll(' ', '_') + 
                      (_random.nextInt(999) + 1).toString();
      
      users.add({
        'id': 'user_${_random.nextInt(10000)}',
        'username': name,
        'imageUrl': 'https://api.dicebear.com/7.x/avataaars/svg?seed=$username',
        'isOnline': _random.nextDouble() > 0.3,
      });
    }

    return users;
  }

  /// Format timestamp for display
  static String _formatTimestamp(int minutesAgo) {
    if (minutesAgo < 1) {
      return 'Just now';
    } else if (minutesAgo < 60) {
      return '${minutesAgo}m ago';
    } else if (minutesAgo < 1440) { // Less than 24 hours
      final hours = (minutesAgo / 60).floor();
      return '${hours}h ago';
    } else {
      final days = (minutesAgo / 1440).floor();
      return '${days}d ago';
    }
  }

  /// Parse timestamp for sorting
  static int _parseTimestampForSort(String timestamp) {
    if (timestamp == 'Just now') return 0;
    
    final match = RegExp(r'(\d+)([mhd])').firstMatch(timestamp);
    if (match == null) return 999999;
    
    final value = int.parse(match.group(1)!);
    final unit = match.group(2);
    
    switch (unit) {
      case 'm':
        return value;
      case 'h':
        return value * 60;
      case 'd':
        return value * 1440;
      default:
        return 999999;
    }
  }
}
