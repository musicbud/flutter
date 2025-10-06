import 'package:flutter/material.dart';

class DiscoverContentManager {
  static const List<String> categories = [
    'All',
    'Pop',
    'Rock',
    'Hip Hop',
    'Electronic',
    'Jazz',
    'Classical',
    'Country',
  ];

  // Featured Artists Data
  static List<Map<String, dynamic>> getFeaturedArtists() {
    return [
      {
        'name': 'Luna Echo',
        'genre': 'Electronic',
        'imageUrl': null,
        'accentColor': Colors.blue,
      },
      {
        'name': 'Coastal Vibes',
        'genre': 'Chill',
        'imageUrl': null,
        'accentColor': Colors.purple,
      },
      {
        'name': 'City Pulse',
        'genre': 'Urban',
        'imageUrl': null,
        'accentColor': Colors.green,
      },
      {
        'name': 'Midnight Dreams',
        'genre': 'Ambient',
        'imageUrl': null,
        'accentColor': Colors.orange,
      },
    ];
  }

  // Trending Tracks Data
  static List<Map<String, dynamic>> getTrendingTracks() {
    return [
      {
        'title': 'Midnight Dreams',
        'artist': 'Luna Echo',
        'genre': 'Electronic',
        'imageUrl': null,
        'icon': Icons.music_note,
        'accentColor': Colors.blue,
      },
      {
        'title': 'Ocean Waves',
        'artist': 'Coastal Vibes',
        'genre': 'Chill',
        'imageUrl': null,
        'icon': Icons.music_note,
        'accentColor': Colors.purple,
      },
      {
        'title': 'Urban Nights',
        'artist': 'City Pulse',
        'genre': 'Hip Hop',
        'imageUrl': null,
        'icon': Icons.music_note,
        'accentColor': Colors.green,
      },
    ];
  }

  // New Releases Data
  static List<Map<String, dynamic>> getNewReleases() {
    return [
      {
        'title': 'Electric Storm',
        'artist': 'Luna Echo',
        'type': 'New EP',
        'imageUrl': null,
        'icon': Icons.music_note,
        'accentColor': Colors.red,
      },
      {
        'title': 'Chill Vibes',
        'artist': 'Coastal Vibes',
        'type': 'Album',
        'imageUrl': null,
        'icon': Icons.music_note,
        'accentColor': Colors.blue,
      },
      {
        'title': 'Urban Flow',
        'artist': 'City Pulse',
        'type': 'Single',
        'imageUrl': null,
        'icon': Icons.music_note,
        'accentColor': Colors.purple,
      },
    ];
  }

  // Discover More Actions Data
  static List<Map<String, dynamic>> getDiscoverActions() {
    return [
      {
        'title': 'Create Playlist',
        'subtitle': 'Build your perfect mix',
        'icon': Icons.playlist_add,
        'accentColor': Colors.green,
      },
      {
        'title': 'Follow Artists',
        'subtitle': 'Stay updated with favorites',
        'icon': Icons.person_add,
        'accentColor': Colors.orange,
      },
    ];
  }

  // Filter content based on selected category
  static List<Map<String, dynamic>> filterByCategory(
    List<Map<String, dynamic>> content,
    String category,
  ) {
    if (category == 'All') return content;
    return content.where((item) => item['genre'] == category).toList();
  }
}