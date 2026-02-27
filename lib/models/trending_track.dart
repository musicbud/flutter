import 'package:flutter/material.dart';

class TrendingTrack {
  final String id;
  final String title;
  final String artist;
  final String genre;
  final String? imageUrl;
  final IconData icon;
  final Color accentColor;

  TrendingTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.genre,
    this.imageUrl,
    this.icon = Icons.music_note,
    required this.accentColor,
  });

  factory TrendingTrack.fromJson(Map<String, dynamic> json) {
    return TrendingTrack(
      id: json['id'] as String? ?? json['uid'] as String? ?? '',
      title: json['title'] as String,
      artist: json['artist'] as String,
      genre: json['genre'] as String? ?? 'Unknown',
      imageUrl: json['image_url'] as String?,
      icon: _parseIcon(json['icon'] as String? ?? 'music_note'),
      accentColor: _parseColor(json['accent_color'] as String? ?? '#FF2196F3'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'genre': genre,
      'image_url': imageUrl,
      'icon': icon.codePoint.toString(),
      'accent_color': '#${(accentColor.r * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0')}'
          '${(accentColor.g * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0')}'
          '${(accentColor.b * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0')}',
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'artist': artist,
      'genre': genre,
      'imageUrl': imageUrl,
      'icon': icon,
      'accentColor': accentColor,
    };
  }

  static IconData _parseIcon(String iconString) {
    switch (iconString) {
      case 'music_note':
        return Icons.music_note;
      case 'audiotrack':
        return Icons.audiotrack;
      case 'queue_music':
        return Icons.queue_music;
      default:
        return Icons.music_note;
    }
  }

  static Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        return Color(int.parse(colorString.substring(1), radix: 16) + 0xFF000000);
      }
      return Color(int.parse(colorString, radix: 16) + 0xFF000000);
    } catch (e) {
      return Colors.blue; // Default color
    }
  }
}