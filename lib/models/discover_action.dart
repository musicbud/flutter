import 'package:flutter/material.dart';

class DiscoverAction {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  DiscoverAction({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });

  factory DiscoverAction.fromJson(Map<String, dynamic> json) {
    return DiscoverAction(
      id: json['id'] as String? ?? json['uid'] as String? ?? '',
      title: json['title'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      icon: _parseIcon(json['icon'] as String? ?? 'music_note'),
      accentColor: _parseColor(json['accent_color'] as String? ?? '#FF2196F3'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'icon': icon.codePoint.toString(),
      'accent_color': '#${(accentColor.r * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0')}'
          '${(accentColor.g * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0')}'
          '${(accentColor.b * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0')}',
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'icon': icon,
      'accentColor': accentColor,
    };
  }

  static IconData _parseIcon(String iconString) {
    switch (iconString) {
      case 'playlist_add':
        return Icons.playlist_add;
      case 'person_add':
        return Icons.person_add;
      case 'music_note':
        return Icons.music_note;
      case 'library_music':
        return Icons.library_music;
      case 'search':
        return Icons.search;
      case 'favorite':
        return Icons.favorite;
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