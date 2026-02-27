import 'package:flutter/material.dart';

class NewRelease {
  final String id;
  final String title;
  final String artist;
  final String type;
  final String? imageUrl;
  final IconData icon;
  final Color accentColor;

  NewRelease({
    required this.id,
    required this.title,
    required this.artist,
    required this.type,
    this.imageUrl,
    this.icon = Icons.music_note,
    required this.accentColor,
  });

  factory NewRelease.fromJson(Map<String, dynamic> json) {
    return NewRelease(
      id: json['id'] as String? ?? json['uid'] as String? ?? '',
      title: json['title'] as String,
      artist: json['artist'] as String,
      type: json['type'] as String? ?? 'Release',
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
      'type': type,
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
      'type': type,
      'imageUrl': imageUrl,
      'icon': icon,
      'accentColor': accentColor,
    };
  }

  static IconData _parseIcon(String iconString) {
    switch (iconString) {
      case 'music_note':
        return Icons.music_note;
      case 'album':
        return Icons.album;
      case 'audiotrack':
        return Icons.audiotrack;
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